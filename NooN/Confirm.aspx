<%@ Page Title="Order Confirmation" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeBehind="Confirm.aspx.cs" Inherits="NooN.Confirm" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
    <%-- Reference the stylesheets in the correct place --%>
    <link href="Content/shared.css?v=coral1" rel="stylesheet" />
    <link href="Content/confirmation.css?v=coral1" rel="stylesheet" />
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="MainContent" runat="server">
    <div class="confirmation-page" dir="ltr">
        <div class="confirm-icon">✅</div>
        <h2 class="confirm-title">Your order is confirmed!</h2>
        <p class="confirm-subtitle">Thank you for trusting Noon. Your order has been received and will be processed shortly. A confirmation message will be sent to your email.</p>
        <div class="confirm-order-num">Order number: <asp:Literal ID="litOrderNumber" runat="server" /></div>

        <div class="tracking-steps">
            <div class="track-step done"><div class="track-icon">✓</div><div class="track-label">Ordered</div></div>
            <div class="track-step active"><div class="track-icon">🔄</div><div class="track-label">Processing</div></div>
            <div class="track-step"><div class="track-icon">📦</div><div class="track-label">Shipped</div></div>
            <div class="track-step"><div class="track-icon">🚚</div><div class="track-label">On the way</div></div>
            <div class="track-step"><div class="track-icon">🏠</div><div class="track-label">Delivered</div></div>
        </div>

        <div class="delivery-card">
            <div style="font-size:13px;color:var(--text-muted);margin-bottom:8px;">Estimated delivery date</div>
            <div style="font-family:'Playfair Display',serif;font-size:1.3rem;font-weight:700;color:var(--text-primary);"><asp:Literal ID="litDeliveryDate" runat="server" /></div>
            <div style="font-size:13px;color:var(--text-muted);margin-top:4px;">Delivering to: <asp:Literal ID="litDeliveryTo" runat="server" /></div>
        </div>

        <div class="confirm-actions">
            <%-- Continue-shopping button (server-side) --%>
            <asp:Button ID="btnContinueShopping" runat="server"
                Text="← Continue Shopping"
                CssClass="btn-primary"
                OnClick="btnContinueShopping_Click" />

            <%-- Track-order button (JavaScript) --%>
            <asp:Button ID="btnTrackOrder" runat="server"
                Text="Track Order"
                CssClass="btn-secondary"
                OnClientClick="showToast('📧 A tracking link has been sent to your email'); return false;" />

            <%-- Print-order button: opens the order details report in a new tab --%>
            <asp:HyperLink ID="btnPrintOrder" runat="server"
                Text="🖨️ Print Order"
                CssClass="btn-secondary"
                Target="_blank" />
        </div>
    </div>
 
    <script src="Scripts/shared.js"></script>
    
</asp:Content>