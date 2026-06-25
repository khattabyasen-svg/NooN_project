<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="resetpassword.aspx.cs" Inherits="NooN.resetpassword" %>
<!DOCTYPE html>
<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title>Reset Password</title>
    <link href="https://fonts.googleapis.com/css2?family=Playfair+Display:wght@400;600&family=DM+Sans:wght@300;400;500&display=swap" rel="stylesheet" />

    <link href="Content/reset_pass.css" rel="stylesheet" />
</head>
<body>
    <form id="form1" runat="server">
        <div class="card">

            <div class="card-header">
                <div class="icon-wrap">
                    <svg viewBox="0 0 24 24" xmlns="http://www.w3.org/2000/svg">
                        <rect x="3" y="11" width="18" height="11" rx="2" ry="2"/>
                        <path d="M7 11V7a5 5 0 0 1 10 0v4"/>
                    </svg>
                </div>
                <div class="card-eyebrow">Account Security</div>
                <h1 class="card-title">Reset Password</h1>
                <p class="card-subtitle">Choose a strong new password to protect your account.</p>
            </div>

            <div class="field-group">
                <asp:Label ID="LabPas" runat="server" CssClass="field-label" AssociatedControlID="TxtPas">Current Password</asp:Label>
                <asp:TextBox ID="TxtPas" runat="server" CssClass="field-input" TextMode="Password" placeholder="Enter current password"></asp:TextBox>
            </div>

            <div class="field-group">
                <asp:Label ID="LabNPass" runat="server" CssClass="field-label" AssociatedControlID="TxtNPas">New Password</asp:Label>
                <asp:TextBox ID="TxtNPas" runat="server" CssClass="field-input" TextMode="Password" placeholder="Enter new password"></asp:TextBox>
            </div>

            <div class="field-group">
                <asp:Label ID="LabCon" runat="server" CssClass="field-label" AssociatedControlID="TxtCon">Confirm Password</asp:Label>
                <asp:TextBox ID="TxtCon" runat="server" CssClass="field-input" TextMode="Password" placeholder="Re-enter new password"></asp:TextBox>
            </div>

            <div class="divider"></div>


          <asp:Button ID="ButSave" runat="server" Text="Save New Password" 
            CssClass="btn-save" OnClick="ButSave_Click" />

            <div class="card-footer">
                Remembered it? <a href="#">Back to Sign In</a>
            </div>

        </div>
    </form>
</body>
</html>