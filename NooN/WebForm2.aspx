<%@ Page Title="بحث المنتجات" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeBehind="WebForm2.aspx.cs" Inherits="NooN.WebForm2" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
    <style>
        .container {
            max-width: 900px;
            margin: auto;
            background: #fff;
            padding: 30px;
            border-radius: 12px;
            box-shadow: 0 8px 24px rgba(0,0,0,0.05);
        }

        h2 { color: #333; text-align: center; margin-bottom: 25px; }

        .search-container {
            display: flex;
            gap: 10px;
            margin-bottom: 30px;
            align-items: center;
        }

        .form-control {
            padding: 12px 15px;
            border: 1px solid #ddd;
            border-radius: 8px;
            font-size: 14px;
            flex: 1;
        }

        .btn-search {
            padding: 12px 25px;
            background-color: #3498db;
            color: white;
            border: none;
            border-radius: 8px;
            cursor: pointer;
        }

        .grid {
            width: 100%;
            border-collapse: separate;
            border-spacing: 0;
            margin-top: 20px;
            border-radius: 8px;
            overflow: hidden;
            border: 1px solid #eee;
        }

        .grid th {
            background-color: #f8f9fa;
            padding: 15px;
            text-align: right;
        }

        .grid td {
            padding: 12px 15px;
            border-bottom: 1px solid #eee;
        }
    </style>
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="MainContent" runat="server">
    <div class="container">
        <h2>🔍 محرك بحث المنتجات</h2>

        <asp:UpdateProgress ID="UpdateProgress1" runat="server" AssociatedUpdatePanelID="UpdatePanel1">
            <ProgressTemplate>
                <div style="text-align:center; padding:10px;">
                    ⏳ جاري التحميل...
                </div>
            </ProgressTemplate>
        </asp:UpdateProgress>

        <asp:UpdatePanel ID="UpdatePanel1" runat="server">
            <ContentTemplate>

                <div class="search-container">
                    <asp:TextBox ID="txtSearch" runat="server"
                        placeholder="ما الذي تبحث عنه؟"
                        CssClass="form-control"
                        AutoPostBack="true"
                        OnTextChanged="txtSearch_TextChanged1" />

                    <asp:DropDownList ID="ddlCategories" runat="server"
                        CssClass="form-control"
                        Style="max-width:200px;"
                        AutoPostBack="true"
                        OnSelectedIndexChanged="ddlCategories_SelectedIndexChanged">
                    </asp:DropDownList>

                    <asp:Button ID="btnSearch" runat="server"
                        Text="بحث"
                        CssClass="btn-search"
                        OnClick="btnSearch_Click" />
                </div>

                <asp:GridView ID="gvResults" runat="server"
                    AutoGenerateColumns="false"
                    CssClass="grid"
                    EmptyDataText="لا توجد نتائج">
                    <Columns>
                        <asp:BoundField DataField="product_id" HeaderText="رقم المنتج" />
                        <asp:BoundField DataField="name" HeaderText="اسم المنتج" />
                        <asp:BoundField DataField="price" HeaderText="السعر" DataFormatString="{0:N2}" />
                        <asp:BoundField DataField="category_name" HeaderText="الفئة" />
                    </Columns>
                </asp:GridView>

            </ContentTemplate>
        </asp:UpdatePanel>
    </div>

</asp:Content>