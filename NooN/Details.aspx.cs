using System;
using System.Configuration;
using System.Data;
using System.Data.SqlClient;
using System.Text;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace NooN
{
    public partial class Details : Page
    {
        private string connStr = Db.ConnectionString;
        private int _productId = 0;

        // ═══════════════════════════════════════════
        // Page Load
        // ═══════════════════════════════════════════
        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                if (!int.TryParse(Request.QueryString["id"], out _productId) || _productId <= 0)
                { ShowNotFound(); return; }

                hfProductId.Value = _productId.ToString();
                LoadProduct();
                LoadReviews();
            }
            else
            {
                if (!int.TryParse(hfProductId.Value, out _productId))
                { ShowNotFound(); return; }
            }
        }

        // ═══════════════════════════════════════════
        // تحميل بيانات المنتج
        // ═══════════════════════════════════════════
        private void LoadProduct()
        {
            using (SqlConnection conn = new SqlConnection(connStr))
            {
                string sql = @"
            SELECT
                p.product_id, p.name, p.description,
                p.price, p.old_price, p.discount_pct,
                p.brand, p.sku, p.rating_avg, p.rating_count,
                p.status, p.available_colors, p.available_sizes, p.images,
                ISNULL(i.available_qty, 0) AS stock_quantity,
                ISNULL(c.name_ar, N'بدون فئة') AS category_name
            FROM products p
            LEFT JOIN product_categories c ON p.category_id = c.category_id
            LEFT JOIN inventory i ON i.product_id = p.product_id
            WHERE p.product_id = @pid";

                using (SqlCommand cmd = new SqlCommand(sql, conn))
                {
                    cmd.Parameters.AddWithValue("@pid", _productId);
                    conn.Open();

                    using (SqlDataReader dr = cmd.ExecuteReader())
                    {
                    if (!dr.Read())
                    {
                        ShowNotFound();
                        return;
                    }

                    // ─────────────── المنتج الأساسي ───────────────
                    ViewState["productId"] = _productId;
                    hfProductId.Value = _productId.ToString();

                    // ── المفضلة (Wishlist) ──
                    bool isFav = false;

                    if (Session["user_id"] != null)
                    {
                        int userId = Convert.ToInt32(Session["user_id"]);

                        using (SqlConnection favConn = new SqlConnection(connStr))
                        {
                            string favSql = @"
                        SELECT COUNT(1)
                        FROM wishlist_items
                        WHERE user_id = @uid AND product_id = @pid";

                            using (SqlCommand favCmd = new SqlCommand(favSql, favConn))
                            {
                                favCmd.Parameters.AddWithValue("@uid", userId);
                                favCmd.Parameters.AddWithValue("@pid", _productId);

                                favConn.Open();
                                isFav = (int)favCmd.ExecuteScalar() > 0;
                            }
                        }
                    }

                    // Initial favorite state; toggled client-side afterwards.
                    btnFav.InnerText = isFav ? "❤️" : "🤍";
                    btnFav.Attributes["data-pid"] = _productId.ToString();

                    // ── Breadcrumb ──
                    string catName = dr["category_name"].ToString();
                    lblBreadCategory.Text = catName;
                    lblBreadProduct.Text = dr["name"].ToString();

                    // ── Brand / Name / SKU ──
                    string brand = dr["brand"] != DBNull.Value ? dr["brand"].ToString() : "";
                    litBrand.Text = !string.IsNullOrEmpty(brand) ? brand : "&nbsp;";
                    litName.Text = dr["name"].ToString();
                    litSku.Text = dr["sku"].ToString();
                    litCategory.Text = catName;

                    // ── Product image gallery ──
                    string prodName = Server.HtmlEncode(dr["name"].ToString());
                    var imageUrls = ProductImage.AllUrls(dr["images"]);
                    if (imageUrls.Count == 0)
                        imageUrls.Add(ProductImage.Placeholder);

                    litMainImage.Text =
                        "<img id=\"galleryMainImg\" src=\"" + imageUrls[0] + "\" alt=\"" + prodName +
                        "\" class=\"gallery-main-img\" onerror=\"this.onerror=null;this.src='" +
                        ProductImage.Placeholder + "'\" />";

                    var thumbs = new System.Text.StringBuilder();
                    for (int i = 0; i < imageUrls.Count; i++)
                    {
                        thumbs.Append("<div class=\"gallery-thumb" + (i == 0 ? " active" : "") + "\">");
                        thumbs.Append("<img src=\"" + imageUrls[i] + "\" data-full=\"" + imageUrls[i] + "\" alt=\"\" />");
                        thumbs.Append("</div>");
                    }
                    litThumbs.Text = thumbs.ToString();

                    // ── Rating ──
                    double ratingAvg = dr["rating_avg"] != DBNull.Value ? Convert.ToDouble(dr["rating_avg"]) : 0;
                    int ratingCount = dr["rating_count"] != DBNull.Value ? Convert.ToInt32(dr["rating_count"]) : 0;

                    int fullStars = (int)Math.Round(ratingAvg);
                    string stars = "";
                    for (int i = 1; i <= 5; i++)
                        stars += i <= fullStars ? "★" : "☆";

                    litStars.Text = stars;
                    litRatingAvg.Text = ratingAvg.ToString("0.0");
                    litRatingCount.Text = ratingCount.ToString("N0");

                    // ── Status ──
                    string status = dr["status"].ToString().ToLower();

                    if (status == "active")
                        litStockStatus.Text = "<span class='in-stock'>✓ متوفر في المخزن</span>";
                    else if (status == "out_of_stock")
                        litStockStatus.Text = "<span class='out-stock'>✗ غير متوفر</span>";
                    else
                        litStockStatus.Text = "<span style='color:var(--muted)'>غير نشط</span>";

                    if (status == "active")
                        litStatusBadge.Text = "<span class='gallery-status status-active'>متوفر ✓</span>";
                    else if (status == "out_of_stock")
                        litStatusBadge.Text = "<span class='gallery-status status-out_of_stock'>غير متوفر</span>";

                    btnAddToCart.Disabled = (status != "active");
                    btnAddToCart.Attributes["data-pid"] = _productId.ToString();

                    // ── Price ──
                    decimal price = Convert.ToDecimal(dr["price"]);
                    decimal discPct = dr["discount_pct"] != DBNull.Value ? Convert.ToDecimal(dr["discount_pct"]) : 0;

                    litPrice.Text = price.ToString("N0");

                    if (discPct > 0)
                        litDiscLabel.Text = $"<span class='detail-discount'>-{discPct:0}%</span>";

                    if (dr["old_price"] != DBNull.Value)
                    {
                        decimal old = Convert.ToDecimal(dr["old_price"]);
                        litOldPrice.Text = $"<span class='detail-old-price'>{old:N0} ر.س</span>";
                    }

                    if (discPct > 0)
                        litDiscBadge.Text = $"<span class='gallery-badge'>-{discPct:0}%</span>";

                    // ── Description ──
                    string desc = dr["description"] != DBNull.Value ? dr["description"].ToString() : "";
                    litDesc.Text = !string.IsNullOrEmpty(desc)
                        ? desc
                        : "منتج عالي الجودة بتصميم أنيق ومواصفات رائدة.";

                    // ── Colors ──
                    string availColors = dr["available_colors"] != DBNull.Value
                        ? dr["available_colors"].ToString().Trim()
                        : "";

                    if (!string.IsNullOrEmpty(availColors))
                    {
                        pnlColors.Visible = true;
                        var sb = new StringBuilder();

                        foreach (string c in availColors.Split(','))
                        {
                            string col = c.Trim();
                            if (!string.IsNullOrEmpty(col))
                                sb.Append($"<button type='button' class='color-btn' data-color='{col}' onclick='pickColor(this)'>{col}</button>");
                        }

                        colorOptions.InnerHtml = sb.ToString();
                    }
                    else pnlColors.Visible = false;

                    // ── Sizes ──
                    string availSizes = dr["available_sizes"] != DBNull.Value
                        ? dr["available_sizes"].ToString().Trim()
                        : "";

                    if (!string.IsNullOrEmpty(availSizes))
                    {
                        pnlSizes.Visible = true;
                        var sb2 = new StringBuilder();

                        foreach (string s in availSizes.Split(','))
                        {
                            string sz = s.Trim();
                            if (!string.IsNullOrEmpty(sz))
                                sb2.Append($"<button type='button' class='size-btn' data-size='{sz}' onclick='pickSize(this)'>{sz}</button>");
                        }

                        sizeOptions.InnerHtml = sb2.ToString();
                    }
                    else pnlSizes.Visible = false;
                    }
                }
            }

            // ── إظهار الصفحة ──
            pnlDetail.Visible = true;
            pnlNotFound.Visible = false;
        }

        // ═══════════════════════════════════════════
        // تحميل التقييمات
        // ═══════════════════════════════════════════
        private void LoadReviews()
        {
            using (SqlConnection conn = new SqlConnection(connStr))
            {
                string sql = @"
                    SELECT r.rating, r.comment, r.created_at,
                           u.first_name + ' ' + u.last_name AS full_name
                    FROM reviews r
                    INNER JOIN users u ON r.user_id = u.user_id
                    WHERE r.product_id = @pid
                    ORDER BY r.created_at DESC";

                using (SqlCommand cmd = new SqlCommand(sql, conn))
                {
                    cmd.Parameters.AddWithValue("@pid", _productId);
                    using (SqlDataAdapter da = new SqlDataAdapter(cmd))
                    {
                        DataTable dt = new DataTable();
                        da.Fill(dt);
                        rptReviews.DataSource = dt;
                        rptReviews.DataBind();
                    }
                }
            }
        }

        // ═══════════════════════════════════════════
        // ItemDataBound — Reviews Repeater
        // ═══════════════════════════════════════════
        protected void rptReviews_ItemDataBound(object sender, RepeaterItemEventArgs e)
        {
            if (e.Item.ItemType != ListItemType.Item &&
                e.Item.ItemType != ListItemType.AlternatingItem) return;

            DataRowView row = (DataRowView)e.Item.DataItem;

            ((Literal)e.Item.FindControl("litUser")).Text = row["full_name"].ToString();

            var litDate = (Literal)e.Item.FindControl("litDate");
            if (row["created_at"] != DBNull.Value)
                litDate.Text = Convert.ToDateTime(row["created_at"]).ToString("yyyy/MM/dd");

            int rating = Convert.ToInt32(row["rating"]);
            string s = "";
            for (int i = 1; i <= 5; i++) s += i <= rating ? "★" : "☆";
            ((Literal)e.Item.FindControl("litRevStars")).Text = s;

            string comment = row["comment"] != DBNull.Value ? row["comment"].ToString() : "";
            ((Literal)e.Item.FindControl("litComment")).Text =
                !string.IsNullOrEmpty(comment) ? comment : "—";
        }

        // Add-to-cart and favorite toggling are handled client-side via
        // fetch() against ShopService.ashx (see Scripts/noon-shop.js).

        // ═══════════════════════════════════════════
        // إرسال تقييم
        // ═══════════════════════════════════════════
        protected void btnSubmitReview_Click(object sender, EventArgs e)
        {
            _productId = Convert.ToInt32(ViewState["productId"]);

            if (Session["user_id"] == null)
            {
                ShowMsg(lblReviewMsg, "يرجى تسجيل الدخول لإضافة تقييم.", isError: true);
                ReloadAll(); return;
            }

            int userId = Convert.ToInt32(Session["user_id"]);

            if (!int.TryParse(hfRating.Value, out int rating) || rating < 1 || rating > 5)
            {
                ShowMsg(lblReviewMsg, "يرجى اختيار تقييم من 1 إلى 5 نجوم.", isError: true);
                ReloadAll(); return;
            }

            string comment = txtComment.Text.Trim();

            try
            {
                using (SqlConnection conn = new SqlConnection(connStr))
                {
                    conn.Open();

                    // تحقق إن المستخدم لم يقيّم سابقاً
                    using (SqlCommand chk = new SqlCommand(@"
                        SELECT COUNT(1) FROM reviews
                        WHERE user_id = @uid AND product_id = @pid", conn))
                    {
                        chk.Parameters.AddWithValue("@uid", userId);
                        chk.Parameters.AddWithValue("@pid", _productId);
                        if ((int)chk.ExecuteScalar() > 0)
                        {
                            ShowMsg(lblReviewMsg, "لقد قيّمت هذا المنتج سابقاً.", isError: true);
                            ReloadAll(); return;
                        }
                    }

                    using (SqlCommand ins = new SqlCommand(@"
                        INSERT INTO reviews (user_id, product_id, rating, comment, created_at)
                        VALUES (@uid, @pid, @rating, @comment, GETDATE())", conn))
                    {
                        ins.Parameters.AddWithValue("@uid", userId);
                        ins.Parameters.AddWithValue("@pid", _productId);
                        ins.Parameters.AddWithValue("@rating", rating);
                        ins.Parameters.AddWithValue("@comment",
                            string.IsNullOrEmpty(comment) ? (object)DBNull.Value : comment);
                        ins.ExecuteNonQuery();
                    }

                    // حدّث rating_avg و rating_count
                    using (SqlCommand upd = new SqlCommand(@"
                        UPDATE products
                           SET rating_avg   = (SELECT AVG(CAST(rating AS decimal(3,2)))
                                               FROM reviews WHERE product_id = @pid),
                               rating_count = (SELECT COUNT(*) FROM reviews WHERE product_id = @pid),
                               updated_at   = GETDATE()
                         WHERE product_id = @pid", conn))
                    {
                        upd.Parameters.AddWithValue("@pid", _productId);
                        upd.ExecuteNonQuery();
                    }
                }

                ShowMsg(lblReviewMsg, "✅ شكراً! تم إرسال تقييمك بنجاح.", isError: false);
                txtComment.Text = "";
                hfRating.Value = "0";
            }
            catch (Exception ex)
            {
                ShowMsg(lblReviewMsg, "حدث خطأ: " + ex.Message, isError: true);
            }

            ReloadAll();
        }

        // ═══════════════════════════════════════════
        // دوال مساعدة
        // ═══════════════════════════════════════════
        private void ShowNotFound()
        {
            pnlNotFound.Visible = true;
            pnlDetail.Visible = false;
        }

        private void ReloadAll()
        {
            LoadProduct();
            LoadReviews();
        }

        private void ShowMsg(Label lbl, string text, bool isError)
        {
            lbl.Text = text;
            lbl.CssClass = "detail-msg " + (isError ? "error" : "success");
        }
    }
}