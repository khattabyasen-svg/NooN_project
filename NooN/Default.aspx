<%@ Page Title="Home" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeBehind="Default.aspx.cs" Inherits="NooN._Default" %>

<asp:Content ID="Content1" ContentPlaceHolderID="MainContent" runat="server">
    <link href="Content/shared.css?v=coral1" rel="stylesheet" />
    <link href="Content/home.css?v=coral1" rel="stylesheet" />

    <div dir="ltr">

        <%-- ===== HERO ===== --%>
        <div class="hero">
            <div class="hero-content">
                <span class="hero-tag">✦ Summer 2026 Collection</span>
                <h1 class="hero-title">Everything you need<br>
                    in <em>one place</em></h1>
                <p class="hero-desc">Shop the latest products from the biggest global and local brands at great prices with fast delivery.</p>
                <div class="hero-actions">
                    <asp:Button ID="btnShopNow" runat="server" Text="Shop Now →" CssClass="btn-primary" OnClick="btnShopNow_Click" />
                    <asp:Button ID="btnDailyOffers" runat="server" Text="Today's Deals" CssClass="btn-secondary" OnClick="btnShopNow_Click" />
               <%--     <asp:Button ID="btnTest" runat="server" Text="Print" CssClass="btn-secondary" OnClick="btnTest_Click" />--%>
                </div>
            </div>

            <div class="hero-image">
                <div class="hero-badge">Up to 70% off</div>
                <div class="hero-visual">
                    <div class="hero-shapes">
                        <div class="shape-card shape-card-1">
                            <div class="shape-icon">📱</div>
                            <div class="shape-label">iPhone 15 Pro</div>
                            <div class="shape-price">3,999 JD</div>
                        </div>
                        <div class="shape-card shape-card-2">
                            <div class="shape-icon" style="font-size: 1.5rem">⌚</div>
                            <div class="shape-label-w">Apple Watch</div>
                            <div class="shape-price-w">1,299 JD</div>
                        </div>
                    </div>
                </div>
            </div>
        </div>

        <%-- ===== CATEGORIES ===== --%>
        <div class="section">
            <div class="section-header">
                <h2 class="section-title">Shop by Category</h2>
                <asp:HyperLink ID="lnkAllCategories" runat="server" NavigateUrl="Prouduct.aspx" CssClass="section-link">View All →</asp:HyperLink>
            </div>

            <%-- Message shown when there are no categories --%>
            <asp:Panel ID="pnlNoCats" runat="server" Visible="false">
                <div class="empty-msg">No categories available at the moment</div>
            </asp:Panel>

            <div class="categories-grid">
                <asp:Repeater ID="rptCategories" runat="server">
                    <ItemTemplate>
                        <div class="cat-card" onclick="location.href='Prouduct.aspx?cat=<%# Eval("category_id") %>'">
                            <span class="cat-icon"><%# Eval("icon") %></span>
                            <span class="cat-name"><%# Eval("name_en") %></span>
                        </div>
                    </ItemTemplate>
                </asp:Repeater>
            </div>
        </div>

        <%-- ===== FEATURED PRODUCTS ===== --%>
        <div class="section">
            <div class="section-header">
                <h2 class="section-title">Featured Products</h2>
                <asp:HyperLink ID="lnkAllProducts" runat="server" NavigateUrl="Prouduct.aspx" CssClass="section-link">View All →</asp:HyperLink>
            </div>

            <%-- Featured products load and update via AJAX (partial postback) --%>
            <asp:UpdatePanel ID="upProducts" runat="server" UpdateMode="Conditional">
                <ContentTemplate>

                    <%-- Message shown when there are no products --%>
                    <asp:Panel ID="pnlNoProducts" runat="server" Visible="false">
                        <div class="empty-msg">No products available at the moment</div>
                    </asp:Panel>

                    <div class="products-grid">
                        <asp:Repeater ID="rptProducts" runat="server">
                            <ItemTemplate>
                                <div class="product-card"
                                    onclick="location.href='Details.aspx?id=<%# Eval("product_id") %>'">

                                    <div class="product-image-wrap">
                                        <%# GetProductImage(Eval("images")) %>

                                        <%# GetDiscountBadge(Eval("discount_pct")) %>

                                        <%-- Favorite toggle: AJAX call that removes the card on un-favorite --%>
                                        <button type="button" class="product-fav active"
                                            data-pid='<%# Eval("product_id") %>'
                                            data-remove-card="1"
                                            title="Remove from favorites"
                                            onclick="event.stopPropagation(); noonShop.toggleFav(this);">❤️</button>
                                    </div>

                                    <div class="product-info">
                                        <div class="product-cat"><%# Eval("category_name") %></div>
                                        <div class="product-name"><%# Eval("name") %></div>

                                        <div class="product-rating">
                                            <%# GetStars(Eval("rating_avg")) %>
                                            <span class="rating-count">(<%# Eval("rating_count") %>)</span>
                                        </div>

                                        <div class="product-price-row">
                                            <div>
                                                <%# GetOldPrice(Eval("old_price")) %>
                                                <span class="product-price">
                                                    <%# string.Format("{0:N2}", Eval("price")) %> JD
                                                </span>
                                            </div>
                                        </div>
                                    </div>
                                </div>
                            </ItemTemplate>
                        </asp:Repeater>
                    </div>

                </ContentTemplate>
            </asp:UpdatePanel>
        </div>

        <%-- ===== PROMO BANNER ===== --%>
        <div class="promo-banner">
            <div>
                <div class="promo-tag">✦ Limited Offer</div>
                <h2 class="promo-title">End of Season Sale<br>
                    Up to 70% off</h2>
                <p class="promo-desc">On thousands of products from the most famous global brands</p>
            </div>
            <div class="promo-cta">
                <asp:Button ID="btnPromo" runat="server" Text="Shop Now"
                    CssClass="btn-primary"
                    Style="margin-top: 12px; background: var(--accent); border-color: var(--accent);"
                    OnClick="btnShopNow_Click" />
            </div>
        </div>

        <%-- ===== FOOTER ===== --%>
        <footer class="footer">
            <div class="footer-grid">
                <div>
                    <div class="footer-brand-name">Noon<span>.</span></div>
                    <p class="footer-desc">The largest online shopping platform in the region. We offer the best products at the best prices.</p>
                </div>
                <div>
                    <div class="footer-heading">Help</div>
                    <ul class="footer-links">
                        <li><a href="Prouduct.aspx">Products</a></li>
                        <li><a href="Cart.aspx">Shopping Cart</a></li>
                    </ul>
                </div>
            </div>
            <div class="footer-bottom">
                <span>© 2026 Noon. All rights reserved.</span>
            </div>
        </footer>
    </div>

    <script src="Scripts/shared.js"></script>
    <script src="Scripts/home.js"></script>
</asp:Content>
