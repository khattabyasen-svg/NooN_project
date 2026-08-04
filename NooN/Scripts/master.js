/* ==============================================
   master.js — NooN Store
   Scripts for Site.Master (shared across all pages)
   ============================================== */

/* Navigate to the products page filtered by the selected category */
function navigateToCategory(ddl) {
    var val = ddl.value;
    if (val && val !== '0')
        window.location.href = 'Prouduct.aspx?category_id=' + val;
    else if (val === '0')
        window.location.href = 'Prouduct.aspx';
}
