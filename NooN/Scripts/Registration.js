/* =============================================
   NooN — Registration Scripts
   File: Registration.js
   ============================================= */

document.addEventListener('DOMContentLoaded', function () {

    var firstNameInput = document.getElementById('TxtFName');
    var lastNameInput  = document.getElementById('TxtLname');
    var emailInput     = document.getElementById('TxtEmail');
    var phoneInput     = document.getElementById('TxtPhone');
    var passInput      = document.getElementById('TxtPass');
    var confirmInput   = document.getElementById('TxtConfirm');
    var registerBtn    = document.getElementById('Button1');

    // --- Autocomplete attributes ---
    if (firstNameInput) firstNameInput.setAttribute('autocomplete', 'given-name');
    if (lastNameInput)  lastNameInput.setAttribute('autocomplete', 'family-name');
    if (emailInput)     emailInput.setAttribute('autocomplete', 'email');
    if (phoneInput)     phoneInput.setAttribute('autocomplete', 'tel');
    if (passInput)      passInput.setAttribute('autocomplete', 'new-password');
    if (confirmInput)   confirmInput.setAttribute('autocomplete', 'new-password');

    // --- Assign button class ---
    if (registerBtn) registerBtn.classList.add('btn-register');

    // --- Live password match indicator ---
    function checkMatch() {
        if (!confirmInput || !confirmInput.value) {
            if (confirmInput) confirmInput.classList.remove('match', 'no-match');
            return true;
        }
        var matches = passInput.value === confirmInput.value;
        confirmInput.classList.toggle('match',    matches);
        confirmInput.classList.toggle('no-match', !matches);
        return matches;
    }

    if (passInput)    passInput.addEventListener('input', checkMatch);
    if (confirmInput) confirmInput.addEventListener('input', checkMatch);

    // --- Client-side validation on submit ---
    if (registerBtn) {
        registerBtn.addEventListener('click', function (e) {

            // 1. Empty-field check (all required fields)
            var required = [firstNameInput, lastNameInput, emailInput, phoneInput, passInput, confirmInput];
            for (var i = 0; i < required.length; i++) {
                if (required[i] && !required[i].value.trim()) {
                    e.preventDefault();
                    shake(required[i]);
                    return false;
                }
            }

            // 2. Email format
            var emailVal = emailInput ? emailInput.value.trim() : '';
            if (emailVal && !/^[^\s@]+@[^\s@]+\.[^\s@]+$/.test(emailVal)) {
                e.preventDefault();
                shake(emailInput);
                showFieldError(emailInput, 'Enter a valid email address.');
                return false;
            }

            // 3. Phone format (Saudi: starts with 05, 10 digits)
            var phoneVal = phoneInput ? phoneInput.value.trim() : '';
            if (phoneVal && !/^07\d{8}$/.test(phoneVal)) {
                e.preventDefault();
                shake(phoneInput);
                showFieldError(phoneInput, 'Phone must start with 07 and be 10 digits.');
                return false;
            }

            // 4. Minimum password length
            if (passInput && passInput.value.length < 8) {
                e.preventDefault();
                shake(passInput);
                showFieldError(passInput, 'Password must be at least 8 characters.');
                return false;
            }

            // 5. Password confirmation match
            if (!checkMatch()) {
                e.preventDefault();
                shake(confirmInput);
                return false;
            }
        });
    }

    // --- Show a transient error below a field ---
    function showFieldError(el, msg) {
        if (!el) return;
        var existing = el.parentNode.querySelector('.js-field-error');
        if (existing) existing.remove();
        var err = document.createElement('span');
        err.className = 'js-field-error';
        err.style.cssText = 'display:block;font-size:12px;color:#c0392b;margin-top:4px;';
        err.textContent = msg;
        el.parentNode.appendChild(err);
        setTimeout(function () { if (err.parentNode) err.remove(); }, 4000);
    }

    // --- Shake animation ---
    function shake(el) {
        if (!el) return;
        el.style.transition = 'transform 0.4s cubic-bezier(.36,.07,.19,.97), border-color 0.2s';
        el.style.borderColor = '#c0392b';
        el.style.transform = 'translateX(-6px)';
        setTimeout(function () { el.style.transform = 'translateX(6px)';  }, 80);
        setTimeout(function () { el.style.transform = 'translateX(-4px)'; }, 160);
        setTimeout(function () { el.style.transform = 'translateX(4px)';  }, 240);
        setTimeout(function () { el.style.transform = 'translateX(0)';    }, 320);
        setTimeout(function () { el.style.borderColor = ''; }, 400);
        el.focus();
    }

});
