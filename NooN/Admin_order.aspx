<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="Admin_order.aspx.cs" Inherits="NooN.Admin_order" %>


<!DOCTYPE html>
<html lang="ar" dir="rtl">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<title>إدارة الطلبات — Admin</title>
<%--<link href="https://fonts.googleapis.com/css2?family=IBM+Plex+Mono:wght@400;600&family=Tajawal:wght@400;600;700;900&display=swap" rel="stylesheet">--%>
    <link href="Content/orders.css" rel="stylesheet" />
</head>
<body>

<!-- ── SIDEBAR ── -->
<aside class="sidebar">
  <div class="sb-logo">⚙️ Noon <em>Admin</em></div>
  <div class="sb-sec">القائمة</div>
  <div class="sb-item"><span class="sb-icon">📊</span> لوحة التحكم</div>
  <div class="sb-item"><span class="sb-icon">📦</span> المنتجات</div>
  <div class="sb-item active"><span class="sb-icon">🧾</span> الطلبات <span class="sb-badge">12</span></div>
  <div class="sb-item"><span class="sb-icon">👥</span> المستخدمين</div>
  <div class="sb-item"><span class="sb-icon">🏭</span> المخزون</div>
  <div class="sb-item"><span class="sb-icon">🎟️</span> الكوبونات</div>
  <div class="sb-item"><span class="sb-icon">🗂️</span> الفئات</div>
  <div class="sb-sec" style="margin-top:auto">النظام</div>
  <div class="sb-item"><span class="sb-icon">⚙️</span> الإعدادات</div>
  <div class="sb-item"><span class="sb-icon">🚪</span> تسجيل الخروج</div>
</aside>

