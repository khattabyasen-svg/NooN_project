using System;
using System.Data.SqlClient;

namespace NooN
{
    /// <summary>Outcome of resolving a coupon code against the coupons table.</summary>
    public class CouponResult
    {
        public bool IsValid { get; set; }
        public int CouponId { get; set; }
        public string Code { get; set; }
        public decimal DiscountAmount { get; set; }
        public string Message { get; set; }
    }

    /// <summary>
    /// Resolves discount coupons against the coupons DB table so Cart and
    /// checkout share a single source of truth (no hardcoded coupon lists).
    /// Validates active flag, expiry, minimum order, and usage limit.
    /// </summary>
    public static class CouponHelper
    {
        public static CouponResult Resolve(string code, decimal subtotal)
        {
            var result = new CouponResult { IsValid = false, Code = "", DiscountAmount = 0m };

            if (string.IsNullOrWhiteSpace(code))
            {
                result.Message = "⚠️ Please enter a coupon code";
                return result;
            }

            code = code.Trim().ToUpperInvariant();

            const string sql = @"
                SELECT coupon_id, type, value, min_order,
                       usage_limit, used_count, expires_at, is_active
                FROM   coupons
                WHERE  code = @code";

            using (var conn = new SqlConnection(Db.ConnectionString))
            using (var cmd = new SqlCommand(sql, conn))
            {
                cmd.Parameters.AddWithValue("@code", code);
                conn.Open();
                using (var dr = cmd.ExecuteReader())
                {
                    if (!dr.Read())
                    {
                        result.Message = "❌ Invalid coupon code";
                        return result;
                    }

                    bool isActive = Convert.ToBoolean(dr["is_active"]);
                    string type = dr["type"].ToString().ToUpperInvariant();
                    decimal value = Convert.ToDecimal(dr["value"]);
                    decimal minOrder = Convert.ToDecimal(dr["min_order"]);
                    int? usageLimit = dr["usage_limit"] == DBNull.Value
                        ? (int?)null : Convert.ToInt32(dr["usage_limit"]);
                    int usedCount = Convert.ToInt32(dr["used_count"]);
                    DateTime? expires = dr["expires_at"] == DBNull.Value
                        ? (DateTime?)null : Convert.ToDateTime(dr["expires_at"]);

                    if (!isActive)
                    {
                        result.Message = "❌ This coupon code is not valid";
                        return result;
                    }
                    if (expires.HasValue && expires.Value < DateTime.Now)
                    {
                        result.Message = "❌ This coupon code has expired";
                        return result;
                    }
                    if (subtotal < minOrder)
                    {
                        result.Message = $"❌ This coupon requires a minimum order of {minOrder:N2} {StoreConfig.Currency}";
                        return result;
                    }
                    if (usageLimit.HasValue && usedCount >= usageLimit.Value)
                    {
                        result.Message = "❌ This coupon has been fully redeemed";
                        return result;
                    }

                    decimal discount = type == "PERCENT"
                        ? subtotal * (value / 100m)
                        : Math.Min(value, subtotal);
                    discount = Math.Round(discount, 2);

                    result.IsValid = true;
                    result.CouponId = Convert.ToInt32(dr["coupon_id"]);
                    result.Code = code;
                    result.DiscountAmount = discount;
                    result.Message = $"✅ Coupon {code} applied";
                    return result;
                }
            }
        }
    }
}
