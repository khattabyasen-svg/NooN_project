/* ==============================================
   detail.js — NooN Store
   Scripts for Details.aspx (product detail page)

   Server-generated control IDs are injected via
   the detailIds object defined inline in Details.aspx
   (above this script tag). Any reference to a hidden
   field or label uses detailIds.<key> to get the
   rendered client ID.
   ============================================== */

function changeQty(delta) {
    var display = document.getElementById('qtyDisplay');
    var hf     = document.getElementById(detailIds.hfQty);
    var hfMax  = document.getElementById(detailIds.hfMaxQty);
    if (!hf || !display) return;
    var max = hfMax ? parseInt(hfMax.value) : 99;
    if (isNaN(max) || max < 1) max = 1;
    var v = parseInt(hf.value) + delta;
    if (v >= 1 && v <= max) {
        hf.value = v;
        display.innerText = v;
    }
}

function pickColor(btn) {
    document.querySelectorAll('.color-btn').forEach(function (b) { b.classList.remove('active'); });
    btn.classList.add('active');
    var hf = document.getElementById(detailIds.hfColor);
    if (hf) hf.value = btn.getAttribute('data-color');
    var grp = document.getElementById('colorGroup');
    if (grp) grp.classList.remove('invalid');
}

function pickSize(btn) {
    document.querySelectorAll('.size-btn').forEach(function (b) { b.classList.remove('active'); });
    btn.classList.add('active');
    var hf = document.getElementById(detailIds.hfSize);
    if (hf) hf.value = btn.getAttribute('data-size');
    var grp = document.getElementById('sizeGroup');
    if (grp) grp.classList.remove('invalid');
}

function pickStar(val) {
    var hf = document.getElementById(detailIds.hfRating);
    if (hf) hf.value = val;
    document.querySelectorAll('.star-pick').forEach(function (s) {
        s.classList.toggle('active', parseInt(s.getAttribute('data-val')) <= val);
    });
}

function validateCart() {
    var ok = true;

    var colorHf = document.getElementById(detailIds.hfColor);
    if (colorHf !== null) {
        if (!colorHf.value || colorHf.value.trim() === '') {
            var grp = document.getElementById('colorGroup');
            if (grp) {
                grp.classList.add('invalid');
                setTimeout(function () { grp.classList.remove('invalid'); }, 2000);
            }
            detailShowToast('⚠️ Please select a color first');
            ok = false;
        }
    }

    var sizeHf = document.getElementById(detailIds.hfSize);
    if (sizeHf !== null && ok) {
        if (!sizeHf.value || sizeHf.value.trim() === '') {
            var grp2 = document.getElementById('sizeGroup');
            if (grp2) {
                grp2.classList.add('invalid');
                setTimeout(function () { grp2.classList.remove('invalid'); }, 2000);
            }
            detailShowToast('⚠️ Please select a size first');
            ok = false;
        }
    }

    return ok;
}

function detailsAddToCart(btn) {
    if (!validateCart()) return;

    var qtyHf   = document.getElementById(detailIds.hfQty);
    var colorHf = document.getElementById(detailIds.hfColor);
    var sizeHf  = document.getElementById(detailIds.hfSize);

    noonShop.addToCart(btn, {
        quantity: qtyHf   ? qtyHf.value          : 1,
        color:    colorHf ? colorHf.value.trim()  : '',
        size:     sizeHf  ? sizeHf.value.trim()   : ''
    });
}

function detailShowToast(msg) {
    var t = document.getElementById('detailToast');
    if (!t) return;
    t.innerText = msg;
    t.style.display = 'block';
    t.style.opacity = '1';
    t.style.transition = '';
    setTimeout(function () {
        t.style.transition = 'opacity .5s';
        t.style.opacity = '0';
        setTimeout(function () {
            t.style.display = 'none';
            t.style.opacity = '1';
        }, 500);
    }, 2500);
}

window.addEventListener('load', function () {
    var r = document.getElementById(detailIds.lblReviewMsg);
    if (r && r.innerText.trim() !== '') detailShowToast(r.innerText.trim());

    var thumbs  = document.querySelectorAll('.gallery-thumb');
    var mainImg = document.getElementById('galleryMainImg');
    thumbs.forEach(function (th) {
        th.addEventListener('click', function () {
            thumbs.forEach(function (t) { t.classList.remove('active'); });
            th.classList.add('active');
            var im = th.querySelector('img');
            if (mainImg && im) mainImg.src = im.getAttribute('data-full') || im.src;
        });
    });

    var hfQty = document.getElementById(detailIds.hfQty);
    var disp  = document.getElementById('qtyDisplay');
    if (hfQty && disp && hfQty.value) {
        disp.innerText = hfQty.value;
    }
});
