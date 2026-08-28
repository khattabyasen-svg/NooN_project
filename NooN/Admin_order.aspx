<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="Admin_order.aspx.cs" Inherits="NooN.Admin_order" %>


<!DOCTYPE html>
<html lang="en" dir="ltr">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<title>Order Management — Admin</title>
<%--<link href="https://fonts.googleapis.com/css2?family=IBM+Plex+Mono:wght@400;600&family=Tajawal:wght@400;600;700;900&display=swap" rel="stylesheet">--%>
    <link href="Content/orders.css" rel="stylesheet" />
</head>
<body>

<!-- ── SIDEBAR ── -->
<aside class="sidebar">
  <div class="sb-logo">⚙️ Noon <em>Admin</em></div>
  <div class="sb-sec">Menu</div>
  <div class="sb-item"><span class="sb-icon">📊</span> Dashboard</div>
  <div class="sb-item"><span class="sb-icon">📦</span> Products</div>
  <div class="sb-item active"><span class="sb-icon">🧾</span> Orders <span class="sb-badge">12</span></div>
  <div class="sb-item"><span class="sb-icon">👥</span> Users</div>
  <div class="sb-item"><span class="sb-icon">🏭</span> Inventory</div>
  <div class="sb-item"><span class="sb-icon">🎟️</span> Coupons</div>
  <div class="sb-item"><span class="sb-icon">🗂️</span> Categories</div>
  <div class="sb-sec" style="margin-top:auto">System</div>
  <div class="sb-item"><span class="sb-icon">⚙️</span> Settings</div>
  <div class="sb-item"><span class="sb-icon">🚪</span> Sign Out</div>
</aside>

