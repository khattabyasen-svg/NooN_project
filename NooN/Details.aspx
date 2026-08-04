<%@ Page Title="تفاصيل المنتج" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeBehind="Details.aspx.cs" Inherits="NooN.Details" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
    <link href="Content/shared.css" rel="stylesheet" />
    <link href="Content/detail.css" rel="stylesheet" />
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="MainContent" runat="server">

    <%-- Toast --%>
    <div id="detailToast"></div>

    <%-- Breadcrumb --%>
    <nav class="breadcrumb" dir="rtl">
        <a href="Default.aspx">الرئيسية</a>
        <span class="sep">/</span>
        <a href="Prouduct.aspx">المنتجات</a>
        <span class="sep">/</span>
        <asp:Label ID="lblBreadCategory" runat="server" CssClass="sep" />
        <asp:Label ID="lblBreadProduct" runat="server" CssClass="current" />
    </nav>

    <%-- Not Found --%>
    <asp:Panel ID="pnlNotFound" runat="server" Visible="false">
        <div style="text-align: center; padding: 80px 20px; color: #6b7080; font-size: 16px;">
            <div style="font-size: 60px; margin-bottom: 16px;">😕</div>
            <p>المنتج غير موجود أو غير متاح.</p>
            <a href="Prouduct.aspx" style="color: #e65100; font-weight: 700;">← العودة للمنتجات</a>
        </div>
    </asp:Panel>

    <%-- Main Detail Panel --%>
    <asp:Panel ID="pnlDetail" runat="server" Visible="false">

        <div class="detail-layout" dir="rtl">

            <%-- Gallery --%>
            <div class="gallery-wrap">
                <div class="gallery-main">
                    <asp:Literal ID="litMainImage" runat="server" />
                    <asp:Literal ID="litDiscBadge" runat="server" />
                    <asp:Literal ID="litStatusBadge" runat="server" />
                </div>
                <div class="gallery-thumbs">
                    <asp:Literal ID="litThumbs" runat="server" />
                </div>
            </div>

            <%-- Info Panel --%>
            <div class="detail-info">

                <div class="detail-brand">
                    <asp:Literal ID="litBrand" runat="server" />
                </div>

                <h1 class="detail-title">
                    <asp:Literal ID="litName" runat="server" /></h1>

                <div class="detail-sku">
                    رمز المنتج (SKU):
                    <asp:Literal ID="litSku" runat="server" />
                    &nbsp;|&nbsp; الفئة:
                    <asp:Literal ID="litCategory" runat="server" />
                </div>

                <%-- Rating --%>
                <div class="detail-rating">
                    <span class="stars-gold">
                        <asp:Literal ID="litStars" runat="server" /></span>
                    <span class="rating-score">
                        <asp:Literal ID="litRatingAvg" runat="server" /></span>
                    <span class="rating-sep">|</span>
                    <span class="rating-count">
                        <asp:Literal ID="litRatingCount" runat="server" />
                        تقييم</span>
                    <span class="rating-sep">|</span>
                    <asp:Literal ID="litStockStatus" runat="server" />
                </div>

                <%-- Price --%>
                <div class="detail-price-section">
                    <asp:Literal ID="litDiscLabel" runat="server" />
                    <asp:Literal ID="litOldPrice" runat="server" />
                    <span class="detail-price">
                        <asp:Literal ID="litPrice" runat="server" /></span>
                    <span class="detail-currency">د.أ</span>
                </div>

                <%-- Description --%>
                <p class="detail-desc">
                    <asp:Literal ID="litDesc" runat="server" />
                </p>

                <%-- Colors — يظهر فقط إذا المنتج عنده ألوان --%>
                <asp:Panel ID="pnlColors" runat="server" Visible="false">
                    <div class="option-group" id="colorGroup">
                        <div class="option-label">اللون <span style="color: var(--danger)">*</span></div>
                        <div class="color-options" id="colorOptions" runat="server"></div>
                        <asp:HiddenField ID="hfColor" runat="server" Value="" />
                    </div>
                </asp:Panel>

                <%-- Sizes — يظهر فقط إذا المنتج عنده أحجام --%>
                <asp:Panel ID="pnlSizes" runat="server" Visible="false">
                    <div class="option-group" id="sizeGroup">
                        <div class="option-label">الحجم / السعة <span style="color: var(--danger)">*</span></div>
                        <div class="size-options" id="sizeOptions" runat="server"></div>
                        <asp:HiddenField ID="hfSize" runat="server" Value="" />
                    </div>
                </asp:Panel>

                <%-- Qty --%>
                <div class="option-group">
                    <div class="option-label">الكمية</div>
                    <div class="qty-row">
                        <button type="button" class="qty-btn" onclick="changeQty(-1)">−</button>
                        <span class="qty-display" id="qtyDisplay">1</span>
                        <button type="button" class="qty-btn" onclick="changeQty(1)">+</button>
                    </div>
                    <%-- HiddenField يحمل القيمة الفعلية للسيرفر --%>
                    <asp:HiddenField ID="hfQty" runat="server" Value="1" />
                    <%-- الحد الأقصى للكمية حسب المخزون المتاح --%>
                    <asp:HiddenField ID="hfMaxQty" runat="server" Value="99" />
                </div>

                <asp:HiddenField ID="hfProductId" runat="server" />

                <%-- Actions — AJAX via ShopService.ashx, no postback --%>
                <div class="action-row">
                    <button type="button" id="btnAddToCart" runat="server"
                        class="btn-add-cart"
                        onclick="detailsAddToCart(this);">أضف إلى السلة</button>
                    <button type="button" id="btnFav" runat="server"
                        class="btn-wishlist"
                        title="المفضلة"
                        onclick="noonShop.toggleFav(this);">🤍</button>
                </div>

                <%-- Features --%>
                <div class="detail-features">
                    <div class="detail-feature">🚚 شحن مجاني فوق 199 د.أ</div>
                    <div class="detail-feature">🔄 إرجاع مجاني خلال 30 يوم</div>
                    <div class="detail-feature">🛡️ ضمان أصالة المنتج</div>
                    <div class="detail-feature">💳 تقسيط بدون فوائد</div>
                </div>

            </div>
        </div>

        <%-- Reviews Section --%>
        <div class="reviews-section" dir="rtl">
            <h2 class="reviews-title">التقييمات والمراجعات</h2>

            <div class="reviews-grid">
                <asp:Repeater ID="rptReviews" runat="server" OnItemDataBound="rptReviews_ItemDataBound">
                    <ItemTemplate>
                        <div class="review-card">
                            <div class="review-header">
                                <span class="review-user">
                                    <asp:Literal ID="litUser" runat="server" /></span>
                                <span class="review-date">
                                    <asp:Literal ID="litDate" runat="server" /></span>
                            </div>
                            <div class="review-stars">
                                <asp:Literal ID="litRevStars" runat="server" />
                            </div>
                            <p class="review-text">
                                <asp:Literal ID="litComment" runat="server" />
                            </p>
                        </div>
                    </ItemTemplate>
                    <FooterTemplate>
                        <%# rptReviews.Items.Count == 0
                    ? "<div class='no-reviews'>لا توجد تقييمات بعد. كن أول من يقيّم!</div>"
                    : "" %>
                    </FooterTemplate>
                </asp:Repeater>
            </div>

            <div class="add-review-box">
                <div class="add-review-title">أضف تقييمك</div>
                <asp:Label ID="lblReviewMsg" runat="server" CssClass="detail-msg" />
                <div class="star-picker" id="starPicker">
                    <span class="star-pick" data-val="1" onclick="pickStar(1)">★</span>
                    <span class="star-pick" data-val="2" onclick="pickStar(2)">★</span>
                    <span class="star-pick" data-val="3" onclick="pickStar(3)">★</span>
                    <span class="star-pick" data-val="4" onclick="pickStar(4)">★</span>
                    <span class="star-pick" data-val="5" onclick="pickStar(5)">★</span>
                </div>
                <asp:HiddenField ID="hfRating" runat="server" Value="0" />
                <asp:TextBox ID="txtComment" runat="server" TextMode="MultiLine"
                    CssClass="review-textarea" placeholder="شاركنا رأيك في هذا المنتج..." />
                <asp:Button ID="btnSubmitReview" runat="server"
                    Text="إرسال التقييم" CssClass="btn-submit-review"
                    OnClick="btnSubmitReview_Click" />
            </div>
        </div>

    </asp:Panel>

        <script>
        var detailIds = {
            hfQty:        '<%= hfQty.ClientID %>',
            hfMaxQty:     '<%= hfMaxQty.ClientID %>',
            hfColor:      '<%= hfColor.ClientID %>',
            hfSize:       '<%= hfSize.ClientID %>',
            hfRating:     '<%= hfRating.ClientID %>',
            lblReviewMsg: '<%= lblReviewMsg.ClientID %>'
        };
    </script>
    <script src='<%= ResolveUrl("~/Scripts/detail.js") %>'></script>
</asp:Content>
