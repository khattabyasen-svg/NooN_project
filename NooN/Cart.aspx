<%@ Page Title="Shopping Cart - NooN" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeBehind="Cart.aspx.cs" Inherits="NooN.Cart" %>

<asp:Content ID="HeadContent" ContentPlaceHolderID="head" runat="server">
    <link href="https://fonts.googleapis.com/css2?family=Tajawal:wght@300;400;500;700;800&display=swap" rel="stylesheet" />
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css" />
    <link href="Content/cart.css?v=coral1" rel="stylesheet" />
</asp:Content>

<asp:Content ID="BodyContent" ContentPlaceHolderID="MainContent" runat="server">


    <div class="cart-container">
        <asp:UpdatePanel ID="UpdatePanel1" runat="server">
            <ContentTemplate>
                
                <%-- System messages (success / error) --%>
                <asp:Panel ID="pnlSuccess" runat="server" Visible="false" CssClass="alert alert-success">
                    <i class="fa-solid fa-circle-check"></i> <asp:Literal ID="litSuccessMsg" runat="server" />
                </asp:Panel>
                
                <asp:Panel ID="pnlError" runat="server" Visible="false" CssClass="alert alert-danger">
                    <i class="fa-solid fa-circle-exclamation"></i> <asp:Literal ID="litErrorMsg" runat="server" />
                </asp:Panel>

                <%-- Cart panel --%>
                <asp:Panel ID="pnlCart" runat="server">
                    <div class="cart-layout">

                        <%-- Left side: products --%>
                        <div class="items-section">
                            <div style="display:flex; justify-content:space-between; align-items:center; margin-bottom:20px;">
                                <h1 style="font-size:24px; font-weight:800; margin:0;">Shopping Cart (<asp:Literal ID="litItemCount" runat="server" />)</h1>
                                <asp:LinkButton ID="btnClearCart" runat="server" OnClick="btnClearCart_Click" OnClientClick="return confirm('Are you sure you want to remove all items?');" ForeColor="#eb4d4b" style="text-decoration:none; font-weight:600; font-size:14px;">
                                    <i class="fa-solid fa-trash-can"></i> Clear Cart
                                </asp:LinkButton>
                            </div>

                            <asp:Repeater ID="rptCartItems" runat="server" OnItemCommand="rptCartItems_ItemCommand">
                                <ItemTemplate>
                                    <div class="cart-card">
                                        <div class="cart-card-body">
                                            <div class="img-container">
                                                <img src='<%# GetProductImage(Eval("images")) %>' alt="product" />
                                            </div>
                                            <div class="product-info">
                                                <a href='Details.aspx?id=<%# Eval("product_id") %>' class="product-name"><%# Eval("name") %></a>
                                                <div class="product-meta">
                                                    <span>Brand: <b><%# Eval("brand") %></b></span> |
                                                    <span>Color: <b><%# Eval("color") ?? "N/A" %></b></span> |
                                                    <span>Size: <b><%# Eval("size") ?? "N/A" %></b></span>
                                                </div>
                                                <div class="qty-box">
                                                    <%-- Decrease button --%>
                                                    <asp:LinkButton ID="btnDec" runat="server"
                                                        CommandName="Decrease"
                                                        CommandArgument='<%# Eval("cart_item_id") %>'
                                                        CausesValidation="false"
                                                        CssClass="qty-btn" Style="color: #888;">−</asp:LinkButton>

                                                    <span class="qty-val"><%# Eval("quantity") %></span>

                                                    <%-- Increase button --%>
                                                    <asp:LinkButton ID="btnInc" runat="server"
                                                        CommandName="Increase"
                                                        CommandArgument='<%# Eval("cart_item_id") %>'
                                                        CausesValidation="false"
                                                        CssClass="qty-btn" Style="color: var(--primary);">+</asp:LinkButton>
                                                </div>
                                            </div>
                                            <div class="price-col">
                                                <div class="item-price"><%# FormatPrice(Eval("item_total")) %> <small>JD</small></div>
                                                <asp:LinkButton ID="btnDelete" runat="server" CommandName="Remove" CommandArgument='<%# Eval("cart_item_id") %>' CssClass="btn-remove">Remove Item</asp:LinkButton>
                                            </div>
                                        </div>
                                    </div>
                                </ItemTemplate>
                            </asp:Repeater>
                        </div>

                        <%-- Right side: summary --%>
                        <div class="summary-section">
                            <div class="summary-card">
                                <h3 style="margin-top:0; margin-bottom:20px; font-weight:800;">Order Summary</h3>

                                <div class="coupon-area">
                                    <asp:TextBox ID="txtCoupon" runat="server" CssClass="txt-coupon" placeholder="Enter coupon code"></asp:TextBox>
                                    <asp:Button ID="btnApplyCoupon" runat="server" Text="Apply" CssClass="btn-apply" OnClick="btnApplyCoupon_Click" />
                                </div>
                                <asp:PlaceHolder ID="pnlCouponMsg" runat="server" Visible="false">
                                    <asp:Literal ID="litCouponMsg" runat="server" />
                                </asp:PlaceHolder>

                                <div class="bill-details" style="margin-top:20px;">
                                    <div class="bill-row">
                                        <span>Subtotal</span>
                                        <span><asp:Literal ID="litSubtotal" runat="server" /> JD</span>
                                    </div>

                                    <asp:Panel ID="pnlDiscountRow" runat="server" CssClass="bill-row discount-text" Visible="false">
                                        <span>Coupon discount <asp:Literal ID="litCouponCode" runat="server" /></span>
                                        <span>- <asp:Literal ID="litDiscount" runat="server" /> JD</span>
                                    </asp:Panel>

                                    <div class="bill-row">
                                        <span>Shipping</span>
                                        <span><asp:Literal ID="litShipping" runat="server" /></span>
                                    </div>
                                    <div class="bill-row">
                                        <span>Tax (16%)</span>
                                        <span><asp:Literal ID="litVat" runat="server" /> JD</span>
                                    </div>
                                    <div class="bill-row total">
                                        <span>Total</span>
                                        <span style="color:var(--dark);"><asp:Literal ID="litTotal" runat="server" /> JD</span>
                                    </div>
                                </div>

                                <asp:Button ID="btnCheckout" runat="server" Text="Proceed to Checkout" CssClass="btn-checkout" OnClick="btnCheckout_Click" />
                                
                                <div style="text-align:center; margin-top:15px; opacity:0.6; font-size:22px; display:flex; justify-content:center; gap:10px;">
                                    <i class="fa-brands fa-cc-visa"></i>
                                    <i class="fa-brands fa-cc-mastercard"></i>
                                    <i class="fa-brands fa-apple-pay"></i>
                                </div>
                            </div>
                        </div>
                    </div>
                </asp:Panel>

                <%-- Empty cart panel --%>
                <asp:Panel ID="pnlEmptyCart" runat="server" Visible="false" style="text-align:center; padding:80px 20px;">
                    <i class="fa-solid fa-cart-plus" style="font-size:70px; color:#ddd; margin-bottom:20px;"></i>
                    <h2 style="font-weight:800;">Your cart is empty</h2>
                    <p style="color:#777; margin-bottom:30px;">Looks like you haven't added any products yet. Start shopping now!</p>
                    <a href="Default.aspx" class="btn-checkout" style="text-decoration:none; display:inline-block; width:auto; padding:12px 40px;">Back to Store</a>
                </asp:Panel>

            </ContentTemplate>
        </asp:UpdatePanel>
    </div>
</asp:Content>
