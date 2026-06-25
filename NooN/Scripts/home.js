/* ============================================================
   NOON — home.js
   Scripts specific to pages/home.html
   ============================================================ */

/* ── Countdown timer on promo banner ── */
function startPromoTimer() {
  const el = document.querySelector('.promo-count');
  if (!el) return;

  setInterval(() => {
    let [h, m] = el.textContent.split(':').map(Number);
    m--;
    if (m < 0) { m = 59; h = Math.max(0, h - 1); }
    el.textContent = String(h).padStart(2, '0') + ':' + String(m).padStart(2, '0');
  }, 60000);
}

/* ── Auto-start ── */
document.addEventListener('DOMContentLoaded', startPromoTimer);
