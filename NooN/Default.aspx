<%@ Page Title="الرئيسية" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeBehind="Default.aspx.cs" Inherits="NooN._Default" %>

<asp:Content ID="Content1" ContentPlaceHolderID="MainContent" runat="server">
    <link href="Content/shared.css" rel="stylesheet" />
    <link href="Content/home.css" rel="stylesheet" />

    <div dir="rtl">

        <%-- ===== HERO ===== --%>
        <div class="hero">
            <div class="hero-content">
                <span class="hero-tag">✦ مجموعة صيف 2026</span>
                <h1 class="hero-title">كل ما تحتاجه<br>
                    في <em>مكان واحد</em></h1>
                <p class="hero-desc">تسوق أحدث المنتجات من أكبر الماركات العالمية والمحلية بأسعار مناسبة وتوصيل سريع.</p>
                <div class="hero-actions">
                    <asp:Button ID="btnShopNow" runat="server" Text="تسوق الآن ←" CssClass="btn-primary" OnClick="btnShopNow_Click" />
                    <asp:Button ID="btnDailyOffers" runat="server" Text="العروض اليوم" CssClass="btn-secondary" OnClick="btnShopNow_Click" />
                    <asp:Button ID="btnTest" runat="server" Text="طباعه" CssClass="btn-secondary" OnClick="btnTest_Click" />
                </div>
            </div>

            <div class="hero-image">
                <div class="hero-badge">خصم حتى 70%</div>
                <div class="hero-visual">
                    <div class="hero-shapes">
                        <div class="shape-card shape-card-1">
                            <div class="shape-icon">📱</div>
                            <div class="shape-label">iPhone 15 Pro</div>
                            <div class="shape-price">3,999 ر.س</div>
                        </div>
                        <div class="shape-card shape-card-2">
                            <div class="shape-icon" style="font-size: 1.5rem">⌚</div>
                            <div class="shape-label-w">Apple Watch</div>
                            <div class="shape-price-w">1,299 ر.س</div>
                        </div>
                    </div>
                </div>
            </div>
        </div>

        <%-- ===== CATEGORIES ===== --%>
        <div class="section">
            <div class="section-header">
                <h2 class="section-title">تسوق حسب الفئة</h2>
                <asp:HyperLink ID="lnkAllCategories" runat="server" NavigateUrl="Prouduct.aspx" CssClass="section-link">عرض الكل ←</asp:HyperLink>
            </div>

            <%-- Message shown when there are no categories --%>
            <asp:Panel ID="pnlNoCats" runat="server" Visible="false">
                <div class="empty-msg">لا توجد فئات متاحة حالياً</div>
            </asp:Panel>

            <div class="categories-grid">
                <asp:Repeater ID="rptCategories" runat="server">
                    <ItemTemplate>
                        <div class="cat-card" onclick="location.href='Prouduct.aspx?cat=<%# Eval("category_id") %>'">
                            <span class="cat-icon"><%# Eval("icon") %></span>
                            <span class="cat-name"><%# Eval("name_ar") %></span>
                        </div>
                    </ItemTemplate>
                </asp:Repeater>
            </div>
        </div>

        <%-- ===== FEATURED PRODUCTS ===== --%>
        <div class="section">
            <div class="section-header">
                <h2 class="section-title">منتجات مميزة</h2>
                <asp:HyperLink ID="lnkAllProducts" runat="server" NavigateUrl="Prouduct.aspx" CssClass="section-link">عرض الكل ←</asp:HyperLink>
            </div>

            <%-- Featured products load and update via AJAX (partial postback) --%>
            <asp:UpdatePanel ID="upProducts" runat="server" UpdateMode="Conditional">
                <ContentTemplate>

                    <%-- Message shown when there are no products --%>
                    <asp:Panel ID="pnlNoProducts" runat="server" Visible="false">
                        <div class="empty-msg">لا توجد منتجات متاحة حالياً</div>
                    </asp:Panel>

                    <div class="products-grid">
                        <asp:Repeater ID="rptProducts" runat="server" OnItemCommand="rptProducts_ItemCommand">
                            <ItemTemplate>
                                <div class="product-card"
                                    onclick="location.href='Details.aspx?id=<%# Eval("product_id") %>'">

                                    <div class="product-image-wrap">
                                        <%# GetProductImage(Eval("images")) %>

                                        <%# GetDiscountBadge(Eval("discount_pct")) %>

                                        <%-- Favorite toggle: async postback that removes the item from the wishlist --%>
                                        <asp:LinkButton runat="server" CssClass="product-fav active"
                                            CommandName="ToggleFav"
                                            CommandArgument='<%# Eval("product_id") %>'
                                            OnClientClick="event.stopPropagation();"
                                            ToolTip="إزالة من المفضلة"
                                            Text="❤️" />
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
                                                    <%# string.Format("{0:N2}", Eval("price")) %>د.أ
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
                <div class="promo-tag">✦ عرض محدود</div>
                <h2 class="promo-title">تخفيضات نهاية الموسم<br>
                    حتى 70% خصم</h2>
                <p class="promo-desc">على آلاف المنتجات من أشهر الماركات العالمية</p>
            </div>
            <div class="promo-cta">
                <asp:Button ID="btnPromo" runat="server" Text="تسوق الآن"
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
                    <p class="footer-desc">أكبر منصة تسوق إلكتروني في المنطقة. نوفر أفضل المنتجات بأفضل الأسعار.</p>
                </div>
                <div>
                    <div class="footer-heading">المساعدة</div>
                    <ul class="footer-links">
                        <li><a href="Prouduct.aspx">المنتجات</a></li>
                        <li><a href="Cart.aspx">سلة التسوق</a></li>
                    </ul>
                </div>
            </div>
            <div class="footer-bottom">
                <span>© 2026 Noon. جميع الحقوق محفوظة.</span>
            </div>
        </footer>
    </div>

    <script src="Scripts/shared.js"></script>
    <script src="Scripts/home.js"></script>
</asp:Content>
