<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="ProductManagement.aspx.cs" Inherits="AdminPanel.ProductManagement" %>

<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="ajaxToolkit" %>
<!DOCTYPE html>
<html xmlns="http://www.w3.org/1999/xhtml" dir="rtl" lang="ar">
<head runat="server">
    <meta charset="UTF-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1.0" />
    <title>إدارة المنتجات</title>
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
                <div class="brand-text">متجر الإدارة</div>
                <div class="brand-sub">لوحة التحكم</div>
            </div>
        </div>
        <div class="sidebar-user">
            <div class="user-avatar">AN</div>
            <div>
                <div class="user-name">Admin Noon</div>
                <div class="user-role">مدير النظام</div>
            </div>
            <i class="fas fa-cog" style="margin-right:auto;color:var(--text-muted);font-size:13px;cursor:pointer;"></i>
        </div>
        <nav class="sidebar-nav">
            <div class="nav-section-title">الرئيسية</div>
            <a class="nav-item" href="#"><span class="nav-icon"><i class="fas fa-chart-pie"></i></span> لوحة التحكم</a>
            <div class="nav-section-title">المخزن</div>
            <a class="nav-item active" href="#"><span class="nav-icon"><i class="fas fa-boxes-stacked"></i></span> المنتجات</a>
            <a class="nav-item" href="..\Proudct_Categories.aspx"><span class="nav-icon"><i class="fas fa-tags"></i></span> فئات المنتجات</a>
            <a class="nav-item" href="#"><span class="nav-icon"><i class="fas fa-shopping-bag"></i></span> الطلبات<span class="nav-badge">12</span></a>
            <div class="nav-section-title">الأشخاص</div>
            <a class="nav-item" href="#"><span class="nav-icon"><i class="fas fa-users"></i></span> المستخدمون</a>
            <a class="nav-item" href="#"><span class="nav-icon"><i class="fas fa-truck"></i></span> المورّدون</a>
            <div class="nav-section-title">التسويق</div>
            <a class="nav-item" href="#"><span class="nav-icon"><i class="fas fa-ticket"></i></span> الكوبونات</a>
            <a class="nav-item" href="#"><span class="nav-icon"><i class="fas fa-layer-group"></i></span> الفئات</a>
        </nav>
        <div class="sidebar-footer">
            <a class="nav-item" href="#"><span class="nav-icon"><i class="fas fa-gear"></i></span> الإعدادات</a>
            <a class="nav-item" href="#"><span class="nav-icon"><i class="fas fa-right-from-bracket"></i></span> تسجيل الخروج</a>
        </div>
    </aside>

    <!-- MAIN -->
    <main class="main">
        <div class="topbar">
            <div class="breadcrumb">
                <i class="fas fa-home" style="font-size:12px;"></i>
                <span class="sep"><i class="fas fa-chevron-left"></i></span>
                <a href="#">Admin</a>
                <span class="sep"><i class="fas fa-chevron-left"></i></span>
                <a href="#">المنتجات</a>
                <span class="sep"><i class="fas fa-chevron-left"></i></span>
                <span class="current">إدارة المنتجات</span>
            </div>
            <div class="topbar-actions">
                <asp:Button ID="btnDeleteSelected" runat="server" CssClass="btn btn-danger" Text="🗑 حذف محدد" OnClick="btnDeleteSelected_Click" />
                <asp:Button ID="btnAddProduct"     runat="server" CssClass="btn btn-primary" Text="+ إضافة منتج" OnClick="btnAddProduct_Click" />
            </div>
        </div>

        <div class="content">
            <div class="page-header">
                <div class="page-icon"><i class="fas fa-boxes-stacked"></i></div>
                <div>
                    <div class="page-title">إدارة المنتجات</div>
                    <div class="page-subtitle">عرض وإدارة جميع منتجات المتجر</div>
                </div>
            </div>

            <div class="stat-tabs">
                <button type="button" class="stat-tab active" onclick="switchTab(this)">الكل <span class="tab-count">48</span></button>
                <button type="button" class="stat-tab" onclick="switchTab(this)">نشط <span class="tab-count">36</span></button>
                <button type="button" class="stat-tab" onclick="switchTab(this)">غير نشط <span class="tab-count">8</span></button>
                <button type="button" class="stat-tab" onclick="switchTab(this)">نفذ المخزون <span class="tab-count">4</span></button>
            </div>

            <div class="filters-bar">
                <div class="search-wrap">
                    <i class="fas fa-search search-icon"></i>
                    <asp:TextBox ID="txtSearch" runat="server" placeholder="ابحث باسم المنتج أو SKU أو الماركة..." AutoPostBack="true" OnTextChanged="txtSearch_TextChanged" />
                </div>
