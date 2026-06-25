/* ============================================================
   NOON — master.js
   Navigation controller for index.html
   Manages iframe routing + toast + cart badge
   ============================================================ */

const PAGES = {
  home:         'pages/home.html',
  products:     'pages/products.html',
  detail:       'pages/detail.html',
  cart:         'pages/cart.html',
  checkout:     'pages/checkout.html',
  confirmation: 'pages/confirmation.html'
};

let currentPage = 'home';
let cartCount   = 3;

/* ── Navigate to a page ── */
function goTo(page, query) {
  if (page === currentPage && !query) return;

  const overlay = document.getElementById('pageOverlay');
  overlay.classList.add('fading');

  setTimeout(() => {
    currentPage = page;
    let src = PAGES[page] || PAGES.home;
    if (query) src += '?' + query;
    document.getElementById('pageFrame').src = src;
    updateNavActive(page);
    overlay.classList.remove('fading');
  }, 180);
}

/* ── Highlight active nav button ── */
function updateNavActive(page) {
  document.querySelectorAll('.nav-btn:not(.cart-btn)').forEach(b => b.classList.remove('active-page'));
  const map = { home: 'nav-home', products: 'nav-products' };
  if (map[page]) document.getElementById(map[page])?.classList.add('active-page');
}

/* ── Category strip click ── */
function filterCat(el, cat) {
  document.querySelectorAll('.nav-cat-item').forEach(a => a.classList.remove('active'));
  el.classList.add('active');
  goTo('products');
}

/* ── Show toast notification ── */
function showToast(msg) {
  const container = document.getElementById('toastContainer');
  const toast = document.createElement('div');
  toast.className = 'toast';
  toast.textContent = msg;
  container.appendChild(toast);
  setTimeout(() => toast.remove(), 3000);
}

/* ── Update cart badge ── */
function setCartBadge(n) {
  cartCount = n;
  document.getElementById('cartBadge').textContent = n;
}

/* ── Listen for postMessage events from child iframes ── */
window.addEventListener('message', (e) => {
  const d = e.data;
  if (!d || !d.type) return;
  if (d.type === 'navigate')   goTo(d.page, d.query);
  if (d.type === 'toast')      showToast(d.msg);
  if (d.type === 'cartUpdate') setCartBadge(d.count);
});

/* ── Sync cartCount into newly loaded iframes ── */
document.getElementById('pageFrame').addEventListener('load', () => {
  try {
    const win = document.getElementById('pageFrame').contentWindow;
    if (win && win.NoonState) win.NoonState.cartCount = cartCount;
  } catch (_) {}
});
