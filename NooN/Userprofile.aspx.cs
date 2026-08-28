using System;
using System.Data.SqlClient;
using System.Text.RegularExpressions;

namespace NooN
{
    public partial class Userprofile : System.Web.UI.Page
    {
        string connStr = Db.ConnectionString;

        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                LoadUserData();
                LoadOrdersSummary();
            }
        }

        private int GetUserId()
        {
            if (Session["user_id"] == null)
            {
                Response.Redirect("LoginUser.aspx");
                return -1;
            }
            return Convert.ToInt32(Session["user_id"]);
        }

        private void LoadUserData()
        {
            int userId = GetUserId();

            using (SqlConnection conn = new SqlConnection(connStr))
            {
                string query = @"
                    SELECT user_id, first_name, last_name, email, phone, updated_at
                    FROM   users
                    WHERE  user_id = @id";

                using (SqlCommand cmd = new SqlCommand(query, conn))
                {
                    cmd.Parameters.AddWithValue("@id", userId);
                    conn.Open();

                    using (SqlDataReader dr = cmd.ExecuteReader())
                    {
                        if (dr.Read())
                        {
                            txtFirstName.Text = dr["first_name"].ToString();
                            txtLastName.Text  = dr["last_name"].ToString();
                            txtEmail.Text     = dr["email"].ToString();
                            txtPhone.Text     = dr["phone"].ToString();

                            litUserID.Text  = dr["user_id"].ToString();
                            litFullName.Text = dr["first_name"] + " " + dr["last_name"];

                            string fn = dr["first_name"].ToString();
                            string ln = dr["last_name"].ToString();
                            litAbbr.Text =
                                (fn.Length > 0 ? fn.Substring(0, 1).ToUpper() : "") +
                                (ln.Length > 0 ? ln.Substring(0, 1).ToUpper() : "");

                            if (dr["updated_at"] != DBNull.Value)
                            {
                                DateTime updated = Convert.ToDateTime(dr["updated_at"]);
                                lblLastUpdated.Text = "Last updated: " + updated.ToString("dd MMMM yyyy",
                                    new System.Globalization.CultureInfo("en-US"));
                            }
                        }
                    }
                }
            }
        }

        private void LoadOrdersSummary()
        {
            int userId = GetUserId();
            using (SqlConnection conn = new SqlConnection(connStr))
            {
                // lblNewOrders label displays "Delivered" in the markup
                // lblCompletedOrders label displays "Cancelled" in the markup
                string query = @"
            SELECT
                SUM(CASE WHEN status = 'delivered' THEN 1 ELSE 0 END) AS DeliveredCount,
                SUM(CASE WHEN status = 'cancelled' THEN 1 ELSE 0 END) AS CancelledCount
            FROM orders
            WHERE user_id = @id";
                using (SqlCommand cmd = new SqlCommand(query, conn))
                {
                    cmd.Parameters.AddWithValue("@id", userId);
                    conn.Open();
                    using (SqlDataReader dr = cmd.ExecuteReader())
                    {
                        if (dr.Read())
                        {
                            lblNewOrders.Text = dr["DeliveredCount"] != DBNull.Value ? dr["DeliveredCount"].ToString() : "0";
                            lblCompletedOrders.Text = dr["CancelledCount"] != DBNull.Value ? dr["CancelledCount"].ToString() : "0";
                        }
                    }
                }
            }
        }
        private void SetValidators(bool enabled)
        {
            RFV_FName.Enabled  = enabled;
            RFV_LName.Enabled  = enabled;
            RFV_Email.Enabled  = enabled;
            REV_Email.Enabled  = enabled;
            RFV_Phone.Enabled  = enabled;
            REV_Phone.Enabled  = enabled;
        }

        private void SetReadOnly(bool readOnly)
        {
            txtFirstName.ReadOnly = readOnly;
            txtLastName.ReadOnly  = readOnly;
            txtEmail.ReadOnly     = readOnly;
            txtPhone.ReadOnly     = readOnly;
        }

        protected void btnEdit_Click(object sender, EventArgs e)
        {
            SetReadOnly(false);
            SetValidators(true);

            btnEdit.Visible   = false;
            btnSave.Visible   = true;
            btnCancel.Visible = true;
            lblStatus.Visible = false;
        }

        protected void btnCancel_Click(object sender, EventArgs e)
        {
            LoadUserData();
            SetReadOnly(true);
            SetValidators(false);

            btnEdit.Visible   = true;
            btnSave.Visible   = false;
            btnCancel.Visible = false;
            lblStatus.Visible = false;
        }

        protected void btnSave_Click(object sender, EventArgs e)
        {
            string fn = txtFirstName.Text.Trim();
            string ln = txtLastName.Text.Trim();
            string em = txtEmail.Text.Trim();
            string ph = txtPhone.Text.Trim();

            // Server-side guard (backs up ASP.NET validators)
            if (string.IsNullOrEmpty(fn) || string.IsNullOrEmpty(ln) ||
                string.IsNullOrEmpty(em) || string.IsNullOrEmpty(ph))
            {
                ShowStatus("⚠️ All fields are required.", false);
                return;
            }

            if (!NooN.Validators.IsValidEmail(em))
            {
                ShowStatus("❌ Invalid email address format.", false);
                return;
            }

            if (!NooN.Validators.IsValidJordanPhone(ph))
            {
                ShowStatus("❌ Phone number must start with 07 and be 10 digits.", false);
                return;
            }

            int userId = GetUserId();

            using (SqlConnection conn = new SqlConnection(connStr))
            {
                string query = @"
                    UPDATE users
                    SET    first_name = @fn,
                           last_name  = @ln,
                           email      = @em,
                           phone      = @ph,
                           updated_at = GETDATE()
                    WHERE  user_id = @id";

                using (SqlCommand cmd = new SqlCommand(query, conn))
                {
                    cmd.Parameters.AddWithValue("@fn", fn);
                    cmd.Parameters.AddWithValue("@ln", ln);
                    cmd.Parameters.AddWithValue("@em", em);
                    cmd.Parameters.AddWithValue("@ph", ph);
                    cmd.Parameters.AddWithValue("@id", userId);
                    conn.Open();
                    cmd.ExecuteNonQuery();
                }
            }

            ShowStatus("✅ Changes saved successfully.", true);

            SetReadOnly(true);
            SetValidators(false);

            btnEdit.Visible   = true;
            btnSave.Visible   = false;
            btnCancel.Visible = false;

            LoadUserData();
        }

        protected void btnChangePass_Click(object sender, EventArgs e)
        {
            Response.Redirect("resetpassword.aspx");
        }

        private void ShowStatus(string message, bool success)
        {
            lblStatus.Text      = message;
            lblStatus.ForeColor = success
                ? System.Drawing.Color.FromArgb(0x27, 0xAE, 0x60)
                : System.Drawing.Color.FromArgb(0xC0, 0x39, 0x2B);
            lblStatus.Visible   = true;
        }
    }
}
