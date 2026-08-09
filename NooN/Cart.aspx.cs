using System;
using System.Collections.Generic;
using System.Data;
using System.Data.SqlClient;
using System.Configuration;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace NooN
{
    public partial class Cart : Page
    {
        // Pricing rules (VAT, shipping, currency) come from the shared StoreConfig,
        // and coupons are resolved from the coupons DB table via CouponHelper — so
        // the cart and checkout always agree.

        // ===== Connection String =====
        private string ConnStr => Db.ConnectionString;

        // ===== معرف المستخدم من الـ Session (يُستبدل بالـ Auth الحقيقي لاحقاً) =====
        private int CurrentUserId
        {
            get
            {
                if (Session["user_id"] != null && int.TryParse(Session["user_id"].ToString(), out int uid))
                    return uid;
                return 0; // 0 = غير مسجل دخول
            }
        }

        // ===== كود الخصم المطبق في الـ Session =====
        private string AppliedCoupon
        {
            get => Session["AppliedCoupon"]?.ToString() ?? "";
            set => Session["AppliedCoupon"] = value;
        }

        // ===========================================================
        // Page_Load
        // ===========================================================
        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                // استعادة الكوبون المطبق إن وجد
                if (!string.IsNullOrEmpty(AppliedCoupon))
                    txtCoupon.Text = AppliedCoupon;

                LoadCart();
            }
        }

        // ===========================================================
        // تحميل السلة من قاعدة البيانات
        // ===========================================================
        private void LoadCart()
        {
            if (CurrentUserId == 0)
            {
                ShowEmptyCart();
                return;
            }
   

            DataTable dt = GetCartItems(CurrentUserId);

            if (dt == null || dt.Rows.Count == 0)
            {
                ShowEmptyCart();
                return;
            }

            // عرض السلة
            pnlEmptyCart.Visible = false;
            pnlCart.Visible = true;

            rptCartItems.DataSource = dt;
            rptCartItems.DataBind();

            // حساب الإجماليات
            CalculateTotals(dt);

            // عدد المنتجات
            litItemCount.Text = dt.Rows.Count.ToString();
        }

        // ===========================================================
        // استعلام DB – جلب عناصر السلة مع تفاصيل المنتجات
        // ===========================================================
        private DataTable GetCartItems(int userId)
        {
            DataTable dt = new DataTable();
            string sql = @"
                select
                    ci.cart_item_id,
                    ci.quantity,
                    ci.color,
                    ci.size,
                    p.product_id,
                    p.name,
                    p.brand,
                    p.price,
                    p.old_price,
                    p.images,
                    ISNULL(i.available_qty, 0) AS stock_quantity,
                    (ci.quantity * p.price) AS item_total
                FROM cart_items ci
                INNER JOIN carts c   ON ci.cart_id = c.cart_id
                INNER JOIN products p ON ci.product_id = p.product_id
                LEFT JOIN inventory i ON i.product_id = p.product_id
                WHERE c.user_id = @userId
                ORDER BY ci.added_at DESC";

            try
            {
                using (var con = new SqlConnection(ConnStr))
                using (var cmd = new SqlCommand(sql, con))
                {
                    cmd.Parameters.AddWithValue("@userId", userId);
                    con.Open();
                    using (var da = new SqlDataAdapter(cmd))
                        da.Fill(dt);
                }
            }
            catch (Exception ex)
            {
                System.Diagnostics.Trace.TraceError("Cart.GetCartItems: " + ex);
                ShowError("حدث خطأ أثناء تحميل السلة، يرجى المحاولة مجدداً.");
            }

            return dt;
        }

        // ===========================================================
        // حساب الإجماليات
        // ===========================================================
        private void CalculateTotals(DataTable dt)
        {
            decimal subtotal = 0;
            foreach (DataRow row in dt.Rows)
                subtotal += Convert.ToDecimal(row["item_total"]);

            // خصم الكوبون — يُحل من جدول coupons عبر CouponHelper
            decimal discountAmount = 0;
            if (!string.IsNullOrEmpty(AppliedCoupon))
            {
                var coupon = CouponHelper.Resolve(AppliedCoupon, subtotal);
                if (coupon.IsValid)
                {
                    discountAmount = coupon.DiscountAmount;
                    pnlDiscountRow.Visible = true;
                    litCouponCode.Text = $"({AppliedCoupon})";
                    litDiscount.Text = FormatPrice(discountAmount);
                }
                else
                {
                    // Coupon no longer valid (expired/deactivated/below min) — drop it.
                    pnlDiscountRow.Visible = false;
                }
            }
            else
            {
                pnlDiscountRow.Visible = false;
            }

            decimal afterDiscount = subtotal - discountAmount;

            // الشحن
            decimal shipping = StoreConfig.ShippingFor(afterDiscount);
            litShipping.Text = shipping == 0 ? "مجاني ✓" : $"{shipping:N0} {StoreConfig.Currency}";

            // الضريبة
            decimal vat = Math.Round(afterDiscount * StoreConfig.VatRate, 2);
            decimal total = afterDiscount + shipping + vat;

            litSubtotal.Text = FormatPrice(subtotal);
            litVat.Text = FormatPrice(vat);
            litTotal.Text = FormatPrice(total);
        }

        // ===========================================================
        // Repeater – أوامر (زيادة / نقص / حذف)
        // ===========================================================
        protected void rptCartItems_ItemCommand(object source, RepeaterCommandEventArgs e)
        {
            if (!int.TryParse(e.CommandArgument?.ToString(), out int cartItemId))
                return;

            switch (e.CommandName)
            {
                case "Increase": ChangeQuantity(cartItemId, +1); break;
                case "Decrease": ChangeQuantity(cartItemId, -1); break;
                case "Remove": RemoveItem(cartItemId); break;
            }

            LoadCart();
            (this.Master as NooN.ISiteMaster)?.RefreshCartBadge();
        }

        // ===========================================================
        // تغيير الكمية
        // ===========================================================
        private void ChangeQuantity(int cartItemId, int delta)
        {
            // احصل على الكمية الحالية والمخزون
            string selectSql = @"
               SELECT ci.quantity, ISNULL(i.available_qty, 0) AS stock_quantity
        FROM cart_items ci
        INNER JOIN products p ON ci.product_id = p.product_id
        LEFT JOIN inventory i ON i.product_id = p.product_id
        WHERE ci.cart_item_id = @id 
        AND EXISTS (
            SELECT 1 FROM carts c 
            WHERE c.cart_id = ci.cart_id AND c.user_id = @userId
                )";

            try
            {
                using (var con = new SqlConnection(ConnStr))
                {
                    con.Open();

                    int currentQty = 0, stock = 0;
                    using (var cmd = new SqlCommand(selectSql, con))
                    {
                        cmd.Parameters.AddWithValue("@id", cartItemId);
                        cmd.Parameters.AddWithValue("@userId", CurrentUserId);
                        using (var rdr = cmd.ExecuteReader())
                        {
                            if (rdr.Read())
                            {
                                currentQty = Convert.ToInt32(rdr["quantity"]);
                                stock = Convert.ToInt32(rdr["stock_quantity"]);
                            }
                            else return; // المنتج ليس للمستخدم الحالي
                        }
                    }

                    int newQty = currentQty + delta;

                    if (newQty <= 0)
                    {
                        // الكمية أصبحت صفر → احذف العنصر
                        RemoveItem(cartItemId);
                        return;
                    }

                    if (newQty > stock)
                    {
                        ShowError("لا يوجد مخزون كافٍ لهذا المنتج.");
                        return;
                    }

                    string updateSql = @"
                        UPDATE cart_items SET quantity = @qty
                        WHERE cart_item_id = @id";

                    using (var cmd2 = new SqlCommand(updateSql, con))
                    {
                        cmd2.Parameters.AddWithValue("@qty", newQty);
                        cmd2.Parameters.AddWithValue("@id", cartItemId);
                        cmd2.ExecuteNonQuery();
                    }

                    // تحديث updated_at في carts
                    UpdateCartTimestamp(con);
                }
            }
            catch (Exception ex)
            {
                System.Diagnostics.Trace.TraceError("Cart.ChangeQuantity: " + ex);
                ShowError("تعذّر تحديث الكمية، يرجى المحاولة مجدداً.");
            }
        }

        // ===========================================================
        // حذف عنصر
        // ===========================================================
        private void RemoveItem(int cartItemId)
        {
            string sql = @"
                DELETE ci FROM cart_items ci
                INNER JOIN carts c ON ci.cart_id = c.cart_id
                WHERE ci.cart_item_id = @id AND c.user_id = @userId";

            try
            {
                using (var con = new SqlConnection(ConnStr))
                using (var cmd = new SqlCommand(sql, con))
                {
                    cmd.Parameters.AddWithValue("@id", cartItemId);
                    cmd.Parameters.AddWithValue("@userId", CurrentUserId);
                    con.Open();
                    cmd.ExecuteNonQuery();
                    UpdateCartTimestamp(con);
                }
                ShowSuccess("تم حذف المنتج من السلة.");
            }
            catch (Exception ex)
            {
                System.Diagnostics.Trace.TraceError("Cart.RemoveItem: " + ex);
                ShowError("تعذّر حذف المنتج، يرجى المحاولة مجدداً.");
            }
        }

        // ===========================================================
        // إفراغ السلة
        // ===========================================================
        protected void btnClearCart_Click(object sender, EventArgs e)
        {
            string sql = @"
                DELETE ci FROM cart_items ci
                INNER JOIN carts c ON ci.cart_id = c.cart_id
                WHERE c.user_id = @userId";

            try
            {
                using (var con = new SqlConnection(ConnStr))
                using (var cmd = new SqlCommand(sql, con))
                {
                    cmd.Parameters.AddWithValue("@userId", CurrentUserId);
                    con.Open();
                    cmd.ExecuteNonQuery();
                }
                AppliedCoupon = "";
                ShowSuccess("تم إفراغ السلة بنجاح.");
                (this.Master as NooN.ISiteMaster)?.RefreshCartBadge();
            }
            catch (Exception ex)
            {
                System.Diagnostics.Trace.TraceError("Cart.ClearCart: " + ex);
                ShowError("تعذّر إفراغ السلة، يرجى المحاولة مجدداً.");
            }

            LoadCart();

        }

        // ===========================================================
        // تطبيق كود الخصم
        // ===========================================================
        protected void btnApplyCoupon_Click(object sender, EventArgs e)
        {
            string code = txtCoupon.Text.Trim();

            if (string.IsNullOrEmpty(code))
            {
                ShowCouponMsg("⚠️ أدخل كود الخصم أولاً.", false);
                return;
            }

            // Compute the current subtotal so the coupon's minimum-order rule can
            // be checked, then resolve against the coupons DB table.
            decimal subtotal = 0;
            DataTable dt = GetCartItems(CurrentUserId);
            if (dt != null)
                foreach (DataRow r in dt.Rows)
                    subtotal += Convert.ToDecimal(r["item_total"]);

            var coupon = CouponHelper.Resolve(code, subtotal);
            AppliedCoupon = coupon.IsValid ? coupon.Code : "";
            ShowCouponMsg(coupon.Message, coupon.IsValid);

            LoadCart();
        }

        // ===========================================================
        // متابعة للدفع
        // ===========================================================
        protected void btnCheckout_Click(object sender, EventArgs e)
        {
            if (CurrentUserId == 0)
            {
                Response.Redirect("Login.aspx?returnUrl=Cart.aspx");
                return;
            }

            // تمرير الكوبون المطبق للـ Session ليستخدمه checkout.aspx
            Session["CheckoutCoupon"] = AppliedCoupon;
            Response.Redirect("checkout.aspx");
        }

        // ===========================================================
        // دوال مساعدة
        // ===========================================================

        private void UpdateCartTimestamp(SqlConnection openCon)
        {
            try
            {
                string sql = "UPDATE carts SET updated_at = GETDATE() WHERE user_id = @userId";
                using (var cmd = new SqlCommand(sql, openCon))
                {
                    cmd.Parameters.AddWithValue("@userId", CurrentUserId);
                    cmd.ExecuteNonQuery();
                }
            }
            catch (Exception ex)
            {
                // Timestamp update is non-critical; log but ignore any failure.
                System.Diagnostics.Trace.TraceError("UpdateCartTimestamp: " + ex.Message);
            }
        }

        private void ShowEmptyCart()
        {
            pnlEmptyCart.Visible = true;
            pnlCart.Visible = false;
        }

        private void ShowSuccess(string msg)
        {
            pnlSuccess.Visible = true;
            litSuccessMsg.Text = msg;
            pnlError.Visible = false;
        }

        private void ShowError(string msg)
        {
            pnlError.Visible = true;
            litErrorMsg.Text = msg;
            pnlSuccess.Visible = false;
        }

        private void ShowCouponMsg(string msg, bool success)
        {
            pnlCouponMsg.Visible = true;
            litCouponMsg.Text = $"<div class=\"alert {(success ? "alert-success" : "alert-danger")}\" style=\"margin-top:8px;\">{msg}</div>";
        }

        // يُستخدم في الـ Repeater لتنسيق الأسعار
        protected string FormatPrice(object val)
        {
            if (val == null || val == DBNull.Value) return "0";
            return Convert.ToDecimal(val).ToString("N2");
        }

        // يُستخدم في الـ Repeater لصورة المنتج
        protected string GetProductImage(object imageUrl)
        {
            string url = imageUrl?.ToString();
            return string.IsNullOrEmpty(url) ? "Content/images/no-image.png" : url;
        }
    }
}