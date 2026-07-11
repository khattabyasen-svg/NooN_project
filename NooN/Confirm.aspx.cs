using System;
using System.Web;
using System.Web.UI;

namespace NooN
{
    public partial class Confirm : System.Web.UI.Page
    {
        // Arabic (Gregorian) month names — used so the delivery estimate does not
        // fall back to the Hijri calendar the ar-SA culture would otherwise use.
        private static readonly string[] ArabicMonths =
        {
            "يناير", "فبراير", "مارس", "أبريل", "مايو", "يونيو",
            "يوليو", "أغسطس", "سبتمبر", "أكتوبر", "نوفمبر", "ديسمبر"
        };

        protected void Page_Load(object sender, EventArgs e)
        {
            if (IsPostBack) return;

            // Guard: without a placed order in Session (e.g. direct navigation),
            // there is nothing to confirm — send the user back home.
            if (Session["OrderNumber"] == null)
            {
                Response.Redirect("Default.aspx");
                return;
            }

            litOrderNumber.Text = "#" + HttpUtility.HtmlEncode(Session["OrderNumber"].ToString());

            // Estimated delivery: a 2–4 day window from now (matches the 3-day
            // shipment estimate saved at checkout).
            DateTime from = DateTime.Now.AddDays(2);
            DateTime to = DateTime.Now.AddDays(4);
            litDeliveryDate.Text = FormatDeliveryRange(from, to);

            // Delivery location from the address entered at checkout.
            string district = Session["District"] as string ?? "";
            string city = CityDisplayName(Session["City"] as string);

            string location = string.IsNullOrEmpty(city)
                ? district
                : (string.IsNullOrEmpty(district) ? city : district + "، " + city);
            litDeliveryTo.Text = HttpUtility.HtmlEncode(location);
        }

        // Builds a range like "2-4 مارس 2026" (uses the end date's month/year).
        private static string FormatDeliveryRange(DateTime from, DateTime to)
        {
            return from.Day + "-" + to.Day + " " + ArabicMonths[to.Month - 1] + " " + to.Year;
        }

        // Maps the stored city value (e.g. "Riyadh") to its Arabic display name.
        private static string CityDisplayName(string value)
        {
            switch (value)
            {
                case "Riyadh": return "الرياض";
                case "Jeddah": return "جدة";
                case "Dammam": return "الدمام";
                case "Makkah": return "مكة المكرمة";
                case "Medina": return "المدينة المنورة";
                case "Taif": return "الطائف";
                default: return value ?? "";
            }
        }

        // Links the "continue shopping" button to the home page.
        protected void btnContinueShopping_Click(object sender, EventArgs e)
        {
            Response.Redirect("Default.aspx");
        }
    }
}
