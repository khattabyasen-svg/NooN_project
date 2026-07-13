using System;
using System.Collections.Generic;
using System.Configuration;
using System.Data;
using System.Data.SqlClient;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace NooN
{
    public partial class Prouduct : Page
    {
        private string connStr = Db.ConnectionString;

        // ═══════════════════════════════════════════
        // Page Load
        // ═══════════════════════════════════════════
        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                LoadCategories();

                string catIdStr = Request.QueryString["category_id"];
                string search = Request.QueryString["search"];

                if (!string.IsNullOrEmpty(catIdStr) && int.TryParse(catIdStr, out int id))
                {
                    SetSelectedCategory(id);
                    LoadProducts(categoryIds: new List<int> { id }, searchText: search);
                }
                else if (!string.IsNullOrEmpty(search))
                {
                    LoadProducts(searchText: search);
                }
                else
                {
                    LoadProducts();
                }
            }
        }

        private void SetSelectedCategory(int categoryId)
        {
            foreach (RepeaterItem item in rptCategories.Items)
            {
                var cb = (CheckBox)item.FindControl("cbCategory");
                var hf = (HiddenField)item.FindControl("hfCatId");

                if (cb != null && hf != null &&
                    int.TryParse(hf.Value, out int id) && id == categoryId)
                {
                    cb.Checked = true;
                    break;
                }
            }
        }

        // ═══════════════════════════════════════════
        // تحميل الفئات
        // ═══════════════════════════════════════════
        private void LoadCategories()
        {
            using (SqlConnection conn = new SqlConnection(connStr))
            {
                string sql = "SELECT category_id, name_ar " +
                             "FROM product_categories " +
                             "WHERE is_active = 1 ORDER BY name_ar";

                using (SqlDataAdapter da = new SqlDataAdapter(sql, conn))
                {
                    DataTable dt = new DataTable();
                    da.Fill(dt);

                    rptCategories.DataSource = dt;
                    rptCategories.DataBind();
                }
            }
        }

        // ═══════════════════════════════════════════
        // جمع الفئات المحددة
        // ═══════════════════════════════════════════
        private List<int> GetSelectedCategories()
        {
            var ids = new List<int>();
            foreach (RepeaterItem item in rptCategories.Items)
            {
                var cb = (CheckBox)item.FindControl("cbCategory");
                var hf = (HiddenField)item.FindControl("hfCatId");
                if (cb != null && cb.Checked && hf != null
                    && int.TryParse(hf.Value, out int catId))
                    ids.Add(catId);
            }
            return ids;
        }

        // ═══════════════════════════════════════════
        // تحميل المنتجات
        // ═══════════════════════════════════════════
        private void LoadProducts(
            List<int> categoryIds = null,
            string minPrice = "",
            string maxPrice = "",
            double minRating = 0,
            string orderBy = "p.created_at DESC",
            string searchText = null)
        {
            using (SqlConnection conn = new SqlConnection(connStr))
            {
                var where = new System.Text.StringBuilder();
                using (var cmd = new SqlCommand())
                {
                cmd.Connection = conn;

                if (!string.IsNullOrEmpty(searchText))
                {
                    where.Append(" AND p.name LIKE @search");
                    cmd.Parameters.AddWithValue("@search", "%" + searchText + "%");
                }

                if (categoryIds != null && categoryIds.Count > 0)
                {
                    var paramNames = new List<string>();
                    for (int i = 0; i < categoryIds.Count; i++)
                    {
                        string pName = "@cat" + i;
                        paramNames.Add(pName);
                        cmd.Parameters.AddWithValue(pName, categoryIds[i]);
                    }
                    where.Append(" AND p.category_id IN ("
                                 + string.Join(",", paramNames) + ")");
                }

                if (!string.IsNullOrEmpty(minPrice)
                    && decimal.TryParse(minPrice, out decimal minP))
                {
                    where.Append(" AND p.price >= @minPrice");
                    cmd.Parameters.AddWithValue("@minPrice", minP);
                }

                if (!string.IsNullOrEmpty(maxPrice)
                    && decimal.TryParse(maxPrice, out decimal maxP))
                {
                    where.Append(" AND p.price <= @maxPrice");
                    cmd.Parameters.AddWithValue("@maxPrice", maxP);
                }

                if (minRating > 0)
                {
                    where.Append(" AND p.rating_avg >= @minRating");
                    cmd.Parameters.AddWithValue("@minRating", minRating);
                }

                // جلب is_wished في نفس الاستعلام — بدون N+1
                int? userId = Session["user_id"] != null
                              ? (int?)Convert.ToInt32(Session["user_id"]) : null;
                cmd.Parameters.AddWithValue("@currentUser", (object)userId ?? DBNull.Value);

                cmd.CommandText = @"
                    SELECT
                        p.product_id,
                        p.name,
                        p.price,
                        p.old_price,
                        p.discount_pct,
                        p.brand,
                        p.rating_avg,
                        p.rating_count,
                        p.images,
                        ISNULL(c.name_ar, N'بدون فئة') AS category_name,
                        CASE WHEN w.product_id IS NOT NULL THEN 1 ELSE 0 END AS is_wished,
                        CASE WHEN p.status = 'active' AND ISNULL(i.available_qty, 0) > 0
                             THEN 1 ELSE 0 END AS is_available
                    FROM products p
                    LEFT JOIN product_categories c ON p.category_id = c.category_id
                    LEFT JOIN inventory i ON i.product_id = p.product_id
                    LEFT JOIN wishlist_items w
                           ON w.product_id = p.product_id
                          AND w.user_id    = @currentUser
                    WHERE p.status IN ('active', 'out_of_stock')
                    " + where.ToString() + @"
                    ORDER BY " + orderBy;

                using (SqlDataAdapter da = new SqlDataAdapter(cmd))
                {
                    DataTable dt = new DataTable();
                    da.Fill(dt);

                    rptProducts.DataSource = dt;
                    rptProducts.DataBind();
                    lblCount.Text = dt.Rows.Count.ToString();
                }
                }
            }
        }

        // ═══════════════════════════════════════════
        // ItemDataBound
        // ═══════════════════════════════════════════
        protected void rptProducts_ItemDataBound(object sender, RepeaterItemEventArgs e)
        {
            if (e.Item.ItemType != ListItemType.Item &&
                e.Item.ItemType != ListItemType.AlternatingItem) return;

            DataRowView row = (DataRowView)e.Item.DataItem;

            // بادج الخصم
            var litBadge = (Literal)e.Item.FindControl("litBadge");
            decimal disc = row["discount_pct"] != DBNull.Value
                           ? Convert.ToDecimal(row["discount_pct"]) : 0;
            if (disc > 0)
                litBadge.Text = "<span class='p-badge'>-" + disc.ToString("0") + "%</span>";

            // النجوم
            var litStars = (Literal)e.Item.FindControl("litStars");
            double rating = row["rating_avg"] != DBNull.Value
                            ? Convert.ToDouble(row["rating_avg"]) : 0;
            int full = (int)Math.Round(rating);
            string stars = "";
            for (int i = 1; i <= 5; i++)
                stars += i <= full ? "★" : "☆";
            litStars.Text = "<span class='stars-gold'>" + stars + "</span>";

            // السعر القديم
            var litOldPrice = (Literal)e.Item.FindControl("litOldPrice");
            if (row["old_price"] != DBNull.Value)
            {
                decimal old = Convert.ToDecimal(row["old_price"]);
                litOldPrice.Text = "<span class='p-old-price'>"
                                 + old.ToString("N0") + " د.أ</span>";
            }

            // Favorite state (is_wished) is bound inline in the markup and
            // toggled client-side via noonShop.toggleFav (ShopService.ashx).
        }

        // ═══════════════════════════════════════════
        // تطبيق الفلتر
        // ═══════════════════════════════════════════
        protected void btnApplyFilter_Click(object sender, EventArgs e)
        {
            ReloadProducts();
            upProducts.Update();
            upToolbar.Update();
        }

        // ═══════════════════════════════════════════
        // تغيير الترتيب
        // ═══════════════════════════════════════════
        protected void ddlSort_SelectedIndexChanged(object sender, EventArgs e)
        {
            ReloadProducts();
            upProducts.Update();
            upToolbar.Update();
        }

        // Add-to-cart and favorite toggling are handled client-side via
        // fetch() against ShopService.ashx (see Scripts/noon-shop.js).

        // ═══════════════════════════════════════════
        // إعادة تحميل مع الحفاظ على الفلتر
        // ═══════════════════════════════════════════
        private void ReloadProducts()
        {
            var catIds = GetSelectedCategories();

            if (catIds.Count == 0)
            {
                string catId = Request.QueryString["category_id"];
                if (!string.IsNullOrEmpty(catId) && int.TryParse(catId, out int id))
                    catIds = new List<int> { id };
            }

            LoadProducts(
                categoryIds: catIds.Count > 0 ? catIds : null,
                minPrice: txtMinPrice.Text,
                maxPrice: txtMaxPrice.Text,
                minRating: GetMinRating(),
                orderBy: GetOrderBy()
            );
        }

        // ═══════════════════════════════════════════
        // استخراج أول صورة من حقل images
        // ═══════════════════════════════════════════
        protected string GetFirstImage(object images)
        {
            // Shared resolver handles single paths, CSV lists and JSON arrays,
            // and returns an inline placeholder when there is no image.
            return ProductImage.FirstUrl(images);
        }

        // ═══════════════════════════════════════════
        // دوال مساعدة
        // ═══════════════════════════════════════════
        private string GetOrderBy()
        {
            switch (ddlSort.SelectedValue)
            {
                case "price_asc": return "p.price ASC";
                case "price_desc": return "p.price DESC";
                case "newest": return "p.created_at DESC";
                case "rating": return "p.rating_avg DESC";
                default: return "p.created_at DESC";
            }
        }

        private double GetMinRating()
        {
            if (cb5Star.Checked) return 5.0;
            if (cb4Star.Checked) return 4.0;
            if (cb3Star.Checked) return 3.0;
            return 0;
        }

        protected void txtMinPrice_TextChanged(object sender, EventArgs e) { }
    }
}