<div class="select-wrap">
    <asp:DropDownList 
        ID="ddlCategory" 
        runat="server" 
        AutoPostBack="true" 
        CssClass="filter-select" 
        OnSelectedIndexChanged="ddlCategory_SelectedIndexChanged">
        <asp:ListItem Value="">كل الفئات</asp:ListItem>
        <asp:ListItem Value="tech">تقنية</asp:ListItem>
        <asp:ListItem Value="sports">رياضة</asp:ListItem>
        <asp:ListItem Value="home">منزل وديكور</asp:ListItem>
    </asp:DropDownList>
</div>
                <div class="select-wrap">
                    <asp:DropDownList ID="ddlBrand" runat="server" CssClass="filter-select" AutoPostBack="true" OnSelectedIndexChanged="ddlBrand_SelectedIndexChanged">
                        <asp:ListItem Value="">كل الماركات</asp:ListItem>
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
                            <th>المنتج</th>
                            <th>الفئة</th>
                            <th>السعر</th>
                            <th>المخزون</th>
                            <th>الحالة</th>
                            <th style="text-align:left;">الإجراءات</th>
                        </tr>
                    </thead>
                    <tbody>
                        <tr>
                            <td><input type="checkbox" class="cb-custom row-cb" /></td>
                            <td><div class="product-cell"><div class="product-thumb">📱</div><div><div class="product-name">iPhone 15 Pro Max 256GB</div><div class="product-sku">APL-IPH15P-256</div></div></div></td>
                            <td><span class="cat-badge"><i class="fas fa-microchip" style="font-size:10px;"></i> تقنية</span></td>
                            <td><span class="price-now">ر.س 3,999</span><span class="price-old">4,599</span></td>
                            <td><div class="stock-wrap"><div class="stock-label"><span>مخزون</span><span class="stock-num" style="color:#16a34a;">84 قطعة</span></div><div class="stock-bar"><div class="stock-fill fill-green" style="width:84%"></div></div></div></td>
                            <td><span class="status status-active"><span class="status-dot"></span> نشط</span></td>
                            <td><div class="actions-cell"><button type="button" class="action-btn edit" title="تعديل"><i class="fas fa-pen"></i></button><button type="button" class="action-btn del" title="حذف"><i class="fas fa-trash"></i></button></div></td>
                        </tr>
                        <tr>
                            <td><input type="checkbox" class="cb-custom row-cb" /></td>
                            <td><div class="product-cell"><div class="product-thumb">🎧</div><div><div class="product-name">Sony WH-1000XM5</div><div class="product-sku">SNY-WH1000XM5</div></div></div></td>
                            <td><span class="cat-badge"><i class="fas fa-microchip" style="font-size:10px;"></i> تقنية</span></td>
                            <td><span class="price-now">ر.س 1,199</span><span class="price-old">1,499</span></td>
                            <td><div class="stock-wrap"><div class="stock-label"><span>منخفض</span><span class="stock-num" style="color:#c2410c;">12 متبقي</span></div><div class="stock-bar"><div class="stock-fill fill-orange" style="width:12%"></div></div></div></td>
                            <td><span class="status status-lowstock"><span class="status-dot"></span> منخفض</span></td>
                            <td><div class="actions-cell"><button type="button" class="action-btn edit"><i class="fas fa-pen"></i></button><button type="button" class="action-btn del"><i class="fas fa-trash"></i></button></div></td>
                        </tr>
                        <tr>
                            <td><input type="checkbox" class="cb-custom row-cb" /></td>
                            <td><div class="product-cell"><div class="product-thumb">👟</div><div><div class="product-name">Nike Air Max 270 React</div><div class="product-sku">NKE-AIRMAX270-43</div></div></div></td>
                            <td><span class="cat-badge"><i class="fas fa-futbol" style="font-size:10px;"></i> رياضة</span></td>
                            <td><span class="price-now">ر.س 649</span><span class="price-old">739</span></td>
                            <td><div class="stock-wrap"><div class="stock-label"><span>نفد</span><span class="stock-num" style="color:#b91c1c;">0 نفد</span></div><div class="stock-bar"><div class="stock-fill fill-red" style="width:2%"></div></div></div></td>
                            <td><span class="status status-outstock"><span class="status-dot"></span> نفذ المخزون</span></td>
                            <td><div class="actions-cell"><button type="button" class="action-btn edit"><i class="fas fa-pen"></i></button><button type="button" class="action-btn del"><i class="fas fa-trash"></i></button></div></td>
                        </tr>
                        <tr>
                            <td><input type="checkbox" class="cb-custom row-cb" /></td>
                            <td><div class="product-cell"><div class="product-thumb">⌚</div><div><div class="product-name">Apple Watch Ultra 2</div><div class="product-sku">APL-WATCH-ULT2</div></div></div></td>
                            <td><span class="cat-badge"><i class="fas fa-microchip" style="font-size:10px;"></i> تقنية</span></td>
                            <td><span class="price-now">ر.س 2,199</span><span class="price-old">2,599</span></td>
                            <td><div class="stock-wrap"><div class="stock-label"><span>مخزون</span><span class="stock-num" style="color:#16a34a;">56 قطعة</span></div><div class="stock-bar"><div class="stock-fill fill-green" style="width:56%"></div></div></div></td>
                            <td><span class="status status-inactive"><span class="status-dot"></span> غير نشط</span></td>
                            <td><div class="actions-cell"><button type="button" class="action-btn edit"><i class="fas fa-pen"></i></button><button type="button" class="action-btn del"><i class="fas fa-trash"></i></button></div></td>
                        </tr>
                        <tr>
                            <td><input type="checkbox" class="cb-custom row-cb" /></td>
                            <td><div class="product-cell"><div class="product-thumb">🛋️</div><div><div class="product-name">طقم أثاث غرفة المعيشة</div><div class="product-sku">HM-SOFA-CLX-5PC</div></div></div></td>
                            <td><span class="cat-badge"><i class="fas fa-couch" style="font-size:10px;"></i> منزل وديكور</span></td>
                            <td><span class="price-now">ر.س 2,499</span><span class="price-old">3,200</span></td>
                            <td><div class="stock-wrap"><div class="stock-label"><span>منخفض</span><span class="stock-num" style="color:#c2410c;">7 متبقي</span></div><div class="stock-bar"><div class="stock-fill fill-orange" style="width:7%"></div></div></div></td>
                            <td><span class="status status-active"><span class="status-dot"></span> نشط</span></td>
                            <td><div class="actions-cell"><button type="button" class="action-btn edit"><i class="fas fa-pen"></i></button><button type="button" class="action-btn del"><i class="fas fa-trash"></i></button></div></td>
                        </tr>
                    </tbody>
                </table>
                <div class="table-footer">
                    <div class="footer-info">عرض 1–5 من 48 منتج</div>
                    <div class="pagination">
                        <button type="button" class="page-btn arrow"><i class="fas fa-chevron-right"></i></button>
                        <button type="button" class="page-btn active">1</button>
                        <button type="button" class="page-btn">2</button>
                        <button type="button" class="page-btn">3</button>
                        <button type="button" class="page-btn arrow"><i class="fas fa-chevron-left"></i></button>
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
