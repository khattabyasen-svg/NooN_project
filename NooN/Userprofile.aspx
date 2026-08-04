<%@ Page Title="الملف الشخصي" Language="C#"
    MasterPageFile="~/Site.Master"
    AutoEventWireup="true"
    CodeBehind="UserProfile.aspx.cs"
    Inherits="NooN.Userprofile" %>

<asp:Content ID="HeadContent" ContentPlaceHolderID="head" runat="server">
    <link href="https://fonts.googleapis.com/css2?family=Cairo:wght@400;600;700;900&display=swap" rel="stylesheet" />
    <link href="Content/profileuser.css" rel="stylesheet" />
</asp:Content>

<asp:Content ID="MainContent" ContentPlaceHolderID="MainContent" runat="server">

    <div class="profile-layout">

        <%-- ── Sidebar ─────────────────────────────────────────── --%>
        <aside class="profile-sidebar">
            <div class="sb-item active">👤 الملف الشخصي</div>
            <a href="#" class="sb-item">📦 طلباتي</a>
            <a href="#" class="sb-item">🔒 الإعدادات</a>
        </aside>

        <%-- ── Main content ────────────────────────────────────── --%>
        <main class="profile-content">

            <%-- Profile hero --%>
            <div class="profile-hero">
                <div class="profile-avatar">
                    <asp:Literal ID="litAbbr" runat="server" Text="--" />
                </div>
                <div class="profile-hero-info">
                    <div class="profile-hero-name">
                        <asp:Literal ID="litFullName" runat="server" Text="جاري التحميل..." />
                    </div>
                    <asp:Label ID="lblLastUpdated" runat="server" CssClass="last-updated" />
                </div>
            </div>

            <%-- ── Account data panel ──────────────────────────── --%>
            <div class="panel">
                <div class="panel-hdr">
                    <div class="panel-title">👤 بيانات الحساب</div>
                    <span class="user-id-badge">
                        ID: <asp:Literal ID="litUserID" runat="server" Text="--" />
                    </span>
                </div>

                <div class="panel-body">

                    <asp:ValidationSummary ID="vsSummary" runat="server"
                        ValidationGroup="ProfileGroup"
                        CssClass="validation-summary"
                        HeaderText="يرجى تصحيح الأخطاء التالية:"
                        ShowMessageBox="false" ShowSummary="true" />

                    <div class="info-grid">

                        <%-- First Name --%>
                        <div class="field">
                            <label>الاسم الأول *</label>
                            <asp:TextBox ID="txtFirstName" runat="server"
                                CssClass="asp-input" ReadOnly="true" />
                            <asp:RequiredFieldValidator ID="RFV_FName" runat="server"
                                ControlToValidate="txtFirstName"
                                ErrorMessage="الاسم الأول مطلوب"
                                CssClass="field-error" Display="Dynamic"
                                ValidationGroup="ProfileGroup" Enabled="false" />
                        </div>

                        <%-- Last Name --%>
                        <div class="field">
                            <label>الاسم الأخير *</label>
                            <asp:TextBox ID="txtLastName" runat="server"
                                CssClass="asp-input" ReadOnly="true" />
                            <asp:RequiredFieldValidator ID="RFV_LName" runat="server"
                                ControlToValidate="txtLastName"
                                ErrorMessage="الاسم الأخير مطلوب"
                                CssClass="field-error" Display="Dynamic"
                                ValidationGroup="ProfileGroup" Enabled="false" />
                        </div>

                        <%-- Email (full width) --%>
                        <div class="field field-full">
                            <label>البريد الإلكتروني *</label>
                            <asp:TextBox ID="txtEmail" runat="server"
                                CssClass="asp-input" ReadOnly="true" TextMode="Email" />
                            <asp:RequiredFieldValidator ID="RFV_Email" runat="server"
                                ControlToValidate="txtEmail"
                                ErrorMessage="البريد الإلكتروني مطلوب"
                                CssClass="field-error" Display="Dynamic"
                                ValidationGroup="ProfileGroup" Enabled="false" />
                            <asp:RegularExpressionValidator ID="REV_Email" runat="server"
                                ControlToValidate="txtEmail"
                                ErrorMessage="صيغة البريد الإلكتروني غير صحيحة"
                                ValidationExpression="\w+([-+.']\w+)*@\w+([-.]\w+)*\.\w+([-.]\w+)*"
                                CssClass="field-error" Display="Dynamic"
                                ValidationGroup="ProfileGroup" Enabled="false" />
                        </div>

                        <%-- Phone (full width) --%>
                        <div class="field field-full">
                            <label>رقم الهاتف *</label>
                            <asp:TextBox ID="txtPhone" runat="server"
                                CssClass="asp-input" ReadOnly="true"
                                TextMode="Phone" placeholder="05XXXXXXXX" />
                            <asp:RequiredFieldValidator ID="RFV_Phone" runat="server"
                                ControlToValidate="txtPhone"
                                ErrorMessage="رقم الهاتف مطلوب"
                                CssClass="field-error" Display="Dynamic"
                                ValidationGroup="ProfileGroup" Enabled="false" />
                            <asp:RegularExpressionValidator ID="REV_Phone" runat="server"
                                ControlToValidate="txtPhone"
                                ErrorMessage="رقم الهاتف يجب أن يبدأ بـ 05 ويتكوّن من 10 أرقام"
                                ValidationExpression="^05\d{8}$"
                                CssClass="field-error" Display="Dynamic"
                                ValidationGroup="ProfileGroup" Enabled="false" />
                        </div>

                        <%-- Password (full width) — display only, change via separate page --%>
                        <div class="field field-full">
                            <label>كلمة المرور</label>
                            <div class="password-row">
                                <div class="password-display">••••••••</div>
                                <asp:Button ID="btnChangePass" runat="server"
                                    Text="تغيير كلمة المرور"
                                    CssClass="btn-outline"
                                    OnClick="btnChangePass_Click"
                                    CausesValidation="false" />
                            </div>
                        </div>

                    </div>

                    <%-- Action buttons --%>
                    <div class="actions-row">
                        <asp:Button ID="btnEdit" runat="server"
                            Text="✏️ تعديل البيانات"
                            CssClass="btn-profile-primary"
                            OnClick="btnEdit_Click"
                            CausesValidation="false" />
                        <asp:Button ID="btnSave" runat="server"
                            Text="💾 حفظ التغييرات"
                            CssClass="btn-profile-primary"
                            Visible="false"
                            OnClick="btnSave_Click"
                            ValidationGroup="ProfileGroup" />
                        <asp:Button ID="btnCancel" runat="server"
                            Text="إلغاء"
                            CssClass="btn-profile-secondary"
                            Visible="false"
                            OnClick="btnCancel_Click"
                            CausesValidation="false" />
                        <asp:Label ID="lblStatus" runat="server"
                            CssClass="save-status" Visible="false" />
                    </div>

                </div>
            </div>

            <%-- ── Orders summary panel ───────────────────────── --%>
            <div class="panel">
                <div class="panel-hdr">
                    <div class="panel-title">📦 ملخص الطلبات</div>
                </div>
                <div class="panel-body">
                    <div class="orders-summary">
                        <div class="order-stat">
                            <div class="order-stat-num">
                                <asp:Label ID="lblNewOrders" runat="server" Text="0" />
                            </div>
                            <div class="order-stat-label">تم التوصيل</div>
                        </div>
                        <div class="order-stat-divider"></div>
                        <div class="order-stat">
                            <div class="order-stat-num">
                                <asp:Label ID="lblCompletedOrders" runat="server" Text="0" />
                            </div>
                            <div class="order-stat-label">ملغاة</div>
                        </div>
                    </div>
                </div>
            </div>

        </main>
    </div>

</asp:Content>
