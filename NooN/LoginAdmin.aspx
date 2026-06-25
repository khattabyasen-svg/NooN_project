<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="LoginAdmin.aspx.cs" Inherits="NooN.LoginAdmin" %>
<!DOCTYPE html>
<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <meta charset="UTF-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1.0" />
    <title>Admin Login — NooN</title>
 <link href="Content/LoginAdmin.css" rel="stylesheet" />
</head>
<body>
    <div class="card">

        <div class="admin-badge">Admin Panel</div>
        <div class="brand">No<span>o</span>N</div>
        <p class="subtitle">Restricted access — authorised personnel only</p>

        <form id="form1" runat="server">

            <div class="field-group">
                <asp:Label ID="LabName" runat="server" Text="Username" AssociatedControlID="TxtName"></asp:Label>
                <asp:TextBox ID="TxtName" runat="server" placeholder="admin_username"></asp:TextBox>
            </div>

            <div class="field-group">
                <asp:Label ID="LabPas" runat="server" Text="Password" AssociatedControlID="TxtPas"></asp:Label>
                <asp:TextBox ID="TxtPas" runat="server" TextMode="Password" placeholder="••••••••••"></asp:TextBox>
            </div>

            <asp:Button ID="AdminButton" runat="server" Text="Authenticate" OnClick="AdminButton_Click" />

        </form>

        <div class="divider"></div>
        <p class="footer-text">Not an admin? <a href="LoginUser.aspx">User login →</a></p>

    </div>
    <script src="Scripts/LoginAdmin.js"></script>
</body>
</html>
