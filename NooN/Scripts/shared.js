/* ============================================================
   NOON — shared.js (ASP.NET FINAL VERSION)
   ============================================================ */

window.NoonState = { cartCount: 3 };

// Bind the functions (showPage is defined below)
window.showPage = showPage;
window.navigateTo = function (page) { showPage(page); };

/* ── Professional toast function ── */
function showToast(msg) {
    // Create the toast element programmatically if it does not exist
    let toast = document.getElementById('custom-toast');
    if (!toast) {
        toast = document.createElement('div');
        toast.id = 'custom-toast';
        toast.style.cssText = "position:fixed; bottom:20px; right:20px; background:#333; color:#fff; padding:12px 25px; border-radius:8px; z-index:9999; display:none; box-shadow:0 4px 12px rgba(0,0,0,0.2); font-family:sans-serif; direction:ltr;";
        document.body.appendChild(toast);
    }

    toast.textContent = msg;
    toast.style.display = 'block';

    // Hide the toast after 3 seconds
    setTimeout(() => { toast.style.display = 'none'; }, 3000);
}

/* ── Update the cart badge ── */
function updateCartBadge(count) {
    // Look up the badge by its ID or Class
    const badge = document.getElementById('cartBadge') || document.querySelector('.cart-badge');
    if (badge) {
        badge.textContent = count;
        // Small pulse effect when an item is added
        badge.style.transform = "scale(1.3)";
        setTimeout(() => { badge.style.transform = "scale(1)"; }, 200);
    }
}

/* ── Add to cart ── */
function addToCart(e, name) {
    if (e) e.stopPropagation(); // Prevent navigating to the details page
    window.NoonState.cartCount++;
    updateCartBadge(window.NoonState.cartCount);
    showToast(`✅ "${name}" added to the cart`);
}

/* ── Favorites ── */
function toggleFav(e, btn) {
    if (e) e.stopPropagation();
    if (btn.textContent.includes('🤍')) {
        btn.innerHTML = '❤️';
        btn.classList.add('active');
        showToast('❤️ Added to favorites');
    } else {
        btn.innerHTML = '🤍';
        btn.classList.remove('active');
    }
}

function toggleFilter(el) {
    el.classList.toggle('checked');
}

/* ── Updated smart navigation function ── */
function showPage(pageId) {
    console.log("Attempting to navigate to: " + pageId);

    // 1. Validation logic when heading to Checkout
    if (pageId.toLowerCase() === 'checkout') {
        // Check the cart count stored in NoonState
        if (window.NoonState.cartCount === 0) {
            showToast("⚠️ Your cart is empty! Add products first to continue.");
            return; // Cancel the navigation
        }
    }

    // 2. Handle page names (case sensitivity)
    let destination = pageId;
    const lowerId = pageId.toLowerCase();

    if (lowerId === 'prouduct' || lowerId === 'product') {
        destination = 'Prouduct';
    } else if (lowerId === 'cart') {
        destination = 'Cart';
    } else if (lowerId === 'checkout') {
        destination = 'checkout'; // Make sure the file name is checkout.aspx
    }

    // 3. Actual redirect
    window.location.href = destination + ".aspx";
}

function placeOrder() {
    console.log("Starting the order confirmation process...");

    // 1. Show a small "loading" effect to feel professional
    const btn = document.querySelector('.checkout-place-btn');
    const originalText = btn.innerHTML;
    btn.innerHTML = "Processing your order... 🔄";
    btn.disabled = true;

    // 2. Simulate the "check" process
    setTimeout(() => {
        let isSuccess = true; // Assume the check succeeded

        if (isSuccess) {
            // 3. Show a success message to the user
            showToast("✅ Your order has been confirmed successfully!");


            setTimeout(() => {
                window.location.href = "Confirm.aspx";
            }, 1000);
        } else {
            // If the check fails
            showToast("❌ An error occurred while confirming the order.");
            btn.innerHTML = originalText;
            btn.disabled = false;
        }
    }, 1500); // 1.5-second delay to simulate processing
}

// Ensure the functions are bound so they work with onclick in HTML
window.showPage = showPage;
window.navigateTo = function (page) { showPage(page); };

window.placeOrder = placeOrder;