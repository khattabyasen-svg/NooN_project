<%@ Page Title="سلة التسوق - NooN" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeBehind="Cart.aspx.cs" Inherits="NooN.Cart" %>

<asp:Content ID="BodyContent" ContentPlaceHolderID="MainContent" runat="server">
    <link href="https://fonts.googleapis.com/css2?family=Tajawal:wght@300;400;500;700;800&display=swap" rel="stylesheet" />
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css" />

  

    <style>
        :root { --primary: #FFC600; --dark: #1A1A1A; --gray-bg: #F7F7F7; --danger: #eb4d4b; --success: #27ae60; }
        body { background-color: var(--gray-bg); font-family: 'Tajawal', sans-serif; direction: rtl; }
        .cart-container { max-width: 1200px; margin: 40px auto; padding: 0 15px; }
        .cart-layout { display: grid; grid-template-columns: 1fr 380px; gap: 30px; }
        
        /* البطاقات والتنسيق */
        .cart-card { background: white; border-radius: 16px; padding: 20px; margin-bottom: 15px; box-shadow: 0 2px 10px rgba(0,0,0,0.05); }
        .cart-card-body { display: flex; gap: 20px; align-items: center; }
        .img-container { width: 100px; height: 100px; border-radius: 12px; overflow: hidden; background: #f9f9f9; border: 1px solid #eee; }
        .img-container img { width: 100%; height: 100%; object-fit: contain; }
        
        .product-info { flex-grow: 1; }
        .product-name { font-size: 18px; font-weight: 700; color: var(--dark); text-decoration: none; display: block; margin-bottom: 5px; }
        .product-meta { font-size: 13px; color: #777; margin-bottom: 10px; }
        
        /* التحكم بالكمية */
        .qty-box { display: flex; align-items: center; gap: 12px; background: #f3f3f3; width: fit-content; padding: 5px 12px; border-radius: 50px; }
        .qty-btn { text-decoration: none; color: var(--dark); font-weight: bold; font-size: 18px; }
        .qty-val { font-weight: 800; min-width: 20px; text-align: center; }

        .price-col { text-align: left; min-width: 120px; }
        .item-price { font-size: 19px; font-weight: 900; }
        .btn-remove { color: var(--danger); font-size: 13px; text-decoration: none; display: block; margin-top: 8px; }

        /* ملخص الفاتورة */
        .summary-card { background: white; padding: 25px; border-radius: 20px; box-shadow: 0 10px 30px rgba(0,0,0,0.05); position: sticky; top: 20px; }
        .bill-row { display: flex; justify-content: space-between; margin-bottom: 15px; font-size: 15px; }
        .bill-row.total { font-size: 22px; font-weight: 900; border-top: 2px solid #f9f9f9; padding-top: 15px; margin-top: 15px; }
        .discount-text { color: var(--success); font-weight: bold; }
        
        .btn-checkout { width: 100%; background: var(--primary); color: var(--dark); border: none; padding: 15px; border-radius: 12px; font-weight: 800; font-size: 17px; cursor: pointer; transition: 0.3s; margin-top: 15px; }
        .btn-checkout:hover { transform: translateY(-2px); box-shadow: 0 5px 15px rgba(255,198,0,0.4); }

        .coupon-area { display: flex; gap: 10px; margin-bottom: 10px; }
        .txt-coupon { flex-grow: 1; padding: 10px; border: 1px solid #ddd; border-radius: 10px; outline: none; }
        .btn-apply { background: var(--dark); color: white; border: none; padding: 0 15px; border-radius: 10px; cursor: pointer; }

        .alert { padding: 12px; border-radius: 10px; margin-bottom: 20px; font-size: 14px; }
        .alert-success { background: #dcfce7; color: #166534; border: 1px solid #bbf7d0; }
        .alert-danger { background: #fee2e2; color: #991b1b; border: 1px solid #fecaca; }
        
        @media (max-width: 991px) { .cart-layout { grid-template-columns: 1fr; } }
    </style>

    <div class="cart-container">
        <asp:UpdatePanel ID="UpdatePanel1" runat="server">
            <ContentTemplate>
                
                <%-- رسائل النظام (نجاح / خطأ) --%>
                <asp:Panel ID="pnlSuccess" runat="server" Visible="false" CssClass="alert alert-success">
                    <i class="fa-solid fa-circle-check"></i> <asp:Literal ID="litSuccessMsg" runat="server" />
                </asp:Panel>
                
                <asp:Panel ID="pnlError" runat="server" Visible="false" CssClass="alert alert-danger">
                    <i class="fa-solid fa-circle-exclamation"></i> <asp:Literal ID="litErrorMsg" runat="server" />
                </asp:Panel>

                <%-- لوحة السلة --%>
                <asp:Panel ID="pnlCart" runat="server">
                    <div class="cart-layout">
                        
                        <%-- الجزء الأيمن: المنتجات --%>
                        <div class="items-section">
                            <div style="display:flex; justify-content:space-between; align-items:center; margin-bottom:20px;">
                                <h1 style="font-size:24px; font-weight:800; margin:0;">سلة التسوق (<asp:Literal ID="litItemCount" runat="server" />)</h1>
                                <asp:LinkButton ID="btnClearCart" runat="server" OnClick="btnClearCart_Click" OnClientClick="return confirm('هل أنت متأكد من حذف جميع العناصر؟');" ForeColor="#eb4d4b" style="text-decoration:none; font-weight:600; font-size:14px;">
                                    <i class="fa-solid fa-trash-can"></i> مسح السلة
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
                                                    <span>الماركة: <b><%# Eval("brand") %></b></span> | 
                                                    <span>اللون: <b><%# Eval("color") ?? "N/A" %></b></span> |
                                                    <span>المقاس: <b><%# Eval("size") ?? "N/A" %></b></span>
                                                </div>
                                                <div class="qty-box">
                                                    <%-- زر النقص --%>
                                                    <asp:LinkButton ID="btnDec" runat="server"
                                                        CommandName="Decrease"
                                                        CommandArgument='<%# Eval("cart_item_id") %>'
                                                        CausesValidation="false"
                                                        CssClass="qty-btn" Style="color: #888;">−</asp:LinkButton>

                                                    <span class="qty-val"><%# Eval("quantity") %></span>

                                                    <%-- زر الزيادة --%>
                                                    <asp:LinkButton ID="btnInc" runat="server"
                                                        CommandName="Increase"
                                                        CommandArgument='<%# Eval("cart_item_id") %>'
                                                        CausesValidation="false"
                                                        CssClass="qty-btn" Style="color: var(--primary);">+</asp:LinkButton>
                                                </div>
                                            </div>
                                            <div class="price-col">
                                                <div class="item-price"><%# FormatPrice(Eval("item_total")) %> <small>ر.س</small></div>
                                                <asp:LinkButton ID="btnDelete" runat="server" CommandName="Remove" CommandArgument='<%# Eval("cart_item_id") %>' CssClass="btn-remove">حذف المنتج</asp:LinkButton>
                                            </div>
                                        </div>
                                    </div>
                                </ItemTemplate>
                            </asp:Repeater>
                        </div>

                        <%-- الجزء الأيسر: الملخص --%>
                        <div class="summary-section">
                            <div class="summary-card">
                                <h3 style="margin-top:0; margin-bottom:20px; font-weight:800;">ملخص الطلب</h3>
                                
                                <div class="coupon-area">
                                    <asp:TextBox ID="txtCoupon" runat="server" CssClass="txt-coupon" placeholder="أدخل كود الخصم"></asp:TextBox>
                                    <asp:Button ID="btnApplyCoupon" runat="server" Text="تطبيق" CssClass="btn-apply" OnClick="btnApplyCoupon_Click" />
                                </div>
                                <asp:PlaceHolder ID="pnlCouponMsg" runat="server" Visible="false">
                                    <asp:Literal ID="litCouponMsg" runat="server" />
                                </asp:PlaceHolder>

                                <div class="bill-details" style="margin-top:20px;">
                                    <div class="bill-row">
                                        <span>المجموع الفرعي</span>
                                        <span><asp:Literal ID="litSubtotal" runat="server" /> ر.س</span>
                                    </div>

                                    <asp:Panel ID="pnlDiscountRow" runat="server" CssClass="bill-row discount-text" Visible="false">
                                        <span>خصم الكوبون <asp:Literal ID="litCouponCode" runat="server" /></span>
                                        <span>- <asp:Literal ID="litDiscount" runat="server" /> ر.س</span>
                                    </asp:Panel>

                                    <div class="bill-row">
                                        <span>الشحن</span>
                                        <span><asp:Literal ID="litShipping" runat="server" /></span>
                                    </div>
                                    <div class="bill-row">
                                        <span>الضريبة (15%)</span>
                                        <span><asp:Literal ID="litVat" runat="server" /> ر.س</span>
                                    </div>
                                    <div class="bill-row total">
                                        <span>الإجمالي</span>
                                        <span style="color:var(--dark);"><asp:Literal ID="litTotal" runat="server" /> ر.س</span>
                                    </div>
                                </div>

                                <asp:Button ID="btnCheckout" runat="server" Text="إتمام عملية الشراء" CssClass="btn-checkout" OnClick="btnCheckout_Click" />
                                
                                <div style="text-align:center; margin-top:15px; opacity:0.6; font-size:22px; display:flex; justify-content:center; gap:10px;">
                                    <i class="fa-brands fa-cc-visa"></i>
                                    <i class="fa-brands fa-cc-mastercard"></i>
                                    <i class="fa-brands fa-apple-pay"></i>
                                </div>
                            </div>
                        </div>
                    </div>
                </asp:Panel>

                <%-- لوحة السلة الفارغة --%>
                <asp:Panel ID="pnlEmptyCart" runat="server" Visible="false" style="text-align:center; padding:80px 20px;">
                    <i class="fa-solid fa-cart-plus" style="font-size:70px; color:#ddd; margin-bottom:20px;"></i>
                    <h2 style="font-weight:800;">سلتك فارغة حالياً</h2>
                    <p style="color:#777; margin-bottom:30px;">يبدو أنك لم تضف أي منتجات بعد. ابدأ بالتسوق الآن!</p>
                    <a href="Default.aspx" class="btn-checkout" style="text-decoration:none; display:inline-block; width:auto; padding:12px 40px;">العودة للمتجر</a>
                </asp:Panel>

            </ContentTemplate>
        </asp:UpdatePanel>
    </div>
</asp:Content>