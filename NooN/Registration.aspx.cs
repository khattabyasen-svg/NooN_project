using System;
using System.Configuration;
using System.Data.SqlClient;
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

            // ✅ التحقق من الحقول الفارغة
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

            // ✅ التحقق من تطابق الباسورد
            if (password_hash != confirm)
            {
                Laberor.Text = "❌ Passwords do not match.";
                Laberor .Visible = true;
                return;
            }

            string connStr = ConfigurationManager.ConnectionStrings["MyConnection"].ConnectionString;

            using (SqlConnection conn = new SqlConnection(connStr))
            {
                conn.Open();

                // ✅ التحقق إذا كان اليوزرنيم موجود مسبقاً
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

                // ✅ إدخال المستخدم الجديد
                string insertQuery = "INSERT INTO Users (first_name,last_name, Email,phone, Password_hash) VALUES (@first_name,@last_name, @email,@phone,@password_hash)";
                using (SqlCommand cmd = new SqlCommand(insertQuery, conn))
                {
                    cmd.Parameters.AddWithValue("@first_name", first_name);
                    cmd.Parameters.AddWithValue("@last_name", last_name);
                    cmd.Parameters.AddWithValue("@email", email);
                    cmd.Parameters.AddWithValue("@phone",phone );
                    cmd.Parameters.AddWithValue("@Password_hash", password_hash);

                    int rows = cmd.ExecuteNonQuery();

                    if (rows > 0)
                    {
                        // ✅ نجاح التسجيل
                        ClientScript.RegisterStartupScript(
                            this.GetType(), "msg",
                            "alert('تم إنشاء حسابك! الرجاء تسجيل الدخول'); window.location='LoginUser.aspx';",
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

        protected void TxtPass_TextChanged(object sender, EventArgs e)
        {

        }

        protected void TxtPass_TextChanged1(object sender, EventArgs e)
        {

        }
    }
}