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
            string password_hash = txtPas.Text.Trim();

            if (string.IsNullOrEmpty(email) || string.IsNullOrEmpty(password_hash))
            {
                lblerror.Text = "⚠️ Please enter username and password.";
                lblerror.Visible = true;
                return;
            }

            string connStr = ConfigurationManager.ConnectionStrings["MyConnection"].ConnectionString;

            using (SqlConnection conn = new SqlConnection(connStr))
            {
                conn.Open();

                string query = @"SELECT user_id, first_name, last_name 
                         FROM Users 
                         WHERE email=@email AND password_hash=@password_hash";

                using (SqlCommand cmd = new SqlCommand(query, conn))
                {
                    cmd.Parameters.AddWithValue("@email", email);
                    cmd.Parameters.AddWithValue("@password_hash", password_hash);

                    SqlDataReader dr = cmd.ExecuteReader();

                    if (dr.Read())
                    {
                        // ✅ تخزين البيانات في Session
                        Session["user_id"] = dr["user_id"];
                        Session["full_name"] = dr["first_name"] + " " + dr["last_name"];
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
        }
    }
}

