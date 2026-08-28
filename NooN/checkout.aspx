<%@ Page Title="Checkout" Language="C#"
    MasterPageFile="~/Site.Master"
    AutoEventWireup="true"
    CodeBehind="checkout.aspx.cs"
    Inherits="NooN.checkout" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
    <link href="Content/shared.css?v=coral1" rel="stylesheet" />
    <link href="Content/checkout.css?v=coral1" rel="stylesheet" />
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="MainContent" runat="server">

    <div class="checkout-layout" dir="ltr">

        <%-- ════════ Left column — the form ════════ --%>
        <div>

            <%-- Step bar --%>
            <div class="checkout-step-bar">
                <div class="checkout-step done">
                    <div class="step-circle">✓</div>
                    <div class="step-label">Cart</div>
                </div>
                <div class="step-line"></div>
                <div class="checkout-step active">
                    <div class="step-circle">2</div>
                    <div class="step-label">Delivery</div>
                </div>
                <div class="step-line"></div>
                <div class="checkout-step">
                    <div class="step-circle">3</div>
                    <div class="step-label">Payment</div>
                </div>
                <div class="step-line"></div>
                <div class="checkout-step">
                    <div class="step-circle">4</div>
                    <div class="step-label">Confirmation</div>
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
                    Delivery Information
                </div>
                <div class="form-grid-2">
                    <div class="form-group">
                        <label class="form-label">First Name *</label>
                        <asp:TextBox ID="txtFirstName" runat="server"
                            CssClass="form-input"
                            placeholder="Mohammed" />
                        <asp:RequiredFieldValidator
                            ID="RFV_FirstName" runat="server"
                            ControlToValidate="txtFirstName"
                            ErrorMessage="First name is required"
                            CssClass="validation-error" Display="Dynamic"
                            ValidationGroup="OrderGroup" />
                    </div>
                    <div class="form-group">
                        <label class="form-label">Last Name *</label>
                        <asp:TextBox ID="txtLastName" runat="server"
                            CssClass="form-input"
                            placeholder="Al-Ahmad" />
                        <asp:RequiredFieldValidator
                            ID="RFV_LastName" runat="server"
                            ControlToValidate="txtLastName"
                            ErrorMessage="Last name is required"
                            CssClass="validation-error" Display="Dynamic"
                            ValidationGroup="OrderGroup" />
                    </div>
                </div>

                <div class="form-group">
                    <label class="form-label">Mobile Number *</label>
                    <asp:TextBox ID="txtPhone" runat="server"
                        CssClass="form-input"
                        TextMode="Phone"
                        placeholder="07XXXXXXXX" />
                    <asp:RequiredFieldValidator
                        ID="RFV_Phone" runat="server"
                        ControlToValidate="txtPhone"
                        ErrorMessage="Mobile number is required"
                        CssClass="validation-error" Display="Dynamic"
                        ValidationGroup="OrderGroup" />
                    <asp:RegularExpressionValidator
                        ID="REV_Phone" runat="server"
                        ControlToValidate="txtPhone"
                        ErrorMessage="Mobile number must start with 07 and be 10 digits"
                        ValidationExpression="^07\d{8}$"
                        CssClass="validation-error" Display="Dynamic"
                        ValidationGroup="OrderGroup" />
                </div>
                <div class="form-group">
                    <label class="form-label">Email Address *</label>
                    <asp:TextBox ID="txtEmail" runat="server"
                        CssClass="form-input" TextMode="Email"
                        placeholder="example@mail.com" />
                    <asp:RequiredFieldValidator
                        ID="RFV_Email" runat="server"
                        ControlToValidate="txtEmail"
                        ErrorMessage="Email address is required"
                        CssClass="validation-error" Display="Dynamic"
                        ValidationGroup="OrderGroup" />
                    <asp:RegularExpressionValidator
                        ID="REV_Email" runat="server"
                        ControlToValidate="txtEmail"
                        ErrorMessage="Invalid email address format"
                        ValidationExpression="\w+([-+.']\w+)*@\w+([-.]\w+)*\.\w+([-.]\w+)*"
                        CssClass="validation-error" Display="Dynamic"
                        ValidationGroup="OrderGroup" />
                </div>

                <div class="form-grid-2">
                    <div class="form-group">
                        <label class="form-label">Governorate *</label>
                        <asp:DropDownList ID="ddlCity" runat="server"
                            CssClass="form-select">
                            <asp:ListItem Text="-- Select governorate --" Value="" />
                            <asp:ListItem Text="Amman" Value="Amman" />
                            <asp:ListItem Text="Irbid" Value="Irbid" />
                            <asp:ListItem Text="Zarqa" Value="Zarqa" />
                            <asp:ListItem Text="Balqa" Value="Balqa" />
                            <asp:ListItem Text="Madaba" Value="Madaba" />
                            <asp:ListItem Text="Mafraq" Value="Mafraq" />
                            <asp:ListItem Text="Jerash" Value="Jerash" />
                            <asp:ListItem Text="Ajloun" Value="Ajloun" />
                            <asp:ListItem Text="Karak" Value="Karak" />
                            <asp:ListItem Text="Tafilah" Value="Tafilah" />
                            <asp:ListItem Text="Maan" Value="Maan" />
                            <asp:ListItem Text="Aqaba" Value="Aqaba" />
                        </asp:DropDownList>
                        <asp:RequiredFieldValidator
                            ID="RFV_City" runat="server"
                            ControlToValidate="ddlCity" InitialValue=""
                            ErrorMessage="Please select a governorate"
                            CssClass="validation-error" Display="Dynamic"
                            ValidationGroup="OrderGroup" />
                    </div>
                    <div class="form-group">
                        <label class="form-label">District *</label>
                        <asp:TextBox ID="txtDistrict" runat="server"
                            CssClass="form-input" placeholder="Al-Nuzha District" />
                        <asp:RequiredFieldValidator
                            ID="RFV_District" runat="server"
                            ControlToValidate="txtDistrict"
                            ErrorMessage="District is required"
                            CssClass="validation-error" Display="Dynamic"
                            ValidationGroup="OrderGroup" />
                    </div>
                </div>

                <div class="form-group">
                    <label class="form-label">Full Address *</label>
                    <asp:TextBox ID="txtAddress" runat="server"
                        CssClass="form-input"
                        placeholder="Street name, building number, floor..." />
                    <asp:RequiredFieldValidator
                        ID="RFV_Address" runat="server"
                        ControlToValidate="txtAddress"
                        ErrorMessage="Full address is required"
                        CssClass="validation-error" Display="Dynamic"
                        ValidationGroup="OrderGroup" />
                </div>
            </div>

            <%-- ══ Payment method section ══ --%>
            <div class="form-section">
                <div class="form-section-title">
                    <span class="form-section-num">2</span>
                    Payment Method
                </div>

                <div class="payment-methods">
                    <div class="payment-option selected"
                        onclick="selectPayment(this,'card')">
                        <div class="payment-radio"></div>
                        <span class="payment-icon">💳</span>
                        <div>
                            <div class="payment-name">Credit Card / Mada</div>
                            <div class="payment-desc">Visa · Mastercard · Mada</div>
                        </div>
                    </div>
                    <div class="payment-option"
                        onclick="selectPayment(this,'apple')">
                        <div class="payment-radio"></div>
                        <span class="payment-icon">📱</span>
                        <div>
                            <div class="payment-name">Apple Pay</div>
                            <div class="payment-desc">Fast checkout with Apple Pay</div>
                        </div>
                    </div>
                    <div class="payment-option"
                        onclick="selectPayment(this,'cash')">
                        <div class="payment-radio"></div>
                        <span class="payment-icon">💵</span>
                        <div>
                            <div class="payment-name">Cash on Delivery</div>
                            <div class="payment-desc">Pay in cash when your order arrives</div>
                        </div>
                    </div>
                </div>

                <asp:HiddenField ID="hfPaymentMethod" runat="server" Value="card" />

                <%-- Card fields --%>
                <div class="card-fields" id="cardSection">
                    <div class="form-group">
                        <label class="form-label">Card Number</label>
                        <asp:TextBox ID="txtCardNumber" runat="server"
                            CssClass="form-input"
                            placeholder="•••• •••• •••• ••••"
                            MaxLength="19" />
                        <asp:RequiredFieldValidator
                            ID="RFV_Card" runat="server"
                            ControlToValidate="txtCardNumber"
                            ErrorMessage="Card number is required"
                            CssClass="validation-error" Display="Dynamic"
                            ValidationGroup="OrderGroup" />
                        <asp:RegularExpressionValidator
                            ID="REV_Card" runat="server"
                            ControlToValidate="txtCardNumber"
                            ErrorMessage="Card number must be 16 to 19 digits"
                            ValidationExpression="^[\d\s]{16,19}$"
                            CssClass="validation-error" Display="Dynamic"
                            ValidationGroup="OrderGroup" />
                    </div>
                    <div class="card-field-row">
                        <div class="form-group">
                            <label class="form-label">Expiry Date</label>
                            <asp:TextBox ID="txtExpiry" runat="server"
                                CssClass="form-input"
                                placeholder="MM/YY" MaxLength="5" />
                            <asp:RequiredFieldValidator
                                ID="RFV_Expiry" runat="server"
                                ControlToValidate="txtExpiry"
                                ErrorMessage="Required"
                                CssClass="validation-error" Display="Dynamic"
                                ValidationGroup="OrderGroup" />
                            <asp:RegularExpressionValidator
                                ID="REV_Expiry" runat="server"
                                ControlToValidate="txtExpiry"
                                ErrorMessage="Correct format is MM/YY"
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
                                ErrorMessage="Required"
                                CssClass="validation-error" Display="Dynamic"
                                ValidationGroup="OrderGroup" />
                            <asp:RegularExpressionValidator
                                ID="REV_CVV" runat="server"
                                ControlToValidate="txtCVV"
                                ErrorMessage="CVV must be 3 or 4 digits"
                                ValidationExpression="^\d{3,4}$"
                                CssClass="validation-error" Display="Dynamic"
                                ValidationGroup="OrderGroup" />
                        </div>
                    </div>
                    <div class="form-group" style="margin-bottom: 0;">
                        <label class="form-label">Name on Card</label>
                        <asp:TextBox ID="txtCardHolder" runat="server"
                            CssClass="form-input"
                            placeholder="MOHAMMED AL-AHMAD" />
                        <asp:RequiredFieldValidator
                            ID="RFV_CardHolder" runat="server"
                            ControlToValidate="txtCardHolder"
                            ErrorMessage="Cardholder name is required"
                            CssClass="validation-error" Display="Dynamic"
                            ValidationGroup="OrderGroup" />
                    </div>
                </div>

                <asp:Button ID="btnPlaceOrder" runat="server"
                    Text="🔒 Place Order"
                    CssClass="checkout-place-btn"
                    ValidationGroup="OrderGroup"
                    OnClick="btnPlaceOrder_Click" />

                <p class="secure-note">
                    Protected by <span>SSL 256-bit</span> encryption | Your data is completely secure 🔐
                </p>
            </div>
        </div>

        <%-- ════════ Right column — order summary ════════ --%>
        <div class="order-summary-sticky">
            <div class="summary-title">🛍 Order Summary</div>

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
                        JD
                        </div>
                    </div>
                </ItemTemplate>
            </asp:Repeater>

            <%-- Empty cart --%>
            <asp:Panel ID="pnlEmptyCart" runat="server" Visible="false">
                <div class="empty-cart-msg">
                    <div class="empty-icon">🛒</div>
                    <p>Your cart is empty</p>
                </div>
            </asp:Panel>

            <%-- Coupon --%>
            <div class="summary-divider" style="margin-top: 16px;"></div>
            <div class="coupon-box">
                <asp:TextBox ID="txtCoupon" runat="server"
                    CssClass="form-input"
                    placeholder="Coupon code"
                    Style="margin-bottom: 0;" />
                <asp:Button ID="btnApplyCoupon" runat="server"
                    Text="Apply" CssClass="coupon-btn"
                    CausesValidation="false"
                    OnClick="btnApplyCoupon_Click" />
            </div>
            <asp:Label ID="lblCouponMsg" runat="server"
                Visible="false"
                Style="margin-bottom: 8px; display: block; font-size: 12px;" />

            <div class="summary-divider"></div>

            <div class="summary-row">
                <span class="summary-row-label">Subtotal</span>
                <asp:Label ID="lblSubtotal" runat="server"
                    CssClass="summary-row-value" Text="0 JD" />
            </div>
            <div class="summary-row">
                <span class="summary-row-label">Discount</span>
                <asp:Label ID="lblDiscount" runat="server"
                    CssClass="summary-row-value"
                    Style="color: #00b14f;" Text="- 0 JD" />
            </div>
            <div class="summary-row">
                <span class="summary-row-label">Shipping</span>
                <asp:Label ID="lblShipping" runat="server"
                    CssClass="summary-row-value free" Text="Free" />
            </div>
            <div class="summary-row">
                <span class="summary-row-label">VAT (16%)</span>
                <asp:Label ID="lblTax" runat="server"
                    CssClass="summary-row-value" Text="0 JD" />
            </div>

            <div class="summary-divider"></div>

            <div class="summary-total">
                <span>Total</span>
                <asp:Label ID="lblTotal" runat="server"
                    CssClass="summary-total-value" Text="0 JD" />
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
