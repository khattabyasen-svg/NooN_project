<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="Registration.aspx.cs" Inherits="NooN.Registration" %>
<!DOCTYPE html>
<html>
<head runat="server">
    <meta charset="UTF-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1.0" />
    <title>Create Account — NooN</title>
    <meta name="viewport" content="width=device-width, initial-scale=1.0" />
    <link href="Content/Registration.css" rel="stylesheet" />

</head>
<body>
    <div class="card">
        <div class="user-badge">New Account</div>
        <div class="brand">No<span>o</span>N</div>
        <p class="subtitle">Create your account to get started</p>

        <form id="form1" runat="server">

            <%-- Row: First Name + Last Name --%>
            <div class="field-row">
                <div class="field-group">
                    <asp:Label ID="LabName" runat="server" Text="Username" AssociatedControlID="TxtFName"></asp:Label>
                    <asp:TextBox ID="TxtFName" runat="server" placeholder="your_name"></asp:TextBox>
                </div>
                <div class="field-group">
                    <asp:Label ID="Lab_lastname" runat="server" Text="Lastname" AssociatedControlID="TxtLname"></asp:Label>
                    <asp:TextBox ID="TxtLname" runat="server" placeholder="your_lastname"></asp:TextBox>
                </div>
            </div>

            <%-- Email --%>
            <div class="field-group">
                <asp:Label ID="LabEmail" runat="server" Text="Email" AssociatedControlID="TxtEmail"></asp:Label>
                <asp:TextBox ID="TxtEmail" runat="server" AutoCompleteType="Email" TextMode="Email" placeholder="you@example.com"></asp:TextBox>
            </div>

            <%-- Phone --%>
            <div class="field-group">
                <asp:Label ID="Label3" runat="server" Text="Phone Number" AssociatedControlID="TxtPhone"></asp:Label>
                <asp:TextBox ID="TxtPhone" runat="server" TextMode="Phone" placeholder="+962 7x xxx xxxx"></asp:TextBox>
            </div>

            <div class="form-divider">Security</div>

            <%-- Row: Password + Confirm --%>
            <div class="field-row">
                <asp:ScriptManager ID="ScriptManager1" runat="server"></asp:ScriptManager>
                <div class="field-group">
                    <asp:Label ID="LabPas" runat="server" Text="Password" AssociatedControlID="TxtPass"></asp:Label>
                    <asp:TextBox ID="TxtPass" runat="server" TextMode="Password" placeholder="••••••••••"></asp:TextBox>
                    <ajaxToolkit:PasswordStrength ID="PasswordStrength1" runat="server" TargetControlID="TxtPass" MinimumLowerCaseCharacters="1" MinimumNumericCharacters="1" MinimumSymbolCharacters="1" MinimumUpperCaseCharacters="1" PreferredPasswordLength="8" BarBorderCssClass="" BarIndicatorCssClass="" DisplayPosition="BelowLeft" RequiresUpperAndLowerCaseCharacters="True" TextStrengthDescriptions="ضعيفة جداً;ضعيفة;متوسطة;قوية;قوية جداً"/>
                </div>
                <div class="field-group">
                    <asp:Label ID="LabConfirm" runat="server" Text="Confirm" AssociatedControlID="TxtConfirm"></asp:Label>
                    <asp:TextBox ID="TxtConfirm" runat="server" TextMode="Password" placeholder="••••••••••"></asp:TextBox>

                </div>
            </div>

            <%-- Submit --%>
            <asp:Button ID="Button1" runat="server" OnClick="Button1_Click" Text="Create Account" />

            <%-- Error Label --%>
            <asp:Label ID="Laberor" runat="server" ForeColor="Red" Text=""></asp:Label>

        </form>

        <div class="divider"></div>
        <p class="footer-text">Already have an account? <a href="LoginUser.aspx">Sign in →</a></p>
    </div>

    <script src="Scripts/Registration.js"></script>
</body>
</html>
