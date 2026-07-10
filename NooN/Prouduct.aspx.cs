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
        private string connStr = ConfigurationManager
                                    .ConnectionStrings["MyConnection"]
                                    .ConnectionString;

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
                        CASE WHEN w.product_id IS NOT NULL THEN 1 ELSE 0 END AS is_wished
                    FROM products p
                    LEFT JOIN product_categories c ON p.category_id = c.category_id
                    LEFT JOIN wishlist_items w
                           ON w.product_id = p.product_id
                          AND w.user_id    = @currentUser
                    WHERE p.status = 'active'
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

            // المفضلة — من is_wished بدون استعلام إضافي
            var lbWish = (LinkButton)e.Item.FindControl("lbWish");
            if (lbWish != null)
            {
                int productId = Convert.ToInt32(row["product_id"]);
                bool isWished = Convert.ToInt32(row["is_wished"]) == 1;

                lbWish.CommandArgument = productId.ToString();
                lbWish.Text = isWished ? "❤️" : "🤍";
                if (isWished) lbWish.CssClass += " wish-active";
            }
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

        // ═══════════════════════════════════════════
        // ItemCommand — سلة + مفضلة
        // ═══════════════════════════════════════════
        protected void rptProducts_ItemCommand(object source, RepeaterCommandEventArgs e)
        {
            if (e.CommandName == "AddToCart")
            {
                if (Session["user_id"] == null)
                {
                    ShowMessage("يرجى تسجيل الدخول أولاً للإضافة للسلة.", isError: true);
                    upMsg.Update();
                    return;
                }

                int userId = Convert.ToInt32(Session["user_id"]);
                int productId = Convert.ToInt32(e.CommandArgument);

                try
                {
                    using (SqlConnection conn = new SqlConnection(connStr))
                    {
                        conn.Open();

                        int cartId;
                        using (SqlCommand cmd = new SqlCommand(
                            "SELECT cart_id FROM carts WHERE user_id = @uid", conn))
                        {
                            cmd.Parameters.AddWithValue("@uid", userId);
                            object res = cmd.ExecuteScalar();
                            if (res == null || res == DBNull.Value)
                            {
                                using (SqlCommand cmdNew = new SqlCommand(@"
                                    INSERT INTO carts (user_id, created_at, updated_at)
                                    VALUES (@uid, GETDATE(), GETDATE());
                                    SELECT SCOPE_IDENTITY();", conn))
                                {
                                    cmdNew.Parameters.AddWithValue("@uid", userId);
                                    cartId = Convert.ToInt32(cmdNew.ExecuteScalar());
                                }
                            }
                            else cartId = Convert.ToInt32(res);
                        }

                        using (SqlCommand cmdItem = new SqlCommand(@"
                            IF EXISTS (SELECT 1 FROM cart_items
                                       WHERE cart_id=@cartId AND product_id=@pid
                                         AND color IS NULL AND size IS NULL)
                                UPDATE cart_items SET quantity = quantity + 1
                                WHERE cart_id=@cartId AND product_id=@pid
                                  AND color IS NULL AND size IS NULL
                            ELSE
                                INSERT INTO cart_items
                                    (cart_id, product_id, quantity, color, size, added_at)
                                VALUES (@cartId, @pid, 1, NULL, NULL, GETDATE())", conn))
                        {
                            cmdItem.Parameters.AddWithValue("@cartId", cartId);
                            cmdItem.Parameters.AddWithValue("@pid", productId);
                            cmdItem.ExecuteNonQuery();
                        }

                        using (SqlCommand cmdUpd = new SqlCommand(
                            "UPDATE carts SET updated_at = GETDATE() WHERE cart_id=@cid", conn))
                        {
                            cmdUpd.Parameters.AddWithValue("@cid", cartId);
                            cmdUpd.ExecuteNonQuery();
                        }
                    }

                    ShowMessage("✅ تمت إضافة المنتج إلى سلتك!", isError: false);
                    (this.Master as NooN.SiteMaster)?.RefreshCartBadge();
                }
                catch (Exception ex)
                {
                    ShowMessage("حدث خطأ: " + ex.Message, isError: true);
                }

                upMsg.Update();
            }

            else if (e.CommandName == "ToggleWish")
            {
                if (Session["user_id"] == null)
                {
                    ShowMessage("يرجى تسجيل الدخول أولاً للمفضلة.", isError: true);
                    upMsg.Update();
                    return;
                }

                int userId = Convert.ToInt32(Session["user_id"]);
                int productId = Convert.ToInt32(e.CommandArgument);

                try
                {
                    using (SqlConnection conn = new SqlConnection(connStr))
                    {
                        conn.Open();

                        int exists;
                        using (SqlCommand check = new SqlCommand(@"
                            SELECT COUNT(*) FROM wishlist_items
                            WHERE user_id=@uid AND product_id=@pid", conn))
                        {
                            check.Parameters.AddWithValue("@uid", userId);
                            check.Parameters.AddWithValue("@pid", productId);
                            exists = (int)check.ExecuteScalar();
                        }

                        if (exists > 0)
                        {
                            using (SqlCommand del = new SqlCommand(@"
                                DELETE FROM wishlist_items
                                WHERE user_id=@uid AND product_id=@pid", conn))
                            {
                                del.Parameters.AddWithValue("@uid", userId);
                                del.Parameters.AddWithValue("@pid", productId);
                                del.ExecuteNonQuery();
                            }
                            ShowMessage("💔 تم الحذف من المفضلة", isError: false);
                        }
                        else
                        {
                            using (SqlCommand ins = new SqlCommand(@"
                                INSERT INTO wishlist_items (user_id, product_id)
                                VALUES (@uid, @pid)", conn))
                            {
                                ins.Parameters.AddWithValue("@uid", userId);
                                ins.Parameters.AddWithValue("@pid", productId);
                                ins.ExecuteNonQuery();
                            }
                            ShowMessage("❤️ تمت الإضافة إلى المفضلة", isError: false);
                        }
                    }
                }
                catch (Exception ex)
                {
                    ShowMessage("حدث خطأ: " + ex.Message, isError: true);
                }

                ReloadProducts();
                upProducts.Update();
                upMsg.Update();
            }
        }

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
            const string placeholder = "~/images/no-image.png";

            if (images == null || images == DBNull.Value)
                return ResolveUrl(placeholder);

            string raw = images.ToString().Trim();
            if (string.IsNullOrEmpty(raw))
                return ResolveUrl(placeholder);

            // JSON array ["img1.jpg","img2.jpg"]
            if (raw.StartsWith("["))
            {
                int start = raw.IndexOf('"');
                int end = raw.IndexOf('"', start + 1);
                if (start >= 0 && end > start)
                {
                    string first = raw.Substring(start + 1, end - start - 1).Trim();
                    return string.IsNullOrEmpty(first) ? ResolveUrl(placeholder) : first;
                }
            }

            // مفصول بفاصلة
            if (raw.Contains(","))
                return raw.Split(',')[0].Trim();

            // مسار واحد
            return raw;
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

        private void ShowMessage(string text, bool isError)
        {
            lblMsg.Text = text;
            lblMsg.Visible = true;
            lblMsg.Style["background"] = isError ? "#ffeaea" : "#eaffea";
            lblMsg.Style["color"] = isError ? "#c0392b" : "#27ae60";
            lblMsg.Style["border"] = isError ? "1px solid #f5c6cb" : "1px solid #c3e6cb";
        }

        protected void txtMinPrice_TextChanged(object sender, EventArgs e) { }
    }
}