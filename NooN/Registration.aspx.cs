using System;
using System.Configuration;
using System.Data.SqlClient;
using System.Text.RegularExpressions;
using System.Web.UI;

namespace NooN
{
    public partial class Registration : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
        }

        protected void Button1_Click(object sender, EventArgs e)
        {
            string first_name= TxtFName.Text.Trim();
            string last_name = TxtLname.Text.Trim();
            string email = TxtEmail.Text.Trim();
            string phone = TxtPhone.Text.Trim();
            string password_hash = TxtPass.Text.Trim();
            string confirm = TxtConfirm.Text.Trim();

            // Empty-field guard
            if (string.IsNullOrEmpty(first_name) ||
                string.IsNullOrEmpty(last_name) ||
                string.IsNullOrEmpty(email) ||
                string.IsNullOrEmpty(phone) ||
                string.IsNullOrEmpty(password_hash) ||
                string.IsNullOrEmpty(confirm))
            {
                Laberor.Text = "⚠️ Please fill in all fields.";
                Laberor.Visible = true;
                return;
            }

            // Email format
            if (!NooN.Validators.IsValidEmail(email))
            {
                Laberor.Text = "❌ Enter a valid email address.";
                Laberor.Visible = true;
                return;
            }

            // Phone format: Jordan mobile (07XXXXXXXX)
            if (!NooN.Validators.IsValidJordanPhone(phone))
            {
                Laberor.Text = "❌ Phone must start with 07 and be 10 digits.";
                Laberor.Visible = true;
                return;
            }

            // Minimum password length
            if (!NooN.Validators.IsValidPassword(password_hash))
            {
                Laberor.Text = "❌ Password must be at least 8 characters.";
                Laberor.Visible = true;
                return;
            }

            // Password confirmation match
            if (password_hash != confirm)
            {
                Laberor.Text = "❌ Passwords do not match.";
                Laberor.Visible = true;
                return;
            }

            string connStr = Db.ConnectionString;

            using (SqlConnection conn = new SqlConnection(connStr))
            {
                conn.Open();

                // ✅ Check whether the email already exists
                string checkQuery = "SELECT COUNT(*) FROM users WHERE email = @email";
                using (SqlCommand checkCmd = new SqlCommand(checkQuery, conn))
                {
                    checkCmd.Parameters.AddWithValue("@email", email);
                    int exists = (int)checkCmd.ExecuteScalar();

                    if (exists > 0)
                    {
                        Laberor.Text = "⚠️ email already exists. Please choose another.";
                        Laberor.Visible = true;
                        return;
                    }
                }

                // ✅ Insert the new user
                string insertQuery = "INSERT INTO Users (first_name,last_name, Email,phone, Password_hash) VALUES (@first_name,@last_name, @email,@phone,@password_hash)";
                using (SqlCommand cmd = new SqlCommand(insertQuery, conn))
                {
                    cmd.Parameters.AddWithValue("@first_name", first_name);
                    cmd.Parameters.AddWithValue("@last_name", last_name);
                    cmd.Parameters.AddWithValue("@email", email);
                    cmd.Parameters.AddWithValue("@phone",phone );
                    cmd.Parameters.AddWithValue("@Password_hash", PasswordHasher.Hash(password_hash));

                    int rows = cmd.ExecuteNonQuery();

                    if (rows > 0)
                    {
                        // ✅ Registration succeeded
                        ClientScript.RegisterStartupScript(
                            this.GetType(), "msg",
                            "alert('Your account has been created! Please sign in'); window.location='LoginUser.aspx';",
                            true);
                    }
                    else
                    {
                        Laberor.Text = "❌ Registration failed. Please try again.";
                        Laberor.Visible = true;
                    }
                }
            }
        }
    }
}