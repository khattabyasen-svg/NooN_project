using System;
using System.Configuration;
using System.Data.SqlClient;

namespace NooN
{
    public partial class Userprofile : System.Web.UI.Page
    {
        string connStr = ConfigurationManager.ConnectionStrings["MyConnection"].ConnectionString;
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
                string query = @"SELECT user_id, first_name, last_name, email, phone
                                 FROM users WHERE user_id = @id";

                SqlCommand cmd = new SqlCommand(query, conn);
                cmd.Parameters.AddWithValue("@id", userId);

                conn.Open();
                SqlDataReader dr = cmd.ExecuteReader();

                if (dr.Read())
                {
                    txtFirstName.Text = dr["first_name"].ToString();
                    txtLastName.Text = dr["last_name"].ToString();
                    txtEmail.Text = dr["email"].ToString();
                    txtPhone.Text = dr["phone"].ToString();

                    litUserID.Text = dr["user_id"].ToString();
                    litFullName.Text = dr["first_name"] + " " + dr["last_name"];

                    litAbbr.Text =
                        dr["first_name"].ToString().Substring(0, 1).ToUpper() +
                        dr["last_name"].ToString().Substring(0, 1).ToUpper();
                }
            }
        }

        private void LoadOrdersSummary()
        {
            int userId = GetUserId();

            using (SqlConnection conn = new SqlConnection(connStr))
            {
                string query = @"
                    SELECT 
                        SUM(CASE WHEN status = 'delivered' THEN 1 ELSE 0 END) AS NewOrders,
                        SUM(CASE WHEN status = 'cancelled' THEN 1 ELSE 0 END) AS CancelledOrders
                    FROM orders
                    WHERE user_id = @id";

                SqlCommand cmd = new SqlCommand(query, conn);
                cmd.Parameters.AddWithValue("@id", userId);

                conn.Open();
                SqlDataReader dr = cmd.ExecuteReader();

                if (dr.Read())
                {
                    lblNewOrders.Text = dr["NewOrders"] != DBNull.Value ? dr["NewOrders"].ToString() : "0";

                    // ملاحظة: انت ما عندك Label للملغية، استخدمت Completed كبديل
                    lblCompletedOrders.Text = dr["CancelledOrders"] != DBNull.Value ? dr["CancelledOrders"].ToString() : "0";
                }
            }
        }

        protected void btnEdit_Click(object sender, EventArgs e)
        {
            txtFirstName.ReadOnly = false;
            txtLastName.ReadOnly = false;
            txtEmail.ReadOnly = false;
            txtPhone.ReadOnly = false;

            btnEdit.Visible = false;
            btnSave.Visible = true;
            btnCancel.Visible = true;
        }

        protected void btnCancel_Click(object sender, EventArgs e)
        {
            LoadUserData();

            txtFirstName.ReadOnly = true;
            txtLastName.ReadOnly = true;
            txtEmail.ReadOnly = true;
            txtPhone.ReadOnly = true;

            btnEdit.Visible = true;
            btnSave.Visible = false;
            btnCancel.Visible = false;

            lblStatus.Visible = false;
        }

        protected void btnSave_Click(object sender, EventArgs e)
        {
            int userId = GetUserId();

            using (SqlConnection conn = new SqlConnection(connStr))
            {
                string query = @"UPDATE users SET
                                 first_name = @fn,
                                 last_name = @ln,
                                 email = @em,
                                 phone = @ph
                                 WHERE user_id = @id";

                SqlCommand cmd = new SqlCommand(query, conn);
                cmd.Parameters.AddWithValue("@fn", txtFirstName.Text);
                cmd.Parameters.AddWithValue("@ln", txtLastName.Text);
                cmd.Parameters.AddWithValue("@em", txtEmail.Text);
                cmd.Parameters.AddWithValue("@ph", txtPhone.Text);
                cmd.Parameters.AddWithValue("@id", userId);

                conn.Open();
                cmd.ExecuteNonQuery();
            }

            lblStatus.Text = "تم حفظ التعديلات";
            lblStatus.Visible = true;

            txtFirstName.ReadOnly = true;
            txtLastName.ReadOnly = true;
            txtEmail.ReadOnly = true;
            txtPhone.ReadOnly = true;

            btnEdit.Visible = true;
            btnSave.Visible = false;
            btnCancel.Visible = false;

            LoadUserData();
        }

        protected void btnChangePass_Click(object sender, EventArgs e)
        {
            Response.Redirect("resetpassword.aspx");
        }
    }
}