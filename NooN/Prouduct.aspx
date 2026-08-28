<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="Prouduct.aspx.cs" Inherits="NooN.Prouduct" MasterPageFile="~/Site.Master" %>

<asp:Content ID="HeadContent" ContentPlaceHolderID="head" runat="server">
    <link href="Content/products.css?v=coral1" rel="stylesheet" />
</asp:Content>

<asp:Content ID="Content1" ContentPlaceHolderID="MainContent" runat="server">

<div class="products-page" dir="ltr">

    <%-- ─────────── Sidebar ─────────── --%>
    <aside class="sidebar">

        <div class="filter-card">
            <h3 class="filter-title">📂 Categories</h3>
            <asp:Repeater ID="rptCategories" runat="server">
                <ItemTemplate>
                    <label class="filter-label">
                        <asp:CheckBox ID="cbCategory" runat="server" />
                        <asp:HiddenField ID="hfCatId" runat="server"
                            Value='<%# Eval("category_id") %>' />
                        <%# Eval("name_en") %>
                    </label>
                </ItemTemplate>
            </asp:Repeater>
        </div>

        <div class="filter-card">
            <h3 class="filter-title">💰 Price Range</h3>
            <div class="price-range">
                <asp:TextBox ID="txtMinPrice" runat="server" placeholder="From" CssClass="price-input"
                    OnTextChanged="txtMinPrice_TextChanged" />
                <span>—</span>
                <asp:TextBox ID="txtMaxPrice" runat="server" placeholder="To" CssClass="price-input" />
            </div>
        </div>

        <div class="filter-card">
            <h3 class="filter-title">⭐ Rating</h3>
            <label class="filter-label"><asp:CheckBox ID="cb5Star" runat="server" /> ★★★★★ (5)</label>
            <label class="filter-label"><asp:CheckBox ID="cb4Star" runat="server" /> ★★★★☆ (4+)</label>
            <label class="filter-label"><asp:CheckBox ID="cb3Star" runat="server" /> ★★★☆☆ (3+)</label>
        </div>

        <asp:Button ID="btnApplyFilter" runat="server" Text="🔍 Apply Filter"
            CssClass="btn-apply" OnClick="btnApplyFilter_Click" />

    </aside>

    <%-- ─────────── Products ─────────── --%>
    <main class="products-main">

        <asp:UpdatePanel ID="upToolbar" runat="server" UpdateMode="Conditional">
            <ContentTemplate>
                <div class="toolbar">
                    <span class="count-badge">
                        <asp:Label ID="lblCount" runat="server" Text="0" /> products
                    </span>
                    <asp:DropDownList ID="ddlSort" runat="server" CssClass="sort-select"
                        AutoPostBack="true"
                        OnSelectedIndexChanged="ddlSort_SelectedIndexChanged">
                        <asp:ListItem Value="newest"     Text="Newest" />
                        <asp:ListItem Value="price_asc"  Text="Price ↑" />
                        <asp:ListItem Value="price_desc" Text="Price ↓" />
                        <asp:ListItem Value="rating"     Text="Top Rated" />
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
                                        <span class="p-price"><%# Eval("price", "{0:N0}") %> JD</span>
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
                                        🛒 Add to Cart
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

<script src="Scripts/products.js"></script>

</asp:Content>
