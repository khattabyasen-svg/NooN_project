/* ============================================================
   NOON — detail.js
   Scripts specific to pages/detail.html
   ============================================================ */

let qtyVal = 1;

/* ── Load product data from URL params ── */
function loadProductFromURL() {
  const p = new URLSearchParams(window.location.search);
  const icon = p.get('icon') || '📱';

  if (p.get('name'))     document.getElementById('detail-name').textContent     = p.get('name');
  if (p.get('price'))    document.getElementById('detail-price').textContent    = p.get('price') + ' د.أ';
  if (p.get('oldPrice')) document.getElementById('detail-old').textContent      = p.get('oldPrice');
  if (p.get('discount')) document.getElementById('detail-discount').textContent = '-' + p.get('discount');
  if (p.get('reviews'))  document.getElementById('detail-reviews').textContent  = p.get('reviews') + ' تقييم';
  if (p.get('cat'))      document.getElementById('detail-cat-bc').textContent   = p.get('cat');

  /* Set gallery icons */
  document.getElementById('gallery-main').textContent = icon;
  const icons = [icon, '🔋', '📦', '🎁'];
  icons.forEach((ic, i) => {
    const t = document.getElementById('thumb-' + i);
    if (t) {
      t.textContent = ic;
      t.onclick = () => selectThumb(t, ic);
    }
  });
}

/* ── Quantity control ── */
function changeQty(d) {
  qtyVal = Math.max(1, qtyVal + d);
  document.getElementById('qty-display').textContent = qtyVal;
}

/* ── Gallery thumbnail selection ── */
function selectThumb(el, icon) {
  document.querySelectorAll('.gallery-thumb').forEach(t => t.classList.remove('active'));
  el.classList.add('active');
  document.getElementById('gallery-main').textContent = icon;
}

/* ── Colour swatch selection ── */
function selectColor(el) {
  document.querySelectorAll('.color-dot').forEach(d => d.classList.remove('active'));
  el.classList.add('active');
}

/* ── Size button selection ── */
function selectSize(el) {
  document.querySelectorAll('.size-btn').forEach(b => b.classList.remove('active'));
  el.classList.add('active');
}

/* ── Wishlist button toggle ── */
function wishlistToggle(btn) {
  if (btn.textContent === '🤍') {
    btn.textContent = '❤️';
    showToast('تمت الإضافة إلى المفضلة ❤️');
  } else {
    btn.textContent = '🤍';
  }
}

/* ── Auto-init ── */
document.addEventListener('DOMContentLoaded', loadProductFromURL);
