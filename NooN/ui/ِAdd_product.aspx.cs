using System;
using System.Web.UI;

namespace AdminPanel
{
    public partial class ProductManagement : Page
    {
        // ── Page Load ────────────────────────────────────────────
        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                LoadProducts();
            }
        }

        // ── Data Loading ─────────────────────────────────────────
        /// <summary>
        /// Bind product data to the table.
        /// Replace with your actual data source (EF, ADO.NET, etc.)
        /// </summary>
        private void LoadProducts(string statusFilter = null)
        {
            // Example:
            // var products = ProductService.GetAll(
            //     search:   txtSearch.Text.Trim(),
            //     category: ddlCategory.SelectedValue,
            //     brand:    ddlBrand.SelectedValue,
            //     status:   statusFilter
            // );
            // gvProducts.DataSource = products;
            // gvProducts.DataBind();
        }

        // ── Button Events ────────────────────────────────────────
        protected void btnAddProduct_Click(object sender, EventArgs e)
        {
            Response.Redirect("~/AddnewItem.aspx");
        }


        protected void btnDeleteSelected_Click(object sender, EventArgs e)
        {
            // 1. Read selected IDs from a hidden field populated by JS.
            // 2. Call your service: ProductService.DeleteRange(selectedIds);
            // 3. Reload.
            LoadProducts();
        }

        // ── Filter / Search Events ───────────────────────────────
        protected void txtSearch_TextChanged(object sender, EventArgs e)
        {
            LoadProducts();
        }

        protected void ddlCategory_SelectedIndexChanged(object sender, EventArgs e)
        {
            LoadProducts();
        }

        protected void ddlBrand_SelectedIndexChanged(object sender, EventArgs e)
        {
            LoadProducts();
        }
    }
}