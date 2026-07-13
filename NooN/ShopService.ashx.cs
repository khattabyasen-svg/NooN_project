using System;
using System.Data;
using System.Data.SqlClient;
using System.Web;
using System.Web.Script.Serialization;
using System.Web.SessionState;

namespace NooN
{
    /// <summary>
    /// JSON endpoint for the AJAX cart / favorites buttons (no postback).
    /// POST action=addtocart : productId, quantity, color, size
    /// POST action=togglefav : productId
    /// Response: { success, message, cartCount, isFav, requireLogin }
    /// </summary>
    public class ShopService : IHttpHandler, IRequiresSessionState
    {
        private static readonly string connStr = Db.ConnectionString;

        // Serialized as the JSON response body.
        private class AjaxResult
        {
            public bool success;
            public string message;
            public int? cartCount;
            public bool? isFav;
            public bool requireLogin;
        }

        public bool IsReusable { get { return true; } }

        public void ProcessRequest(HttpContext context)
        {
            AjaxResult result;

            try
            {
                if (!string.Equals(context.Request.HttpMethod, "POST", StringComparison.OrdinalIgnoreCase))
                {
                    context.Response.StatusCode = 405;
                    result = Fail("طريقة الطلب غير صحيحة.");
                }
                else if (context.Session["user_id"] == null)
                {
                    // Auth is enforced server-side; the client only reacts to the flag.
                    result = Fail("يرجى تسجيل الدخول أولاً.");
                    result.requireLogin = true;
                }
                else
                {
                    int userId = Convert.ToInt32(context.Session["user_id"]);

                    int productId;
                    int.TryParse(context.Request.Form["productId"], out productId);

                    if (productId <= 0)
                    {
                        result = Fail("منتج غير صالح.");
                    }
                    else
                    {
                        string action = (context.Request.Form["action"] ?? "").Trim().ToLowerInvariant();
                        switch (action)
                        {
                            case "addtocart":
                                result = AddToCart(context, userId, productId);
                                break;
                            case "togglefav":
                                result = ToggleFavorites(userId, productId);
                                break;
                            default:
                                result = Fail("إجراء غير معروف.");
                                break;
                        }
                    }
                }
            }
            catch (Exception ex)
            {
                System.Diagnostics.Trace.TraceError("ShopService Error: " + ex);
                result = Fail("حدث خطأ غير متوقع. حاول مرة أخرى.");
            }

            context.Response.ContentType = "application/json; charset=utf-8";
            context.Response.Write(new JavaScriptSerializer().Serialize(result));
        }

