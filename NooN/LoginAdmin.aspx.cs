using System;
using System.Data.SqlClient;
using System.Configuration;
using System.Web.UI;

namespace NooN
{
    public partial class LoginAdmin : System.Web.UI.Page
    {
        // جلب نص الاتصال من ملف الـ Web.config
        string connStr = ConfigurationManager.ConnectionStrings["MyConnection"].ConnectionString;

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
                    // استعلام للتحقق من البريد، كلمة المرور، والصلاحية (Role)
                    // ملاحظة: يُفضل دائماً تشفير كلمة المرور (Hashing) وليس مقارنتها كنص عادي
                    string query = @"SELECT [user_id], [first_name], [role] 
                                   FROM [users] 
                                   WHERE [email] = @email 
                                   AND [password_hash] = @pass 
                                   AND [role] = 'Admin' 
                                   AND [is_active] = 1";

                    SqlCommand cmd = new SqlCommand(query, conn);
                    cmd.Parameters.AddWithValue("@email", email);
                    cmd.Parameters.AddWithValue("@pass", password); // هنا نضع كلمة المرور

                    conn.Open();
                    SqlDataReader reader = cmd.ExecuteReader();

                    if (reader.Read())
                    {
                        // إذا وجدنا المستخدم، نقوم بإنشاء جلسة (Session)
                        Session["AdminID"] = reader["user_id"].ToString();
                        Session["AdminName"] = reader["first_name"].ToString();

                        // الانتقال لصفحة الطلبات
                        Response.Redirect("Admin_order.aspx");
                    }
                    else
                    {
                        // إذا كانت البيانات خاطئة
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