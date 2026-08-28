<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="ProductManagement.aspx.cs" Inherits="AdminPanel.ProductManagement" %>

<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="ajaxToolkit" %>
<!DOCTYPE html>
<html xmlns="http://www.w3.org/1999/xhtml" dir="ltr" lang="en">
<head runat="server">
    <meta charset="UTF-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1.0" />
    <title>Product Management</title>
    <link href="https://fonts.googleapis.com/css2?family=Cairo:wght@300;400;500;600;700;800&display=swap" rel="stylesheet" />
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css" rel="stylesheet" />
    <link href="../Content/Add_pro.css" rel="stylesheet" />

</head>
<body>
<form id="form1" runat="server">
<div class="layout">

    <!-- SIDEBAR -->
    <aside class="sidebar">
        <div class="sidebar-brand">
            <div class="brand-icon"><i class="fas fa-store"></i></div>
            <div>
                <div class="brand-text">Admin Store</div>
                <div class="brand-sub">Control Panel</div>
            </div>
        </div>
        <div class="sidebar-user">
            <div class="user-avatar">AN</div>
            <div>
                <div class="user-name">Admin Noon</div>
                <div class="user-role">System Administrator</div>
            </div>
            <i class="fas fa-cog" style="margin-left:auto;color:var(--text-muted);font-size:13px;cursor:pointer;"></i>
        </div>
        <nav class="sidebar-nav">
            <div class="nav-section-title">Home</div>
            <a class="nav-item" href="#"><span class="nav-icon"><i class="fas fa-chart-pie"></i></span> Dashboard</a>
            <div class="nav-section-title">Inventory</div>
            <a class="nav-item active" href="#"><span class="nav-icon"><i class="fas fa-boxes-stacked"></i></span> Products</a>
            <a class="nav-item" href="..\Proudct_Categories.aspx"><span class="nav-icon"><i class="fas fa-tags"></i></span> Product Categories</a>
            <a class="nav-item" href="#"><span class="nav-icon"><i class="fas fa-shopping-bag"></i></span> Orders<span class="nav-badge">12</span></a>
            <div class="nav-section-title">People</div>
            <a class="nav-item" href="#"><span class="nav-icon"><i class="fas fa-users"></i></span> Users</a>
            <a class="nav-item" href="#"><span class="nav-icon"><i class="fas fa-truck"></i></span> Suppliers</a>
            <div class="nav-section-title">Marketing</div>
            <a class="nav-item" href="#"><span class="nav-icon"><i class="fas fa-ticket"></i></span> Coupons</a>
            <a class="nav-item" href="#"><span class="nav-icon"><i class="fas fa-layer-group"></i></span> Categories</a>
        </nav>
        <div class="sidebar-footer">
            <a class="nav-item" href="#"><span class="nav-icon"><i class="fas fa-gear"></i></span> Settings</a>
            <a class="nav-item" href="#"><span class="nav-icon"><i class="fas fa-right-from-bracket"></i></span> Sign Out</a>
        </div>
    </aside>

    <!-- MAIN -->
    <main class="main">
        <div class="topbar">
            <div class="breadcrumb">
                <i class="fas fa-home" style="font-size:12px;"></i>
                <span class="sep"><i class="fas fa-chevron-right"></i></span>
                <a href="#">Admin</a>
                <span class="sep"><i class="fas fa-chevron-right"></i></span>
                <a href="#">Products</a>
                <span class="sep"><i class="fas fa-chevron-right"></i></span>
                <span class="current">Product Management</span>
            </div>
            <div class="topbar-actions">
                <asp:Button ID="btnDeleteSelected" runat="server" CssClass="btn btn-danger" Text="🗑 Delete Selected" OnClick="btnDeleteSelected_Click" />
                <asp:Button ID="btnAddProduct"     runat="server" CssClass="btn btn-primary" Text="+ Add Product" OnClick="btnAddProduct_Click" />
            </div>
        </div>

        <div class="content">
            <div class="page-header">
                <div class="page-icon"><i class="fas fa-boxes-stacked"></i></div>
                <div>
                    <div class="page-title">Product Management</div>
                    <div class="page-subtitle">View and manage all store products</div>
                </div>
            </div>

            <div class="stat-tabs">
                <button type="button" class="stat-tab active" onclick="switchTab(this)">All <span class="tab-count">48</span></button>
                <button type="button" class="stat-tab" onclick="switchTab(this)">Active <span class="tab-count">36</span></button>
                <button type="button" class="stat-tab" onclick="switchTab(this)">Inactive <span class="tab-count">8</span></button>
                <button type="button" class="stat-tab" onclick="switchTab(this)">Out of Stock <span class="tab-count">4</span></button>
            </div>

            <div class="filters-bar">
                <div class="search-wrap">
                    <i class="fas fa-search search-icon"></i>
                    <asp:TextBox ID="txtSearch" runat="server" placeholder="Search by product name, SKU, or brand..." AutoPostBack="true" OnTextChanged="txtSearch_TextChanged" />
                </div>
