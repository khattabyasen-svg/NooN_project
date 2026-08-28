using System;
using System.Web;
using System.Web.UI;

namespace NooN
{
    public partial class Confirm : System.Web.UI.Page
    {
        // English (Gregorian) month names — used so the delivery estimate is
        // formatted consistently regardless of the server culture.
        private static readonly string[] Months =
        {
            "January", "February", "March", "April", "May", "June",
            "July", "August", "September", "October", "November", "December"
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
                : (string.IsNullOrEmpty(district) ? city : district + ", " + city);
            litDeliveryTo.Text = HttpUtility.HtmlEncode(location);
        }

        // Formats each date fully so the window is correct across month/year
        // boundaries: same month -> "2 - 4 March 2026"; different month ->
        // "30 January - 2 February 2026"; different year adds each year.
        private static string FormatDeliveryRange(DateTime from, DateTime to)
        {
            string fromMonth = Months[from.Month - 1];
            string toMonth = Months[to.Month - 1];

            if (from.Year == to.Year && from.Month == to.Month)
                return $"{from.Day} - {to.Day} {toMonth} {to.Year}";

            if (from.Year == to.Year)
                return $"{from.Day} {fromMonth} - {to.Day} {toMonth} {to.Year}";

            return $"{from.Day} {fromMonth} {from.Year} - {to.Day} {toMonth} {to.Year}";
        }

        // Maps the stored governorate value (e.g. "Amman") to its display name.
        // Values are already stored in English, so they are returned as-is.
        private static string CityDisplayName(string value)
        {
            return value ?? "";
        }

        // Links the "continue shopping" button to the home page.
        protected void btnContinueShopping_Click(object sender, EventArgs e)
        {
            Response.Redirect("Default.aspx");
        }
    }
}
