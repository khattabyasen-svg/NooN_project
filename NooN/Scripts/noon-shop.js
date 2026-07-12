// Shared AJAX helpers for the cart / favorites buttons.
// Talks to ShopService.ashx via fetch() and updates the navbar cart badge
// and a small toast without any page reload or postback.
(function () {
    'use strict';

    var HANDLER_URL = 'ShopService.ashx';

    function post(data) {
        return fetch(HANDLER_URL, {
            method: 'POST',
            credentials: 'same-origin',
            headers: { 'Content-Type': 'application/x-www-form-urlencoded; charset=UTF-8' },
            body: new URLSearchParams(data).toString()
        }).then(function (res) {
            if (!res.ok) throw new Error('HTTP ' + res.status);
            return res.json();
        });
    }

    function toast(msg, isError) {
        var t = document.getElementById('noonToast');
        if (!t) {
            t = document.createElement('div');
            t.id = 'noonToast';
            document.body.appendChild(t);
        }
        t.textContent = msg;
        t.className = isError ? 'error show' : 'success show';
        clearTimeout(t._timer);
        t._timer = setTimeout(function () { t.classList.remove('show'); }, 3000);
    }

    function updateCartBadge(count) {
        if (typeof count !== 'number') return;
        // The badge lives in the master page navbar, so update by class.
        document.querySelectorAll('.cart-badge').forEach(function (b) {
            b.textContent = count;
            b.style.display = count > 0 ? '' : 'none';
        });
    }

    function handleFailure(res) {
        toast(res.message || 'حدث خطأ. حاول مرة أخرى.', true);
        if (res.requireLogin) {
            // Give the user a moment to read the toast, then go to login.
            setTimeout(function () { window.location.href = 'LoginUser.aspx'; }, 1500);
        }
    }

    // btn must carry data-pid. opts: { quantity, color, size, onSuccess }.
    function addToCart(btn, opts) {
        opts = opts || {};
        var pid = btn.getAttribute('data-pid');
        if (!pid || btn.disabled) return;

        btn.disabled = true;
        post({
            action: 'addtocart',
            productId: pid,
            quantity: opts.quantity || 1,
            color: opts.color || '',
            size: opts.size || ''
        }).then(function (res) {
            if (res.success) {
                toast(res.message);
                updateCartBadge(res.cartCount);
                if (opts.onSuccess) opts.onSuccess(res);
            } else {
                handleFailure(res);
            }
        }).catch(function () {
            toast('تعذر الاتصال بالخادم. حاول مرة أخرى.', true);
        }).finally(function () {
            btn.disabled = false;
        });
    }

    // btn must carry data-pid. Set data-remove-card="1" to remove the
    // surrounding .product-card on un-favorite (home wishlist grid).
    function toggleFav(btn) {
        var pid = btn.getAttribute('data-pid');
        if (!pid || btn.disabled) return;

        btn.disabled = true;
        post({ action: 'togglefav', productId: pid }).then(function (res) {
            if (!res.success) {
                handleFailure(res);
                return;
            }

            toast(res.message);
            btn.textContent = res.isFav ? '❤️' : '🤍';
            btn.classList.toggle('wish-active', !!res.isFav);

            if (!res.isFav && btn.getAttribute('data-remove-card') === '1') {
                var card = btn.closest('.product-card');
                if (card) card.remove();
            }
        }).catch(function () {
            toast('تعذر الاتصال بالخادم. حاول مرة أخرى.', true);
        }).finally(function () {
            btn.disabled = false;
        });
    }

    window.noonShop = {
        addToCart: addToCart,
        toggleFav: toggleFav,
        toast: toast,
        updateCartBadge: updateCartBadge
    };
})();
