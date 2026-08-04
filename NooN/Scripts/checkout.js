/* ==============================================
   checkout.js — NooN Store
   Scripts for checkout.aspx

   Server-generated control IDs are injected via
   the checkoutIds object defined inline in checkout.aspx
   (above this script tag).
   ============================================== */

function imgFallback(img) {
    img.onerror = null;
    img.src = "data:image/svg+xml,%3Csvg xmlns='http://www.w3.org/2000/svg' width='44' height='44'%3E%3Crect width='44' height='44' fill='%23eeeeee'/%3E%3Cpath d='M11 31l7-7 4 4 5-5 6 6v2H11z' fill='%23c9c9c9'/%3E%3Ccircle cx='17' cy='17' r='3' fill='%23c9c9c9'/%3E%3C/svg%3E";
}

function toggleCardValidators(isCard) {
    if (typeof ValidatorEnable !== 'function') return;
    [
        checkoutIds.rfvCard,    checkoutIds.revCard,
        checkoutIds.rfvExpiry,  checkoutIds.revExpiry,
        checkoutIds.rfvCVV,     checkoutIds.revCVV,
        checkoutIds.rfvCardHolder
    ].forEach(function (id) {
        var v = document.getElementById(id);
        if (v) ValidatorEnable(v, isCard);
    });
}

function applyPaymentMethod(type) {
    var isCard = (type === 'card');
    document.getElementById('cardSection').style.display = isCard ? 'block' : 'none';
    toggleCardValidators(isCard);
}

function selectPayment(el, type) {
    document.querySelectorAll('.payment-option').forEach(function (o) { o.classList.remove('selected'); });
    el.classList.add('selected');
    document.getElementById(checkoutIds.hfPaymentMethod).value = type;
    applyPaymentMethod(type);
}

window.addEventListener('load', function () {
    var method = document.getElementById(checkoutIds.hfPaymentMethod).value;
    applyPaymentMethod(method);

    var cardInput = document.getElementById(checkoutIds.txtCardNumber);
    if (cardInput) {
        cardInput.addEventListener('input', function () {
            var v = this.value.replace(/\D/g, '').substring(0, 16);
            var parts = v.match(/.{1,4}/g);
            this.value = parts ? parts.join(' ') : v;
        });
    }

    var expiryInput = document.getElementById(checkoutIds.txtExpiry);
    if (expiryInput) {
        expiryInput.addEventListener('input', function () {
            var v = this.value.replace(/\D/g, '');
            if (v.length >= 2) v = v.substring(0, 2) + '/' + v.substring(2, 4);
            this.value = v;
        });
    }
});
