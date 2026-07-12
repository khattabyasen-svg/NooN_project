<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="AddnewItem.aspx.cs" Inherits="NooN.AddnewItem" %>

<!DOCTYPE html>
<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title>Add New Product - NooN</title>
    <script src="https://cdn.tailwindcss.com"></script>
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css" rel="stylesheet" />
    <style>
    .custom-checkbox-list input[type="checkbox"] {
        margin-left: 5px;
        width: 16px;
        height: 16px;
        cursor: pointer;
    }
    .custom-checkbox-list label {
        cursor: pointer;
        font-size: 14px;
        color: #4a5568;
    }
</style>
</head>
<body class="bg-gray-50 font-sans">
    <form id="form1" runat="server" enctype="multipart/form-data">
        <div class="container mx-auto py-10 px-4">
            <div class="max-w-4xl mx-auto mb-8 flex justify-between items-center">
                <h1 class="text-2xl font-bold text-gray-800">Add New Product to Warehouse</h1>
                <a href="Prouduct.aspx" class="text-blue-600 hover:underline"><i class="fas fa-arrow-left"></i>Back to Products</a>
            </div>

            <div class="max-w-4xl mx-auto bg-white rounded-xl shadow-md overflow-hidden border border-gray-100">
                <div class="p-8">
                    <asp:Label ID="lblMessage" runat="server" Visible="false" />

                    <div class="grid grid-cols-1 md:grid-cols-2 gap-6 mb-8">
                        <div>
                            <label class="block text-sm font-medium text-gray-700 mb-1">Product Name</label>
                            <asp:TextBox ID="txtName" runat="server" CssClass="w-full px-4 py-2 border border-gray-300 rounded-lg focus:ring-2 focus:ring-blue-500 outline-none" placeholder="Enter product name"></asp:TextBox>
                        </div>
                        <div>
                            <label class="block text-sm font-medium text-gray-700 mb-1">Slug (URL)</label>
                            <asp:TextBox ID="txtSlug" runat="server" CssClass="w-full px-4 py-2 border border-gray-300 rounded-lg focus:ring-2 focus:ring-blue-500 outline-none" placeholder="product-url-example"></asp:TextBox>
                        </div>
                        <div>
                            <label class="block text-sm font-medium text-gray-700 mb-1">Category</label>
                            <asp:DropDownList ID="ddlCategory" runat="server" CssClass="w-full px-4 py-2 border border-gray-300 rounded-lg focus:ring-2 focus:ring-blue-500 outline-none">
                                <asp:ListItem Text="Select Category" Value="0"></asp:ListItem>
                                <%-- Categories will be loaded from the database --%>
                            </asp:DropDownList>
                        </div>
                        <div>
                            <label class="block text-sm font-medium text-gray-700 mb-1">Brand</label>
                            <asp:TextBox ID="txtBrand" runat="server" CssClass="w-full px-4 py-2 border border-gray-300 rounded-lg focus:ring-2 focus:ring-blue-500 outline-none"></asp:TextBox>
                        </div>
                    </div>

                    <hr class="my-6 border-gray-100" />

                    <h3 class="text-lg font-semibold text-gray-700 mb-4">Pricing &amp; Inventory</h3>
                    <div class="grid grid-cols-1 md:grid-cols-4 gap-4 mb-8">
                        <div>
                            <label class="block text-sm font-medium text-gray-700 mb-1">Current Price</label>
                            <asp:TextBox ID="txtPrice" runat="server" TextMode="Number" step="0.01" CssClass="w-full px-4 py-2 border border-gray-300 rounded-lg focus:ring-2 focus:ring-blue-500 outline-none"></asp:TextBox>
                        </div>
                        <div>
                            <label class="block text-sm font-medium text-gray-700 mb-1">Old Price</label>
                            <asp:TextBox ID="txtOldPrice" runat="server" TextMode="Number" step="0.01" CssClass="w-full px-4 py-2 border border-gray-300 rounded-lg focus:ring-2 focus:ring-blue-500 outline-none"></asp:TextBox>
                        </div>
                        <div>
                            <label class="block text-sm font-medium text-gray-700 mb-1">Discount (%)</label>
                            <asp:TextBox ID="txtDiscount" runat="server" TextMode="Number" CssClass="w-full px-4 py-2 border border-gray-300 rounded-lg focus:ring-2 focus:ring-blue-500 outline-none"></asp:TextBox>
                        </div>
                        <div>
                            <label class="block text-sm font-medium text-gray-700 mb-1">Product Code (SKU)</label>
                            <asp:TextBox ID="txtSKU" runat="server" CssClass="w-full px-4 py-2 border border-gray-300 rounded-lg focus:ring-2 focus:ring-blue-500 outline-none"></asp:TextBox>
                        </div>
                        <div>
                            <label class="block text-sm font-medium text-gray-700 mb-1">Stock Quantity</label>
                            <asp:TextBox ID="txtStockQty" runat="server" TextMode="Number" min="0" CssClass="w-full px-4 py-2 border border-gray-300 rounded-lg focus:ring-2 focus:ring-blue-500 outline-none"></asp:TextBox>
                        </div>
                    </div>

                    <div class="mb-8">
                        <label class="block text-sm font-medium text-gray-700 mb-1">Product Description</label>
                        <asp:TextBox ID="txtDescription" runat="server" TextMode="MultiLine" Rows="4" CssClass="w-full px-4 py-2 border border-gray-300 rounded-lg focus:ring-2 focus:ring-blue-500 outline-none"></asp:TextBox>
                    </div>
                    <%-- Add this section before the "Product Images" section --%>

                    <hr class="my-6 border-gray-100" />

                    <h3 class="text-lg font-semibold text-gray-700 mb-4">Product Options (Customization)</h3>
                    <div class="grid grid-cols-1 md:grid-cols-2 gap-8 mb-8">

                        <div class="bg-gray-50 p-4 rounded-xl border border-gray-200">
                            <label class="block text-sm font-bold text-gray-700 mb-3">
                                <i class="fas fa-palette ml-1 text-blue-500"></i>Available Colors
                            </label>
                            <div class="flex flex-wrap gap-3">
                                <asp:CheckBoxList ID="cblColors" runat="server" RepeatDirection="Horizontal" RepeatLayout="Flow" CssClass="custom-checkbox-list">
                                    <asp:ListItem Value="Red" Text="&nbsp;Red&nbsp;&nbsp;"></asp:ListItem>
                                    <asp:ListItem Value="Blue" Text="&nbsp;Blue&nbsp;&nbsp;"></asp:ListItem>
                                    <asp:ListItem Value="Black" Text="&nbsp;Black&nbsp;&nbsp;"></asp:ListItem>
                                    <asp:ListItem Value="White" Text="&nbsp;White&nbsp;&nbsp;"></asp:ListItem>
                                    <asp:ListItem Value="Green" Text="&nbsp;Green&nbsp;&nbsp;"></asp:ListItem>
                                </asp:CheckBoxList>
                            </div>
                            <div class="mt-3">
                                <asp:TextBox ID="txtCustomColor" runat="server" placeholder="Add another color..." CssClass="text-xs w-full px-3 py-1 border border-gray-300 rounded-md outline-none focus:ring-1 focus:ring-blue-400"></asp:TextBox>
                            </div>
                        </div>

                        <div class="bg-gray-50 p-4 rounded-xl border border-gray-200">
                            <label class="block text-sm font-bold text-gray-700 mb-3">
                                <i class="fas fa-ruler-combined ml-1 text-blue-500"></i>Available Sizes
                            </label>
                            <div class="flex flex-wrap gap-3">
                                <asp:CheckBoxList ID="cblSizes" runat="server" RepeatDirection="Horizontal" RepeatLayout="Flow" CssClass="custom-checkbox-list">
                                    <asp:ListItem Value="S" Text="&nbsp;S&nbsp;&nbsp;"></asp:ListItem>
                                    <asp:ListItem Value="M" Text="&nbsp;M&nbsp;&nbsp;"></asp:ListItem>
                                    <asp:ListItem Value="L" Text="&nbsp;L&nbsp;&nbsp;"></asp:ListItem>
                                    <asp:ListItem Value="XL" Text="&nbsp;XL&nbsp;&nbsp;"></asp:ListItem>
                                    <asp:ListItem Value="XXL" Text="&nbsp;XXL&nbsp;&nbsp;"></asp:ListItem>
                                </asp:CheckBoxList>
                            </div>
                            <p class="text-[10px] text-gray-400 mt-2">* You can select more than one size per product</p>
                        </div>
                        
                    </div>

                    <%-- Continue withh the rest of the code (images section) --%>

                    <div class="mb-8 border-2 border-dashed border-gray-200 p-6 rounded-lg text-center">
                        <label class="block text-sm font-medium text-gray-700 mb-2">Product Images</label>
                        <div class="flex flex-col items-center">
                            <i class="fas fa-cloud-upload-alt text-3xl text-gray-400 mb-2"></i>
                            <asp:FileUpload ID="fileImages" runat="server" AllowMultiple="true" CssClass="text-sm text-gray-500 file:mr-4 file:py-2 file:px-4 file:rounded-full file:border-0 file:text-sm file:font-semibold file:bg-blue-50 file:text-blue-700 hover:file:bg-blue-100" />
                        </div>
                    </div>

                    <div class="flex justify-end gap-4">
                        <asp:Button ID="btnCancel" runat="server" Text="Cancel" CausesValidation="false" OnClick="btnCancel_Click" CssClass="px-6 py-2 bg-gray-200 text-gray-700 rounded-lg hover:bg-gray-300 cursor-pointer" />
                        <asp:Button ID="btnSubmit" runat="server" Text="Save Product" OnClick="btnSubmit_Click" CssClass="px-6 py-2 bg-blue-600 text-white rounded-lg hover:bg-blue-700 shadow-lg cursor-pointer transition duration-200" />
                    </div>
                </div>
            </div>
        </div>
    </form>
</body>
</html>
