<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="Registration.aspx.cs" Inherits="NooN.Registration" %>
<!DOCTYPE html>
<html>
<head runat="server">
    <meta charset="UTF-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1.0" />
    <title>Create Account — NooN</title>
    <link href="Content/shared.css" rel="stylesheet" />
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
                    <asp:Label ID="LabName" runat="server" Text="First Name" AssociatedControlID="TxtFName"></asp:Label>
                    <asp:TextBox ID="TxtFName" runat="server" placeholder="Mohammed"></asp:TextBox>
                    <asp:RequiredFieldValidator ID="RFV_FName" runat="server"
                        ControlToValidate="TxtFName"
                        ErrorMessage="First name is required."
                        CssClass="field-error" Display="Dynamic"
                        ValidationGroup="RegGroup" />
                </div>
                <div class="field-group">
                    <asp:Label ID="Lab_lastname" runat="server" Text="Last Name" AssociatedControlID="TxtLname"></asp:Label>
                    <asp:TextBox ID="TxtLname" runat="server" placeholder="Al-Ahmad"></asp:TextBox>
                    <asp:RequiredFieldValidator ID="RFV_LName" runat="server"
                        ControlToValidate="TxtLname"
                        ErrorMessage="Last name is required."
                        CssClass="field-error" Display="Dynamic"
                        ValidationGroup="RegGroup" />
                </div>
            </div>

            <%-- Email --%>
            <div class="field-group">
                <asp:Label ID="LabEmail" runat="server" Text="Email" AssociatedControlID="TxtEmail"></asp:Label>
                <asp:TextBox ID="TxtEmail" runat="server" AutoCompleteType="Email" TextMode="Email" placeholder="you@example.com"></asp:TextBox>
                <asp:RequiredFieldValidator ID="RFV_Email" runat="server"
                    ControlToValidate="TxtEmail"
                    ErrorMessage="Email is required."
                    CssClass="field-error" Display="Dynamic"
                    ValidationGroup="RegGroup" />
                <asp:RegularExpressionValidator ID="REV_Email" runat="server"
                    ControlToValidate="TxtEmail"
                    ErrorMessage="Enter a valid email address."
                    ValidationExpression="\w+([-+.']\w+)*@\w+([-.]\w+)*\.\w+([-.]\w+)*"
                    CssClass="field-error" Display="Dynamic"
                    ValidationGroup="RegGroup" />
            </div>

            <%-- Phone --%>
            <div class="field-group">
                <asp:Label ID="Label3" runat="server" Text="Phone Number" AssociatedControlID="TxtPhone"></asp:Label>
                <asp:TextBox ID="TxtPhone" runat="server" TextMode="Phone" placeholder="07XXXXXXXX"></asp:TextBox>
                <asp:RequiredFieldValidator ID="RFV_Phone" runat="server"
                    ControlToValidate="TxtPhone"
                    ErrorMessage="Phone number is required."
                    CssClass="field-error" Display="Dynamic"
                    ValidationGroup="RegGroup" />
                <asp:RegularExpressionValidator ID="REV_Phone" runat="server"
                    ControlToValidate="TxtPhone"
                    ErrorMessage="Phone must start with 07 and be 10 digits."
                    ValidationExpression="^07\d{8}$"
                    CssClass="field-error" Display="Dynamic"
                    ValidationGroup="RegGroup" />
            </div>

            <div class="form-divider">Security</div>

            <%-- Row: Password + Confirm --%>
            <div class="field-row">
                <asp:ScriptManager ID="ScriptManager1" runat="server"></asp:ScriptManager>
                <div class="field-group">
                    <asp:Label ID="LabPas" runat="server" Text="Password" AssociatedControlID="TxtPass"></asp:Label>
                    <asp:TextBox ID="TxtPass" runat="server" TextMode="Password" placeholder="••••••••••"></asp:TextBox>
                    <ajaxToolkit:PasswordStrength ID="PasswordStrength1" runat="server" TargetControlID="TxtPass" MinimumLowerCaseCharacters="1" MinimumNumericCharacters="1" MinimumSymbolCharacters="1" MinimumUpperCaseCharacters="1" PreferredPasswordLength="8" BarBorderCssClass="" BarIndicatorCssClass="" DisplayPosition="BelowLeft" RequiresUpperAndLowerCaseCharacters="True" TextStrengthDescriptions="ضعيفة جداً;ضعيفة;متوسطة;قوية;قوية جداً"/>
                    <asp:RequiredFieldValidator ID="RFV_Pass" runat="server"
                        ControlToValidate="TxtPass"
                        ErrorMessage="Password is required."
                        CssClass="field-error" Display="Dynamic"
                        ValidationGroup="RegGroup" />
                </div>
                <div class="field-group">
                    <asp:Label ID="LabConfirm" runat="server" Text="Confirm Password" AssociatedControlID="TxtConfirm"></asp:Label>
                    <asp:TextBox ID="TxtConfirm" runat="server" TextMode="Password" placeholder="••••••••••"></asp:TextBox>
                    <asp:RequiredFieldValidator ID="RFV_Confirm" runat="server"
                        ControlToValidate="TxtConfirm"
                        ErrorMessage="Please confirm your password."
                        CssClass="field-error" Display="Dynamic"
                        ValidationGroup="RegGroup" />
                    <asp:CompareValidator ID="CV_Passwords" runat="server"
                        ControlToValidate="TxtConfirm"
                        ControlToCompare="TxtPass"
                        ErrorMessage="Passwords do not match."
                        CssClass="field-error" Display="Dynamic"
                        ValidationGroup="RegGroup" />
                </div>
            </div>

            <%-- Submit --%>
            <asp:Button ID="Button1" runat="server" OnClick="Button1_Click"
                Text="Create Account" ValidationGroup="RegGroup" />

            <%-- Error Label --%>
            <asp:Label ID="Laberor" runat="server" ForeColor="Red" Text=""></asp:Label>

        </form>

        <div class="divider"></div>
        <p class="footer-text">Already have an account? <a href="LoginUser.aspx">Sign in →</a></p>
    </div>

    <script src="Scripts/Registration.js"></script>
</body>
</html>