<!-- ── MAIN ── -->
<div class="main">

  <div class="topbar">
    <div class="topbar-left">
      <div class="topbar-title">🧾 إدارة الطلبات</div>
      <div class="breadcrumb"><span>Admin</span> › <span>/</span> الطلبات</div>
    </div>
    <div class="topbar-actions">
      <button class="btn" onclick="showToast('📥 جارٍ تصدير Excel...')">📥 تصدير</button>
      <button class="btn primary" onclick="showToast('🔄 تم تحديث البيانات')">🔄 تحديث</button>
    </div>
  </div>

  <div style="padding:24px;overflow-y:auto;flex:1">

    <!-- STATS -->
    <div class="stats-row">
      <div class="stat-card" style="border-top-color:var(--yellow)">
        <div class="stat-val" style="color:var(--yellow)">12</div>
        <div class="stat-lbl">بانتظار المعالجة</div>
        <div class="stat-sub" style="color:var(--yellow)">⚠ يحتاج مراجعة</div>
      </div>
      <div class="stat-card" style="border-top-color:var(--blue)">
        <div class="stat-val" style="color:var(--blue)">34</div>
        <div class="stat-lbl">قيد المعالجة</div>
        <div class="stat-sub" style="color:var(--muted)">↑ 8% عن أمس</div>
      </div>
      <div class="stat-card" style="border-top-color:var(--purple)">
        <div class="stat-val" style="color:var(--purple)">28</div>
        <div class="stat-lbl">تم الشحن</div>
        <div class="stat-sub" style="color:var(--muted)">في الطريق</div>
      </div>
      <div class="stat-card" style="border-top-color:var(--green)">
        <div class="stat-val" style="color:var(--green)">186</div>
        <div class="stat-lbl">تم التوصيل</div>
        <div class="stat-sub" style="color:var(--green)">↑ 12% هذا الشهر</div>
      </div>
      <div class="stat-card" style="border-top-color:var(--red)">
        <div class="stat-val" style="color:var(--red)">5</div>
        <div class="stat-lbl">ملغية</div>
        <div class="stat-sub" style="color:var(--muted)">↓ 3% عن أمس</div>
      </div>
    </div>

    <!-- TABS -->
    <div class="tabs">
      <div class="tab active" onclick="switchTab(this)">الكل (265)</div>
      <div class="tab" onclick="switchTab(this)">🟡 انتظار (12)</div>
      <div class="tab" onclick="switchTab(this)">🔵 مدفوع (34)</div>
      <div class="tab" onclick="switchTab(this)">🟣 معالجة (28)</div>
      <div class="tab" onclick="switchTab(this)">🚚 شُحن (28)</div>
      <div class="tab" onclick="switchTab(this)">✅ مُوصّل (186)</div>
      <div class="tab" onclick="switchTab(this)">🔴 ملغي (5)</div>
    </div>

    <!-- FILTERS -->
    <div class="filters-row">
      <div class="search-wrap">
        <span class="search-ico">🔍</span>
        <input class="search-inp" type="text" placeholder="رقم الطلب، اسم العميل، البريد الإلكتروني...">
      </div>
      <input class="date-inp" type="date" value="2025-03-01">
      <input class="date-inp" type="date" value="2025-03-31">
      <select class="sel">
        <option>كل طرق الدفع</option>
        <option>بطاقة ائتمان</option>
        <option>Apple Pay</option>
        <option>STC Pay</option>
        <option>الدفع عند الاستلام</option>
      </select>
      <select class="sel">
        <option>الأحدث أولاً</option>
        <option>الأقدم أولاً</option>
        <option>الأعلى قيمة</option>
        <option>الأقل قيمة</option>
      </select>
    </div>

    <!-- TABLE -->
    <div class="card">
      <table class="orders-table">
        <thead>
          <tr>
            <th style="width:36px"><input type="checkbox"></th>
            <th>رقم الطلب</th>
            <th>العميل</th>
            <th>المنتجات</th>
            <th>المبلغ</th>
            <th>طريقة الدفع</th>
            <th>الحالة</th>
            <th>التاريخ</th>
            <th>الإجراءات</th>
          </tr>
        </thead>
        <tbody>
          <tr>
            <td><input type="checkbox"></td>
            <td><div class="order-num">#NOO-2025-78432</div></td>
            <td><div class="customer-info"><div class="avatar">م</div><div><div class="c-name">محمد الأحمد</div><div class="c-email">mohammed@email.com</div></div></div></td>
            <td><div>3 منتجات</div><div class="items-count">iPhone, Sony, Nike</div></td>
            <td><div class="order-total">7,293 ر.س</div></td>
            <td><span style="font-size:12px">💳 بطاقة</span></td>
            <td><span class="badge b-delivered">✅ مُوصّل</span></td>
            <td><div style="font-size:12px">02 مارس 2025</div><div style="font-size:11px;color:var(--muted)">10:24 ص</div></td>
            <td><div class="table-actions"><button class="icon-btn" onclick="openDetail('78432')">👁️</button><button class="icon-btn" onclick="showToast('📥 تم تحميل الفاتورة')">🧾</button></div></td>
          </tr>
          <tr>
            <td><input type="checkbox"></td>
            <td><div class="order-num">#NOO-2025-78431</div></td>
            <td><div class="customer-info"><div class="avatar">س</div><div><div class="c-name">سارة العمري</div><div class="c-email">sara@email.com</div></div></div></td>
            <td><div>1 منتج</div><div class="items-count">Apple Watch Ultra</div></td>
            <td><div class="order-total">2,199 ر.س</div></td>
            <td><span style="font-size:12px">📱 Apple Pay</span></td>
            <td><span class="badge b-shipped">🚚 شُحن</span></td>
            <td><div style="font-size:12px">01 مارس 2025</div><div style="font-size:11px;color:var(--muted)">03:15 م</div></td>
            <td><div class="table-actions"><button class="icon-btn" onclick="openDetail('78431')">👁️</button><button class="icon-btn" onclick="showToast('📥 تم تحميل الفاتورة')">🧾</button></div></td>
          </tr>
          <tr>
            <td><input type="checkbox"></td>
            <td><div class="order-num">#NOO-2025-78430</div></td>
            <td><div class="customer-info"><div class="avatar">ف</div><div><div class="c-name">فيصل الغامدي</div><div class="c-email">faisal@email.com</div></div></div></td>
            <td><div>2 منتج</div><div class="items-count">Dyson V15, طقم أثاث</div></td>
            <td><div class="order-total">4,398 ر.س</div></td>
            <td><span style="font-size:12px">🏦 STC Pay</span></td>
            <td><span class="badge b-processing">⚙️ معالجة</span></td>
            <td><div style="font-size:12px">01 مارس 2025</div><div style="font-size:11px;color:var(--muted)">11:48 ص</div></td>
            <td><div class="table-actions"><button class="icon-btn" onclick="openDetail('78430')">👁️</button><button class="icon-btn" onclick="showToast('📥 تم تحميل الفاتورة')">🧾</button></div></td>
          </tr>
          <tr>
            <td><input type="checkbox"></td>
            <td><div class="order-num">#NOO-2025-78429</div></td>
            <td><div class="customer-info"><div class="avatar">ن</div><div><div class="c-name">نورة السالم</div><div class="c-email">noura@email.com</div></div></div></td>
            <td><div>4 منتجات</div><div class="items-count">Dior, Nike, Samsung...</div></td>
            <td><div class="order-total">5,847 ر.س</div></td>
            <td><span style="font-size:12px">💳 بطاقة</span></td>
            <td><span class="badge b-paid">💳 مدفوع</span></td>
            <td><div style="font-size:12px">28 فبراير 2025</div><div style="font-size:11px;color:var(--muted)">08:30 ص</div></td>
            <td><div class="table-actions"><button class="icon-btn" onclick="openDetail('78429')">👁️</button><button class="icon-btn" onclick="showToast('📥 تم تحميل الفاتورة')">🧾</button></div></td>
          </tr>
          <tr>
            <td><input type="checkbox"></td>
            <td><div class="order-num">#NOO-2025-78428</div></td>
            <td><div class="customer-info"><div class="avatar">ع</div><div><div class="c-name">عبدالله المطيري</div><div class="c-email">abdullah@email.com</div></div></div></td>
            <td><div>1 منتج</div><div class="items-count">سماعات Sony</div></td>
            <td><div class="order-total">1,199 ر.س</div></td>
            <td><span style="font-size:12px">💵 الاستلام</span></td>
            <td><span class="badge b-pending">⏳ انتظار</span></td>
            <td><div style="font-size:12px">28 فبراير 2025</div><div style="font-size:11px;color:var(--muted)">06:12 م</div></td>
            <td><div class="table-actions"><button class="icon-btn" onclick="openDetail('78428')">👁️</button><button class="icon-btn" onclick="showToast('📥 تم تحميل الفاتورة')">🧾</button></div></td>
          </tr>
          <tr>
            <td><input type="checkbox"></td>
            <td><div class="order-num">#NOO-2025-78427</div></td>
            <td><div class="customer-info"><div class="avatar">ر</div><div><div class="c-name">ريم الحربي</div><div class="c-email">reem@email.com</div></div></div></td>
            <td><div>2 منتج</div><div class="items-count">حقيبة Samsonite, عطر</div></td>
            <td><div class="order-total">869 ر.س</div></td>
            <td><span style="font-size:12px">📱 Apple Pay</span></td>
            <td><span class="badge b-cancelled">❌ ملغي</span></td>
            <td><div style="font-size:12px">27 فبراير 2025</div><div style="font-size:11px;color:var(--muted)">02:45 م</div></td>
            <td><div class="table-actions"><button class="icon-btn" onclick="openDetail('78427')">👁️</button><button class="icon-btn" onclick="showToast('🔄 تم استرداد المبلغ')">💰</button></div></td>
          </tr>
        </tbody>
      </table>
      <div class="pagination">
        <div class="page-info">عرض 1–6 من 265 طلب</div>
        <div class="page-btns">
          <button class="page-btn">‹</button>
          <button class="page-btn active">1</button>
          <button class="page-btn">2</button>
          <button class="page-btn">3</button>
          <button class="page-btn">...</button>
          <button class="page-btn">45</button>
          <button class="page-btn">›</button>
        </div>
      </div>
    </div>

  </div>
