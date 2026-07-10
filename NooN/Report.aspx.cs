using Microsoft.Reporting.WebForms;
using System;
using System.Collections.Generic;
using System.Configuration;
using System.Data;
using System.Data.SqlClient;
using System.Drawing;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace NooN
{
    public partial class Report : System.Web.UI.Page
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
            //Step 1: Get Data
            DataTable dt = new DataTable();

            using (SqlDataAdapter da = new SqlDataAdapter(@"
                                       SELECT
                        p.product_id,
                        p.category_id AS product_category_id,
                        p.name AS product_name,
                        c.name_ar AS category_name_ar,
                        c.name_en AS category_name_en
                    FROM products p
                    INNER JOIN product_categories c
                        ON p.category_id = c.category_id;

                    ", connStr))
            {
                da.Fill(dt);
            }

            // Step 2: Set Report Path
            ReportViewer1.LocalReport.ReportPath = Server.MapPath("~/reports/Report1.rdlc");

            // Step 3: Clear old data
            ReportViewer1.LocalReport.DataSources.Clear();

            // IMPORTANT: Name must match RDLC DataSet Name
            ReportDataSource rds = new ReportDataSource("DataSet2", dt);

            ReportViewer1.LocalReport.DataSources.Add(rds);

            //Step 4: Refresh
            ReportViewer1.LocalReport.Refresh();
        }
    }
}