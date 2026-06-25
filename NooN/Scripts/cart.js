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
    // تقوم بتغيير رابط المتصفح إلى صفحة الـ checkout
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
    showToast('🗑️ تم حذف المنتج من السلة');
  }, 300);
}
if (window.NoonState.cartCount === 0) {
    showToast("⚠️ سلتك فارغة! أضف منتجات أولاً للمتابعة.");
    return;
}