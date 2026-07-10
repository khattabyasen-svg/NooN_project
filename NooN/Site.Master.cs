using System;
using System.Configuration;
using System.Data;
using System.Data.SqlClient;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace NooN
{
    public partial class SiteMaster : MasterPage
    {
        private static readonly string connStr =
            ConfigurationManager.ConnectionStrings["MyConnection"].ConnectionString;

        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
                BindCategories();

            UpdateCartBadge();
        }

        // ══ الفئات ══
        private void BindCategories()
        {
            using (SqlConnection con = new SqlConnection(connStr))
            {
                SqlCommand cmd = new SqlCommand(@"
                    SELECT category_id, name_ar
                    FROM   product_categories
                    WHERE  is_active = 1
                    ORDER BY name_ar", con);
                con.Open();
                ddlCategories.DataSource = cmd.ExecuteReader();
                ddlCategories.DataTextField = "name_ar";
                ddlCategories.DataValueField = "category_id";
                ddlCategories.DataBind();
            }
            ddlCategories.Items.Insert(0, new ListItem("🏷️ كل الفئات", "0"));
        }

        protected void ddlCategories_SelectedIndexChanged(object sender, EventArgs e)
        {
            //string catId = ddlCategories.SelectedValue;
            //Response.Redirect(catId != "0"
            //    ? "~/Prouduct.aspx?category_id=" + catId
            //    : "~/Prouduct.aspx");
        }

        // ══ بحث ══
        protected void btnSearch_Click(object sender, EventArgs e)
        {
            string q = txtSearch.Text.Trim();
            if (!string.IsNullOrEmpty(q))
                Response.Redirect("~/Prouduct.aspx?search=" + Server.UrlEncode(q));
        }

        // ══ زر السلة في Nav ══
        //protected void lnkCart_Click(object sender, EventArgs e)
        //{
        //    Response.Redirect("~/Cart.aspx");
        //}

        // ══ عداد السلة ══

        /// <summary>
        /// استدعيها من أي صفحة بعد الإضافة للسلة
        /// </summary>
        public void RefreshCartBadge()
        {
            if (Session["user_id"] == null) return;

            string cacheKey = "cart_count_" + Session["user_id"];
            HttpContext.Current.Cache.Remove(cacheKey);

            UpdateCartBadge();
            upCart.Update();
        }

        private void UpdateCartBadge()
        {
            if (Session["user_id"] == null)
            {
                lblCartBadge.Visible = false;
                return;
            }

            int userId = Convert.ToInt32(Session["user_id"]);
            string cacheKey = "cart_count_" + userId;
            int count;

            if (HttpContext.Current.Cache[cacheKey] != null)
            {
                count = (int)HttpContext.Current.Cache[cacheKey];
            }
            else
            {
                count = GetCartCountFromDB(userId);
                HttpContext.Current.Cache.Insert(
                    cacheKey, count, null,
                    DateTime.Now.AddMinutes(2),
                    System.Web.Caching.Cache.NoSlidingExpiration);
            }

            lblCartBadge.Text = count.ToString();
            lblCartBadge.Visible = count > 0;
        }

        private int GetCartCountFromDB(int userId)
        {
            try
            {
                using (SqlConnection conn = new SqlConnection(connStr))
                {
                    SqlCommand cmd = new SqlCommand(@"
                        SELECT ISNULL(SUM(ci.quantity), 0)
                        FROM   cart_items ci
                        INNER JOIN carts c ON ci.cart_id = c.cart_id
                        WHERE  c.user_id = @uid", conn);
                    cmd.Parameters.AddWithValue("@uid", userId);
                    conn.Open();
                    return (int)cmd.ExecuteScalar();
                }
            }
            catch (Exception ex)
            {
                System.Diagnostics.Trace.TraceError("CartBadge Error: " + ex.Message);
                return 0;
            }
        }
    }
}