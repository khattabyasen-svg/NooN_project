<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="LoginUser.aspx.cs" Inherits="NooN.LoginUser" %>

<!DOCTYPE html>
<html>
<head runat="server">
    <meta charset="UTF-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1.0" />
    <title>Sign In — NooN</title>
<link href=" Content/LoginUser.css" rel="stylesheet" />
  
</head>
<body>
    <div class="card">

        <div class="brand">No<span>o</span>N</div>
        <p class="subtitle">Welcome back</p>

        <form id="form1" runat="server">

            <div class="field-group">
                <asp:Label ID="LabEmail" runat="server" Text="Email Address" AssociatedControlID="txtEmail"></asp:Label>
                <asp:TextBox ID="txtEmail" runat="server" TextMode="Email" placeholder="you@example.com"></asp:TextBox>
            </div>

            <div class="field-group">
                <asp:Label ID="LabPas" runat="server" Text="Password" AssociatedControlID="txtPas"></asp:Label>
                <asp:TextBox ID="txtPas" runat="server" TextMode="Password" placeholder="••••••••"></asp:TextBox>
            </div>

            <asp:Button ID="login_button" runat="server" OnClick="login_button_Click" Text="Sign In" />

        <div class="divider">
            <asp:Label ID="lblerror" runat="server" ForeColor="Red"></asp:Label>
            </div>

        </form>

        <p class="footer-text">Don't have an account? <a href="Registration.aspx">Create one</a></p>

    </div>
<script src="Scripts/LoginUser.js"></script>
    
</body>
</html>
