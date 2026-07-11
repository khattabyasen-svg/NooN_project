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
        // Quotes are percent-encoded (%22) so the URI contains no raw quote
        // characters and stays valid inside single- or double-quoted attributes.
        public const string Placeholder =
            "data:image/svg+xml,%3Csvg%20xmlns=%22http://www.w3.org/2000/svg%22%20width=%22400%22%20height=%22300%22%3E" +
            "%3Crect%20width=%22400%22%20height=%22300%22%20fill=%22%23eeeeee%22/%3E" +
            "%3Cpath%20d=%22M120%20210l55-55%2035%2035%2045-45%2065%2065v20H120z%22%20fill=%22%23cccccc%22/%3E" +
            "%3Ccircle%20cx=%22160%22%20cy=%22120%22%20r=%2222%22%20fill=%22%23cccccc%22/%3E%3C/svg%3E";

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
