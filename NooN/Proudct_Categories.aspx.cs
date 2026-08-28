using System;
using System.Configuration;
using System.Data;
using System.Data.SqlClient;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace NooN
{
    public partial class Proudct_Categories : Page
    {
        // ═══════════════════════════════════════════
        // Connection string from Web.config
        // ═══════════════════════════════════════════
        private string connStr = Db.ConnectionString;

        // ═══════════════════════════════════════════
        // Page load
        // ═══════════════════════════════════════════
        protected void Page_Load(object sender, EventArgs e)
        {
            // Admin-only page: block anonymous access (add/edit/delete categories).
            if (Session["AdminID"] == null)
            {
                Response.Redirect("LoginAdmin.aspx");
                return;
            }

            if (!IsPostBack)
            {
                LoadCategories();
            }
        }

        // ═══════════════════════════════════════════
        // Fetch the data and bind it to the GridView
        // ═══════════════════════════════════════════
        private void LoadCategories()
        {
            using (SqlConnection conn = new SqlConnection(connStr))
            {
                string sql = "SELECT category_id, name_ar, name_en, is_active FROM product_categories ORDER BY category_id DESC";

                using (SqlDataAdapter da = new SqlDataAdapter(sql, conn))
                {
                    DataSet ds = new DataSet();
                    da.Fill(ds);

                    gvCategories.DataSource = ds;
                    gvCategories.DataBind();
                }
            }
        }

        // ═══════════════════════════════════════════
        // Add a new category
        // ═══════════════════════════════════════════
        protected void btnAdd_Click(object sender, EventArgs e)
        {
            string nameAr = txtNameAr.Text.Trim();
            string nameEn = txtNameEn.Text.Trim();
            int isActive = int.Parse(ddlStatus.SelectedValue);

            // ── Input validation ──
            if (string.IsNullOrEmpty(nameAr) || string.IsNullOrEmpty(nameEn))
            {
                ShowAlert("Please enter both the Arabic and English names.", "alert-danger");
                return;
            }

            using (SqlConnection conn = new SqlConnection(connStr))
            {
                string sql = "INSERT INTO product_categories (name_ar, name_en, is_active) " +
                             "VALUES (@nameAr, @nameEn, @isActive)";

                using (SqlCommand cmd = new SqlCommand(sql, conn))
                {
                    cmd.Parameters.AddWithValue("@nameAr", nameAr);
                    cmd.Parameters.AddWithValue("@nameEn", nameEn);
                    cmd.Parameters.AddWithValue("@isActive", isActive);

                    conn.Open();
                    cmd.ExecuteNonQuery();
                }
            }

            InvalidateCategoriesCache();

            // ── Clear the fields after adding ──
            txtNameAr.Text = "";
            txtNameEn.Text = "";
            ddlStatus.SelectedIndex = 0;

            ShowAlert("✅ Category added successfully.", "alert-success");
            LoadCategories();
        }

        // ═══════════════════════════════════════════
        // Enter edit mode for the row
        // ═══════════════════════════════════════════
        protected void gvCategories_RowEditing(object sender, GridViewEditEventArgs e)
        {
            gvCategories.EditIndex = e.NewEditIndex;
            LoadCategories();
        }

        // ═══════════════════════════════════════════
        // Cancel editing
        // ═══════════════════════════════════════════
        protected void gvCategories_RowCancelingEdit(object sender, GridViewCancelEditEventArgs e)
        {
            gvCategories.EditIndex = -1;
            LoadCategories();
        }

        // ═══════════════════════════════════════════
        // Save the edits for a given row
        // ═══════════════════════════════════════════
        protected void gvCategories_RowUpdating(object sender, GridViewUpdateEventArgs e)
        {
            // ── Get the ID from DataKeys ──
            int categoryId = (int)gvCategories.DataKeys[e.RowIndex].Value;

            // ── Get the field values from the row ──
            GridViewRow row = gvCategories.Rows[e.RowIndex];

            string nameAr = ((TextBox)row.FindControl("txtNameAr")).Text.Trim();
            string nameEn = ((TextBox)row.FindControl("txtNameEn")).Text.Trim();
            int isActive = int.Parse(
                               ((DropDownList)row.FindControl("ddlStatus")).SelectedValue);

            if (string.IsNullOrEmpty(nameAr) || string.IsNullOrEmpty(nameEn))
            {
                ShowAlert("Please enter both the Arabic and English names.", "alert-danger");
                return;
            }


            using (SqlConnection conn = new SqlConnection(connStr))
            {
                string sql = "UPDATE product_categories " +
                             "SET name_ar = @nameAr, name_en = @nameEn, is_active = @isActive " +
                             "WHERE category_id = @id";

                using (SqlCommand cmd = new SqlCommand(sql, conn))
                {
                    cmd.Parameters.AddWithValue("@nameAr", nameAr);
                    cmd.Parameters.AddWithValue("@nameEn", nameEn);
                    cmd.Parameters.AddWithValue("@isActive", isActive);
                    cmd.Parameters.AddWithValue("@id", categoryId);

                    conn.Open();
                    cmd.ExecuteNonQuery();
                }
            }

            InvalidateCategoriesCache();

            gvCategories.EditIndex = -1;
            ShowAlert("✅ Category updated successfully.", "alert-success");
            LoadCategories();
        }

        // ═══════════════════════════════════════════
        // Delete a category
        // ═══════════════════════════════════════════
        protected void gvCategories_RowDeleting(object sender, GridViewDeleteEventArgs e)
        {
            int categoryId = (int)gvCategories.DataKeys[e.RowIndex].Value;

            using (SqlConnection conn = new SqlConnection(connStr))
            {
                string sql = "DELETE FROM product_categories WHERE category_id = @id";

                using (SqlCommand cmd = new SqlCommand(sql, conn))
                {
                    cmd.Parameters.AddWithValue("@id", categoryId);

                    conn.Open();
                    cmd.ExecuteNonQuery();
                }
            }

            InvalidateCategoriesCache();

            ShowAlert("🗑️ Category deleted successfully.", "alert-success");
            LoadCategories();
        }

        // ═══════════════════════════════════════════
        // Unused event (required by the ASPX)
        // ═══════════════════════════════════════════
        protected void gvCategories_SelectedIndexChanged(object sender, EventArgs e) { }

        // ═══════════════════════════════════════════
        // Clear the cached category lists (navbar dropdown and home page)
        // so both reflect changes immediately. Keys must match the ones used
        // in Site.Master.cs and Default.aspx.cs.
        // ═══════════════════════════════════════════
        private void InvalidateCategoriesCache()
        {
            Cache.Remove(SiteMaster.CategoriesCacheKey);
            Cache.Remove(_Default.CategoriesCacheKey);
        }

        // ═══════════════════════════════════════════
        // Helper: display an alert message
        // ═══════════════════════════════════════════
        private void ShowAlert(string message, string cssClass)
        {
            pnlAlert.Visible = true;
            pnlAlert.CssClass = "alert " + cssClass;
            lblAlert.Text = message;
        }

        protected void txtNameAr_TextChanged(object sender, EventArgs e)
        {

        }
    }
}