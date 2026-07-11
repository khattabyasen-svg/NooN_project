using System;
using System.Collections.Generic;
using System.Data.SqlClient;
using System.Drawing;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace NooN
{
    // ── Model ──────────────────────────────────────────────────────────
    public class CartItemDisplay
    {
        public int ProductId { get; set; }
        public string ProductName { get; set; }
        public string Brand { get; set; }
        public string ImageUrl { get; set; }
        public string Color { get; set; }
        public string Size { get; set; }
        public int Quantity { get; set; }
        public decimal UnitPrice { get; set; }
        public decimal LineTotal { get { return UnitPrice * Quantity; } }
    }

    // ── Page ───────────────────────────────────────────────────────────
    public partial class checkout : System.Web.UI.Page
    {
        // Single session key used everywhere.
        private const string SESSION_USER = "user_id";

        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                if (Session[SESSION_USER] != null)
                    LoadUserDefaults((int)Session[SESSION_USER]);

                LoadCartItems();
            }
        }

        // ══════════════════════════════════════════════════════════════
        //  Load the cart from the DB
        // ══════════════════════════════════════════════════════════════
        private void LoadCartItems()
        {
            if (Session[SESSION_USER] == null)
            {
                Response.Redirect("LoginUser.aspx");
                return;
            }

            int userId = (int)Session[SESSION_USER];

            try
            {
                string cs = Db.ConnectionString;

                string sql = @"
                    SELECT  ci.product_id,
                            p.name      AS product_name,
                            p.brand,
                            p.price,
                            p.images,
                            ci.quantity,
                            ci.color,
                            ci.size
                    FROM    cart_items  ci
                    JOIN    carts       c  ON c.cart_id    = ci.cart_id
                    JOIN    products    p  ON p.product_id = ci.product_id
                    WHERE   c.user_id  = @uid
                      AND   p.status  = 'active'
                    ORDER BY ci.added_at DESC";

                var items = new List<CartItemDisplay>();

                using (var conn = new SqlConnection(cs))
                using (var cmd = new SqlCommand(sql, conn))
                {
                    cmd.Parameters.AddWithValue("@uid", userId);
                    conn.Open();

                    using (var dr = cmd.ExecuteReader())
                    {
                        while (dr.Read())
                        {
                            items.Add(new CartItemDisplay
                            {
                                ProductId = Convert.ToInt32(dr["product_id"]),
                                ProductName = dr["product_name"].ToString(),
                                Brand = dr["brand"].ToString(),
                                UnitPrice = Convert.ToDecimal(dr["price"]),
                                Quantity = Convert.ToInt32(dr["quantity"]),
                                Color = dr["color"] == DBNull.Value ? "" : dr["color"].ToString(),
                                Size = dr["size"] == DBNull.Value ? "" : dr["size"].ToString(),
                                ImageUrl = ParseFirstImage(dr["images"].ToString())
                            });
                        }
                    }
                }

                // سلة فاضية
                if (items.Count == 0)
                {
                    pnlEmptyCart.Visible = true;
                    btnPlaceOrder.Enabled = false;
                    return;
                }

                // ربط الـ Repeater
                rptCartItems.DataSource = items;
                rptCartItems.DataBind();

                // حساب الإجماليات
                decimal subtotal = 0;
                foreach (var item in items) subtotal += item.LineTotal;

                decimal discount = subtotal * 0.10m;
                decimal tax = (subtotal - discount) * 0.15m;
                decimal total = subtotal - discount + tax;

                // حفظ في Session
                Session["CartItems"] = items;
                Session["Subtotal"] = subtotal;
                Session["Discount"] = discount;
                Session["Tax"] = tax;
                Session["Total"] = total;

                // تحديث الـ Labels
                lblSubtotal.Text = subtotal.ToString("N2") + " ر.س";
                lblDiscount.Text = "- " + discount.ToString("N2") + " ر.س";
                lblTax.Text = tax.ToString("N2") + " ر.س";
                lblTotal.Text = total.ToString("N2") + " ر.س";
            }
            catch (Exception ex)
            {
                lblError.Text = "تعذّر تحميل السلة، يرجى المحاولة مجدداً.";
                lblError.Visible = true;
                System.Diagnostics.Debug.WriteLine("LoadCartItems: " + ex.Message);
            }
        }

        // استخراج أول صورة من الحقل
        private string ParseFirstImage(string raw)
        {
            if (string.IsNullOrEmpty(raw)) return "images/placeholder.png";
            raw = raw.Trim();

            if (raw.StartsWith("["))
            {
                raw = raw.Trim('[', ']');
                string first = raw.Split(',')[0].Trim().Trim('"');
                return string.IsNullOrEmpty(first) ? "images/placeholder.png" : first;
            }
            return raw.Split(',')[0].Trim();
        }

        // ══════════════════════════════════════════════════════════════
        //  تعبئة بيانات المستخدم المسجّل
        // ══════════════════════════════════════════════════════════════
        private void LoadUserDefaults(int userId)
        {
            try
            {
                string cs = Db.ConnectionString;

                // بيانات المستخدم
                string sqlUser = @"
                    SELECT first_name, last_name, email, phone
                    FROM   users
                    WHERE  user_id = @uid AND is_active = 1";

                using (var conn = new SqlConnection(cs))
                using (var cmd = new SqlCommand(sqlUser, conn))
                {
                    cmd.Parameters.AddWithValue("@uid", userId);
                    conn.Open();
                    using (var dr = cmd.ExecuteReader())
                    {
                        if (dr.Read())
                        {
                            txtFirstName.Text = dr["first_name"].ToString();
                            txtLastName.Text = dr["last_name"].ToString();
                            txtEmail.Text = dr["email"].ToString();
                            txtPhone.Text = dr["phone"].ToString();
                        }
                    }
                }

                // العنوان الافتراضي
                string sqlAddr = @"
                    SELECT TOP 1 city, district, street
                    FROM   addresses
                    WHERE  user_id = @uid AND is_default = 1";

                using (var conn = new SqlConnection(cs))
                using (var cmd = new SqlCommand(sqlAddr, conn))
                {
                    cmd.Parameters.AddWithValue("@uid", userId);
                    conn.Open();
                    using (var dr = cmd.ExecuteReader())
                    {
                        if (dr.Read())
                        {
                            ListItem cityItem =
                                ddlCity.Items.FindByValue(dr["city"].ToString());
                            if (cityItem != null) cityItem.Selected = true;

                            txtDistrict.Text = dr["district"].ToString();
                            txtAddress.Text = dr["street"].ToString();
                        }
                    }
                }
            }
            catch (Exception ex)
            {
                // Pre-filling a saved address is best-effort; log but don't block checkout.
                System.Diagnostics.Debug.WriteLine("LoadSavedAddress: " + ex.Message);
            }
        }

        // ══════════════════════════════════════════════════════════════
        //  زر تأكيد الطلب
        // ══════════════════════════════════════════════════════════════
        protected void btnPlaceOrder_Click(object sender, EventArgs e)
        {
            if (!Page.IsValid) return;

            try
            {
                string firstName = txtFirstName.Text.Trim();
                string lastName = txtLastName.Text.Trim();
                string phone = txtPhone.Text.Trim();
                string email = txtEmail.Text.Trim();
                string city = ddlCity.SelectedValue;
                string district = txtDistrict.Text.Trim();
                string address = txtAddress.Text.Trim();
                string paymentMethod = hfPaymentMethod.Value;

                Session["FirstName"] = firstName;
                Session["LastName"] = lastName;
                Session["Phone"] = phone;
                Session["Email"] = email;
                Session["City"] = city;
                Session["District"] = district;
                Session["Address"] = address;
                Session["PaymentMethod"] = paymentMethod;

                int orderId = SaveOrderToDb(
                    firstName, lastName, phone, email,
                    city, district, address, paymentMethod);

                if (orderId > 0)
                    Session["OrderId"] = orderId;

                // ✅ false يمنع ThreadAbortException
                Response.Redirect("Confirm.aspx", false);
            }
            catch (System.Threading.ThreadAbortException)
            {
                // ✅ طبيعي مع Redirect — تجاهله
            }
            catch (Exception ex)
            {
                // Log full detail server-side; show the user a generic message
                // so internal errors (SQL, schema, etc.) aren't leaked.
                System.Diagnostics.Debug.WriteLine("PlaceOrder: " + ex);
                lblError.Text = "تعذّر إتمام الطلب، يرجى المحاولة مجدداً.";
                lblError.Visible = true;
            }
        }        // ══════════════════════════════════════════════════════════════
        //  كوبون الخصم
        // ══════════════════════════════════════════════════════════════
        protected void btnApplyCoupon_Click(object sender, EventArgs e)
        {
            string code = txtCoupon.Text.Trim().ToUpper();

            if (string.IsNullOrEmpty(code))
            {
                lblCouponMsg.Text = "⚠️ يرجى إدخال كود الخصم";
                lblCouponMsg.ForeColor = Color.Orange;
                lblCouponMsg.Visible = true;
                return;
            }

            if (code == "NOON20")
            {
                decimal subtotal = Session["Subtotal"] != null
                    ? (decimal)Session["Subtotal"] : 0;

                decimal discount = subtotal * 0.20m;
                decimal tax = (subtotal - discount) * 0.15m;
                decimal total = subtotal - discount + tax;

                Session["Discount"] = discount;
                Session["Tax"] = tax;
                Session["Total"] = total;

                lblDiscount.Text = "- " + discount.ToString("N2") + " ر.س";
                lblTax.Text = tax.ToString("N2") + " ر.س";
                lblTotal.Text = total.ToString("N2") + " ر.س";
                lblCouponMsg.Text = "✅ تم تطبيق الكوبون NOON20 — خصم 20%";
                lblCouponMsg.ForeColor = Color.Green;
                lblCouponMsg.Visible = true;
            }
            else
            {
                lblCouponMsg.Text = "❌ كود الخصم غير صحيح";
                lblCouponMsg.ForeColor = Color.Red;
                lblCouponMsg.Visible = true;
            }
        }

        // ══════════════════════════════════════════════════════════════
        //  حفظ الطلب كاملاً في DB
        // ══════════════════════════════════════════════════════════════
        private int SaveOrderToDb(
            string firstName, string lastName,
            string phone, string email,
            string city, string district,
            string address, string paymentMethod)
        {
            try
            {
                string cs = Db.ConnectionString;

                // ── 1. جيب أو أنشئ المستخدم ──
                int userId = GetOrCreateUserId(cs, firstName, lastName, email, phone);

                // ── 2. احفظ العنوان وخذ address_id ──
                int addressId = SaveAddress(cs, userId, city, district, address);

                // ── 3. اقرأ الأرقام من Session ──
                decimal subtotal = Session["Subtotal"] != null ? (decimal)Session["Subtotal"] : 0;
                decimal discount = Session["Discount"] != null ? (decimal)Session["Discount"] : 0;
                decimal tax = Session["Tax"] != null ? (decimal)Session["Tax"] : 0;
                decimal total = Session["Total"] != null ? (decimal)Session["Total"] : 0;
                decimal shipping = 0;

                // ── 4. رقم الطلب الفريد ──
                string orderNumber = "ORD-" + DateTime.Now.ToString("yyyyMMdd-HHmmss");

                // ── 5. INSERT orders ──
                int orderId = 0;
                string sqlOrder = @"
                    INSERT INTO orders
                        (user_id, address_id, coupon_id, order_number,
                         status, subtotal, discount_amt, tax_amt,
                         shipping_fee, total, notes, placed_at, updated_at)
                    VALUES
                        (@uid, @aid, NULL, @orderNum,
                         'pending', @sub, @disc, @tax,
                         @ship, @total, NULL, GETDATE(), GETDATE());
                    SELECT SCOPE_IDENTITY();";

                using (var conn = new SqlConnection(cs))
                using (var cmd = new SqlCommand(sqlOrder, conn))
                {
                    cmd.Parameters.AddWithValue("@uid", userId);
                    cmd.Parameters.AddWithValue("@aid", addressId);
                    cmd.Parameters.AddWithValue("@orderNum", orderNumber);
                    cmd.Parameters.AddWithValue("@sub", subtotal);
                    cmd.Parameters.AddWithValue("@disc", discount);
                    cmd.Parameters.AddWithValue("@tax", tax);
                    cmd.Parameters.AddWithValue("@ship", shipping);
                    cmd.Parameters.AddWithValue("@total", total);
                    conn.Open();
                    orderId = Convert.ToInt32(cmd.ExecuteScalar());
                }

                if (orderId == 0) return 0;

                // ── 6. INSERT order_items ──
                var cartItems = Session["CartItems"] as List<CartItemDisplay>;
                if (cartItems != null && cartItems.Count > 0)
                {
                    string sqlItem = @"
                        INSERT INTO order_items
                            (order_id, product_id, quantity,
                             unit_price, color, size, subtotal)
                        VALUES
                            (@oid, @pid, @qty,
                             @price, @color, @size, @itemSub)";

                    using (var conn = new SqlConnection(cs))
                    {
                        conn.Open();
                        foreach (var item in cartItems)
                        {
                            using (var cmd = new SqlCommand(sqlItem, conn))
                            {
                                cmd.Parameters.AddWithValue("@oid", orderId);
                                cmd.Parameters.AddWithValue("@pid", item.ProductId);
                                cmd.Parameters.AddWithValue("@qty", item.Quantity);
                                cmd.Parameters.AddWithValue("@price", item.UnitPrice);
                                cmd.Parameters.AddWithValue("@itemSub", item.LineTotal);
                                cmd.Parameters.AddWithValue("@color",
                                    string.IsNullOrEmpty(item.Color)
                                    ? (object)DBNull.Value : item.Color);
                                cmd.Parameters.AddWithValue("@size",
                                    string.IsNullOrEmpty(item.Size)
                                    ? (object)DBNull.Value : item.Size);
                                cmd.ExecuteNonQuery();
                            }
                        }
                    }
                }

                // ── 7. INSERT payments ──
                string dbMethod;
                if (paymentMethod == "apple") dbMethod = "wallet";
                else if (paymentMethod == "cash") dbMethod = "cod";
                else dbMethod = "card";

                string sqlPayment = @"
                    INSERT INTO payments
                        (order_id, method, status, amount, created_at)
                    VALUES
                        (@oid, @method, 'pending', @amount, GETDATE())";

                using (var conn = new SqlConnection(cs))
                using (var cmd = new SqlCommand(sqlPayment, conn))
                {
                    cmd.Parameters.AddWithValue("@oid", orderId);
                    cmd.Parameters.AddWithValue("@method", dbMethod);
                    cmd.Parameters.AddWithValue("@amount", total);
                    conn.Open();
                    cmd.ExecuteNonQuery();
                }

                // ── 8. INSERT shipments ──
                string trackingNo = "TRK-" + DateTime.Now.ToString("yyyyMMdd")
                                  + "-" + orderId.ToString("D6");

                string sqlShipment = @"
                INSERT INTO shipments
                    (order_id, address_id, status, est_delivery, tracking_no)
                VALUES
                    (@oid, @aid, 'pending', @est, @tracking)";

                using (var conn = new SqlConnection(cs))
                using (var cmd = new SqlCommand(sqlShipment, conn))
                {
                    cmd.Parameters.AddWithValue("@oid", orderId);
                    cmd.Parameters.AddWithValue("@aid", addressId);
                    cmd.Parameters.AddWithValue("@tracking", trackingNo);
                    cmd.Parameters.AddWithValue("@est",
                        DateTime.Now.AddDays(3).ToString("yyyy-MM-dd"));
                    conn.Open();
                    cmd.ExecuteNonQuery();
                }

                // احفظ رقم التتبع في Session
                Session["TrackingNo"] = trackingNo;

                // ── 9. حذف السلة بعد الطلب ──
                // ✅ نفس اسم الـ Session في كل مكان
                if (Session[SESSION_USER] != null)
                {
                    string sqlClear = @"
                        DELETE ci
                        FROM   cart_items ci
                        JOIN   carts      c ON c.cart_id = ci.cart_id
                        WHERE  c.user_id = @uid";

                    using (var conn = new SqlConnection(cs))
                    using (var cmd = new SqlCommand(sqlClear, conn))
                    {
                        cmd.Parameters.AddWithValue("@uid", (int)Session[SESSION_USER]);
                        conn.Open();
                        cmd.ExecuteNonQuery();
                    }
                }

                // ── 10. احفظ رقم الطلب في Session ──
                Session["OrderNumber"] = orderNumber;

                return orderId;
            }
            catch (Exception ex)
            {
                System.Diagnostics.Debug.WriteLine("SaveOrderToDb: " + ex.Message);
                return 0;
            }
        }

        // ══════════════════════════════════════════════════════════════
        //  Helper — جيب أو أنشئ المستخدم
        // ══════════════════════════════════════════════════════════════
        private int GetOrCreateUserId(
            string cs,
            string firstName, string lastName,
            string email, string phone)
        {
            // ✅ نفس اسم الـ Session
            if (Session[SESSION_USER] != null)
                return (int)Session[SESSION_USER];

            string sqlFind = "SELECT user_id FROM users WHERE email = @email";
            using (var conn = new SqlConnection(cs))
            using (var cmd = new SqlCommand(sqlFind, conn))
            {
                cmd.Parameters.AddWithValue("@email", email);
                conn.Open();
                object res = cmd.ExecuteScalar();
                if (res != null) return Convert.ToInt32(res);
            }

            string sqlInsert = @"
                INSERT INTO users
                    (first_name, last_name, email, phone,
                     password_hash, role, is_active,
                     created_at, updated_at)
                VALUES
                    (@fn, @ln, @em, @ph,
                     @pw, 'customer', 1,
                     GETDATE(), GETDATE());
                SELECT SCOPE_IDENTITY();";

            using (var conn = new SqlConnection(cs))
            using (var cmd = new SqlCommand(sqlInsert, conn))
            {
                cmd.Parameters.AddWithValue("@fn", firstName);
                cmd.Parameters.AddWithValue("@ln", lastName);
                cmd.Parameters.AddWithValue("@em", email);
                cmd.Parameters.AddWithValue("@ph", phone);
                // Guest checkout account: no chosen password, so store an unusable
                // random hash. The user can set a real password later via reset.
                cmd.Parameters.AddWithValue("@pw", PasswordHasher.Hash(Guid.NewGuid().ToString("N")));
                conn.Open();
                return Convert.ToInt32(cmd.ExecuteScalar());
            }
        }

        // ══════════════════════════════════════════════════════════════
        //  Helper — احفظ العنوان
        // ══════════════════════════════════════════════════════════════
        private int SaveAddress(
            string cs, int userId,
            string city, string district, string street)
        {
            // تحقق إذا العنوان موجود مسبقاً
            string sqlFind = @"
                SELECT TOP 1 address_id
                FROM   addresses
                WHERE  user_id  = @uid
                  AND  city     = @city
                  AND  district = @district
                  AND  street   = @street";

            using (var conn = new SqlConnection(cs))
            using (var cmd = new SqlCommand(sqlFind, conn))
            {
                cmd.Parameters.AddWithValue("@uid", userId);
                cmd.Parameters.AddWithValue("@city", city);
                cmd.Parameters.AddWithValue("@district", district);
                cmd.Parameters.AddWithValue("@street", street);
                conn.Open();
                object res = cmd.ExecuteScalar();
                if (res != null) return Convert.ToInt32(res);
            }

            // أنشئ عنوان جديد
            string sqlInsert = @"
                INSERT INTO addresses
                    (user_id, label, city, district, street, is_default)
                VALUES
                    (@uid, 'home', @city, @district, @street, 0);
                SELECT SCOPE_IDENTITY();";

            using (var conn = new SqlConnection(cs))
            using (var cmd = new SqlCommand(sqlInsert, conn))
            {
                cmd.Parameters.AddWithValue("@uid", userId);
                cmd.Parameters.AddWithValue("@city", city);
                cmd.Parameters.AddWithValue("@district", district);
                cmd.Parameters.AddWithValue("@street", street);
                conn.Open();
                return Convert.ToInt32(cmd.ExecuteScalar());
            }
        }
    }
}