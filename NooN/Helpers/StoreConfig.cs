namespace NooN
{
    /// <summary>
    /// Centralized store-wide pricing constants so the rules live in one place
    /// instead of being duplicated across Cart, checkout, etc.
    /// </summary>
    public static class StoreConfig
    {
        // VAT / general sales tax rate (Jordan = 16%).
        public const decimal VatRate = 0.16m;

        // Free shipping at or above this post-discount amount; flat fee otherwise.
        public const decimal FreeShipThreshold = 200m;
        public const decimal ShippingCost = 25m;

        // Currency suffix shown next to prices (Jordanian Dinar).
        public const string Currency = "JD";

        /// <summary>Shipping fee for a given post-discount amount.</summary>
        public static decimal ShippingFor(decimal afterDiscount)
        {
            return afterDiscount >= FreeShipThreshold ? 0m : ShippingCost;
        }
    }
}
