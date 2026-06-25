using System;
using System.Configuration;
using System.Data.SqlClient;
using System.Web.UI;

namespace NooN
{
    public partial class resetpassword : Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
        }
        // ── Connection string ─────────────────────────────────────────────────
        // Change this to match your actual connection string (or pull from Web.config)
        string connStr = ConfigurationManager.ConnectionStrings["MyConnection"].ConnectionString;

        // ── Save button ───────────────────────────────────────────────────────
        protected void ButSave_Click(object sender, EventArgs e)
        {
            string currentPassword = TxtPas.Text.Trim();
            string newPassword = TxtNPas.Text.Trim();
            string confirmPassword = TxtCon.Text.Trim();

            // ── 1. Empty-field guard ──────────────────────────────────────────
            if (string.IsNullOrEmpty(currentPassword) ||
                string.IsNullOrEmpty(newPassword) ||
                string.IsNullOrEmpty(confirmPassword))
            {
                ShowMessage("All fields are required.", MessageType.Error);
                return;
            }

            // ── 2. New password must match confirm ────────────────────────────
            if (newPassword != confirmPassword)
            {
                ShowMessage("New password and confirm password do not match.", MessageType.Error);
                return;
            }

            // ── 3. New password must differ from current ──────────────────────
            if (newPassword == currentPassword)
            {
                ShowMessage("New password must be different from your current password.", MessageType.Error);
                return;
            }

            // ── 4. Identify the logged-in user ────────────────────────────────
            // Adjust this if you store the user ID differently (e.g. FormsAuthentication)
            if (Session["user_id"] == null)
            {
                Response.Redirect("~/LoginUsers.aspx");
                return;
            }

            int userId = Convert.ToInt32(Session["user_id"]);

            // ── 5. Verify current password & update in DB ─────────────────────
            try
            {
                using (SqlConnection conn = new SqlConnection(connStr))
                {
                    conn.Open();

                    // 5a. Check current password
                    // IMPORTANT: If your passwords are hashed, replace the plain-text
                    // comparison below with your hashing logic (e.g. BCrypt.Verify).
                    const string checkSql =
                        "SELECT COUNT(1) FROM users " +
                        "WHERE user_id = @UserID AND password_hash = @CurrentPassword";

                    using (SqlCommand checkCmd = new SqlCommand(checkSql, conn))
                    {
                        checkCmd.Parameters.AddWithValue("@UserID", userId);
                        checkCmd.Parameters.AddWithValue("@CurrentPassword", currentPassword);

                        int matches = (int)checkCmd.ExecuteScalar();

                        if (matches == 0)
                        {
                            ShowMessage("Current password is incorrect.", MessageType.Error);
                            return;
                        }
                    }

                    // 5b. Update to new password
                    const string updateSql =
                        "UPDATE users SET password_hash = @NewPassword " +
                        "WHERE user_id = @UserID";

                    using (SqlCommand updateCmd = new SqlCommand(updateSql, conn))
                    {
                        updateCmd.Parameters.AddWithValue("@NewPassword", newPassword);
                        updateCmd.Parameters.AddWithValue("@UserID", userId);
                        updateCmd.ExecuteNonQuery();
                    }
                }

                // ── 6. Success ────────────────────────────────────────────────
                ClearFields();
                ShowMessage("Your password has been updated successfully.", MessageType.Success);
            }
            catch (SqlException ex)
            {
                // Log ex.Message to your logging system as needed
                ShowMessage("A database error occurred. Please try again later.", MessageType.Error);
            }
            catch (Exception ex)
            {
                ShowMessage("An unexpected error occurred. Please try again.", MessageType.Error);
            }
        }

        // ── Helpers ───────────────────────────────────────────────────────────

        private enum MessageType { Success, Error }

        /// <summary>
        /// Injects a styled feedback message into the page via ClientScript.
        /// Works with the card layout in resetpassword.aspx.
        /// </summary>
        private void ShowMessage(string message, MessageType type)
        {
            string color = type == MessageType.Success ? "#3a7d5c" : "#b85c38";
            string bgColor = type == MessageType.Success ? "#edf7f2" : "#fdf2ee";
            string icon = type == MessageType.Success ? "✓" : "✕";

            string script = $@"
                (function() {{
                    var existing = document.getElementById('__feedbackMsg');
                    if (existing) existing.remove();

                    var msg = document.createElement('div');
                    msg.id = '__feedbackMsg';
                    msg.style.cssText =
                        'margin-top:1.2rem;padding:0.75rem 1rem;border-radius:3px;' +
                        'font-size:0.875rem;font-family:DM Sans,sans-serif;' +
                        'display:flex;align-items:center;gap:0.5rem;' +
                        'color:{color};background:{bgColor};' +
                        'border:1px solid {color}33;';

                    var span = document.createElement('span');
                    span.style.cssText =
                        'width:18px;height:18px;border-radius:50%;' +
                        'background:{color};color:#fff;display:inline-flex;' +
                        'align-items:center;justify-content:center;' +
                        'font-size:0.7rem;flex-shrink:0;';
                    span.textContent = '{icon}';

                    msg.appendChild(span);
                    msg.appendChild(document.createTextNode({System.Web.HttpUtility.JavaScriptStringEncode(message)}));

                    var btn = document.getElementById('{ButSave.ClientID}');
                    btn.parentNode.insertBefore(msg, btn.nextSibling);
                }})();
            ";

            Page.ClientScript.RegisterStartupScript(GetType(), "feedbackMsg", script, addScriptTags: true);
        }

        private void ClearFields()
        {
            TxtPas.Text = string.Empty;
            TxtNPas.Text = string.Empty;
            TxtCon.Text = string.Empty;
        }
    }
}