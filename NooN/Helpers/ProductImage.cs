using System;
using System.Web;

namespace NooN
{
    /// <summary>
    /// Centralized resolver for a product's image URL. Handles the different
    /// shapes stored in products.images (a single path, a CSV list, or a JSON
    /// array) and normalizes them to a browser-usable URL, so every page renders
    /// images the same way.
    /// </summary>
    public static class ProductImage
    {
        /// <summary>
        /// Inline SVG placeholder used when a product has no image. It is a data
        /// URI, so it never hits the network and can never 404 or loop.
        /// </summary>
        public const string Placeholder =
            "data:image/svg+xml,%3Csvg xmlns='http://www.w3.org/2000/svg' width='400' height='300'%3E" +
            "%3Crect width='400' height='300' fill='%23eeeeee'/%3E" +
            "%3Cpath d='M120 210l55-55 35 35 45-45 65 65v20H120z' fill='%23cccccc'/%3E" +
            "%3Ccircle cx='160' cy='120' r='22' fill='%23cccccc'/%3E%3C/svg%3E";

        /// <summary>
        /// Returns a usable URL for the first image of a product, or the inline
        /// placeholder when there is none.
        /// </summary>
        public static string FirstUrl(object imagesValue)
        {
            string raw = imagesValue?.ToString()?.Trim();
            if (string.IsNullOrEmpty(raw))
                return Placeholder;

            // JSON array: ["img1.jpg","img2.jpg"] → take the first quoted value.
            if (raw.StartsWith("["))
            {
                int start = raw.IndexOf('"');
                int end = start >= 0 ? raw.IndexOf('"', start + 1) : -1;
                raw = (start >= 0 && end > start)
                    ? raw.Substring(start + 1, end - start - 1).Trim()
                    : "";
            }
            else if (raw.Contains(","))
            {
                // CSV list → take the first path.
                raw = raw.Split(',')[0].Trim();
            }

            if (string.IsNullOrEmpty(raw))
                return Placeholder;

            // Already a usable URL (absolute, or root-relative like /Uploads/...).
            if (raw.StartsWith("http://") || raw.StartsWith("https://") || raw.StartsWith("/"))
                return raw;

            // App-relative path.
            if (raw.StartsWith("~/"))
                return VirtualPathUtility.ToAbsolute(raw);

            // Bare filename → assume it lives in the uploads folder.
            return VirtualPathUtility.ToAbsolute("~/Uploads/Products/" + raw);
        }
    }
}
