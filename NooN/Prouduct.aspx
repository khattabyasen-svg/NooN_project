<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="Prouduct.aspx.cs" Inherits="NooN.Prouduct" MasterPageFile="~/Site.Master" %>

<asp:Content ID="Content1" ContentPlaceHolderID="MainContent" runat="server">

<div class="products-page" dir="rtl">

    <%-- ─────────── السايدبار ─────────── --%>
    <aside class="sidebar">

        <div class="filter-card">
            <h3 class="filter-title">📂 الفئات</h3>
            <asp:Repeater ID="rptCategories" runat="server">
                <ItemTemplate>
                    <label class="filter-label">
                        <asp:CheckBox ID="cbCategory" runat="server" />
                        <asp:HiddenField ID="hfCatId" runat="server"
                            Value='<%# Eval("category_id") %>' />
                        <%# Eval("name_ar") %>
                    </label>
                </ItemTemplate>
            </asp:Repeater>
        </div>

        <div class="filter-card">
            <h3 class="filter-title">💰 نطاق السعر</h3>
            <div class="price-range">
                <asp:TextBox ID="txtMinPrice" runat="server" placeholder="من" CssClass="price-input"
                    OnTextChanged="txtMinPrice_TextChanged" />
                <span>—</span>
                <asp:TextBox ID="txtMaxPrice" runat="server" placeholder="إلى" CssClass="price-input" />
            </div>
        </div>

        <div class="filter-card">
            <h3 class="filter-title">⭐ التقييم</h3>
            <label class="filter-label"><asp:CheckBox ID="cb5Star" runat="server" /> ★★★★★ (5)</label>
            <label class="filter-label"><asp:CheckBox ID="cb4Star" runat="server" /> ★★★★☆ (4+)</label>
            <label class="filter-label"><asp:CheckBox ID="cb3Star" runat="server" /> ★★★☆☆ (3+)</label>
        </div>

        <asp:Button ID="btnApplyFilter" runat="server" Text="🔍 تطبيق الفلتر"
            CssClass="btn-apply" OnClick="btnApplyFilter_Click" />

    </aside>

    <%-- ─────────── المنتجات ─────────── --%>
    <main class="products-main">

        <asp:UpdatePanel ID="upToolbar" runat="server" UpdateMode="Conditional">
            <ContentTemplate>
                <div class="toolbar">
                    <span class="count-badge">
                        <asp:Label ID="lblCount" runat="server" Text="0" /> منتج
                    </span>
                    <asp:DropDownList ID="ddlSort" runat="server" CssClass="sort-select"
                        AutoPostBack="true"
                        OnSelectedIndexChanged="ddlSort_SelectedIndexChanged">
                        <asp:ListItem Value="newest"     Text="الأحدث" />
                        <asp:ListItem Value="price_asc"  Text="السعر ↑" />
                        <asp:ListItem Value="price_desc" Text="السعر ↓" />
                        <asp:ListItem Value="rating"     Text="الأعلى تقييماً" />
                    </asp:DropDownList>
                </div>
            </ContentTemplate>
            <Triggers>
                <asp:AsyncPostBackTrigger ControlID="ddlSort"        EventName="SelectedIndexChanged" />
                <asp:AsyncPostBackTrigger ControlID="btnApplyFilter" EventName="Click" />
            </Triggers>
        </asp:UpdatePanel>

        <asp:UpdatePanel ID="upProducts" runat="server" UpdateMode="Conditional">
            <ContentTemplate>
                <div class="products-grid">
                    <asp:Repeater ID="rptProducts" runat="server"
                        OnItemDataBound="rptProducts_ItemDataBound">
                        <ItemTemplate>
                            <div class="product-card">

                                <asp:Literal ID="litBadge" runat="server" />

                                <a href='Details.aspx?id=<%# Eval("product_id") %>'>
                                    <img src='<%# GetFirstImage(Eval("images")) %>'
                                         alt='<%# Eval("name") %>'
                                         class="product-img" loading="lazy" />
                                </a>

                                <%-- AJAX favorite toggle — no postback --%>
                                <button type="button"
                                    class='wish-btn <%# Convert.ToInt32(Eval("is_wished")) == 1 ? "wish-active" : "" %>'
                                    data-pid='<%# Eval("product_id") %>'
                                    onclick="noonShop.toggleFav(this);"><%# Convert.ToInt32(Eval("is_wished")) == 1 ? "❤️" : "🤍" %></button>

                                <div class="card-body">
                                    <span class="category-tag"><%# Eval("category_name") %></span>

                                    <a href='Details.aspx?id=<%# Eval("product_id") %>'
                                       class="product-name"><%# Eval("name") %></a>

                                    <asp:Literal ID="litStars" runat="server" />
                                    <span class="rating-count">(<%# Eval("rating_count") %>)</span>

                                    <div class="price-row">
                                        <span class="p-price"><%# Eval("price", "{0:N0}") %> د.أ</span>
                                        <asp:Literal ID="litOldPrice" runat="server" />
                                    </div>

                                    <%-- Unavailable products stay visible but cannot be added to the cart --%>
                                    <%# Convert.ToInt32(Eval("is_available")) == 0
                                            ? "<div class='p-unavailable'>Product not available.</div>"
                                            : "" %>

                                    <%-- AJAX add to cart — no postback --%>
                                    <button type="button" class="btn-cart"
                                        data-pid='<%# Eval("product_id") %>'
                                        onclick="noonShop.addToCart(this);"
                                        <%# Convert.ToInt32(Eval("is_available")) == 0 ? "disabled" : "" %>>
                                        🛒 أضف للسلة
                                    </button>
                                </div>

                            </div>
                        </ItemTemplate>
                    </asp:Repeater>
                </div>
            </ContentTemplate>
            <Triggers>
                <asp:AsyncPostBackTrigger ControlID="btnApplyFilter" EventName="Click" />
                <asp:AsyncPostBackTrigger ControlID="ddlSort"        EventName="SelectedIndexChanged" />
            </Triggers>
        </asp:UpdatePanel>

    </main>
</div>

<div id="loadingOverlay" style="display:none;">
    <div class="spinner"></div>
</div>

<style>
    .products-page { display:flex; gap:24px; max-width:1300px; margin:24px auto; padding:0 16px; align-items:flex-start; }
    .sidebar { width:240px; flex-shrink:0; position:sticky; top:80px; }
    .filter-card { background:#fff; border:1px solid #e8ecf0; border-radius:12px; padding:16px; margin-bottom:16px; box-shadow:0 2px 8px rgba(0,0,0,.04); }
    .filter-title { font-size:.85rem; font-weight:700; color:#555; text-transform:uppercase; letter-spacing:.05em; margin:0 0 12px; border-bottom:2px solid #f0f0f0; padding-bottom:8px; }
    .filter-label { display:flex; align-items:center; gap:8px; padding:5px 0; cursor:pointer; font-size:.92rem; color:#333; transition:color .15s; }
    .filter-label:hover { color:#e44d26; }
    .price-range { display:flex; align-items:center; gap:8px; }
    .price-input { width:80px; border:1px solid #ddd; border-radius:8px; padding:6px 10px; font-size:.88rem; text-align:center; }
    .price-input:focus { border-color:#e44d26; outline:none; box-shadow:0 0 0 3px rgba(228,77,38,.1); }
    .btn-apply { width:100%; padding:10px; background:linear-gradient(135deg,#e44d26,#f7931e); color:#fff; border:none; border-radius:10px; font-size:.95rem; font-weight:700; cursor:pointer; transition:transform .15s,box-shadow .15s; margin-top:4px; display:block; }
    .btn-apply:hover { transform:translateY(-2px); box-shadow:0 6px 18px rgba(228,77,38,.35); }
    .products-main { flex:1; min-width:0; }
    .toolbar { display:flex; align-items:center; justify-content:space-between; margin-bottom:20px; }
    .count-badge { background:#f8f8f8; border:1px solid #eee; border-radius:20px; padding:4px 14px; font-size:.9rem; color:#666; }
    .sort-select { border:1px solid #ddd; border-radius:8px; padding:6px 12px; font-size:.9rem; cursor:pointer; background:#fff; }
    .products-grid { display:grid; grid-template-columns:repeat(auto-fill,minmax(220px,1fr)); gap:20px; }
    .product-card { background:#fff; border:1px solid #e8ecf0; border-radius:14px; overflow:hidden; position:relative; transition:transform .2s,box-shadow .2s; display:flex; flex-direction:column; }
    .product-card:hover { transform:translateY(-4px); box-shadow:0 12px 32px rgba(0,0,0,.1); }
    .product-img { width:100%; height:200px; object-fit:cover; display:block; transition:transform .35s ease; }
    .product-card:hover .product-img { transform:scale(1.04); }
    .p-badge { position:absolute; top:10px; right:10px; background:#e44d26; color:#fff; font-size:.75rem; font-weight:700; padding:3px 8px; border-radius:20px; z-index:1; }
    .wish-btn { position:absolute; top:10px; left:10px; background:rgba(255,255,255,.85); border:none; border-radius:50%; width:34px; height:34px; display:flex; align-items:center; justify-content:center; font-size:1.1rem; cursor:pointer; transition:transform .15s; z-index:1; backdrop-filter:blur(4px); text-decoration:none; }
    .wish-btn:hover { transform:scale(1.2); background:#fff; }
    .card-body { padding:14px; display:flex; flex-direction:column; gap:6px; flex:1; }
    .category-tag { font-size:.72rem; color:#999; text-transform:uppercase; letter-spacing:.04em; }
    .product-name { font-size:.95rem; font-weight:600; color:#222; text-decoration:none; line-height:1.35; display:-webkit-box; -webkit-line-clamp:2; -webkit-box-orient:vertical; overflow:hidden; }
    .product-name:hover { color:#e44d26; }
    .stars-gold { color:#f4b400; font-size:.9rem; }
    .rating-count { font-size:.78rem; color:#aaa; }
    .price-row { display:flex; align-items:baseline; gap:8px; }
    .p-price { font-size:1.05rem; font-weight:700; color:#e44d26; }
    .p-old-price { font-size:.82rem; color:#bbb; text-decoration:line-through; }
    .btn-cart { margin-top:auto; padding:9px; background:#222; color:#fff; border:none; border-radius:8px; font-size:.88rem; font-weight:600; cursor:pointer; text-align:center; text-decoration:none; display:block; transition:background .2s,transform .15s; width:100%; }
    .btn-cart:hover { background:#e44d26; transform:translateY(-1px); }
    #loadingOverlay { position:fixed; inset:0; background:rgba(255,255,255,.6); backdrop-filter:blur(3px); z-index:9999; display:flex; align-items:center; justify-content:center; }
    .spinner { width:46px; height:46px; border:4px solid #eee; border-top-color:#e44d26; border-radius:50%; animation:spin .7s linear infinite; }
    @keyframes spin { to { transform:rotate(360deg); } }
    @media (max-width:768px) { .products-page { flex-direction:column; } .sidebar { width:100%; position:static; } .products-grid { grid-template-columns:repeat(2,1fr); } }
    @media (max-width:480px) { .products-grid { grid-template-columns:1fr; } }
</style>

<script>
    var prm = Sys.WebForms.PageRequestManager.getInstance();

    prm.add_beginRequest(function () {
        document.getElementById("loadingOverlay").style.display = "flex";
    });

    prm.add_endRequest(function () {
        document.getElementById("loadingOverlay").style.display = "none";
    });
</script>

</asp:Content>
