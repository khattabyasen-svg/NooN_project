<%@ Page Title="الدفع" Language="C#"
    MasterPageFile="~/Site.Master"
    AutoEventWireup="true"
    CodeBehind="checkout.aspx.cs"
    Inherits="NooN.checkout" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
    <link href="Content/shared.css" rel="stylesheet" />
    <link href="Content/checkout.css" rel="stylesheet" />
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
                        placeholder="07XXXXXXXX" />
                    <asp:RequiredFieldValidator
                        ID="RFV_Phone" runat="server"
                        ControlToValidate="txtPhone"
                        ErrorMessage="رقم الجوال مطلوب"
                        CssClass="validation-error" Display="Dynamic"
                        ValidationGroup="OrderGroup" />
                    <asp:RegularExpressionValidator
                        ID="REV_Phone" runat="server"
                        ControlToValidate="txtPhone"
                        ErrorMessage="رقم الجوال يجب أن يبدأ بـ 07 ويتكوّن من 10 أرقام"
                        ValidationExpression="^07\d{8}$"
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
                        <label class="form-label">المحافظة *</label>
                        <asp:DropDownList ID="ddlCity" runat="server"
                            CssClass="form-select">
                            <asp:ListItem Text="-- اختر المحافظة --" Value="" />
                            <asp:ListItem Text="عمّان" Value="Amman" />
                            <asp:ListItem Text="إربد" Value="Irbid" />
                            <asp:ListItem Text="الزرقاء" Value="Zarqa" />
                            <asp:ListItem Text="البلقاء" Value="Balqa" />
                            <asp:ListItem Text="مادبا" Value="Madaba" />
                            <asp:ListItem Text="المفرق" Value="Mafraq" />
                            <asp:ListItem Text="جرش" Value="Jerash" />
                            <asp:ListItem Text="عجلون" Value="Ajloun" />
                            <asp:ListItem Text="الكرك" Value="Karak" />
                            <asp:ListItem Text="الطفيلة" Value="Tafilah" />
                            <asp:ListItem Text="معان" Value="Maan" />
                            <asp:ListItem Text="العقبة" Value="Aqaba" />
                        </asp:DropDownList>
                        <asp:RequiredFieldValidator
                            ID="RFV_City" runat="server"
                            ControlToValidate="ddlCity" InitialValue=""
                            ErrorMessage="يرجى اختيار المحافظة"
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
                        <asp:RegularExpressionValidator
                            ID="REV_Card" runat="server"
                            ControlToValidate="txtCardNumber"
                            ErrorMessage="رقم البطاقة يجب أن يتكوّن من 16 إلى 19 رقماً"
                            ValidationExpression="^[\d\s]{16,19}$"
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
                            <asp:RegularExpressionValidator
                                ID="REV_Expiry" runat="server"
                                ControlToValidate="txtExpiry"
                                ErrorMessage="الصيغة الصحيحة MM/YY"
                                ValidationExpression="^(0[1-9]|1[0-2])\/\d{2}$"
                                CssClass="validation-error" Display="Dynamic"
                                ValidationGroup="OrderGroup" />
                        </div>
                        <div class="form-group">
                            <label class="form-label">CVV</label>
                            <asp:TextBox ID="txtCVV" runat="server"
                                CssClass="form-input"
                                placeholder="•••" MaxLength="4"
                                TextMode="Password" />
                            <asp:RequiredFieldValidator
                                ID="RFV_CVV" runat="server"
                                ControlToValidate="txtCVV"
                                ErrorMessage="مطلوب"
                                CssClass="validation-error" Display="Dynamic"
                                ValidationGroup="OrderGroup" />
                            <asp:RegularExpressionValidator
                                ID="REV_CVV" runat="server"
                                ControlToValidate="txtCVV"
                                ErrorMessage="CVV يجب أن يتكوّن من 3 أو 4 أرقام"
                                ValidationExpression="^\d{3,4}$"
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
                            ValidationGroup="OrderGroup" />
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
                                onerror="imgFallback(this)" />
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
                        د.أ
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
                    CssClass="summary-row-value" Text="0 د.أ" />
            </div>
            <div class="summary-row">
                <span class="summary-row-label">الخصم</span>
                <asp:Label ID="lblDiscount" runat="server"
                    CssClass="summary-row-value"
                    Style="color: #00b14f;" Text="- 0 د.أ" />
            </div>
            <div class="summary-row">
                <span class="summary-row-label">الشحن</span>
                <asp:Label ID="lblShipping" runat="server"
                    CssClass="summary-row-value free" Text="مجاني" />
            </div>
            <div class="summary-row">
                <span class="summary-row-label">ضريبة القيمة المضافة (16%)</span>
                <asp:Label ID="lblTax" runat="server"
                    CssClass="summary-row-value" Text="0 د.أ" />
            </div>

            <div class="summary-divider"></div>

            <div class="summary-total">
                <span>الإجمالي</span>
                <asp:Label ID="lblTotal" runat="server"
                    CssClass="summary-total-value" Text="0 د.أ" />
            </div>
        </div>
    </div>

    <script src='<%= ResolveUrl("~/Scripts/shared.js") %>'></script>
    <script>
        var checkoutIds = {
            hfPaymentMethod: '<%= hfPaymentMethod.ClientID %>',
            rfvCard:         '<%= RFV_Card.ClientID %>',
            revCard:         '<%= REV_Card.ClientID %>',
            rfvExpiry:       '<%= RFV_Expiry.ClientID %>',
            revExpiry:       '<%= REV_Expiry.ClientID %>',
            rfvCVV:          '<%= RFV_CVV.ClientID %>',
            revCVV:          '<%= REV_CVV.ClientID %>',
            rfvCardHolder:   '<%= RFV_CardHolder.ClientID %>',
            txtCardNumber:   '<%= txtCardNumber.ClientID %>',
            txtExpiry:       '<%= txtExpiry.ClientID %>'
        };
    </script>
    <script src='<%= ResolveUrl("~/Scripts/checkout.js") %>'></script>

</asp:Content>
