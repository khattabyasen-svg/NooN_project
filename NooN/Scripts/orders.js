// ============================================================
// Admin Orders — JavaScript
// ============================================================

// ── TABS ────────────────────────────────────────────────────
function switchTab(el) {
  document.querySelectorAll('.tab').forEach(t => t.classList.remove('active'));
  el.classList.add('active');
}

// ── DETAIL PANEL ────────────────────────────────────────────
function openDetail(num) {
  document.getElementById('detailPanel').classList.add('open');
  document.getElementById('overlay').classList.add('open');
  document.getElementById('panel-order-num').textContent = '#NOO-2025-' + num;
}

function closeDetail() {
  document.getElementById('detailPanel').classList.remove('open');
  document.getElementById('overlay').classList.remove('open');
}

// ── STATUS CHANGE ────────────────────────────────────────────
function changeStatus(status) {
  showToast('✅ تم تغيير حالة الطلب إلى: ' + status);
}

// ── PAGINATION ──────────────────────────────────────────────
document.querySelectorAll('.page-btn').forEach(btn => {
  btn.addEventListener('click', function () {
    document.querySelectorAll('.page-btn').forEach(b => b.classList.remove('active'));
    this.classList.add('active');
  });
});

// ── SELECT ALL ──────────────────────────────────────────────
const masterCheck = document.querySelector('thead input[type="checkbox"]');
if (masterCheck) {
  masterCheck.addEventListener('change', function () {
    document.querySelectorAll('tbody input[type="checkbox"]')
      .forEach(cb => cb.checked = this.checked);
  });
}

// ── TOAST ───────────────────────────────────────────────────
function showToast(msg) {
  const wrap = document.getElementById('toasts');
  const t    = document.createElement('div');
  t.className   = 'toast';
  t.textContent = msg;
  wrap.appendChild(t);
  setTimeout(() => t.remove(), 3000);
}
