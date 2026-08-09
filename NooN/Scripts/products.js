/* ==============================================
   products.js — NooN Store
   Scripts for Prouduct.aspx (product listing page)
   Hooks into ASP.NET UpdatePanel to show/hide
   the loading overlay during partial-page refreshes.
   ============================================== */

// Guard: the ASP.NET AJAX runtime (Sys) must be loaded and the page must have a
// ScriptManager/UpdatePanel before wiring the loading overlay.
if (typeof Sys !== 'undefined' && Sys.WebForms) {
    var prm = Sys.WebForms.PageRequestManager.getInstance();

    prm.add_beginRequest(function () {
        var o = document.getElementById('loadingOverlay');
        if (o) o.style.display = 'flex';
    });

    prm.add_endRequest(function () {
        var o = document.getElementById('loadingOverlay');
        if (o) o.style.display = 'none';
    });
}
