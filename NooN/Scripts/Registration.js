/* =============================================
   NooN — Registration Scripts
   File: Registration.js
   ============================================= */

document.addEventListener('DOMContentLoaded', function () {

    var passInput    = document.getElementById('TxtPass');
    var confirmInput = document.getElementById('TxtConfirm');
    var registerBtn  = document.getElementById('Button1');

    // --- Autocomplete ---
    var nameInput  = document.getElementById('TxtName');
    var emailInput = document.getElementById('TxtEmail');
    var phoneInput = document.getElementById('TxtPhone');

    if (nameInput)    nameInput.setAttribute('autocomplete', 'username');
    if (emailInput)   emailInput.setAttribute('autocomplete', 'email');
    if (phoneInput)   phoneInput.setAttribute('autocomplete', 'tel');
    if (passInput)    passInput.setAttribute('autocomplete', 'new-password');
    if (confirmInput) confirmInput.setAttribute('autocomplete', 'new-password');

    // --- Assign button class ---
    if (registerBtn) registerBtn.classList.add('btn-register');

    // --- Live password match indicator ---
    function checkMatch() {
        if (!confirmInput || !confirmInput.value) {
            confirmInput.classList.remove('match', 'no-match');
            return true;
        }
        var matches = passInput.value === confirmInput.value;
        confirmInput.classList.toggle('match',    matches);
        confirmInput.classList.toggle('no-match', !matches);
        return matches;
    }

    if (passInput)    passInput.addEventListener('input', checkMatch);
    if (confirmInput) confirmInput.addEventListener('input', checkMatch);

    // --- Client-side validation ---
    if (registerBtn) {
        registerBtn.addEventListener('click', function (e) {
            var fields = [nameInput, emailInput, phoneInput, passInput, confirmInput];
            var firstEmpty = null;

            fields.forEach(function (f) {
                if (f && !f.value.trim() && !firstEmpty) firstEmpty = f;
            });

            if (firstEmpty) {
                e.preventDefault();
                shake(firstEmpty);
                return false;
            }

            if (!checkMatch()) {
                e.preventDefault();
                shake(confirmInput);
                return false;
            }
        });
    }


    // --- Shake animation ---
    function shake(el) {
        if (!el) return;
        el.style.transition = 'transform 0.4s cubic-bezier(.36,.07,.19,.97), border-color 0.2s';
        el.style.borderColor = 'var(--error)';
        el.style.transform = 'translateX(-6px)';
        setTimeout(function () { el.style.transform = 'translateX(6px)';  }, 80);
        setTimeout(function () { el.style.transform = 'translateX(-4px)'; }, 160);
        setTimeout(function () { el.style.transform = 'translateX(4px)';  }, 240);
        setTimeout(function () { el.style.transform = 'translateX(0)';    }, 320);
        el.focus();
    }

});
