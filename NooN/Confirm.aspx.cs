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

            // Point the print button at the order details report for this order.
            // Falls back to hidden if the numeric order id is missing from Session.
            if (Session["OrderId"] != null)
            {
                btnPrintOrder.NavigateUrl = "OrderReport.aspx?id=" + Convert.ToInt32(Session["OrderId"]);
            }
            else
            {
                btnPrintOrder.Visible = false;
            }

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

        // Formats each date fully so the window is correct across month/year
        // boundaries: same month -> "2 - 4 مارس 2026"; different month ->
        // "30 يناير - 2 فبراير 2026"; different year adds each year.
        private static string FormatDeliveryRange(DateTime from, DateTime to)
        {
            string fromMonth = ArabicMonths[from.Month - 1];
            string toMonth = ArabicMonths[to.Month - 1];

            if (from.Year == to.Year && from.Month == to.Month)
                return $"{from.Day} - {to.Day} {toMonth} {to.Year}";

            if (from.Year == to.Year)
                return $"{from.Day} {fromMonth} - {to.Day} {toMonth} {to.Year}";

            return $"{from.Day} {fromMonth} {from.Year} - {to.Day} {toMonth} {to.Year}";
        }

        // Maps the stored governorate value (e.g. "Amman") to its Arabic display name.
        private static string CityDisplayName(string value)
        {
            switch (value)
            {
                case "Amman": return "عمّان";
                case "Irbid": return "إربد";
                case "Zarqa": return "الزرقاء";
                case "Balqa": return "البلقاء";
                case "Madaba": return "مادبا";
                case "Mafraq": return "المفرق";
                case "Jerash": return "جرش";
                case "Ajloun": return "عجلون";
                case "Karak": return "الكرك";
                case "Tafilah": return "الطفيلة";
                case "Maan": return "معان";
                case "Aqaba": return "العقبة";
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
