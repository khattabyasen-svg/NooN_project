<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="Proudct_Categories.aspx.cs" Inherits="NooN.Proudct_Categories" %>

<!DOCTYPE html>
<html xmlns="http://www.w3.org/1999/xhtml" dir="ltr">
<head runat="server">
    <meta charset="UTF-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1.0" />
    <title>Category Management - NooN</title>
    <link href="Content/Proudct_categories.css" rel="stylesheet" />
</head>
<body>
    <form id="form2" runat="server">

        <div class="page-header">
            <h1>Category Management</h1>
            <p>Add, edit, and delete product categories</p>
        </div>

        <asp:Panel ID="pnlAlert" runat="server" Visible="false" CssClass="alert">
            <asp:Label ID="lblAlert" runat="server"></asp:Label>
        </asp:Panel>

        <div class="add-card">
            <h2>Add New Category</h2>
            <div class="form-row">
                <div class="form-group">
                    <label>Arabic Name</label>
                    <asp:TextBox ID="txtNameAr" runat="server" placeholder="Enter Arabic name"></asp:TextBox>
                </div>
                <div class="form-group">
                    <label>English Name</label>
                    <asp:TextBox ID="txtNameEn" runat="server" placeholder="Enter English name"></asp:TextBox>
                </div>
                <div class="form-group status-group">
                    <label>Status</label>
                    <asp:DropDownList ID="ddlStatus" runat="server">
                        <asp:ListItem Value="1">Active</asp:ListItem>
                        <asp:ListItem Value="0">Inactive</asp:ListItem>
                    </asp:DropDownList>
                </div>
                <asp:Button ID="btnAdd" runat="server" Text="+ Add" CssClass="btn btn-add" OnClick="btnAdd_Click" />
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
                    <div class="empty">No categories — add one from above.</div>
                </EmptyDataTemplate>
                <Columns>
    <asp:TemplateField HeaderText="#">
        <ItemTemplate>
            <asp:Label runat="server" Text='<%# Container.DataItemIndex + 1 %>'></asp:Label>
        </ItemTemplate>
    </asp:TemplateField>

    <asp:TemplateField HeaderText="Arabic Name">
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

    <asp:TemplateField HeaderText="English Name">
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

    <asp:TemplateField HeaderText="Status">
        <ItemTemplate>
            <%# Convert.ToInt32(Eval("is_active") ?? 0) == 1 ? "Active" : "Inactive" %>
        </ItemTemplate>
        <EditItemTemplate>
            <asp:DropDownList ID="ddlStatus" runat="server">
                <asp:ListItem Value="1">Active</asp:ListItem>
                <asp:ListItem Value="0">Inactive</asp:ListItem>
            </asp:DropDownList>
        </EditItemTemplate>
    </asp:TemplateField>

    <asp:TemplateField HeaderText="Actions">
        <ItemTemplate>
            <asp:LinkButton runat="server" CommandName="Edit"
                            CssClass="btn btn-edit">Edit</asp:LinkButton>
            <asp:LinkButton runat="server" CommandName="Delete"
                            CssClass="btn btn-del"
                            OnClientClick="return confirm('Are you sure you want to delete this?');">Delete</asp:LinkButton>
        </ItemTemplate>
        <EditItemTemplate>
            <asp:LinkButton runat="server" CommandName="Update"
                            CssClass="btn btn-save">Save</asp:LinkButton>
            <asp:LinkButton runat="server" CommandName="Cancel"
                            CssClass="btn btn-cancel">Cancel</asp:LinkButton>
        </EditItemTemplate>
    </asp:TemplateField>
</Columns>
            </asp:GridView>
        </div>
    </form>
</body>
</html>