<div class="select-wrap">
    <asp:DropDownList
        ID="ddlCategory"
        runat="server"
        AutoPostBack="true"
        CssClass="filter-select"
        OnSelectedIndexChanged="ddlCategory_SelectedIndexChanged">
        <asp:ListItem Value="">All Categories</asp:ListItem>
        <asp:ListItem Value="tech">Technology</asp:ListItem>
        <asp:ListItem Value="sports">Sports</asp:ListItem>
        <asp:ListItem Value="home">Home &amp; Decor</asp:ListItem>
    </asp:DropDownList>
</div>
                <div class="select-wrap">
                    <asp:DropDownList ID="ddlBrand" runat="server" CssClass="filter-select" AutoPostBack="true" OnSelectedIndexChanged="ddlBrand_SelectedIndexChanged">
                        <asp:ListItem Value="">All Brands</asp:ListItem>
                        <asp:ListItem Value="apple">Apple</asp:ListItem>
                        <asp:ListItem Value="sony">Sony</asp:ListItem>
                        <asp:ListItem Value="nike">Nike</asp:ListItem>
                    </asp:DropDownList>
                </div>
            </div>

            <div class="table-card">
                <table>
                    <thead>
                        <tr>
                            <th><input type="checkbox" class="cb-custom" id="chkAll" onclick="toggleAll(this)" /></th>
                            <th>Product</th>
                            <th>Category</th>
                            <th>Price</th>
                            <th>Stock</th>
                            <th>Status</th>
                            <th style="text-align:right;">Actions</th>
                        </tr>
                    </thead>
                    <tbody>
                        <tr>
                            <td><input type="checkbox" class="cb-custom row-cb" /></td>
                            <td><div class="product-cell"><div class="product-thumb">📱</div><div><div class="product-name">iPhone 15 Pro Max 256GB</div><div class="product-sku">APL-IPH15P-256</div></div></div></td>
                            <td><span class="cat-badge"><i class="fas fa-microchip" style="font-size:10px;"></i> Technology</span></td>
                            <td><span class="price-now">3,999 JD</span><span class="price-old">4,599</span></td>
                            <td><div class="stock-wrap"><div class="stock-label"><span>In stock</span><span class="stock-num" style="color:#16a34a;">84 units</span></div><div class="stock-bar"><div class="stock-fill fill-green" style="width:84%"></div></div></div></td>
                            <td><span class="status status-active"><span class="status-dot"></span> Active</span></td>
                            <td><div class="actions-cell"><button type="button" class="action-btn edit" title="Edit"><i class="fas fa-pen"></i></button><button type="button" class="action-btn del" title="Delete"><i class="fas fa-trash"></i></button></div></td>
                        </tr>
                        <tr>
                            <td><input type="checkbox" class="cb-custom row-cb" /></td>
                            <td><div class="product-cell"><div class="product-thumb">🎧</div><div><div class="product-name">Sony WH-1000XM5</div><div class="product-sku">SNY-WH1000XM5</div></div></div></td>
                            <td><span class="cat-badge"><i class="fas fa-microchip" style="font-size:10px;"></i> Technology</span></td>
                            <td><span class="price-now">1,199 JD</span><span class="price-old">1,499</span></td>
                            <td><div class="stock-wrap"><div class="stock-label"><span>Low</span><span class="stock-num" style="color:#c2410c;">12 left</span></div><div class="stock-bar"><div class="stock-fill fill-orange" style="width:12%"></div></div></div></td>
                            <td><span class="status status-lowstock"><span class="status-dot"></span> Low</span></td>
                            <td><div class="actions-cell"><button type="button" class="action-btn edit"><i class="fas fa-pen"></i></button><button type="button" class="action-btn del"><i class="fas fa-trash"></i></button></div></td>
                        </tr>
                        <tr>
                            <td><input type="checkbox" class="cb-custom row-cb" /></td>
                            <td><div class="product-cell"><div class="product-thumb">👟</div><div><div class="product-name">Nike Air Max 270 React</div><div class="product-sku">NKE-AIRMAX270-43</div></div></div></td>
                            <td><span class="cat-badge"><i class="fas fa-futbol" style="font-size:10px;"></i> Sports</span></td>
                            <td><span class="price-now">649 JD</span><span class="price-old">739</span></td>
                            <td><div class="stock-wrap"><div class="stock-label"><span>Out</span><span class="stock-num" style="color:#b91c1c;">0 out</span></div><div class="stock-bar"><div class="stock-fill fill-red" style="width:2%"></div></div></div></td>
                            <td><span class="status status-outstock"><span class="status-dot"></span> Out of Stock</span></td>
                            <td><div class="actions-cell"><button type="button" class="action-btn edit"><i class="fas fa-pen"></i></button><button type="button" class="action-btn del"><i class="fas fa-trash"></i></button></div></td>
                        </tr>
                        <tr>
                            <td><input type="checkbox" class="cb-custom row-cb" /></td>
                            <td><div class="product-cell"><div class="product-thumb">⌚</div><div><div class="product-name">Apple Watch Ultra 2</div><div class="product-sku">APL-WATCH-ULT2</div></div></div></td>
                            <td><span class="cat-badge"><i class="fas fa-microchip" style="font-size:10px;"></i> Technology</span></td>
                            <td><span class="price-now">2,199 JD</span><span class="price-old">2,599</span></td>
                            <td><div class="stock-wrap"><div class="stock-label"><span>In stock</span><span class="stock-num" style="color:#16a34a;">56 units</span></div><div class="stock-bar"><div class="stock-fill fill-green" style="width:56%"></div></div></div></td>
                            <td><span class="status status-inactive"><span class="status-dot"></span> Inactive</span></td>
                            <td><div class="actions-cell"><button type="button" class="action-btn edit"><i class="fas fa-pen"></i></button><button type="button" class="action-btn del"><i class="fas fa-trash"></i></button></div></td>
                        </tr>
                        <tr>
                            <td><input type="checkbox" class="cb-custom row-cb" /></td>
                            <td><div class="product-cell"><div class="product-thumb">🛋️</div><div><div class="product-name">Living Room Furniture Set</div><div class="product-sku">HM-SOFA-CLX-5PC</div></div></div></td>
                            <td><span class="cat-badge"><i class="fas fa-couch" style="font-size:10px;"></i> Home &amp; Decor</span></td>
                            <td><span class="price-now">2,499 JD</span><span class="price-old">3,200</span></td>
                            <td><div class="stock-wrap"><div class="stock-label"><span>Low</span><span class="stock-num" style="color:#c2410c;">7 left</span></div><div class="stock-bar"><div class="stock-fill fill-orange" style="width:7%"></div></div></div></td>
                            <td><span class="status status-active"><span class="status-dot"></span> Active</span></td>
                            <td><div class="actions-cell"><button type="button" class="action-btn edit"><i class="fas fa-pen"></i></button><button type="button" class="action-btn del"><i class="fas fa-trash"></i></button></div></td>
                        </tr>
                    </tbody>
                </table>
                <div class="table-footer">
                    <div class="footer-info">Showing 1–5 of 48 products</div>
                    <div class="pagination">
                        <button type="button" class="page-btn arrow"><i class="fas fa-chevron-left"></i></button>
                        <button type="button" class="page-btn active">1</button>
                        <button type="button" class="page-btn">2</button>
                        <button type="button" class="page-btn">3</button>
                        <button type="button" class="page-btn arrow"><i class="fas fa-chevron-right"></i></button>
                    </div>
                </div>
            </div>
        </div>
    </main>
</div>
</form>

    <script src="../Scripts/Add_pro.js"></script>
</body>
</html>
