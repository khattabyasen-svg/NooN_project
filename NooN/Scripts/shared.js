/* ============================================================
   NOON — shared.js (ASP.NET FINAL VERSION)
   ============================================================ */

window.NoonState = { cartCount: 3 };

/* ── دالة التنقل الذكية ── */
function showPage(pageId) {
    console.log("محاولة الانتقال إلى: " + pageId);

    // التحقق من الحالات الخاصة بالأسماء (Prouduct بالـ u)
    let destination = pageId;
    if (pageId.toLowerCase() === 'prouduct' || pageId.toLowerCase() === 'product') {
        destination = 'Prouduct';
    } else if (pageId.toLowerCase() === 'cart') {
        destination = 'Cart';
    }

    // التحويل المباشر لصفحة الـ ASPX
    window.location.href = destination + ".aspx";
}

// ربط الدوال
window.showPage = showPage;
window.navigateTo = function (page) { showPage(page); };

/* ── دالة التنبيه (Toast) الاحترافية ── */
function showToast(msg) {
    // إنشاء عنصر التنبيه برمجياً إذا لم يكن موجوداً
    let toast = document.getElementById('custom-toast');
    if (!toast) {
        toast = document.createElement('div');
        toast.id = 'custom-toast';
        toast.style.cssText = "position:fixed; bottom:20px; right:20px; background:#333; color:#fff; padding:12px 25px; border-radius:8px; z-index:9999; display:none; box-shadow:0 4px 12px rgba(0,0,0,0.2); font-family:sans-serif; direction:rtl;";
        document.body.appendChild(toast);
    }

    toast.textContent = msg;
    toast.style.display = 'block';

    // إخفاء التنبيه بعد 3 ثواني
    setTimeout(() => { toast.style.display = 'none'; }, 3000);
}

/* ── تحديث عداد السلة ── */
function updateCartBadge(count) {
    // نبحث عن العداد باستخدام الـ ID أو الـ Class
    const badge = document.getElementById('cartBadge') || document.querySelector('.cart-badge');
    if (badge) {
        badge.textContent = count;
        // تأثير نبض بسيط عند الإضافة
        badge.style.transform = "scale(1.3)";
        setTimeout(() => { badge.style.transform = "scale(1)"; }, 200);
    }
}

/* ── إضافة للسلة ── */
function addToCart(e, name) {
    if (e) e.stopPropagation(); // منع الانتقال لصفحة التفاصيل
    window.NoonState.cartCount++;
    updateCartBadge(window.NoonState.cartCount);
    showToast(`✅ تمت إضافة "${name}" للسلة`);
}

/* ── المفضلة ── */
function toggleFav(e, btn) {
    if (e) e.stopPropagation();
    if (btn.textContent.includes('🤍')) {
        btn.innerHTML = '❤️';
        btn.classList.add('active');
        showToast('❤️ تمت الإضافة للمفضلة');
    } else {
        btn.innerHTML = '🤍';
        btn.classList.remove('active');
    }
}

function toggleFilter(el) {
    el.classList.toggle('checked');
}

/* ── دالة التنقل الذكية المحدثة ── */
function showPage(pageId) {
    console.log("محاولة الانتقال إلى: " + pageId);

    // 1. منطق التحقق عند التوجه للدفع (Checkout)
    if (pageId.toLowerCase() === 'checkout') {
        // نتحقق من عداد السلة الموجود في NoonState
        if (window.NoonState.cartCount === 0) {
            showToast("⚠️ سلتك فارغة! أضف منتجات أولاً للمتابعة.");
            return; // إلغاء عملية الانتقال
        }
    }

    // 2. معالجة أسماء الصفحات (Case Sensitivity)
    let destination = pageId;
    const lowerId = pageId.toLowerCase();

    if (lowerId === 'prouduct' || lowerId === 'product') {
        destination = 'Prouduct';
    } else if (lowerId === 'cart') {
        destination = 'Cart';
    } else if (lowerId === 'checkout') {
        destination = 'checkout'; // تأكد أن اسم الملف هو checkout.aspx
    }

    // 3. التحويل الفعلي
    window.location.href = destination + ".aspx";
}

function placeOrder() {
    console.log("بدء عملية تأكيد الطلب...");

    // 1. إظهار تأثير "تحميل" بسيط لإعطاء انطباع بالاحترافية
    const btn = document.querySelector('.checkout-place-btn');
    const originalText = btn.innerHTML;
    btn.innerHTML = "جاري معالجة الطلب... 🔄";
    btn.disabled = true;

    // 2. محاكاة عملية "التشيك" (Check) - ه
    setTimeout(() => {
        let isSuccess = true; // افترضنا أن الفحص نجح

        if (isSuccess) {
            // 3. إظهار رسالة نجاح للمستخدم
            showToast("✅ تم تأكيد طلبك بنجاح!");

         
            setTimeout(() => {
                window.location.href = "Confirm.aspx";
            }, 1000);
        } else {
            // في حال فشل الفحص
            showToast("❌ حدث خطأ أثناء تأكيد الطلب.");
            btn.innerHTML = originalText;
            btn.disabled = false;
        }
    }, 1500); // تأخير لمدة ثانية ونصف لمحاكاة المعالجة
}

// التأكد من ربط الدوال لتعمل مع onclick في HTML
window.showPage = showPage;
window.navigateTo = function (page) { showPage(page); };
function placeOrder() {
    // الكود الخاص بك
}

window.placeOrder = placeOrder;