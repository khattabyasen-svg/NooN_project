using Microsoft.Reporting.WebForms;
using System;
using System.Data;
using System.Data.SqlClient;

namespace NooN
{
    public partial class OrderReport : System.Web.UI.Page
    {
        private static readonly string connStr = Db.ConnectionString;

        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                LoadReport();
            }
        }

        private void LoadReport()
        {
            // Step 1: Resolve the order id (from query string, otherwise latest order)
            int orderId = GetOrderId();

            // Step 2: Get data - order header (order + customer + shipping address)
            DataTable dtHeader = new DataTable();
            using (SqlConnection cn = new SqlConnection(connStr))
            using (SqlCommand cmd = new SqlCommand(@"
                    SELECT
                        o.order_id,
                        o.order_number,
                        o.status,
                        o.placed_at,
                        o.subtotal,
                        o.discount_amt,
                        o.tax_amt,
                        o.shipping_fee,
                        o.total,
                        u.first_name,
                        u.last_name,
                        u.email,
                        u.phone,
                        a.label AS address_label,
                        a.city,
                        a.district,
                        a.street
                    FROM orders o
                    INNER JOIN users u ON u.user_id = o.user_id
                    LEFT JOIN addresses a ON a.address_id = o.address_id
                    WHERE o.order_id = @order_id;
                    ", cn))
            {
                cmd.Parameters.AddWithValue("@order_id", orderId);
                using (SqlDataAdapter da = new SqlDataAdapter(cmd))
                {
                    da.Fill(dtHeader);
                }
            }

            // Order items with product names
            DataTable dtItems = new DataTable();
            using (SqlConnection cn = new SqlConnection(connStr))
            using (SqlCommand cmd = new SqlCommand(@"
                    SELECT
                        oi.item_id,
                        p.name AS product_name,
                        oi.color,
                        oi.size,
                        oi.quantity,
                        oi.unit_price,
                        oi.subtotal
                    FROM order_items oi
                    LEFT JOIN products p ON p.product_id = oi.product_id
                    WHERE oi.order_id = @order_id
                    ORDER BY oi.item_id;
                    ", cn))
            {
                cmd.Parameters.AddWithValue("@order_id", orderId);
                using (SqlDataAdapter da = new SqlDataAdapter(cmd))
                {
                    da.Fill(dtItems);
                }
            }

            // Step 3: Set report path
            ReportViewer1.LocalReport.ReportPath = Server.MapPath("~/reports/OrderDetailsReport.rdlc");

            // Step 4: Bind data sources (names must match RDLC DataSet names)
            ReportViewer1.LocalReport.DataSources.Clear();
            ReportViewer1.LocalReport.DataSources.Add(new ReportDataSource("OrderHeader", dtHeader));
            ReportViewer1.LocalReport.DataSources.Add(new ReportDataSource("OrderItems", dtItems));

            // Step 5: Refresh
            ReportViewer1.LocalReport.Refresh();
        }

        private int GetOrderId()
        {
            int orderId;
            if (int.TryParse(Request.QueryString["id"], out orderId))
            {
                return orderId;
            }

            // Fallback: most recently placed order
            using (SqlConnection cn = new SqlConnection(connStr))
            using (SqlCommand cmd = new SqlCommand(
                "SELECT TOP 1 order_id FROM orders ORDER BY placed_at DESC;", cn))
            {
                cn.Open();
                object result = cmd.ExecuteScalar();
                return result == null ? 0 : Convert.ToInt32(result);
            }
        }
    }
}
