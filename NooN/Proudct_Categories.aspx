<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="Proudct_Categories.aspx.cs" Inherits="NooN.Proudct_Categories" %>

<!DOCTYPE html>
<html xmlns="http://www.w3.org/1999/xhtml" dir="rtl">
<head runat="server">
    <title>إدارة الفئات - NooN</title>
    <link href="Content/Proudct_categories.css" rel="stylesheet" />
</head>
<body>
    <form id="form2" runat="server">

        <div class="page-header">
            <h1>إدارة الفئات</h1>
            <p>إضافة وتعديل وحذف فئات المنتجات</p>
        </div>

        <asp:Panel ID="pnlAlert" runat="server" Visible="false" CssClass="alert">
            <asp:Label ID="lblAlert" runat="server"></asp:Label>
        </asp:Panel>

        <div class="add-card">
            <h2>إضافة فئة جديدة</h2>
            <div class="form-row">
                <div class="form-group">
                    <label>الاسم العربي</label>
                    <asp:TextBox ID="txtNameAr" runat="server" placeholder="أدخل الاسم العربي"></asp:TextBox>
                </div>
                <div class="form-group">
                    <label>الاسم الإنجليزي</label>
                    <asp:TextBox ID="txtNameEn" runat="server" placeholder="Enter English name"></asp:TextBox>
                </div>
                <div class="form-group status-group">
                    <label>الحالة</label>
                    <asp:DropDownList ID="ddlStatus" runat="server">
                        <asp:ListItem Value="1">فعالة</asp:ListItem>
                        <asp:ListItem Value="0">غير فعالة</asp:ListItem>
                    </asp:DropDownList>
                </div>
                <asp:Button ID="btnAdd" runat="server" Text="+ إضافة" CssClass="btn btn-add" OnClick="btnAdd_Click" />
            </div>
        </div>

        <div class="table-wrap">
            <asp:GridView ID="gvCategories" runat="server" AutoGenerateColumns="false" CssClass="grid" 
                DataKeyNames="category_id" 
                OnRowEditing="gvCategories_RowEditing" 
                OnRowCancelingEdit="gvCategories_RowCancelingEdit" 
                OnRowUpdating="gvCategories_RowUpdating" 
                OnRowDeleting="gvCategories_RowDeleting">

                <EmptyDataTemplate>
                    <div class="empty">لا توجد فئات — أضف فئة من الأعلى.</div>
                </EmptyDataTemplate>
                <Columns>
    <asp:TemplateField HeaderText="#">
        <ItemTemplate>
            <asp:Label runat="server" Text='<%# Container.DataItemIndex + 1 %>'></asp:Label>
        </ItemTemplate>
    </asp:TemplateField>

    <asp:TemplateField HeaderText="الاسم العربي">
        <ItemTemplate>
            <asp:TextBox ID="txtNameAr" runat="server"
                         Text='<%# Eval("name_ar") %>'
                         ReadOnly="true"
                         CssClass="txt-readonly"></asp:TextBox>
        </ItemTemplate>
        <EditItemTemplate>
            <asp:TextBox ID="txtNameAr" runat="server"
                         Text='<%# Bind("name_ar") %>'></asp:TextBox>
        </EditItemTemplate>
    </asp:TemplateField>

    <asp:TemplateField HeaderText="الاسم الإنجليزي">
        <ItemTemplate>
            <asp:TextBox ID="txtNameEn" runat="server"
                         Text='<%# Eval("name_en") %>'
                         ReadOnly="true"
                         CssClass="txt-readonly"></asp:TextBox>
        </ItemTemplate>
        <EditItemTemplate>
            <asp:TextBox ID="txtNameEn" runat="server"
                         Text='<%# Bind("name_en") %>'></asp:TextBox>
        </EditItemTemplate>
    </asp:TemplateField>

    <asp:TemplateField HeaderText="الحالة">
        <ItemTemplate>
            <%# Convert.ToInt32(Eval("is_active") ?? 0) == 1 ? "فعالة" : "غير فعالة" %>
        </ItemTemplate>
        <EditItemTemplate>
            <asp:DropDownList ID="ddlStatus" runat="server">
                <asp:ListItem Value="1">فعالة</asp:ListItem>
                <asp:ListItem Value="0">غير فعالة</asp:ListItem>
            </asp:DropDownList>
        </EditItemTemplate>
    </asp:TemplateField>

    <asp:TemplateField HeaderText="الإجراءات">
        <ItemTemplate>
            <asp:LinkButton runat="server" CommandName="Edit"
                            CssClass="btn btn-edit">تعديل</asp:LinkButton>
            <asp:LinkButton runat="server" CommandName="Delete"
                            CssClass="btn btn-del"
                            OnClientClick="return confirm('هل أنت متأكد من الحذف؟');">حذف</asp:LinkButton>
        </ItemTemplate>
        <EditItemTemplate>
            <asp:LinkButton runat="server" CommandName="Update"
                            CssClass="btn btn-save">حفظ</asp:LinkButton>
            <asp:LinkButton runat="server" CommandName="Cancel"
                            CssClass="btn btn-cancel">إلغاء</asp:LinkButton>
        </EditItemTemplate>
    </asp:TemplateField>
</Columns>
            </asp:GridView>
        </div>
    </form>
</body>
</html>