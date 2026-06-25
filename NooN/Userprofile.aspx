<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="UserProfile.aspx.cs" Inherits="NooN.Userprofile" %>

<!DOCTYPE html>
<html lang="ar" dir="rtl">
<head runat="server">
    <meta charset="UTF-8"/>
    <meta name="viewport" content="width=device-width,initial-scale=1.0"/>
    <title>Noon – User Profile</title>
    <link href="https://fonts.googleapis.com/css2?family=Cairo:wght@300;400;500;600;700;900&display=swap" rel="stylesheet"/>
    <link href="Content/profileuser.css" rel="stylesheet" />
</head>
<body>
    <form id="form1" runat="server">
        
        <div class="toolbar">
            <div class="toolbar-logo"><span></span>noon</div>
            <div class="toolbar-right">
                <div class="user-chip">
                    <div class="chip-av"><asp:Literal ID="litAbbr" runat="server" Text="--" /></div>
                    <span class="chip-name"><asp:Literal ID="litFullName" runat="server" Text="جاري التحميل..." /></span>
                </div>
            </div>
        </div>

        <div class="layout">
            <aside class="sidebar">
                <div class="sb-item active">👤 الملف الشخصي</div>
                <a href="#" class="sb-item">📦 طلباتي</a>
                <a href="#" class="sb-item">🔒 الإعدادات</a>
            </aside>

            <main class="content">
                <div class="page-hdr">
                    <h1>الملف الشخصي</h1>
                    <asp:Label ID="lblLastUpdated" runat="server" CssClass="last-updated" Text="آخر تحديث: 29 مارس 2026" />
                </div>

                <div class="panel">
                    <div class="panel-hdr">
                        <div class="panel-title">👤 بيانات الحساب</div>
                        <span style="font-size:10px; color:#999">ID: <asp:Literal ID="litUserID" runat="server" Text="--" /></span>
                    </div>
                    <div class="panel-body">
                        
                        <div class="info-grid">
                            <div class="field">
                                <label>الاسم الأول</label>
                                <asp:TextBox ID="txtFirstName" runat="server" CssClass="asp-input" ReadOnly="true" />
                            </div>

                            <div class="field">
                                <label>الاسم الأخير</label>
                                <asp:TextBox ID="txtLastName" runat="server" CssClass="asp-input" ReadOnly="true" />
                            </div>

                            <div class="field">
                                <label>البريد الإلكتروني</label>
                                <asp:TextBox ID="txtEmail" runat="server" CssClass="asp-input" ReadOnly="true" />
                            </div>

                            <div class="field">
                                <label>رقم الهاتف</label>
                                <asp:TextBox ID="txtPhone" runat="server" CssClass="asp-input" ReadOnly="true" />
                            </div>

                            <div class="field" style="grid-column: span 2;">
                                <label>كلمة المرور</label>
                                <div style="display:flex; gap:8px">
                                    c
                                    <asp:Button ID="btnChangePass" runat="server" Text="تغيير" CssClass="btn-secondary" style="padding:0 15px" OnClick="btnChangePass_Click" />
                                </div>
                            </div>
                        </div>

                        <div class="actions-row" style="margin-top:24px; display:flex; align-items:center">
                            <asp:Button ID="btnEdit" runat="server" Text="✏️ تعديل البيانات" CssClass="btn-primary" OnClick="btnEdit_Click" />
                            <asp:Button ID="btnSave" runat="server" Text="💾 حفظ التغييرات" CssClass="btn-primary" Visible="false" OnClick="btnSave_Click" />
                            <asp:Button ID="btnCancel" runat="server" Text="إلغاء" CssClass="btn-secondary" Visible="false" OnClick="btnCancel_Click" style="margin-right:10px" />
                            <asp:Label ID="lblStatus" runat="server" CssClass="save-status" Visible="false" />
                        </div>
                    </div>
                </div>

                <div class="panel">
                    <div class="panel-hdr">📦 ملخص الطلبات</div>
                    <div class="panel-body">
                         <div style="display:flex; gap:20px; text-align:center">
                             <div style="flex:1">
                                 <h2 style="font-size:24px"><asp:Label ID="lblNewOrders" runat="server" Text="0" /></h2>
                                 <p style="color:#888">جديدة</p>
                             </div>
                             <div style="flex:1">
                                 <h2 style="font-size:24px"><asp:Label ID="lblCompletedOrders" runat="server" Text="0" /></h2>
                                 <p style="color:#888">مكتملة</p>
                             </div>
                         </div>
                    </div>
                </div>

            </main>
        </div>
    </form>
</body>
</html>