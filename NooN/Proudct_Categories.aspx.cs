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
        // سلسلة الاتصال من Web.config
        // ═══════════════════════════════════════════
        private string connStr = ConfigurationManager
                                    .ConnectionStrings["MyConnection"]
                                    .ConnectionString;

        // ═══════════════════════════════════════════
        // تحميل الصفحة
        // ═══════════════════════════════════════════
        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                LoadCategories();
            }
        }

        // ═══════════════════════════════════════════
        // جلب البيانات وربطها بالـ GridView
        // ═══════════════════════════════════════════
        private void LoadCategories()
        {
            using (SqlConnection conn = new SqlConnection(connStr))
            {
                string sql = "SELECT category_id, name_ar, name_en, is_active FROM product_categories ORDER BY category_id DESC";

                SqlDataAdapter da = new SqlDataAdapter(sql, conn);
                DataSet ds = new DataSet();
                //DataTable dt = new DataTable();
                da.Fill(ds);

                gvCategories.DataSource = ds;
                gvCategories.DataBind();
            }
        }

        // ═══════════════════════════════════════════
        // إضافة فئة جديدة
        // ═══════════════════════════════════════════
        protected void btnAdd_Click(object sender, EventArgs e)
        {
            string nameAr = txtNameAr.Text.Trim();
            string nameEn = txtNameEn.Text.Trim();
            int isActive = int.Parse(ddlStatus.SelectedValue);

            // ── التحقق من الإدخال ──
            if (string.IsNullOrEmpty(nameAr) || string.IsNullOrEmpty(nameEn))
            {
                ShowAlert("يرجى إدخال الاسمين العربي والإنجليزي.", "alert-danger");
                return;
            }

            using (SqlConnection conn = new SqlConnection(connStr))
            {
                string sql = "INSERT INTO product_categories (name_ar, name_en, is_active) " +
                             "VALUES (@nameAr, @nameEn, @isActive)";

                SqlCommand cmd = new SqlCommand(sql, conn);
                cmd.Parameters.AddWithValue("@nameAr", nameAr);
                cmd.Parameters.AddWithValue("@nameEn", nameEn);
                cmd.Parameters.AddWithValue("@isActive", isActive);

                conn.Open();
                cmd.ExecuteNonQuery();
            }

            InvalidateCategoriesCache();

            // ── تنظيف الحقول بعد الإضافة ──
            txtNameAr.Text = "";
            txtNameEn.Text = "";
            ddlStatus.SelectedIndex = 0;

            ShowAlert("✅ تمت إضافة الفئة بنجاح.", "alert-success");
            LoadCategories();
        }

        // ═══════════════════════════════════════════
        // تفعيل وضع التعديل في الصف
        // ═══════════════════════════════════════════
        protected void gvCategories_RowEditing(object sender, GridViewEditEventArgs e)
        {
            gvCategories.EditIndex = e.NewEditIndex;
            LoadCategories();
        }

        // ═══════════════════════════════════════════
        // إلغاء التعديل
        // ═══════════════════════════════════════════
        protected void gvCategories_RowCancelingEdit(object sender, GridViewCancelEditEventArgs e)
        {
            gvCategories.EditIndex = -1;
            LoadCategories();
        }

        // ═══════════════════════════════════════════
        // حفظ التعديلات على صف معين
        // ═══════════════════════════════════════════
        protected void gvCategories_RowUpdating(object sender, GridViewUpdateEventArgs e)
        {
            // ── جلب الـ ID من DataKeys ──
            int categoryId = (int)gvCategories.DataKeys[e.RowIndex].Value;

            // ── جلب قيم الحقول من الصف ──
            GridViewRow row = gvCategories.Rows[e.RowIndex];

            string nameAr = ((TextBox)row.FindControl("txtNameAr")).Text.Trim();
            string nameEn = ((TextBox)row.FindControl("txtNameEn")).Text.Trim();
            int isActive = int.Parse(
                               ((DropDownList)row.FindControl("ddlStatus")).SelectedValue);

            if (string.IsNullOrEmpty(nameAr) || string.IsNullOrEmpty(nameEn))
            {
                ShowAlert("يرجى إدخال الاسمين العربي والإنجليزي.", "alert-danger");
                return;
            }


            using (SqlConnection conn = new SqlConnection(connStr))
            {
                string sql = "UPDATE product_categories " +
                             "SET name_ar = @nameAr, name_en = @nameEn, is_active = @isActive " +
                             "WHERE category_id = @id";

                SqlCommand cmd = new SqlCommand(sql, conn);
                cmd.Parameters.AddWithValue("@nameAr", nameAr);
                cmd.Parameters.AddWithValue("@nameEn", nameEn);
                cmd.Parameters.AddWithValue("@isActive", isActive);
                cmd.Parameters.AddWithValue("@id", categoryId);

                conn.Open();
                cmd.ExecuteNonQuery();
            }

            InvalidateCategoriesCache();

            gvCategories.EditIndex = -1;
            ShowAlert("✅ تم تحديث الفئة بنجاح.", "alert-success");
            LoadCategories();
        }

        // ═══════════════════════════════════════════
        // حذف فئة
        // ═══════════════════════════════════════════
        protected void gvCategories_RowDeleting(object sender, GridViewDeleteEventArgs e)
        {
            int categoryId = (int)gvCategories.DataKeys[e.RowIndex].Value;

            using (SqlConnection conn = new SqlConnection(connStr))
            {
                string sql = "DELETE FROM product_categories WHERE category_id = @id";

                SqlCommand cmd = new SqlCommand(sql, conn);
                cmd.Parameters.AddWithValue("@id", categoryId);

                conn.Open();
                cmd.ExecuteNonQuery();
            }

            InvalidateCategoriesCache();

            ShowAlert("🗑️ تم حذف الفئة بنجاح.", "alert-success");
            LoadCategories();
        }

        // ═══════════════════════════════════════════
        // حدث غير مستخدم (مطلوب بسبب الـ ASPX)
        // ═══════════════════════════════════════════
        protected void gvCategories_SelectedIndexChanged(object sender, EventArgs e) { }

        // ═══════════════════════════════════════════
        // Clear the cached category list used by the master page
        // so the navbar dropdown reflects changes immediately.
        // Must match the cache key in Site.Master.cs (GetCategories).
        // ═══════════════════════════════════════════
        private void InvalidateCategoriesCache()
        {
            Cache.Remove("site_categories");
        }

        // ═══════════════════════════════════════════
        // دالة مساعدة: إظهار رسالة تنبيه
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