using System;
using System.Configuration;
using System.Data.SqlClient;
using System.Web.UI;

namespace NooN
{
    public partial class LoginUser : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
        }

        protected void login_button_Click(object sender, EventArgs e)
        {
            string email = txtEmail.Text.Trim();
            string password = txtPas.Text.Trim();

            if (string.IsNullOrEmpty(email) || string.IsNullOrEmpty(password))
            {
                lblerror.Text = "⚠️ Please enter username and password.";
                lblerror.Visible = true;
                return;
            }

            string connStr = ConfigurationManager.ConnectionStrings["MyConnection"].ConnectionString;

            using (SqlConnection conn = new SqlConnection(connStr))
            {
                conn.Open();

                // Fetch the account by email, then verify the password in code —
                // the stored value is a hash, so it can't be compared in SQL.
                string query = @"SELECT user_id, first_name, last_name, password_hash
                         FROM Users
                         WHERE email=@email";

                int userId = 0;
                string fullName = null;
                string storedHash = null;
                bool found = false;

                using (SqlCommand cmd = new SqlCommand(query, conn))
                {
                    cmd.Parameters.AddWithValue("@email", email);

                    using (SqlDataReader dr = cmd.ExecuteReader())
                    {
                        if (dr.Read())
                        {
                            found = true;
                            userId = Convert.ToInt32(dr["user_id"]);
                            fullName = dr["first_name"] + " " + dr["last_name"];
                            storedHash = dr["password_hash"] as string;
                        }
                    }
                }

                if (found && PasswordHasher.Verify(password, storedHash))
                {
                    // Transparently migrate legacy plaintext passwords to a hash.
                    if (PasswordHasher.NeedsUpgrade(storedHash))
                        UpgradePassword(conn, userId, password);

                    Session["user_id"] = userId;
                    Session["full_name"] = fullName;
                    Session["email"] = email;

                    Response.Redirect("Default.aspx");
                }
                else
                {
                    lblerror.Text = "❌ Invalid username or password.";
                    lblerror.Visible = true;
                }
            }
        }

        private static void UpgradePassword(SqlConnection conn, int userId, string password)
        {
            using (SqlCommand cmd = new SqlCommand(
                "UPDATE Users SET password_hash = @hash WHERE user_id = @id", conn))
            {
                cmd.Parameters.AddWithValue("@hash", PasswordHasher.Hash(password));
                cmd.Parameters.AddWithValue("@id", userId);
                cmd.ExecuteNonQuery();
            }
        }
    }
}

