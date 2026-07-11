<%@ Page Title="تأكيد الطلب" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeBehind="Confirm.aspx.cs" Inherits="NooN.Confirm" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
    <%-- استدعاء ملفات التنسيق في المكان الصحيح --%>
    <link href="Content/shared.css" rel="stylesheet" />
    <link href="Content/confirmation.css" rel="stylesheet" />
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="MainContent" runat="server">
    <div class="confirmation-page" dir="rtl">
        <div class="confirm-icon">✅</div>
        <h2 class="confirm-title">تم تأكيد طلبك!</h2>
        <p class="confirm-subtitle">شكراً لك على ثقتك بـ Noon. تم استلام طلبك وسيتم معالجته قريباً. ستصلك رسالة تأكيد على بريدك الإلكتروني.</p>
        <div class="confirm-order-num">طلب رقم: <asp:Literal ID="litOrderNumber" runat="server" /></div>

        <div class="tracking-steps">
            <div class="track-step done"><div class="track-icon">✓</div><div class="track-label">تم الطلب</div></div>
            <div class="track-step active"><div class="track-icon">🔄</div><div class="track-label">قيد المعالجة</div></div>
            <div class="track-step"><div class="track-icon">📦</div><div class="track-label">تم الشحن</div></div>
            <div class="track-step"><div class="track-icon">🚚</div><div class="track-label">في الطريق</div></div>
            <div class="track-step"><div class="track-icon">🏠</div><div class="track-label">تم التوصيل</div></div>
        </div>

        <div class="delivery-card">
            <div style="font-size:13px;color:var(--text-muted);margin-bottom:8px;">موعد التوصيل المتوقع</div>
            <div style="font-family:'Playfair Display',serif;font-size:1.3rem;font-weight:700;color:var(--text-primary);"><asp:Literal ID="litDeliveryDate" runat="server" /></div>
            <div style="font-size:13px;color:var(--text-muted);margin-top:4px;">التوصيل إلى: <asp:Literal ID="litDeliveryTo" runat="server" /></div>
        </div>

        <div class="confirm-actions">
            <%-- زر العودة للرئيسية (سيرفري) --%>
            <asp:Button ID="btnContinueShopping" runat="server" 
                Text="← متابعة التسوق" 
                CssClass="btn-primary" 
                OnClick="btnContinueShopping_Click" />

            <%-- زر التتبع (جافا سكريبت) --%>
            <asp:Button ID="btnTrackOrder" runat="server" 
                Text="تتبع الطلب" 
                CssClass="btn-secondary" 
                OnClientClick="showToast('📧 تم إرسال رابط التتبع لبريدك'); return false;" />
        </div>
    </div>
 
    <script src="Scripts/shared.js"></script>
    
</asp:Content>