/* ============================================================
   NOON — cart.js
   Scripts specific to pages/cart.html
   ============================================================ */

/* ── Change quantity of a cart item ── */
function changeCartQty(btn, d) {
  const numEl = btn.parentElement.querySelector('.cart-qty-num');
  let qty = parseInt(numEl.textContent) + d;
  if (qty < 1) qty = 1;
  numEl.textContent = qty;
}
function navigateTo(page) {
    // Changes the browser URL to the checkout page
    window.location.href = page + ".aspx";
}
/* ── Remove a cart item with slide-out animation ── */
function removeCartItem(el) {
  const item = el.closest('.cart-item');
  item.style.opacity    = '0';
  item.style.transform  = 'translateX(40px)';
  item.style.transition = 'all 0.3s';

  setTimeout(() => {
    item.remove();
    NoonState.cartCount = Math.max(0, NoonState.cartCount - 1);
    updateCartBadge(NoonState.cartCount);
    showToast('🗑️ Product removed from the cart');
  }, 300);
}