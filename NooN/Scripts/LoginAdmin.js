/* =============================================
   NooN — Admin Login Scripts
   File: LoginAdmin.js
   ============================================= */

document.addEventListener('DOMContentLoaded', function () {

    // --- Autocomplete attributes ---
    var nameInput = document.getElementById('TxtName');
    var passInput = document.getElementById('TxtPas');

    if (nameInput) nameInput.setAttribute('autocomplete', 'username');
    if (passInput) passInput.setAttribute('autocomplete', 'current-password');

    // --- Assign button style class ---
    var adminBtn = document.getElementById('AdminButton');
    if (adminBtn) adminBtn.classList.add('btn-admin');

    // --- Client-side validation before postback ---
    if (adminBtn) {
        adminBtn.addEventListener('click', function (e) {
            var name = nameInput ? nameInput.value.trim() : '';
            var pass = passInput ? passInput.value.trim() : '';

            if (!name || !pass) {
                e.preventDefault();
                shake(!name ? nameInput : passInput);
                return false;
            }
        });
    }

    // --- Shake animation on empty field ---
    function shake(el) {
        if (!el) return;
        el.style.transition = 'transform 0.4s cubic-bezier(.36,.07,.19,.97), border-color 0.2s';
        el.style.borderColor = 'var(--accent)';
        el.style.transform = 'translateX(-6px)';
        setTimeout(function () { el.style.transform = 'translateX(6px)';  }, 80);
        setTimeout(function () { el.style.transform = 'translateX(-4px)'; }, 160);
        setTimeout(function () { el.style.transform = 'translateX(4px)';  }, 240);
        setTimeout(function () { el.style.transform = 'translateX(0)';    }, 320);
        el.focus();
    }

});
