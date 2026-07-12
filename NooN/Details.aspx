<%@ Page Title="تفاصيل المنتج" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeBehind="Details.aspx.cs" Inherits="NooN.Details" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
    <link href="Content/shared.css" rel="stylesheet" />
    <style>
        /* ═══════════════════════════════════════════
   Details Page — NooN Store
═══════════════════════════════════════════ */
        :root {
            --yellow: #f9a825;
            --yellow-dark: #e65100;
            --bg: #f4f5f9;
            --surface: #ffffff;
            --border: #e5e7ef;
            --text: #1c1c2e;
            --muted: #6b7080;
            --light: #a0a4b8;
            --success: #27ae60;
            --danger: #c0392b;
            --radius: 14px;
            --radius-sm: 8px;
            --font: 'Tajawal', sans-serif;
        }

        * {
            box-sizing: border-box;
            margin: 0;
            padding: 0;
        }

        body {
            font-family: var(--font);
            background: var(--bg);
            color: var(--text);
        }

        /* ── Breadcrumb ── */
        .breadcrumb {
            max-width: 1280px;
            margin: 18px auto 0;
            padding: 0 24px;
            font-size: 13px;
            color: var(--muted);
            display: flex;
            align-items: center;
            gap: 6px;
            flex-wrap: wrap;
        }

            .breadcrumb a {
                color: var(--muted);
                text-decoration: none;
            }

                .breadcrumb a:hover {
                    color: var(--yellow-dark);
                }

            .breadcrumb .sep {
                color: var(--light);
            }

            .breadcrumb .current {
                color: var(--text);
                font-weight: 700;
            }

        /* ── Layout ── */
        .detail-layout {
            display: grid;
            grid-template-columns: 480px 1fr;
            gap: 32px;
            max-width: 1280px;
            margin: 20px auto 40px;
            padding: 0 24px;
            align-items: start;
        }

        /* ── Gallery ── */
        .gallery-wrap {
            position: sticky;
            top: 20px;
        }

        .gallery-main {
            background: linear-gradient(135deg,#fff8e1,#fff3cd);
            border: 1px solid var(--border);
            border-radius: var(--radius);
            height: 400px;
            display: flex;
            align-items: center;
            justify-content: center;
            font-size: 120px;
            margin-bottom: 12px;
            position: relative;
            overflow: hidden;
        }

        .gallery-main-img {
            width: 100%;
            height: 100%;
            object-fit: cover;
            display: block;
        }

        .gallery-thumb img {
            width: 100%;
            height: 100%;
            object-fit: cover;
            border-radius: inherit;
        }

        .gallery-badge {
            position: absolute;
            top: 14px;
            right: 14px;
            background: var(--yellow-dark);
            color: #fff;
            font-size: 13px;
            font-weight: 800;
            padding: 4px 12px;
            border-radius: 20px;
        }

        .gallery-status {
            position: absolute;
            top: 14px;
            left: 14px;
            font-size: 12px;
            font-weight: 700;
            padding: 4px 10px;
            border-radius: 20px;
        }

        .status-active {
            background: #eaffea;
            color: var(--success);
        }

        .status-out_of_stock {
            background: #ffeaea;
            color: var(--danger);
        }

        .status-inactive {

            background: #f0f0f0;
            color: var(--muted);
        }

        .gallery-thumbs {
            display: flex;
            gap: 10px;
            justify-content: center;
        }

        .gallery-thumb {
            width: 72px;
            height: 72px;
            background: linear-gradient(135deg,#fff8e1,#fff3cd);
            border: 2px solid var(--border);
            border-radius: var(--radius-sm);
            display: flex;
            align-items: center;
            justify-content: center;
            font-size: 28px;
            cursor: pointer;
            transition: border-color .15s, transform .15s;
        }

            .gallery-thumb:hover, .gallery-thumb.active {
                border-color: var(--yellow);
                transform: translateY(-2px);
            }

        /* ── Info Panel ── */
        .detail-info {
            background: var(--surface);
            border: 1px solid var(--border);
            border-radius: var(--radius);
            padding: 28px;
        }

        .detail-brand {
            font-size: 11px;
            font-weight: 800;
            color: var(--yellow-dark);
            text-transform: uppercase;
            letter-spacing: 1.2px;
            margin-bottom: 8px;
        }

        .detail-title {
            font-size: 22px;
            font-weight: 800;
            line-height: 1.4;
            margin-bottom: 12px;
            color: var(--text);
        }

        .detail-sku {
            font-size: 12px;
            color: var(--light);
            margin-bottom: 14px;
        }

        .detail-rating {
            display: flex;
            align-items: center;
            gap: 8px;
            flex-wrap: wrap;
            margin-bottom: 18px;
            font-size: 14px;
        }

        .stars-gold {
            color: #f59e0b;
            font-size: 17px;
        }

        .rating-score {
            font-weight: 800;
            color: var(--text);
        }

        .rating-sep {
            color: var(--light);
        }

        .rating-count {
            color: var(--muted);
        }

        .in-stock {
            color: var(--success);
            font-weight: 700;
        }

        .out-stock {
            color: var(--danger);
            font-weight: 700;
        }

        .detail-price-section {
            display: flex;
            align-items: baseline;
            gap: 10px;
            flex-wrap: wrap;
            margin-bottom: 18px;
            padding: 16px;
            background: #fff8f0;
            border-radius: var(--radius-sm);
            border: 1px solid #ffe0b2;
        }

        .detail-discount {
            background: var(--yellow-dark);
            color: #fff;
            font-size: 13px;
            font-weight: 800;
            padding: 3px 10px;
            border-radius: 20px;
        }

        .detail-old-price {
            font-size: 15px;
            color: var(--light);
            text-decoration: line-through;
        }

        .detail-price {
            font-size: 28px;
            font-weight: 800;
            color: var(--yellow-dark);
        }

        .detail-currency {
            font-size: 16px;
            font-weight: 700;
            color: var(--yellow-dark);
        }

        .detail-desc {
            font-size: 14px;
            color: var(--muted);
            line-height: 1.8;
            margin-bottom: 20px;
            padding-bottom: 20px;
            border-bottom: 1px solid var(--border);
        }

        /* ── Options ── */
        .option-label {
            font-size: 13px;
            font-weight: 800;
            color: var(--text);
            margin-bottom: 10px;
        }

        .option-group {
            margin-bottom: 18px;
        }

        /* Color Buttons */
        .color-options {
            display: flex;
            flex-wrap: wrap;
            gap: 8px;
        }

        .color-btn {
            padding: 7px 18px;
            border: 1.5px solid var(--border);
            border-radius: var(--radius-sm);
            background: var(--bg);
            font-family: var(--font);
            font-size: 13px;
            font-weight: 700;
            color: var(--text);
            cursor: pointer;
            transition: all .15s;
        }

            .color-btn:hover {
                border-color: var(--yellow);
            }

            .color-btn.active {
                border-color: var(--yellow-dark);
                background: var(--yellow-dark);
                color: #fff;
            }

        /* Size Buttons */
        .size-options {
            display: flex;
            flex-wrap: wrap;
            gap: 8px;
        }

        .size-btn {
            padding: 7px 16px;
            border: 1.5px solid var(--border);
            border-radius: var(--radius-sm);
            background: var(--bg);
            font-family: var(--font);
            font-size: 13px;
            font-weight: 700;
            color: var(--text);
            cursor: pointer;
            transition: all .15s;
        }

            .size-btn:hover {
                border-color: var(--yellow);
            }

            .size-btn.active {
                border-color: var(--yellow-dark);
                background: var(--yellow-dark);
                color: #fff;
            }

        /* validation highlight */
        .option-group.invalid {
            border: 2px solid var(--yellow-dark) !important;
            border-radius: var(--radius-sm);
            padding: 10px;
            animation: shake .3s ease;
        }

        @keyframes shake {
            0%,100% {
                transform: translateX(0);
            }

            25% {
                transform: translateX(-6px);
            }

            75% {
                transform: translateX(6px);
            }
        }

        /* Qty */
        .qty-row {
            display: flex;
            align-items: center;
            gap: 0;
            width: fit-content;
            border: 1.5px solid var(--border);
            border-radius: var(--radius-sm);
            overflow: hidden;
        }

        .qty-btn {
            width: 42px;
            height: 42px;
            background: var(--bg);
            border: none;
            font-size: 20px;
            font-weight: 700;
            cursor: pointer;
            color: var(--text);
            transition: background .15s;
        }

            .qty-btn:hover {
                background: #e8e9ef;
            }

        .qty-display {
            width: 60px;
            height: 42px;
            border-right: 1.5px solid var(--border);
            border-left: 1.5px solid var(--border);
            text-align: center;
            font-family: var(--font);
            font-size: 16px;
            font-weight: 800;
            color: var(--text);
            background: #fff;
            display: flex;
            align-items: center;
            justify-content: center;
        }

        /* Action Buttons */
        .action-row {
            display: flex;
            gap: 10px;
            margin-bottom: 20px;
            margin-top: 20px;
        }

        .btn-add-cart {
            flex: 1;
            padding: 13px;
            background: var(--yellow);
            color: #fff;
            font-family: var(--font);
            font-size: 15px;
            font-weight: 800;
            border: none;
            border-radius: var(--radius-sm);
            cursor: pointer;
            transition: background .15s, transform .15s;
        }

            .btn-add-cart:hover {
                background: var(--yellow-dark);
                transform: translateY(-2px);
            }

            .btn-add-cart:disabled {
                background: var(--light);
                cursor: not-allowed;
                transform: none;
            }

        .btn-wishlist {
            width: 50px;
            background: var(--bg);
            border: 1.5px solid var(--border);
            border-radius: var(--radius-sm);
            font-size: 22px;
            cursor: pointer;
            transition: all .15s;
        }

            .btn-wishlist:hover {
                border-color: #e91e63;
            }

        /* Message */
        .detail-msg {
            padding: 10px 16px;
            border-radius: var(--radius-sm);
            font-size: 14px;
            margin-bottom: 16px;
            display: none;
        }

            .detail-msg.success {
                background: #eaffea;
                color: var(--success);
                border: 1px solid #c3e6cb;
                display: block;
            }

            .detail-msg.error {
                background: #ffeaea;
                color: var(--danger);
                border: 1px solid #f5c6cb;
                display: block;
            }

        /* Features */
        .detail-features {
            display: grid;
            grid-template-columns: 1fr 1fr;
            gap: 10px;
            padding-top: 20px;
            border-top: 1px solid var(--border);
        }

        .detail-feature {
            font-size: 13px;
            color: var(--muted);
            display: flex;
            align-items: center;
            gap: 6px;
        }

        /* ── Reviews ── */
        .reviews-section {
            max-width: 1280px;
            margin: 0 auto 50px;
            padding: 0 24px;
        }

        .reviews-title {
            font-size: 20px;
            font-weight: 800;
            margin-bottom: 20px;
            padding-bottom: 12px;
            border-bottom: 2px solid var(--border);
        }

        .reviews-grid {
            display: grid;
            grid-template-columns: repeat(auto-fill, minmax(300px, 1fr));
            gap: 16px;
            margin-bottom: 30px;
        }

        .review-card {
            background: var(--surface);
            border: 1px solid var(--border);
            border-radius: var(--radius);
            padding: 18px;
        }

        .review-header {
            display: flex;
            align-items: center;
            justify-content: space-between;
            margin-bottom: 10px;
        }

        .review-user {
            font-size: 14px;
            font-weight: 800;
        }

        .review-date {
            font-size: 12px;
            color: var(--light);
        }

        .review-stars {
            color: #f59e0b;
            font-size: 15px;
            margin-bottom: 8px;
        }

        .review-text {
            font-size: 13px;
            color: var(--muted);
            line-height: 1.7;
        }

        .no-reviews {
            text-align: center;
            padding: 40px;
            color: var(--muted);
            font-size: 15px;
            background: var(--surface);
            border: 1px dashed var(--border);
            border-radius: var(--radius);
        }

        .add-review-box {
            background: var(--surface);
            border: 1px solid var(--border);
            border-radius: var(--radius);
            padding: 24px;
        }

        .add-review-title {
            font-size: 16px;
            font-weight: 800;
            margin-bottom: 16px;
        }

        .star-picker {
            display: flex;
            gap: 6px;
            margin-bottom: 14px;
            direction: ltr;
        }

        .star-pick {
            font-size: 30px;
            cursor: pointer;
            color: var(--light);
            transition: color .1s, transform .1s;
            user-select: none;
        }

            .star-pick.active, .star-pick:hover {
                color: #f59e0b;
                transform: scale(1.15);
            }

        .review-textarea {
            width: 100%;
            min-height: 90px;
            padding: 10px 14px;
            border: 1.5px solid var(--border);
            border-radius: var(--radius-sm);
            font-family: var(--font);
            font-size: 14px;
            color: var(--text);
            resize: vertical;
            margin-bottom: 14px;
            transition: border-color .15s;
        }

            .review-textarea:focus {
                outline: none;
                border-color: var(--yellow);
            }

        .btn-submit-review {
            padding: 11px 28px;
            background: var(--yellow);
            color: #fff;
            font-family: var(--font);
            font-size: 14px;
            font-weight: 800;
            border: none;
            border-radius: var(--radius-sm);
            cursor: pointer;
            transition: background .15s;
        }

            .btn-submit-review:hover {
                background: var(--yellow-dark);
            }

        /* Toast */
        #detailToast {
            display: none;
            position: fixed;
            bottom: 24px;
            left: 50%;
            transform: translateX(-50%);
            background: #1c1c2e;
            color: #fff;
            padding: 12px 28px;
            border-radius: 10px;
            font-size: 14px;
            z-index: 9999;
            font-family: var(--font);
            box-shadow: 0 8px 24px rgba(0,0,0,.2);
            white-space: nowrap;
        }

        /* ── Responsive ── */
        @media (max-width: 900px) {
            .detail-layout {
                grid-template-columns: 1fr;
                gap: 20px;
            }

            .gallery-wrap {
                position: static;
            }

            .gallery-main {
                height: 280px;
                font-size: 80px;
            }
        }

        @media (max-width: 600px) {
            .detail-features {
                grid-template-columns: 1fr;
            }

            .detail-layout, .reviews-section {
                padding: 0 12px;
            }
        }
    </style>
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

    <script type="text/javascript">

        // ── Qty ──
        function changeQty(delta) {
            var display = document.getElementById('qtyDisplay');
            var hf = document.getElementById('<%= hfQty.ClientID %>');
            var v = parseInt(hf.value) + delta;
            if (v >= 1 && v <= 99) {
                hf.value = v;
                display.innerText = v;
            }
        }

        // ── Color Picker ──
        function pickColor(btn) {
            document.querySelectorAll('.color-btn').forEach(function (b) { b.classList.remove('active'); });
            btn.classList.add('active');
            var hf = document.getElementById('<%= hfColor.ClientID %>');
            if (hf) hf.value = btn.getAttribute('data-color');
            // إزالة هايلايت الخطأ
            var grp = document.getElementById('colorGroup');
            if (grp) grp.classList.remove('invalid');
        }

        // ── Size Picker ──
        function pickSize(btn) {
            document.querySelectorAll('.size-btn').forEach(function (b) { b.classList.remove('active'); });
            btn.classList.add('active');
            var hf = document.getElementById('<%= hfSize.ClientID %>');
            if (hf) hf.value = btn.getAttribute('data-size');
            // إزالة هايلايت الخطأ
            var grp = document.getElementById('sizeGroup');
            if (grp) grp.classList.remove('invalid');
        }

        // ── Star Picker ──
        function pickStar(val) {
            document.getElementById('<%= hfRating.ClientID %>').value = val;
            document.querySelectorAll('.star-pick').forEach(function (s) {
                s.classList.toggle('active', parseInt(s.getAttribute('data-val')) <= val);
            });
        }

        // ── Validation قبل الإضافة للسلة ──
        function validateCart() {
            var ok = true;

            // تحقق من اللون إذا كان القسم ظاهر
            var colorHf = document.getElementById('<%= hfColor.ClientID %>');
            if (colorHf !== null) {
                if (!colorHf.value || colorHf.value.trim() === '') {
                    var grp = document.getElementById('colorGroup');
                    if (grp) {
                        grp.classList.add('invalid');
                        setTimeout(function () { grp.classList.remove('invalid'); }, 2000);
                    }
                    showToast('⚠️ يرجى اختيار اللون أولاً');
                    ok = false;
                }
            }

            // تحقق من الحجم إذا كان القسم ظاهر
            var sizeHf = document.getElementById('<%= hfSize.ClientID %>');
            if (sizeHf !== null && ok) {
                if (!sizeHf.value || sizeHf.value.trim() === '') {
                    var grp2 = document.getElementById('sizeGroup');
                    if (grp2) {
                        grp2.classList.add('invalid');
                        setTimeout(function () { grp2.classList.remove('invalid'); }, 2000);
                    }
                    showToast('⚠️ يرجى اختيار الحجم أولاً');
                    ok = false;
                }
            }

            return ok;
        }

        // ── Add to cart (AJAX) ──
        // Validates the selected options, then posts to ShopService.ashx via
        // the shared noonShop helper. The page never reloads.
        function detailsAddToCart(btn) {
            if (!validateCart()) return;

            var qtyHf = document.getElementById('<%= hfQty.ClientID %>');
            var colorHf = document.getElementById('<%= hfColor.ClientID %>');
            var sizeHf = document.getElementById('<%= hfSize.ClientID %>');

            noonShop.addToCart(btn, {
                quantity: qtyHf ? qtyHf.value : 1,
                color: colorHf ? colorHf.value.trim() : '',
                size: sizeHf ? sizeHf.value.trim() : ''
            });
        }

        // ── Toast ──
        function showToast(msg) {
            var t = document.getElementById('detailToast');
            t.innerText = msg;
            t.style.display = 'block';
            t.style.opacity = '1';
            t.style.transition = '';
            setTimeout(function () {
                t.style.transition = 'opacity .5s';
                t.style.opacity = '0';
                setTimeout(function () {
                    t.style.display = 'none';
                    t.style.opacity = '1';
                }, 500);
            }, 2500);
        }

        window.addEventListener("load", function () {

            // Toast من السيرفر
            var m = document.getElementById('<%= lblMsg.ClientID %>');
            if (m && m.innerText.trim() !== '') showToast(m.innerText.trim());

            var r = document.getElementById('<%= lblReviewMsg.ClientID %>');
            if (r && r.innerText.trim() !== '') showToast(r.innerText.trim());

            // Gallery thumbs — swap the main image on click
            var thumbs = document.querySelectorAll('.gallery-thumb');
            var mainImg = document.getElementById('galleryMainImg');
            thumbs.forEach(function (th) {
                th.addEventListener('click', function () {
                    thumbs.forEach(function (t) { t.classList.remove('active'); });
                    th.classList.add('active');
                    var im = th.querySelector('img');
                    if (mainImg && im) mainImg.src = im.getAttribute('data-full') || im.src;
                });
            });

            // مزامنة qtyDisplay مع hfQty عند الـ PostBack
            var hfQty = document.getElementById('<%= hfQty.ClientID %>');
            var disp = document.getElementById('qtyDisplay');
            if (hfQty && disp && hfQty.value) {
                disp.innerText = hfQty.value;
            }
        });

</script>
</asp:Content>
