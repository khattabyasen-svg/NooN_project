/* =============================================
   NooN — Login Page Scripts
   File: LoginUser.js
   ============================================= */

document.addEventListener('DOMContentLoaded', function () {

    // --- Autocomplete attributes ---
    var emailInput = document.getElementById('txtEmail');
    var passInput  = document.getElementById('txtPas');

    if (emailInput) emailInput.setAttribute('autocomplete', 'email');
    if (passInput)  passInput.setAttribute('autocomplete', 'current-password');

    // --- Assign button style class (ASP.NET renders <input type="submit">) ---
    var loginBtn = document.getElementById('login_button');
    if (loginBtn) loginBtn.classList.add('btn-login');

    // --- Basic client-side validation before postback ---
    if (loginBtn) {
        loginBtn.addEventListener('click', function (e) {
            var email = emailInput ? emailInput.value.trim() : '';
            var pass  = passInput  ? passInput.value.trim()  : '';

            if (!email || !pass) {
                e.preventDefault();
                shake(email ? passInput : emailInput);
                return false;
            }
        });
    }

    // --- Shake animation on empty field ---
    function shake(el) {
        if (!el) return;
        el.style.transition = 'transform 0.4s cubic-bezier(.36,.07,.19,.97)';
        el.style.transform = 'translateX(-6px)';
        setTimeout(function () { el.style.transform = 'translateX(6px)';  }, 80);
        setTimeout(function () { el.style.transform = 'translateX(-4px)'; }, 160);
        setTimeout(function () { el.style.transform = 'translateX(4px)';  }, 240);
        setTimeout(function () { el.style.transform = 'translateX(0)';    }, 320);
        el.focus();
    }

});
