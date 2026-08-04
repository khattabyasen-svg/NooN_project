/* ==============================================
   products.js — NooN Store
   Scripts for Prouduct.aspx (product listing page)
   Hooks into ASP.NET UpdatePanel to show/hide
   the loading overlay during partial-page refreshes.
   ============================================== */

var prm = Sys.WebForms.PageRequestManager.getInstance();

prm.add_beginRequest(function () {
    document.getElementById('loadingOverlay').style.display = 'flex';
});

prm.add_endRequest(function () {
    document.getElementById('loadingOverlay').style.display = 'none';
});
