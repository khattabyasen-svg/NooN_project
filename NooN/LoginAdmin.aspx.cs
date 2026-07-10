using System;
using System.Data.SqlClient;
using System.Configuration;
using System.Web.UI;

namespace NooN
{
    public partial class LoginAdmin : System.Web.UI.Page
    {
        // جلب نص الاتصال من ملف الـ Web.config
        string connStr = Db.ConnectionString;

        protected void Page_Load(object sender, EventArgs e)
        {
            // يمكنك هنا إضافة كود لمنع الأدمن المسجل دخوله بالفعل من رؤية هذه الصفحة
        }

        protected void AdminButton_Click(object sender, EventArgs e)
        {
            string email = TxtName.Text.Trim(); // نستخدم الايميل كـ Username
            string password = TxtPas.Text.Trim();

            if (string.IsNullOrEmpty(email) || string.IsNullOrEmpty(password))
            {
                ShowMessage("Please enter all fields.", MessageType.Error);
                return;
            }

            try
            {
                using (SqlConnection conn = new SqlConnection(connStr))
                {
                    // Fetch the admin account by email/role, then verify the password
                    // in code — the stored value is a hash, not comparable in SQL.
                    string query = @"SELECT [user_id], [first_name], [password_hash]
                                   FROM [users]
                                   WHERE [email] = @email
                                   AND [role] = 'Admin'
                                   AND [is_active] = 1";

                    int adminId = 0;
                    string adminName = null;
                    string storedHash = null;
                    bool found = false;

                    conn.Open();
                    using (SqlCommand cmd = new SqlCommand(query, conn))
                    {
                        cmd.Parameters.AddWithValue("@email", email);

                        using (SqlDataReader reader = cmd.ExecuteReader())
                        {
                            if (reader.Read())
                            {
                                found = true;
                                adminId = Convert.ToInt32(reader["user_id"]);
                                adminName = reader["first_name"].ToString();
                                storedHash = reader["password_hash"] as string;
                            }
                        }
                    }

                    if (found && PasswordHasher.Verify(password, storedHash))
                    {
                        // Transparently migrate legacy plaintext passwords to a hash.
                        if (PasswordHasher.NeedsUpgrade(storedHash))
                        {
                            using (SqlCommand up = new SqlCommand(
                                "UPDATE [users] SET password_hash = @hash WHERE user_id = @id", conn))
                            {
                                up.Parameters.AddWithValue("@hash", PasswordHasher.Hash(password));
                                up.Parameters.AddWithValue("@id", adminId);
                                up.ExecuteNonQuery();
                            }
                        }

                        Session["AdminID"] = adminId.ToString();
                        Session["AdminName"] = adminName;

                        Response.Redirect("Admin_order.aspx");
                    }
                    else
                    {
                        ShowMessage("Invalid credentials or you do not have admin access.", MessageType.Error);
                    }
                }
            }
            catch (Exception ex)
            {
                // في حالة حدوث خطأ في قاعدة البيانات
                ShowMessage("Connection error: " + ex.Message, MessageType.Error);
            }
        }

        // دالة لإظهار رسائل الخطأ (التي شرحناها سابقاً)
        private void ShowMessage(string message, MessageType type)
        {
            string color = type == MessageType.Success ? "#3a7d5c" : "#b85c38";
            string bgColor = type == MessageType.Success ? "#edf7f2" : "#fdf2ee";
            string script = $@"
                (function() {{
                    var existing = document.getElementById('__feedbackMsg');
                    if (existing) existing.remove();
                    var msg = document.createElement('div');
                    msg.id = '__feedbackMsg';
                    msg.style.cssText = 'margin-top:1.2rem;padding:0.75rem;border-radius:3px;font-family:sans-serif;color:{color};background:{bgColor};border:1px solid {color}33;';
                    msg.textContent = {System.Web.HttpUtility.JavaScriptStringEncode(message)};
                    var btn = document.getElementById('{AdminButton.ClientID}');
                    btn.parentNode.insertBefore(msg, btn.nextSibling);
                }})();";
            ClientScript.RegisterStartupScript(GetType(), "msg", script, true);
        }

        public enum MessageType { Success, Error }
    }
}