        // ═══════════════════════════════════════════
        // Add to cart (find/create cart + upsert item)
        // ═══════════════════════════════════════════
        private AjaxResult AddToCart(HttpContext context, int userId, int productId)
        {
            int qty;
            if (!int.TryParse(context.Request.Form["quantity"], out qty) || qty < 1) qty = 1;
            if (qty > 99) qty = 99;

            string color = (context.Request.Form["color"] ?? "").Trim();
            string size = (context.Request.Form["size"] ?? "").Trim();

            using (SqlConnection conn = new SqlConnection(connStr))
            {
                conn.Open();

                // The product must exist and be purchasable.
                string status;
                string availColors, availSizes;
                int stockQty;
                using (SqlCommand cmd = new SqlCommand(@"
                    SELECT p.status, p.available_colors, p.available_sizes,
                           ISNULL(i.available_qty, 0) AS stock_quantity
                    FROM products p
                    LEFT JOIN inventory i ON i.product_id = p.product_id
                    WHERE p.product_id = @pid", conn))
                {
                    cmd.Parameters.AddWithValue("@pid", productId);
                    using (SqlDataReader dr = cmd.ExecuteReader())
                    {
                        if (!dr.Read())
                            return Fail("المنتج غير موجود.");

                        status = dr["status"].ToString().ToLower();
                        availColors = dr["available_colors"] != DBNull.Value ? dr["available_colors"].ToString().Trim() : "";
                        availSizes = dr["available_sizes"] != DBNull.Value ? dr["available_sizes"].ToString().Trim() : "";
                        stockQty = Convert.ToInt32(dr["stock_quantity"]);
                    }
                }

                if (status != "active" || stockQty <= 0)
                    return Fail("عذراً، هذا المنتج غير متوفر حالياً.");

                // When no option is sent (quick-add from the products grid has
                // no pickers), fall back to the product's first available
                // color / size instead of rejecting the request. The details
                // page still enforces an explicit choice client-side.
                if (string.IsNullOrEmpty(color) && !string.IsNullOrEmpty(availColors))
                    color = availColors.Split(',')[0].Trim();
                if (string.IsNullOrEmpty(size) && !string.IsNullOrEmpty(availSizes))
                    size = availSizes.Split(',')[0].Trim();

                object colorParam = string.IsNullOrEmpty(color) ? (object)DBNull.Value : color;
                object sizeParam = string.IsNullOrEmpty(size) ? (object)DBNull.Value : size;

                // 1) Find or create the user's cart.
                int cartId;
                using (SqlCommand cmd = new SqlCommand(
                    "SELECT cart_id FROM carts WHERE user_id = @uid", conn))
                {
                    cmd.Parameters.AddWithValue("@uid", userId);
                    object res = cmd.ExecuteScalar();
                    if (res == null || res == DBNull.Value)
                    {
                        using (SqlCommand cn = new SqlCommand(@"
                            INSERT INTO carts (user_id, created_at, updated_at)
                            VALUES (@uid, GETDATE(), GETDATE());
                            SELECT SCOPE_IDENTITY();", conn))
                        {
                            cn.Parameters.AddWithValue("@uid", userId);
                            cartId = Convert.ToInt32(cn.ExecuteScalar());
                        }
                    }
                    else cartId = Convert.ToInt32(res);
                }

                // 2) Stock check — the requested quantity plus what is already
                //    in the cart (all color/size variants share one inventory
                //    row) must not exceed the available stock.
                int inCartQty;
                using (SqlCommand cmdInCart = new SqlCommand(@"
                    SELECT ISNULL(SUM(quantity), 0)
                    FROM cart_items
                    WHERE cart_id = @cartId AND product_id = @pid", conn))
                {
                    cmdInCart.Parameters.AddWithValue("@cartId", cartId);
                    cmdInCart.Parameters.AddWithValue("@pid", productId);
                    inCartQty = Convert.ToInt32(cmdInCart.ExecuteScalar());
                }

                if (inCartQty + qty > stockQty)
                {
                    int remaining = stockQty - inCartQty;
                    return Fail(remaining > 0
                        ? "لا يوجد مخزون كافٍ — المتبقي " + remaining + " فقط ولديك " + inCartQty + " في السلة."
                        : "لقد أضفت كامل الكمية المتوفرة من هذا المنتج إلى سلتك.");
                }

                // 3) Upsert the item — ISNULL so NULL color/size compare correctly.
                using (SqlCommand cmdItem = new SqlCommand(@"
                    IF EXISTS (
                        SELECT 1 FROM cart_items
                        WHERE cart_id    = @cartId
                          AND product_id = @pid
                          AND ISNULL(color,'') = ISNULL(@color,'')
                          AND ISNULL(size,'')  = ISNULL(@size,'')
                    )
                        UPDATE cart_items
                           SET quantity = quantity + @qty
                         WHERE cart_id    = @cartId
                           AND product_id = @pid
                           AND ISNULL(color,'') = ISNULL(@color,'')
                           AND ISNULL(size,'')  = ISNULL(@size,'')
                    ELSE
                        INSERT INTO cart_items
                            (cart_id, product_id, quantity, color, size, added_at)
                        VALUES (@cartId, @pid, @qty, @color, @size, GETDATE())", conn))
                {
                    cmdItem.Parameters.AddWithValue("@cartId", cartId);
                    cmdItem.Parameters.AddWithValue("@pid", productId);
                    cmdItem.Parameters.AddWithValue("@qty", qty);
                    cmdItem.Parameters.Add("@color", SqlDbType.NVarChar, 40).Value = colorParam;
                    cmdItem.Parameters.Add("@size", SqlDbType.NVarChar, 40).Value = sizeParam;
                    cmdItem.ExecuteNonQuery();
                }

                // 4) Touch the cart's updated_at.
                using (SqlCommand cu = new SqlCommand(
                    "UPDATE carts SET updated_at = GETDATE() WHERE cart_id = @cid", conn))
                {
                    cu.Parameters.AddWithValue("@cid", cartId);
                    cu.ExecuteNonQuery();
                }

                // The master page caches the badge count per user; drop it so
                // full page loads also show the fresh value.
                HttpRuntime.Cache.Remove("cart_count_" + userId);

                int cartCount;
                using (SqlCommand cnt = new SqlCommand(@"
                    SELECT ISNULL(SUM(ci.quantity), 0)
                    FROM   cart_items ci
                    INNER JOIN carts c ON ci.cart_id = c.cart_id
                    WHERE  c.user_id = @uid", conn))
                {
                    cnt.Parameters.AddWithValue("@uid", userId);
                    cartCount = (int)cnt.ExecuteScalar();
                }

                string colorMsg = string.IsNullOrEmpty(color) ? "" : " | اللون: " + color;
                string sizeMsg = string.IsNullOrEmpty(size) ? "" : " | الحجم: " + size;

                return new AjaxResult
                {
                    success = true,
                    message = "✅ تمت إضافة " + qty + " منتج" + colorMsg + sizeMsg + " إلى سلتك!",
                    cartCount = cartCount
                };
            }
        }

        // ═══════════════════════════════════════════
        // Toggle wishlist membership
        // ═══════════════════════════════════════════
        private AjaxResult ToggleFavorites(int userId, int productId)
        {
            using (SqlConnection conn = new SqlConnection(connStr))
            {
                conn.Open();

                // Verify the product exists (avoids an FK error on insert).
                using (SqlCommand chkProd = new SqlCommand(
                    "SELECT COUNT(1) FROM products WHERE product_id = @pid", conn))
                {
                    chkProd.Parameters.AddWithValue("@pid", productId);
                    if ((int)chkProd.ExecuteScalar() == 0)
                        return Fail("المنتج غير موجود.");
                }

                bool exists;
                using (SqlCommand chk = new SqlCommand(@"
                    SELECT COUNT(1) FROM wishlist_items
                    WHERE user_id = @uid AND product_id = @pid", conn))
                {
                    chk.Parameters.AddWithValue("@uid", userId);
                    chk.Parameters.AddWithValue("@pid", productId);
                    exists = (int)chk.ExecuteScalar() > 0;
                }

                if (exists)
                {
                    using (SqlCommand del = new SqlCommand(@"
                        DELETE FROM wishlist_items
                        WHERE user_id = @uid AND product_id = @pid", conn))
                    {
                        del.Parameters.AddWithValue("@uid", userId);
                        del.Parameters.AddWithValue("@pid", productId);
                        del.ExecuteNonQuery();
                    }

                    return new AjaxResult { success = true, isFav = false, message = "💔 تم الحذف من المفضلة" };
                }

                using (SqlCommand ins = new SqlCommand(@"
                    INSERT INTO wishlist_items (user_id, product_id)
                    VALUES (@uid, @pid)", conn))
                {
                    ins.Parameters.AddWithValue("@uid", userId);
                    ins.Parameters.AddWithValue("@pid", productId);
                    ins.ExecuteNonQuery();
                }

                return new AjaxResult { success = true, isFav = true, message = "❤️ تمت الإضافة إلى المفضلة" };
            }
        }

        private static AjaxResult Fail(string message)
        {
            return new AjaxResult { success = false, message = message };
        }
    }
}
