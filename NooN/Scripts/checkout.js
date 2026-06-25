/* ============================================================
   NOON — checkout.js
   Scripts specific to pages/checkout.html
   ============================================================ */

/* ── Switch payment method ── */
function selectPayment(el) {
  document.querySelectorAll('.payment-option').forEach(o => o.classList.remove('selected'));
  el.classList.add('selected');

  const isCard = el.querySelector('.payment-name').textContent.includes('بطاقة');
  const cf = document.querySelector('.card-fields');
  if (cf) cf.style.display = isCard ? 'block' : 'none';
}

/* ── Place order → navigate to confirmation ── */
function placeOrder() {
  showToast('⏳ جارٍ معالجة طلبك...');

  setTimeout(() => {
    NoonState.cartCount = 0;
    updateCartBadge(0);
    navigateTo('confirmation');
    setTimeout(() => showToast('🎉 تم تأكيد طلبك بنجاح!'), 400);
  }, 1500);
}


function selectPayment(el, type) {
    // إزالة selected من الكل
    document.querySelectorAll('.payment-option')
        .forEach(o => o.classList.remove('selected'));
    // إضافة selected للمختار
    el.classList.add('selected');

    // حفظ طريقة الدفع في HiddenField
    document.getElementById(
        '<%= hfPaymentMethod.ClientID %>').value = type;

    // إظهار/إخفاء قسم البطاقة
    var cardSection = document.getElementById('cardSection');
    cardSection.style.display =
        (type === 'card') ? 'block' : 'none';
}

// إخفاء قسم البطاقة عند تحميل الصفحة إذا لم يكن card
window.onload = function () {
    var method = document.getElementById(
        '<%= hfPaymentMethod.ClientID %>').value;
    if (method !== 'card')
        document.getElementById('cardSection')
            .style.display = 'none';
};