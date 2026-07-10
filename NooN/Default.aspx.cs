using System;
using System.Data;
using System.Data.SqlClient;
using System.Configuration;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace NooN
{
    public partial class _Default : Page
    {
        // ──────────────────────────────────────────
        // Connection string from Web.config
        // ──────────────────────────────────────────
        private readonly string _connStr = Db.ConnectionString;

        // Cache key for the home-page category list. Referenced by admin pages
        // (e.g. Proudct_Categories) to invalidate the cache after changes.
        public const string CategoriesCacheKey = "home_categories";

        // ──────────────────────────────────────────
        // Icon map keyed by the English category name.
        // Adjust these or add an icon column to the table.
        // ──────────────────────────────────────────
        private static readonly System.Collections.Generic.Dictionary<string, string> CategoryIcons =
            new System.Collections.Generic.Dictionary<string, string>(System.StringComparer.OrdinalIgnoreCase)
            {
                { "electronics",    "📱" },
                { "tech",           "💻" },
                { "fashion",        "👗" },
                { "clothing",       "👕" },
                { "home",           "🏠" },
                { "furniture",      "🛋️" },
                { "sports",         "⚽" },
                { "beauty",         "💄" },
                { "books",          "📚" },
                { "toys",           "🧸" },
                { "food",           "🍔" },
                { "jewelry",        "💎" },
            };

        // ══════════════════════════════════════════
        //  Page_Load
        // ══════════════════════════════════════════
        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                LoadCategories();
                LoadWishlistProducts();
            }
        }

        // ══════════════════════════════════════════
        //  Load active categories (up to 8)
        // ══════════════════════════════════════════
        private void LoadCategories()
        {
            try
            {
                DataTable dt = GetCategories();

                if (dt.Rows.Count == 0)
                    pnlNoCats.Visible = true;

                rptCategories.DataSource = dt;
                rptCategories.DataBind();
            }
            catch (Exception ex)
            {
                // Log the error and show an empty state instead of breaking the page.
                System.Diagnostics.Debug.WriteLine("LoadCategories Error: " + ex.Message);
                pnlNoCats.Visible = true;
            }
        }

        // Categories rarely change, so cache the computed list (icons included)
        // for all users to avoid a DB round-trip on every home-page load.
        private DataTable GetCategories()
        {
            DataTable cached = Cache[CategoriesCacheKey] as DataTable;
            if (cached != null)
                return cached;

            const string sql = @"
                SELECT TOP 8
                    category_id,
                    name_ar,
                    name_en
                FROM product_categories
                WHERE is_active = 1
                ORDER BY created_at DESC";

            var dt = new DataTable();
            using (var con = new SqlConnection(_connStr))
            using (var cmd = new SqlCommand(sql, con))
            {
                con.Open();
                dt.Load(cmd.ExecuteReader());
            }

            // Add an icon column computed from name_en
            dt.Columns.Add("icon", typeof(string));
            foreach (DataRow row in dt.Rows)
            {
                string nameEn = row["name_en"]?.ToString() ?? "";
                row["icon"] = ResolveIcon(nameEn);
            }

            Cache.Insert(
                CategoriesCacheKey, dt, null,
                DateTime.Now.AddMinutes(30),
                System.Web.Caching.Cache.NoSlidingExpiration);

            return dt;
        }

        // ══════════════════════════════════════════
        //  Load featured (wishlist) products (up to 8)
        // ══════════════════════════════════════════
        private void LoadWishlistProducts()
        {
            // The user must be logged in.
            if (Session["user_id"] == null)
            {
                pnlNoProducts.Visible = true;
                rptProducts.DataSource = null;
                rptProducts.DataBind();
                return;
            }

            int userId = Convert.ToInt32(Session["user_id"]);

            const string sql = @"
        SELECT 
            p.product_id,
            p.name,
            p.price,
            p.old_price,
            p.discount_pct,
            p.rating_avg,
            p.rating_count,
            p.images,
            c.name_ar AS category_name
        FROM wishlist_items w
        INNER JOIN products p ON w.product_id = p.product_id
        INNER JOIN product_categories c ON p.category_id = c.category_id
        WHERE w.user_id = @user_id
          AND p.status = 'active'
          AND c.is_active = 1
        ORDER BY w.added_at DESC";

            try
            {
                using (var con = new SqlConnection(_connStr))
                using (var cmd = new SqlCommand(sql, con))
                {
                    cmd.Parameters.AddWithValue("@user_id", userId);

                    con.Open();
                    var dt = new DataTable();
                    dt.Load(cmd.ExecuteReader());

                    pnlNoProducts.Visible = dt.Rows.Count == 0;

                    rptProducts.DataSource = dt;
                    rptProducts.DataBind();
                }
            }

            catch (Exception ex)
            {
                System.Diagnostics.Debug.WriteLine("LoadWishlistProducts Error: " + ex.Message);
                pnlNoProducts.Visible = true;
            }
        }
        // ══════════════════════════════════════════
        //  Helper Methods (called from the ASPX)
        // ══════════════════════════════════════════

        /// <summary>
        /// Returns the category icon based on name_en.
        /// Falls back to a default icon when there is no match.
        /// </summary>
        private static string ResolveIcon(string nameEn)
        {
            if (string.IsNullOrWhiteSpace(nameEn))
                return "🛍️";

            // Partial match: it's enough for the name to contain the keyword.
            foreach (var kvp in CategoryIcons)
                if (nameEn.IndexOf(kvp.Key, StringComparison.OrdinalIgnoreCase) >= 0)
                    return kvp.Value;

            return "🛍️";
        }

        /// <summary>
        /// Returns an img tag when an image exists, otherwise a span with an emoji.
        /// The images field is stored as a JSON array: ["img1.jpg","img2.jpg"]
        /// or as a direct path: "uploads/img1.jpg".
        /// </summary>
        protected string GetProductImage(object imagesObj)
        {
            string images = imagesObj?.ToString() ?? "";

            if (!string.IsNullOrWhiteSpace(images))
            {
                // Extract the first image from a simple JSON array without an external library.
                string first = images.Trim();
                if (first.StartsWith("["))
                {
                    // Remove [ ], whitespace and quotes.
                    first = first.TrimStart('[').TrimEnd(']');
                    int comma = first.IndexOf(',');
                    if (comma > 0) first = first.Substring(0, comma);
                    first = first.Trim().Trim('"').Trim('\'');
                }

                if (!string.IsNullOrWhiteSpace(first))
                    return $"<img src='{ResolveUrl("~/" + first)}' alt='منتج' class='product-img' loading='lazy' />";
            }

            return "<span class='product-emoji'>🛍️</span>";
        }

        /// <summary>
        /// Returns the discount badge when the value is greater than zero.
        /// </summary>
        protected string GetDiscountBadge(object discountObj)
        {
            if (discountObj == null || discountObj == DBNull.Value)
                return "";

            decimal disc = Convert.ToDecimal(discountObj);
            if (disc <= 0) return "";

            return $"<span class='product-badge'>-{disc:0.#}%</span>";
        }

        /// <summary>
        /// Returns the old price (struck through) when present.
        /// </summary>
        protected string GetOldPrice(object oldPriceObj)
        {
            if (oldPriceObj == null || oldPriceObj == DBNull.Value)
                return "";

            decimal old = Convert.ToDecimal(oldPriceObj);
            if (old <= 0) return "";

            return $"<span class='product-old-price'>{old:N2}</span>";
        }

        /// <summary>
        /// Returns HTML stars based on the average rating (0-5).
        /// </summary>
        protected string GetStars(object ratingObj)
        {
            decimal rating = 0;
            if (ratingObj != null && ratingObj != DBNull.Value)
                decimal.TryParse(ratingObj.ToString(), out rating);

            int full = (int)Math.Floor(rating);         // Full stars
            bool half = (rating - full) >= 0.5m;          // Half star
            int empty = 5 - full - (half ? 1 : 0);        // Empty stars

            string stars = new string('★', full)
                         + (half ? "½" : "")
                         + new string('☆', empty);

            return $"<span class='stars' title='{rating:0.0}'>{stars}</span>";
        }

        // ══════════════════════════════════════════
        //  Favorite toggle (async postback from rptProducts)
        // ══════════════════════════════════════════
        protected void rptProducts_ItemCommand(object source, RepeaterCommandEventArgs e)
        {
            if (e.CommandName != "ToggleFav")
                return;

            if (Session["user_id"] == null)
            {
                Response.Redirect("LoginUser.aspx");
                return;
            }

            int userId = Convert.ToInt32(Session["user_id"]);
            int productId = Convert.ToInt32(e.CommandArgument);

            // The home page lists wishlist items, so toggling removes the item.
            try
            {
                using (var con = new SqlConnection(_connStr))
                using (var cmd = new SqlCommand(
                    "DELETE FROM wishlist_items WHERE user_id = @uid AND product_id = @pid", con))
                {
                    cmd.Parameters.AddWithValue("@uid", userId);
                    cmd.Parameters.AddWithValue("@pid", productId);
                    con.Open();
                    cmd.ExecuteNonQuery();
                }
            }
            catch (Exception ex)
            {
                System.Diagnostics.Debug.WriteLine("ToggleFav Error: " + ex.Message);
            }

            // Rebind and refresh only the products panel.
            LoadWishlistProducts();
            upProducts.Update();
        }

        // ══════════════════════════════════════════
        //  Button events
        // ══════════════════════════════════════════
        protected void btnShopNow_Click(object sender, EventArgs e)
        {
            Response.Redirect("Prouduct.aspx");
        }

        protected void btnTest_Click(object sender, EventArgs e)
        {
            Response.Redirect("/Report.aspx");
        }
    }
}