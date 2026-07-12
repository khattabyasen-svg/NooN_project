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

            // Card fields are only required when paying by card. This runs on every
            // load (before validation) so it is enforced server-side, not just in JS.
            bool payingByCard = hfPaymentMethod.Value == "card";
            RFV_Card.Enabled = payingByCard;
            RFV_Expiry.Enabled = payingByCard;
            RFV_CVV.Enabled = payingByCard;
            RFV_CardHolder.Enabled = payingByCard;
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

                // Empty cart
                if (items.Count == 0)
                {
                    pnlEmptyCart.Visible = true;
                    btnPlaceOrder.Enabled = false;
                    return;
                }

                // Bind the repeater
                rptCartItems.DataSource = items;
                rptCartItems.DataBind();

                // Compute the totals
                decimal subtotal = 0;
                foreach (var item in items) subtotal += item.LineTotal;

                decimal discountRate = 0.10m;   // base discount before any coupon
                decimal discount = subtotal * discountRate;
                decimal tax = (subtotal - discount) * 0.15m;
                decimal total = subtotal - discount + tax;

                // Store in Session
                Session["CartItems"] = items;
                Session["Subtotal"] = subtotal;
                Session["DiscountRate"] = discountRate;
                Session["Discount"] = discount;
                Session["Tax"] = tax;
                Session["Total"] = total;

                // Update the labels
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

        // Extract the first image from the field (shared resolver).
        private string ParseFirstImage(string raw)
        {
            return ProductImage.FirstUrl(raw);
        }

        // ══════════════════════════════════════════════════════════════
        //  Pre-fill the logged-in user's details
        // ══════════════════════════════════════════════════════════════
        private void LoadUserDefaults(int userId)
        {
            try
            {
                string cs = Db.ConnectionString;

                // User details
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

                // Default address
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
        //  Place order button
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

                // Only proceed to confirmation if the order actually saved.
                if (orderId <= 0)
                {
                    lblError.Text = "تعذّر إتمام الطلب، يرجى المحاولة مجدداً.";
                    lblError.Visible = true;
                    return;
                }

                Session["OrderId"] = orderId;

                // endResponse:false avoids a ThreadAbortException.
                Response.Redirect("Confirm.aspx", false);
            }
            catch (Exception ex)
            {
                // Log full detail server-side; show the user a generic message
                // so internal errors (SQL, schema, etc.) aren't leaked.
                System.Diagnostics.Debug.WriteLine("PlaceOrder: " + ex);
                lblError.Text = "تعذّر إتمام الطلب، يرجى المحاولة مجدداً.";
                lblError.Visible = true;
            }
        }

        // ══════════════════════════════════════════════════════════════
        //  Discount coupon
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

                decimal discountRate = 0.20m;
                decimal discount = subtotal * discountRate;
                decimal tax = (subtotal - discount) * 0.15m;
                decimal total = subtotal - discount + tax;

                Session["DiscountRate"] = discountRate;
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
        //  Save the whole order in a single transaction (all-or-nothing)
        // ══════════════════════════════════════════════════════════════
        private int SaveOrderToDb(
            string firstName, string lastName,
            string phone, string email,
            string city, string district,
            string address, string paymentMethod)
        {
            using (var conn = new SqlConnection(Db.ConnectionString))
            {
                conn.Open();
                using (var tx = conn.BeginTransaction())
                {
                    try
                    {
                        // 1. Get or create the user.
                        int userId = GetOrCreateUserId(conn, tx, firstName, lastName, email, phone);

                        // 2. Save the address and take its address_id.
                        int addressId = SaveAddress(conn, tx, userId, city, district, address);

                        // 3. Recompute the cart and totals authoritatively from the DB.
                        //    Session totals are only for display — they can be stale or
                        //    lost, so the saved order must not depend on them.
                        var orderItems = new List<CartItemDisplay>();
                        decimal subtotal = 0;

                        string sqlCart = @"
                            SELECT ci.product_id, p.price,
                                   ci.quantity, ci.color, ci.size
                            FROM   cart_items ci
                            JOIN   carts    c ON c.cart_id    = ci.cart_id
                            JOIN   products p ON p.product_id = ci.product_id
                            WHERE  c.user_id = @uid AND p.status = 'active'";

                        using (var cmd = new SqlCommand(sqlCart, conn, tx))
                        {
                            cmd.Parameters.AddWithValue("@uid", userId);
                            using (var dr = cmd.ExecuteReader())
                            {
                                while (dr.Read())
                                {
                                    var item = new CartItemDisplay
                                    {
                                        ProductId = Convert.ToInt32(dr["product_id"]),
                                        UnitPrice = Convert.ToDecimal(dr["price"]),
                                        Quantity = Convert.ToInt32(dr["quantity"]),
                                        Color = dr["color"] == DBNull.Value ? "" : dr["color"].ToString(),
                                        Size = dr["size"] == DBNull.Value ? "" : dr["size"].ToString()
                                    };
                                    orderItems.Add(item);
                                    subtotal += item.LineTotal;
                                }
                            }
                        }

                        // Nothing left to order (empty or already-cleared cart).
                        if (orderItems.Count == 0)
                        {
                            tx.Rollback();
                            return 0;
                        }

                        decimal discountRate = Session["DiscountRate"] != null
                            ? (decimal)Session["DiscountRate"] : 0.10m;
                        decimal discount = subtotal * discountRate;
                        decimal shipping = 0;
                        decimal tax = (subtotal - discount) * 0.15m;
                        decimal total = subtotal - discount + tax;

                        // 4. Unique order number (millisecond precision to avoid collisions).
                        string orderNumber = "ORD-" + DateTime.Now.ToString("yyyyMMdd-HHmmssfff");

                        // 5. INSERT orders
                        int orderId;
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

                        using (var cmd = new SqlCommand(sqlOrder, conn, tx))
                        {
                            cmd.Parameters.AddWithValue("@uid", userId);
                            cmd.Parameters.AddWithValue("@aid", addressId);
                            cmd.Parameters.AddWithValue("@orderNum", orderNumber);
                            cmd.Parameters.AddWithValue("@sub", subtotal);
                            cmd.Parameters.AddWithValue("@disc", discount);
                            cmd.Parameters.AddWithValue("@tax", tax);
                            cmd.Parameters.AddWithValue("@ship", shipping);
                            cmd.Parameters.AddWithValue("@total", total);
                            orderId = Convert.ToInt32(cmd.ExecuteScalar());
                        }

                        if (orderId == 0)
                        {
                            tx.Rollback();
                            return 0;
                        }

                        // 6. INSERT order_items (from the authoritative DB list)
                        string sqlItem = @"
                            INSERT INTO order_items
                                (order_id, product_id, quantity,
                                 unit_price, color, size, subtotal)
                            VALUES
                                (@oid, @pid, @qty,
                                 @price, @color, @size, @itemSub)";

                        foreach (var item in orderItems)
                        {
                            using (var cmd = new SqlCommand(sqlItem, conn, tx))
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

                        // 7. Deduct the ordered quantities from inventory.
                        //    Color/size variants share one inventory row, so the
                        //    quantities are grouped per product first. The UPDATE
                        //    only succeeds when enough stock remains, which keeps
                        //    the check atomic against concurrent orders.
                        var qtyPerProduct = new Dictionary<int, int>();
                        foreach (var item in orderItems)
                        {
                            int q;
                            qtyPerProduct.TryGetValue(item.ProductId, out q);
                            qtyPerProduct[item.ProductId] = q + item.Quantity;
                        }

                        string sqlStock = @"
                            UPDATE inventory
                               SET available_qty = available_qty - @qty,
                                   sold_qty      = sold_qty + @qty,
                                   updated_at    = GETDATE()
                             WHERE product_id = @pid
                               AND available_qty >= @qty";

                        foreach (var kv in qtyPerProduct)
                        {
                            using (var cmd = new SqlCommand(sqlStock, conn, tx))
                            {
                                cmd.Parameters.AddWithValue("@pid", kv.Key);
                                cmd.Parameters.AddWithValue("@qty", kv.Value);
                                if (cmd.ExecuteNonQuery() == 0)
                                {
                                    // Not enough stock (or no inventory row) — abort the order.
                                    tx.Rollback();
                                    _orderError = "عذراً، الكمية المطلوبة لم تعد متوفرة في المخزون لأحد المنتجات. يرجى مراجعة سلتك.";
                                    return 0;
                                }
                            }

                            // Mark the product out of stock once its inventory is exhausted.
                            using (var cmd = new SqlCommand(@"
                                UPDATE products SET status = 'out_of_stock', updated_at = GETDATE()
                                WHERE product_id = @pid
                                  AND EXISTS (SELECT 1 FROM inventory
                                              WHERE product_id = @pid AND available_qty = 0)", conn, tx))
                            {
                                cmd.Parameters.AddWithValue("@pid", kv.Key);
                                cmd.ExecuteNonQuery();
                            }
                        }

                        // 8. INSERT payments
                        string dbMethod;
                        if (paymentMethod == "apple") dbMethod = "wallet";
                        else if (paymentMethod == "cash") dbMethod = "cod";
                        else dbMethod = "card";

                        string sqlPayment = @"
                            INSERT INTO payments
                                (order_id, method, status, amount, created_at)
                            VALUES
                                (@oid, @method, 'pending', @amount, GETDATE())";

                        using (var cmd = new SqlCommand(sqlPayment, conn, tx))
                        {
                            cmd.Parameters.AddWithValue("@oid", orderId);
                            cmd.Parameters.AddWithValue("@method", dbMethod);
                            cmd.Parameters.AddWithValue("@amount", total);
                            cmd.ExecuteNonQuery();
                        }

                        // 9. INSERT shipments
                        string trackingNo = "TRK-" + DateTime.Now.ToString("yyyyMMdd")
                                          + "-" + orderId.ToString("D6");

                        string sqlShipment = @"
                            INSERT INTO shipments
                                (order_id, address_id, status, est_delivery, tracking_no)
                            VALUES
                                (@oid, @aid, 'pending', @est, @tracking)";

                        using (var cmd = new SqlCommand(sqlShipment, conn, tx))
                        {
                            cmd.Parameters.AddWithValue("@oid", orderId);
                            cmd.Parameters.AddWithValue("@aid", addressId);
                            cmd.Parameters.AddWithValue("@tracking", trackingNo);
                            cmd.Parameters.AddWithValue("@est",
                                DateTime.Now.AddDays(3).ToString("yyyy-MM-dd"));
                            cmd.ExecuteNonQuery();
                        }

                        // 9. Clear the cart after ordering.
                        if (Session[SESSION_USER] != null)
                        {
                            string sqlClear = @"
                                DELETE ci
                                FROM   cart_items ci
                                JOIN   carts      c ON c.cart_id = ci.cart_id
                                WHERE  c.user_id = @uid";

                            using (var cmd = new SqlCommand(sqlClear, conn, tx))
                            {
                                cmd.Parameters.AddWithValue("@uid", (int)Session[SESSION_USER]);
                                cmd.ExecuteNonQuery();
                            }
                        }

                        // Commit only after every step succeeded.
                        tx.Commit();

                        // Persist the authoritative amounts + identifiers for the confirmation page.
                        Session["Subtotal"] = subtotal;
                        Session["Discount"] = discount;
                        Session["Tax"] = tax;
                        Session["Total"] = total;
                        Session["TrackingNo"] = trackingNo;
                        Session["OrderNumber"] = orderNumber;

                        return orderId;
                    }
                    catch (Exception ex)
                    {
                        // Roll back so a partial order is never left behind.
                        try { tx.Rollback(); } catch { /* connection already gone */ }
                        System.Diagnostics.Debug.WriteLine("SaveOrderToDb: " + ex);
                        return 0;
                    }
                }
            }
        }

        // ══════════════════════════════════════════════════════════════
        //  Helper — get or create the user (within the order transaction)
        // ══════════════════════════════════════════════════════════════
        private int GetOrCreateUserId(
            SqlConnection conn, SqlTransaction tx,
            string firstName, string lastName,
            string email, string phone)
        {
            // Logged-in user: reuse the session id.
            if (Session[SESSION_USER] != null)
                return (int)Session[SESSION_USER];

            using (var cmd = new SqlCommand(
                "SELECT user_id FROM users WHERE email = @email", conn, tx))
            {
                cmd.Parameters.AddWithValue("@email", email);
                object res = cmd.ExecuteScalar();
                if (res != null && res != DBNull.Value) return Convert.ToInt32(res);
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

            using (var cmd = new SqlCommand(sqlInsert, conn, tx))
            {
                cmd.Parameters.AddWithValue("@fn", firstName);
                cmd.Parameters.AddWithValue("@ln", lastName);
                cmd.Parameters.AddWithValue("@em", email);
                cmd.Parameters.AddWithValue("@ph", phone);
                // Guest checkout account: no chosen password, so store an unusable
                // random hash. The user can set a real password later via reset.
                cmd.Parameters.AddWithValue("@pw", PasswordHasher.Hash(Guid.NewGuid().ToString("N")));
                return Convert.ToInt32(cmd.ExecuteScalar());
            }
        }

        // ══════════════════════════════════════════════════════════════
        //  Helper — save the address (within the order transaction)
        // ══════════════════════════════════════════════════════════════
        private int SaveAddress(
            SqlConnection conn, SqlTransaction tx, int userId,
            string city, string district, string street)
        {
            // Reuse the address if it already exists.
            string sqlFind = @"
                SELECT TOP 1 address_id
                FROM   addresses
                WHERE  user_id  = @uid
                  AND  city     = @city
                  AND  district = @district
                  AND  street   = @street";

            using (var cmd = new SqlCommand(sqlFind, conn, tx))
            {
                cmd.Parameters.AddWithValue("@uid", userId);
                cmd.Parameters.AddWithValue("@city", city);
                cmd.Parameters.AddWithValue("@district", district);
                cmd.Parameters.AddWithValue("@street", street);
                object res = cmd.ExecuteScalar();
                if (res != null && res != DBNull.Value) return Convert.ToInt32(res);
            }

            // Otherwise create a new address.
            string sqlInsert = @"
                INSERT INTO addresses
                    (user_id, label, city, district, street, is_default)
                VALUES
                    (@uid, 'home', @city, @district, @street, 0);
                SELECT SCOPE_IDENTITY();";

            using (var cmd = new SqlCommand(sqlInsert, conn, tx))
            {
                cmd.Parameters.AddWithValue("@uid", userId);
                cmd.Parameters.AddWithValue("@city", city);
                cmd.Parameters.AddWithValue("@district", district);
                cmd.Parameters.AddWithValue("@street", street);
                return Convert.ToInt32(cmd.ExecuteScalar());
            }
        }
    }
}