</div>

<!-- ── ORDER DETAIL PANEL ── -->
<div class="panel-overlay" id="overlay" onclick="closeDetail()"></div>
<div class="detail-panel" id="detailPanel">
  <div class="panel-hdr">
    <div class="panel-title">🧾 تفاصيل الطلب <span id="panel-order-num" style="font-family:'IBM Plex Mono',monospace;font-size:13px;color:var(--muted)"></span></div>
    <button class="close-btn" onclick="closeDetail()">✕</button>
  </div>
  <div class="panel-body">

    <div class="detail-section">
      <div class="detail-sec-title">تتبع الطلب</div>
      <div class="stepper">
        <div class="step-item done"><div class="step-circle">✓</div><div class="step-lbl">الطلب</div></div>
        <div class="step-item done"><div class="step-circle">✓</div><div class="step-lbl">مدفوع</div></div>
        <div class="step-item current"><div class="step-circle">⚙</div><div class="step-lbl">معالجة</div></div>
        <div class="step-item"><div class="step-circle">🚚</div><div class="step-lbl">شُحن</div></div>
        <div class="step-item"><div class="step-circle">🏠</div><div class="step-lbl">وُصّل</div></div>
      </div>
      <div class="detail-sec-title" style="margin-top:16px">تغيير الحالة</div>
      <div class="status-change">
        <button class="status-btn" onclick="changeStatus('معالجة')">⚙️ معالجة</button>
        <button class="status-btn" onclick="changeStatus('شُحن')">🚚 شحن</button>
        <button class="status-btn" onclick="changeStatus('تم التوصيل')">✅ وُصّل</button>
        <button class="status-btn" style="color:var(--red)" onclick="changeStatus('ملغي')">❌ إلغاء</button>
      </div>
    </div>

    <div class="detail-section">
      <div class="detail-sec-title">معلومات العميل</div>
      <div class="info-grid">
        <div><div class="info-lbl">الاسم</div><div class="info-val">محمد الأحمد</div></div>
        <div><div class="info-lbl">الجوال</div><div class="info-val">0512345678</div></div>
        <div><div class="info-lbl">البريد</div><div class="info-val" style="font-size:12px">mohammed@email.com</div></div>
        <div><div class="info-lbl">المدينة</div><div class="info-val">الرياض</div></div>
        <div style="grid-column:1/-1"><div class="info-lbl">عنوان التوصيل</div><div class="info-val">شارع الملك فهد، حي النزهة، مبنى 24</div></div>
      </div>
    </div>

    <div class="detail-section">
      <div class="detail-sec-title">المنتجات (3)</div>
      <div class="order-item-row"><div class="oi-img">📱</div><div><div class="oi-name">iPhone 15 Pro Max</div><div class="oi-variant">256GB — أسود × 1</div></div><div class="oi-price">3,999 ر.س</div></div>
      <div class="order-item-row"><div class="oi-img">🎧</div><div><div class="oi-name">Sony WH-1000XM5</div><div class="oi-variant">أسود × 2</div></div><div class="oi-price">2,398 ر.س</div></div>
      <div class="order-item-row"><div class="oi-img">👟</div><div><div class="oi-name">Nike Air Max 270</div><div class="oi-variant">43 — أبيض × 1</div></div><div class="oi-price">649 ر.س</div></div>
    </div>

    <div class="detail-section">
      <div class="detail-sec-title">ملخص المبلغ</div>
      <div class="summary-row"><span style="color:var(--muted)">المجموع الفرعي</span><span>7,046 ر.س</span></div>
      <div class="summary-row"><span style="color:var(--muted)">خصم NOON20</span><span style="color:var(--green)">- 705 ر.س</span></div>
      <div class="summary-row"><span style="color:var(--muted)">الشحن</span><span style="color:var(--green)">مجاني</span></div>
      <div class="summary-row"><span style="color:var(--muted)">ضريبة (15%)</span><span>952 ر.س</span></div>
      <div class="summary-total"><span>الإجمالي</span><span>7,293 ر.س</span></div>
    </div>

    <div style="display:flex;gap:8px;flex-wrap:wrap">
      <button class="btn" style="flex:1" onclick="showToast('📧 تم إرسال الفاتورة للعميل')">📧 إرسال فاتورة</button>
      <button class="btn" style="flex:1" onclick="showToast('📦 تم إنشاء شحنة جديدة')">📦 إنشاء شحنة</button>
      <button class="btn" style="flex:1;color:var(--red)" onclick="showToast('💰 تم بدء إجراءات الاسترداد')">💰 استرداد</button>
    </div>

  </div>
</div>

<div class="toast-wrap" id="toasts"></div>
    <script src="Scripts/orders.js"></script>
</body>
</html>