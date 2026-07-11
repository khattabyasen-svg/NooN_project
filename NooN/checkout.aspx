<%@ Page Title="الدفع" Language="C#"
    MasterPageFile="~/Site.Master"
    AutoEventWireup="true"
    CodeBehind="checkout.aspx.cs"
    Inherits="NooN.checkout" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
    <link href="Content/shared.css" rel="stylesheet" />
    <style>
        *, *::before, *::after {
            box-sizing: border-box;
        }

        body {
            background: #f5f5f5;
            font-family: 'Segoe UI', Tahoma, Arial, sans-serif;
        }

        /* ── Layout ── */
        .checkout-layout {
            display: grid;
            grid-template-columns: 1fr 360px;
            gap: 24px;
            max-width: 1100px;
            margin: 32px auto;
            padding: 0 16px;
            align-items: start;
        }

        @media(max-width:860px) {
            .checkout-layout {
                grid-template-columns: 1fr;
            }

            .order-summary-sticky {
                order: -1;
            }
        }

        /* ── Step Bar ── */
        .checkout-step-bar {
            display: flex;
            align-items: center;
            justify-content: center;
            margin-bottom: 28px;
            background: #fff;
            border-radius: 12px;
            padding: 18px 24px;
            border: 1px solid #e8e8e8;
        }

        .checkout-step {
            display: flex;
            flex-direction: column;
            align-items: center;
            gap: 6px;
        }

        .step-circle {
            width: 36px;
            height: 36px;
            border-radius: 50%;
            border: 2px solid #ddd;
            display: flex;
            align-items: center;
            justify-content: center;
            font-size: 14px;
            font-weight: 700;
            color: #aaa;
            background: #fff;
            transition: all .3s;
        }

        .step-label {
            font-size: 12px;
            color: #aaa;
            font-weight: 600;
        }

        .checkout-step.active .step-circle {
            border-color: #f5a623;
            background: #f5a623;
            color: #fff;
        }

        .checkout-step.active .step-label {
            color: #f5a623;
        }

        .checkout-step.done .step-circle {
            border-color: #00b14f;
            background: #00b14f;
            color: #fff;
        }

        .checkout-step.done .step-label {
            color: #00b14f;
        }

        .step-line {
            flex: 1;
            height: 2px;
            background: #e8e8e8;
            min-width: 40px;
            margin: 0 4px 22px;
        }

        /* ── Form Section ── */
        .form-section {
            background: #fff;
            border: 1px solid #e8e8e8;
            border-radius: 14px;
            padding: 24px;
            margin-bottom: 20px;
        }

        .form-section-title {
            font-size: 17px;
            font-weight: 700;
            color: #1a1a2e;
            margin-bottom: 20px;
            display: flex;
            align-items: center;
            gap: 10px;
        }

        .form-section-num {
            width: 28px;
            height: 28px;
            border-radius: 50%;
            background: #f5a623;
            color: #fff;
            display: flex;
            align-items: center;
            justify-content: center;
            font-size: 13px;
            font-weight: 700;
            flex-shrink: 0;
        }

        /* ── Form Controls ── */
        .form-grid-2 {
            display: grid;
            grid-template-columns: 1fr 1fr;
            gap: 16px;
        }

        @media(max-width:560px) {
            .form-grid-2 {
                grid-template-columns: 1fr;
            }
        }

        .form-group {
            margin-bottom: 16px;
        }

        .form-label {
            display: block;
            font-size: 13px;
            font-weight: 600;
            color: #444;
            margin-bottom: 6px;
        }

        .form-input, .form-select {
            width: 100%;
            padding: 11px 14px;
            border: 1.5px solid #e0e0e0;
            border-radius: 9px;
            font-size: 14px;
            color: #1a1a2e;
            background: #fafafa;
            transition: border-color .2s, box-shadow .2s;
            outline: none;
        }

            .form-input:focus, .form-select:focus {
                border-color: #f5a623;
                box-shadow: 0 0 0 3px rgba(245,166,35,.12);
                background: #fff;
            }

            .form-input::placeholder {
                color: #bbb;
            }

        .validation-error {
            display: block;
            font-size: 12px;
            color: #e53935;
            margin-top: 4px;
            font-weight: 500;
        }

        /* ── Payment ── */
        .payment-methods {
            display: flex;
            flex-direction: column;
            gap: 12px;
            margin-bottom: 20px;
        }

        .payment-option {
            display: flex;
            align-items: center;
            gap: 14px;
            border: 2px solid #e8e8e8;
            border-radius: 12px;
            padding: 14px 18px;
            cursor: pointer;
            transition: border-color .2s, background .2s;
            background: #fafafa;
        }

            .payment-option:hover {
                border-color: #f5a623;
                background: #fffbf2;
            }

            .payment-option.selected {
                border-color: #f5a623;
                background: #fffbf2;
            }

        .payment-radio {
            width: 18px;
            height: 18px;
            border-radius: 50%;
            border: 2px solid #ddd;
            flex-shrink: 0;
            transition: all .2s;
        }

        .payment-option.selected .payment-radio {
            border-color: #f5a623;
            border-width: 5px;
        }

        .payment-icon {
            font-size: 24px;
        }

        .payment-name {
            font-size: 14px;
            font-weight: 700;
            color: #1a1a2e;
        }

        .payment-desc {
            font-size: 12px;
            color: #888;
            margin-top: 2px;
        }

        /* ── Card Fields ── */
        .card-fields {
            background: #f9f9f9;
            border: 1px solid #eee;
            border-radius: 10px;
            padding: 18px;
            margin-bottom: 20px;
        }

        .card-field-row {
            display: grid;
            grid-template-columns: 1fr 1fr;
            gap: 16px;
        }

        /* ── Button ── */
        .checkout-place-btn {
            width: 100%;
            background: linear-gradient(135deg,#f5a623,#e8960f);
            color: #fff;
            border: none;
            border-radius: 12px;
            padding: 16px;
            font-size: 17px;
            font-weight: 700;
            cursor: pointer;
            transition: opacity .2s, transform .1s;
            margin-top: 4px;
        }

            .checkout-place-btn:hover {
                opacity: .92;
                transform: translateY(-1px);
            }

            .checkout-place-btn:active {
                transform: translateY(0);
            }

        /* ── Order Summary ── */
        .order-summary-sticky {
            background: #fff;
            border: 1px solid #e8e8e8;
            border-radius: 14px;
            padding: 22px;
            position: sticky;
            top: 90px;
        }

        .summary-title {
            font-size: 17px;
            font-weight: 700;
            color: #1a1a2e;
            margin-bottom: 18px;
            padding-bottom: 14px;
            border-bottom: 1px solid #f0f0f0;
        }

        .order-item-mini {
            display: flex;
            align-items: center;
            gap: 12px;
            padding: 10px 0;
            border-bottom: 1px solid #f5f5f5;
        }

            .order-item-mini:last-of-type {
                border-bottom: none;
            }

        .order-item-img {
            width: 44px;
            height: 44px;
            background: #f5f5f5;
            border-radius: 8px;
            overflow: hidden;
            flex-shrink: 0;
            display: flex;
            align-items: center;
            justify-content: center;
        }

            .order-item-img img {
                width: 100%;
                height: 100%;
                object-fit: cover;
            }

        .order-item-name {
            font-size: 13px;
            font-weight: 600;
            color: #1a1a2e;
        }

        .order-item-qty {
            font-size: 12px;
            color: #888;
            margin-top: 2px;
        }

        .order-item-price {
            margin-right: auto;
            font-size: 13px;
            font-weight: 700;
            white-space: nowrap;
        }

        .summary-divider {
            height: 1px;
            background: #f0f0f0;
            margin: 14px 0;
        }

        .summary-row {
            display: flex;
            justify-content: space-between;
            font-size: 13px;
            color: #555;
            padding: 5px 0;
        }

        .summary-row-label {
            color: #777;
        }

        .summary-row-value {
            font-weight: 600;
        }

            .summary-row-value.free {
                color: #00b14f;
            }

        .summary-total {
            display: flex;
            justify-content: space-between;
            align-items: center;
            padding-top: 6px;
        }

            .summary-total > span:first-child {
                font-size: 16px;
                font-weight: 700;
                color: #1a1a2e;
            }

        .summary-total-value {
            font-size: 20px;
            font-weight: 800;
            color: #f5a623;
        }

        /* ── Coupon ── */
        .coupon-box {
            display: flex;
            gap: 8px;
            margin-bottom: 16px;
        }

        .coupon-btn {
            padding: 11px 18px;
            background: #1a1a2e;
            color: #fff;
            border: none;
            border-radius: 9px;
            font-size: 13px;
            font-weight: 600;
            cursor: pointer;
            white-space: nowrap;
        }

            .coupon-btn:hover {
                background: #2d2d4e;
            }

        .secure-note {
            text-align: center;
            font-size: 12px;
            color: #aaa;
            margin-top: 12px;
        }

            .secure-note span {
                color: #00b14f;
                font-weight: 600;
            }

        /* ── Empty Cart ── */
        .empty-cart-msg {
            text-align: center;
            padding: 32px 16px;
            color: #888;
        }

            .empty-cart-msg .empty-icon {
                font-size: 48px;
                margin-bottom: 12px;
            }

            .empty-cart-msg p {
                font-size: 15px;
                margin: 0;
            }
    </style>
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="MainContent" runat="server">

    <div class="checkout-layout" dir="rtl">

        <%-- ════════ Left column — the form ════════ --%>
        <div>

            <%-- Step bar --%>
            <div class="checkout-step-bar">
                <div class="checkout-step done">
                    <div class="step-circle">✓</div>
                    <div class="step-label">السلة</div>
                </div>
                <div class="step-line"></div>
                <div class="checkout-step active">
                    <div class="step-circle">2</div>
                    <div class="step-label">التوصيل</div>
                </div>
                <div class="step-line"></div>
                <div class="checkout-step">
                    <div class="step-circle">3</div>
                    <div class="step-label">الدفع</div>
                </div>
                <div class="step-line"></div>
                <div class="checkout-step">
                    <div class="step-circle">4</div>
                    <div class="step-label">التأكيد</div>
                </div>
            </div>

            <%-- General error message --%>
            <asp:Label ID="lblError" runat="server"
                CssClass="validation-error"
                Visible="false"
                Style="font-size: 14px; margin-bottom: 12px; display: block; padding: 10px; background: #fff0f0; border-radius: 8px;" />

            <%-- ══ Delivery information section ══ --%>
            <div class="form-section">
                <div class="form-section-title">
                    <span class="form-section-num">1</span>
                    معلومات التوصيل
                </div>
                <div class="form-grid-2">
                    <div class="form-group">
                        <label class="form-label">الاسم الأول *</label>
                        <asp:TextBox ID="txtFirstName" runat="server"
                            CssClass="form-input"
                            placeholder="محمد" />
                        <asp:RequiredFieldValidator
                            ID="RFV_FirstName" runat="server"
                            ControlToValidate="txtFirstName"
                            ErrorMessage="الاسم الأول مطلوب"
                            CssClass="validation-error" Display="Dynamic"
                            ValidationGroup="OrderGroup" />
                    </div>
                    <div class="form-group">
                        <label class="form-label">اسم العائلة *</label>
                        <asp:TextBox ID="txtLastName" runat="server"
                            CssClass="form-input"
                            placeholder="الأحمد" />
                        <asp:RequiredFieldValidator
                            ID="RFV_LastName" runat="server"
                            ControlToValidate="txtLastName"
                            ErrorMessage="اسم العائلة مطلوب"
                            CssClass="validation-error" Display="Dynamic"
                            ValidationGroup="OrderGroup" />
                    </div>
                </div>

                <div class="form-group">
                    <label class="form-label">رقم الجوال *</label>
                    <asp:TextBox ID="txtPhone" runat="server"
                        CssClass="form-input"
                        TextMode="Phone"
                        placeholder="05XXXXXXXX" />
                    <asp:RequiredFieldValidator
                        ID="RFV_Phone" runat="server"
                        ControlToValidate="txtPhone"
                        ErrorMessage="رقم الجوال مطلوب"
                        CssClass="validation-error" Display="Dynamic"
                        ValidationGroup="OrderGroup" />
                    <asp:RegularExpressionValidator
                        ID="REV_Phone" runat="server"
                        ControlToValidate="txtPhone"
                        ErrorMessage="رقم الجوال يجب أن يبدأ بـ 05 ويتكوّن من 10 أرقام"
                        ValidationExpression="^05\d{8}$"
                        CssClass="validation-error" Display="Dynamic"
                        ValidationGroup="OrderGroup" />
                </div>
                <div class="form-group">
                    <label class="form-label">البريد الإلكتروني *</label>
                    <asp:TextBox ID="txtEmail" runat="server"
                        CssClass="form-input" TextMode="Email"
                        placeholder="example@mail.com" />
                    <asp:RequiredFieldValidator
                        ID="RFV_Email" runat="server"
                        ControlToValidate="txtEmail"
                        ErrorMessage="البريد الإلكتروني مطلوب"
                        CssClass="validation-error" Display="Dynamic"
                        ValidationGroup="OrderGroup" />
                    <asp:RegularExpressionValidator
                        ID="REV_Email" runat="server"
                        ControlToValidate="txtEmail"
                        ErrorMessage="صيغة البريد الإلكتروني غير صحيحة"
                        ValidationExpression="\w+([-+.']\w+)*@\w+([-.]\w+)*\.\w+([-.]\w+)*"
                        CssClass="validation-error" Display="Dynamic"
                        ValidationGroup="OrderGroup" />
                </div>

                <div class="form-grid-2">
                    <div class="form-group">
                        <label class="form-label">المدينة *</label>
                        <asp:DropDownList ID="ddlCity" runat="server"
                            CssClass="form-select">
                            <asp:ListItem Text="-- اختر المدينة --" Value="" />
                            <asp:ListItem Text="الرياض" Value="Riyadh" />
                            <asp:ListItem Text="جدة" Value="Jeddah" />
                            <asp:ListItem Text="الدمام" Value="Dammam" />
                            <asp:ListItem Text="مكة المكرمة" Value="Makkah" />
                            <asp:ListItem Text="المدينة المنورة" Value="Medina" />
                            <asp:ListItem Text="الطائف" Value="Taif" />
                        </asp:DropDownList>
                        <asp:RequiredFieldValidator
                            ID="RFV_City" runat="server"
                            ControlToValidate="ddlCity" InitialValue=""
                            ErrorMessage="يرجى اختيار المدينة"
                            CssClass="validation-error" Display="Dynamic"
                            ValidationGroup="OrderGroup" />
                    </div>
                    <div class="form-group">
                        <label class="form-label">الحي *</label>
                        <asp:TextBox ID="txtDistrict" runat="server"
                            CssClass="form-input" placeholder="حي النزهة" />
                        <asp:RequiredFieldValidator
                            ID="RFV_District" runat="server"
                            ControlToValidate="txtDistrict"
                            ErrorMessage="الحي مطلوب"
                            CssClass="validation-error" Display="Dynamic"
                            ValidationGroup="OrderGroup" />
                    </div>
                </div>

                <div class="form-group">
                    <label class="form-label">العنوان التفصيلي *</label>
                    <asp:TextBox ID="txtAddress" runat="server"
                        CssClass="form-input"
                        placeholder="اسم الشارع، رقم المبنى، الطابق..." />
                    <asp:RequiredFieldValidator
                        ID="RFV_Address" runat="server"
                        ControlToValidate="txtAddress"
                        ErrorMessage="العنوان التفصيلي مطلوب"
                        CssClass="validation-error" Display="Dynamic"
                        ValidationGroup="OrderGroup" />
                </div>
            </div>

            <%-- ══ Payment method section ══ --%>
            <div class="form-section">
                <div class="form-section-title">
                    <span class="form-section-num">2</span>
                    طريقة الدفع
                </div>

                <div class="payment-methods">
                    <div class="payment-option selected"
                        onclick="selectPayment(this,'card')">
                        <div class="payment-radio"></div>
                        <span class="payment-icon">💳</span>
                        <div>
                            <div class="payment-name">بطاقة ائتمان / مدى</div>
                            <div class="payment-desc">Visa · Mastercard · Mada</div>
                        </div>
                    </div>
                    <div class="payment-option"
                        onclick="selectPayment(this,'apple')">
                        <div class="payment-radio"></div>
                        <span class="payment-icon">📱</span>
                        <div>
                            <div class="payment-name">Apple Pay</div>
                            <div class="payment-desc">الدفع السريع عبر Apple Pay</div>
                        </div>
                    </div>
                    <div class="payment-option"
                        onclick="selectPayment(this,'cash')">
                        <div class="payment-radio"></div>
                        <span class="payment-icon">💵</span>
                        <div>
                            <div class="payment-name">الدفع عند الاستلام</div>
                            <div class="payment-desc">ادفع نقداً عند وصول الطلب</div>
                        </div>
                    </div>
                </div>

                <asp:HiddenField ID="hfPaymentMethod" runat="server" Value="card" />

                <%-- Card fields --%>
                <div class="card-fields" id="cardSection">
                    <div class="form-group">
                        <label class="form-label">رقم البطاقة</label>
                        <asp:TextBox ID="txtCardNumber" runat="server"
                            CssClass="form-input"
                            placeholder="•••• •••• •••• ••••"
                            MaxLength="19" />
                        <asp:RequiredFieldValidator
                            ID="RFV_Card" runat="server"
                            ControlToValidate="txtCardNumber"
                            ErrorMessage="رقم البطاقة مطلوب"
                            CssClass="validation-error" Display="Dynamic"
                            ValidationGroup="OrderGroup" />
                    </div>
                    <div class="card-field-row">
                        <div class="form-group">
                            <label class="form-label">تاريخ الانتهاء</label>
                            <asp:TextBox ID="txtExpiry" runat="server"
                                CssClass="form-input"
                                placeholder="MM/YY" MaxLength="5" />
                            <asp:RequiredFieldValidator
                                ID="RFV_Expiry" runat="server"
                                ControlToValidate="txtExpiry"
                                ErrorMessage="مطلوب"
                                CssClass="validation-error" Display="Dynamic"
                                ValidationGroup="OrderGroup" />
                        </div>
                        <div class="form-group">
                            <label class="form-label">CVV</label>
                            <asp:TextBox ID="txtCVV" runat="server"
                                CssClass="form-input"
                                placeholder="•••" MaxLength="3"
                                TextMode="Password" />
                            <asp:RequiredFieldValidator
                                ID="RFV_CVV" runat="server"
                                ControlToValidate="txtCVV"
                                ErrorMessage="مطلوب"
                                CssClass="validation-error" Display="Dynamic"
                                ValidationGroup="OrderGroup" />
                        </div>
                    </div>
                    <div class="form-group" style="margin-bottom: 0;">
                        <label class="form-label">الاسم على البطاقة</label>
                        <asp:TextBox ID="txtCardHolder" runat="server"
                            CssClass="form-input"
                            placeholder="MOHAMMED AL-AHMAD" />
                        <asp:RequiredFieldValidator
                            ID="RFV_CardHolder" runat="server"
                            ControlToValidate="txtCardHolder"
                            ErrorMessage="اسم حامل البطاقة مطلوب"
                            CssClass="validation-error" Display="Dynamic"
                            ValidationGroup="CardGroup" />
                    </div>
                </div>

                <asp:Button ID="btnPlaceOrder" runat="server"
                    Text="🔒 تأكيد الطلب"
                    CssClass="checkout-place-btn"
                    ValidationGroup="OrderGroup"
                    OnClick="btnPlaceOrder_Click" />

                <p class="secure-note">
                    محمي بتشفير <span>SSL 256-bit</span> | بياناتك آمنة تماماً 🔐
                </p>
            </div>
        </div>

        <%-- ════════ Right column — order summary ════════ --%>
        <div class="order-summary-sticky">
            <div class="summary-title">🛍 ملخص الطلب</div>

            <%-- Cart items repeater --%>
            <asp:Repeater ID="rptCartItems" runat="server">
                <ItemTemplate>
                    <div class="order-item-mini">
                        <div class="order-item-img">
                            <img src='<%# Eval("ImageUrl") %>'
                                alt='<%# Eval("ProductName") %>'
                                onerror="this.src='images/placeholder.png'" />
                        </div>
                        <div style="flex: 1; min-width: 0;">
                            <div class="order-item-name">
                                <%# Eval("ProductName") %>
                            </div>
                            <div class="order-item-qty">
                                <%# Eval("Brand") %>
                                <%# !string.IsNullOrEmpty(
                                    Eval("Color").ToString())
                                ? " · " + Eval("Color") : "" %>
                                <%# !string.IsNullOrEmpty(
                                    Eval("Size").ToString())
                                ? " · " + Eval("Size")  : "" %>
                            × <%# Eval("Quantity") %>
                            </div>
                        </div>
                        <div class="order-item-price">
                            <%# ((decimal)Eval("LineTotal")).ToString("N2") %>
                        ر.س
                        </div>
                    </div>
                </ItemTemplate>
            </asp:Repeater>

            <%-- Empty cart --%>
            <asp:Panel ID="pnlEmptyCart" runat="server" Visible="false">
                <div class="empty-cart-msg">
                    <div class="empty-icon">🛒</div>
                    <p>سلتك فارغة</p>
                </div>
            </asp:Panel>

            <%-- Coupon --%>
            <div class="summary-divider" style="margin-top: 16px;"></div>
            <div class="coupon-box">
                <asp:TextBox ID="txtCoupon" runat="server"
                    CssClass="form-input"
                    placeholder="كود الخصم"
                    Style="margin-bottom: 0;" />
                <asp:Button ID="btnApplyCoupon" runat="server"
                    Text="تطبيق" CssClass="coupon-btn"
                    CausesValidation="false"
                    OnClick="btnApplyCoupon_Click" />
            </div>
            <asp:Label ID="lblCouponMsg" runat="server"
                Visible="false"
                Style="margin-bottom: 8px; display: block; font-size: 12px;" />

            <div class="summary-divider"></div>

            <div class="summary-row">
                <span class="summary-row-label">المجموع الفرعي</span>
                <asp:Label ID="lblSubtotal" runat="server"
                    CssClass="summary-row-value" Text="0 ر.س" />
            </div>
            <div class="summary-row">
                <span class="summary-row-label">الخصم</span>
                <asp:Label ID="lblDiscount" runat="server"
                    CssClass="summary-row-value"
                    Style="color: #00b14f;" Text="- 0 ر.س" />
            </div>
            <div class="summary-row">
                <span class="summary-row-label">الشحن</span>
                <asp:Label ID="lblShipping" runat="server"
                    CssClass="summary-row-value free" Text="مجاني" />
            </div>
            <div class="summary-row">
                <span class="summary-row-label">ضريبة القيمة المضافة (15%)</span>
                <asp:Label ID="lblTax" runat="server"
                    CssClass="summary-row-value" Text="0 ر.س" />
            </div>

            <div class="summary-divider"></div>

            <div class="summary-total">
                <span>الإجمالي</span>
                <asp:Label ID="lblTotal" runat="server"
                    CssClass="summary-total-value" Text="0 ر.س" />
            </div>
        </div>
    </div>

    <script src='<%= ResolveUrl("~/Scripts/shared.js") %>'></script>
    <script>
        function selectPayment(el, type) {
            document.querySelectorAll('.payment-option')
                .forEach(o => o.classList.remove('selected'));
            el.classList.add('selected');
            document.getElementById(
            '<%= hfPaymentMethod.ClientID %>').value = type;
            document.getElementById('cardSection').style.display =
                (type === 'card') ? 'block' : 'none';
        }

        window.addEventListener('load', function () {
            var method = document.getElementById(
            '<%= hfPaymentMethod.ClientID %>').value;
        document.getElementById('cardSection').style.display =
            (method === 'card') ? 'block' : 'none';
    });

        // Format the card number
        var cardInput = document.getElementById('<%= txtCardNumber.ClientID %>');
        if (cardInput) {
            cardInput.addEventListener('input', function () {
                var v = this.value.replace(/\D/g, '').substring(0, 16);
                var parts = v.match(/.{1,4}/g);
                this.value = parts ? parts.join(' ') : v;
            });
        }

        // Format the expiry date
        var expiryInput = document.getElementById('<%= txtExpiry.ClientID %>');
        if (expiryInput) {
            expiryInput.addEventListener('input', function () {
                var v = this.value.replace(/\D/g, '');
                if (v.length >= 2) v = v.substring(0, 2) + '/' + v.substring(2, 4);
                this.value = v;
            });
        }
    </script>

</asp:Content>