<!-- ── MAIN ── -->
<div class="main">

  <div class="topbar">
    <div class="topbar-left">
      <div class="topbar-title">🧾 Order Management</div>
      <div class="breadcrumb"><span>Admin</span> › <span>/</span> Orders</div>
    </div>
    <div class="topbar-actions">
      <button class="btn" onclick="showToast('📥 Exporting to Excel...')">📥 Export</button>
      <button class="btn primary" onclick="showToast('🔄 Data refreshed')">🔄 Refresh</button>
    </div>
  </div>

  <div style="padding:24px;overflow-y:auto;flex:1">

    <!-- STATS -->
    <div class="stats-row">
      <div class="stat-card" style="border-top-color:var(--yellow)">
        <div class="stat-val" style="color:var(--yellow)">12</div>
        <div class="stat-lbl">Awaiting Processing</div>
        <div class="stat-sub" style="color:var(--yellow)">⚠ Needs review</div>
      </div>
      <div class="stat-card" style="border-top-color:var(--blue)">
        <div class="stat-val" style="color:var(--blue)">34</div>
        <div class="stat-lbl">Processing</div>
        <div class="stat-sub" style="color:var(--muted)">↑ 8% vs yesterday</div>
      </div>
      <div class="stat-card" style="border-top-color:var(--purple)">
        <div class="stat-val" style="color:var(--purple)">28</div>
        <div class="stat-lbl">Shipped</div>
        <div class="stat-sub" style="color:var(--muted)">On the way</div>
      </div>
      <div class="stat-card" style="border-top-color:var(--green)">
        <div class="stat-val" style="color:var(--green)">186</div>
        <div class="stat-lbl">Delivered</div>
        <div class="stat-sub" style="color:var(--green)">↑ 12% this month</div>
      </div>
      <div class="stat-card" style="border-top-color:var(--red)">
        <div class="stat-val" style="color:var(--red)">5</div>
        <div class="stat-lbl">Cancelled</div>
        <div class="stat-sub" style="color:var(--muted)">↓ 3% vs yesterday</div>
      </div>
    </div>

    <!-- TABS -->
    <div class="tabs">
      <div class="tab active" onclick="switchTab(this)">All (265)</div>
      <div class="tab" onclick="switchTab(this)">🟡 Pending (12)</div>
      <div class="tab" onclick="switchTab(this)">🔵 Paid (34)</div>
      <div class="tab" onclick="switchTab(this)">🟣 Processing (28)</div>
      <div class="tab" onclick="switchTab(this)">🚚 Shipped (28)</div>
      <div class="tab" onclick="switchTab(this)">✅ Delivered (186)</div>
      <div class="tab" onclick="switchTab(this)">🔴 Cancelled (5)</div>
    </div>

    <!-- FILTERS -->
    <div class="filters-row">
      <div class="search-wrap">
        <span class="search-ico">🔍</span>
        <input class="search-inp" type="text" placeholder="Order number, customer name, email...">
      </div>
      <input class="date-inp" type="date" value="2025-03-01">
      <input class="date-inp" type="date" value="2025-03-31">
      <select class="sel">
        <option>All payment methods</option>
        <option>Credit card</option>
        <option>Apple Pay</option>
        <option>STC Pay</option>
        <option>Cash on delivery</option>
      </select>
      <select class="sel">
        <option>Newest first</option>
        <option>Oldest first</option>
        <option>Highest value</option>
        <option>Lowest value</option>
      </select>
    </div>

    <!-- TABLE -->
    <div class="card">
      <table class="orders-table">
        <thead>
          <tr>
            <th style="width:36px"><input type="checkbox"></th>
            <th>Order No.</th>
            <th>Customer</th>
            <th>Products</th>
            <th>Amount</th>
            <th>Payment Method</th>
            <th>Status</th>
            <th>Date</th>
            <th>Actions</th>
          </tr>
        </thead>
        <tbody>
          <tr>
            <td><input type="checkbox"></td>
            <td><div class="order-num">#NOO-2025-78432</div></td>
            <td><div class="customer-info"><div class="avatar">M</div><div><div class="c-name">Mohammed Al-Ahmad</div><div class="c-email">mohammed@email.com</div></div></div></td>
            <td><div>3 products</div><div class="items-count">iPhone, Sony, Nike</div></td>
            <td><div class="order-total">7,293 JD</div></td>
            <td><span style="font-size:12px">💳 Card</span></td>
            <td><span class="badge b-delivered">✅ Delivered</span></td>
            <td><div style="font-size:12px">02 March 2025</div><div style="font-size:11px;color:var(--muted)">10:24 AM</div></td>
            <td><div class="table-actions"><button class="icon-btn" onclick="openDetail('78432')">👁️</button><button class="icon-btn" onclick="showToast('📥 Invoice downloaded')">🧾</button></div></td>
          </tr>
          <tr>
            <td><input type="checkbox"></td>
            <td><div class="order-num">#NOO-2025-78431</div></td>
            <td><div class="customer-info"><div class="avatar">S</div><div><div class="c-name">Sara Al-Omari</div><div class="c-email">sara@email.com</div></div></div></td>
            <td><div>1 product</div><div class="items-count">Apple Watch Ultra</div></td>
            <td><div class="order-total">2,199 JD</div></td>
            <td><span style="font-size:12px">📱 Apple Pay</span></td>
            <td><span class="badge b-shipped">🚚 Shipped</span></td>
            <td><div style="font-size:12px">01 March 2025</div><div style="font-size:11px;color:var(--muted)">03:15 PM</div></td>
            <td><div class="table-actions"><button class="icon-btn" onclick="openDetail('78431')">👁️</button><button class="icon-btn" onclick="showToast('📥 Invoice downloaded')">🧾</button></div></td>
          </tr>
          <tr>
            <td><input type="checkbox"></td>
            <td><div class="order-num">#NOO-2025-78430</div></td>
            <td><div class="customer-info"><div class="avatar">F</div><div><div class="c-name">Faisal Al-Ghamdi</div><div class="c-email">faisal@email.com</div></div></div></td>
            <td><div>2 products</div><div class="items-count">Dyson V15, Furniture set</div></td>
            <td><div class="order-total">4,398 JD</div></td>
            <td><span style="font-size:12px">🏦 STC Pay</span></td>
            <td><span class="badge b-processing">⚙️ Processing</span></td>
            <td><div style="font-size:12px">01 March 2025</div><div style="font-size:11px;color:var(--muted)">11:48 AM</div></td>
            <td><div class="table-actions"><button class="icon-btn" onclick="openDetail('78430')">👁️</button><button class="icon-btn" onclick="showToast('📥 Invoice downloaded')">🧾</button></div></td>
          </tr>
          <tr>
            <td><input type="checkbox"></td>
            <td><div class="order-num">#NOO-2025-78429</div></td>
            <td><div class="customer-info"><div class="avatar">N</div><div><div class="c-name">Noura Al-Salem</div><div class="c-email">noura@email.com</div></div></div></td>
            <td><div>4 products</div><div class="items-count">Dior, Nike, Samsung...</div></td>
            <td><div class="order-total">5,847 JD</div></td>
            <td><span style="font-size:12px">💳 Card</span></td>
            <td><span class="badge b-paid">💳 Paid</span></td>
            <td><div style="font-size:12px">28 February 2025</div><div style="font-size:11px;color:var(--muted)">08:30 AM</div></td>
            <td><div class="table-actions"><button class="icon-btn" onclick="openDetail('78429')">👁️</button><button class="icon-btn" onclick="showToast('📥 Invoice downloaded')">🧾</button></div></td>
          </tr>
          <tr>
            <td><input type="checkbox"></td>
            <td><div class="order-num">#NOO-2025-78428</div></td>
            <td><div class="customer-info"><div class="avatar">A</div><div><div class="c-name">Abdullah Al-Mutairi</div><div class="c-email">abdullah@email.com</div></div></div></td>
            <td><div>1 product</div><div class="items-count">Sony headphones</div></td>
            <td><div class="order-total">1,199 JD</div></td>
            <td><span style="font-size:12px">💵 Cash on delivery</span></td>
            <td><span class="badge b-pending">⏳ Pending</span></td>
            <td><div style="font-size:12px">28 February 2025</div><div style="font-size:11px;color:var(--muted)">06:12 PM</div></td>
            <td><div class="table-actions"><button class="icon-btn" onclick="openDetail('78428')">👁️</button><button class="icon-btn" onclick="showToast('📥 Invoice downloaded')">🧾</button></div></td>
          </tr>
          <tr>
            <td><input type="checkbox"></td>
            <td><div class="order-num">#NOO-2025-78427</div></td>
            <td><div class="customer-info"><div class="avatar">R</div><div><div class="c-name">Reem Al-Harbi</div><div class="c-email">reem@email.com</div></div></div></td>
            <td><div>2 products</div><div class="items-count">Samsonite bag, Perfume</div></td>
            <td><div class="order-total">869 JD</div></td>
            <td><span style="font-size:12px">📱 Apple Pay</span></td>
            <td><span class="badge b-cancelled">❌ Cancelled</span></td>
            <td><div style="font-size:12px">27 February 2025</div><div style="font-size:11px;color:var(--muted)">02:45 PM</div></td>
            <td><div class="table-actions"><button class="icon-btn" onclick="openDetail('78427')">👁️</button><button class="icon-btn" onclick="showToast('🔄 Amount refunded')">💰</button></div></td>
          </tr>
        </tbody>
      </table>
      <div class="pagination">
        <div class="page-info">Showing 1–6 of 265 orders</div>
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
    <div class="panel-title">🧾 Order Details <span id="panel-order-num" style="font-family:'IBM Plex Mono',monospace;font-size:13px;color:var(--muted)"></span></div>
    <button class="close-btn" onclick="closeDetail()">✕</button>
  </div>
  <div class="panel-body">

    <div class="detail-section">
      <div class="detail-sec-title">Order Tracking</div>
      <div class="stepper">
        <div class="step-item done"><div class="step-circle">✓</div><div class="step-lbl">Ordered</div></div>
        <div class="step-item done"><div class="step-circle">✓</div><div class="step-lbl">Paid</div></div>
        <div class="step-item current"><div class="step-circle">⚙</div><div class="step-lbl">Processing</div></div>
        <div class="step-item"><div class="step-circle">🚚</div><div class="step-lbl">Shipped</div></div>
        <div class="step-item"><div class="step-circle">🏠</div><div class="step-lbl">Delivered</div></div>
      </div>
      <div class="detail-sec-title" style="margin-top:16px">Change Status</div>
      <div class="status-change">
        <button class="status-btn" onclick="changeStatus('Processing')">⚙️ Processing</button>
        <button class="status-btn" onclick="changeStatus('Shipped')">🚚 Ship</button>
        <button class="status-btn" onclick="changeStatus('Delivered')">✅ Delivered</button>
        <button class="status-btn" style="color:var(--red)" onclick="changeStatus('Cancelled')">❌ Cancel</button>
      </div>
    </div>

    <div class="detail-section">
      <div class="detail-sec-title">Customer Information</div>
      <div class="info-grid">
        <div><div class="info-lbl">Name</div><div class="info-val">Mohammed Al-Ahmad</div></div>
        <div><div class="info-lbl">Mobile</div><div class="info-val">0791234567</div></div>
        <div><div class="info-lbl">Email</div><div class="info-val" style="font-size:12px">mohammed@email.com</div></div>
        <div><div class="info-lbl">Governorate</div><div class="info-val">Amman</div></div>
        <div style="grid-column:1/-1"><div class="info-lbl">Delivery Address</div><div class="info-val">Al-Madinah Al-Munawwarah St., Al-Sweifieh District, Building 24</div></div>
      </div>
    </div>

    <div class="detail-section">
      <div class="detail-sec-title">Products (3)</div>
      <div class="order-item-row"><div class="oi-img">📱</div><div><div class="oi-name">iPhone 15 Pro Max</div><div class="oi-variant">256GB — Black × 1</div></div><div class="oi-price">3,999 JD</div></div>
      <div class="order-item-row"><div class="oi-img">🎧</div><div><div class="oi-name">Sony WH-1000XM5</div><div class="oi-variant">Black × 2</div></div><div class="oi-price">2,398 JD</div></div>
      <div class="order-item-row"><div class="oi-img">👟</div><div><div class="oi-name">Nike Air Max 270</div><div class="oi-variant">43 — White × 1</div></div><div class="oi-price">649 JD</div></div>
    </div>

    <div class="detail-section">
      <div class="detail-sec-title">Amount Summary</div>
      <div class="summary-row"><span style="color:var(--muted)">Subtotal</span><span>7,046 JD</span></div>
      <div class="summary-row"><span style="color:var(--muted)">NOON20 discount</span><span style="color:var(--green)">- 705 JD</span></div>
      <div class="summary-row"><span style="color:var(--muted)">Shipping</span><span style="color:var(--green)">Free</span></div>
      <div class="summary-row"><span style="color:var(--muted)">Tax (16%)</span><span>952 JD</span></div>
      <div class="summary-total"><span>Total</span><span>7,293 JD</span></div>
    </div>

    <div style="display:flex;gap:8px;flex-wrap:wrap">
      <button class="btn" style="flex:1" onclick="showToast('📧 Invoice sent to the customer')">📧 Send Invoice</button>
      <button class="btn" style="flex:1" onclick="showToast('📦 New shipment created')">📦 Create Shipment</button>
      <button class="btn" style="flex:1;color:var(--red)" onclick="showToast('💰 Refund process started')">💰 Refund</button>
    </div>

  </div>
</div>

<div class="toast-wrap" id="toasts"></div>
    <script src="Scripts/orders.js"></script>
</body>
</html>
