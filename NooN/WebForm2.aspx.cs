using System;
using System.Collections.Generic;
using System.Data;
using System.Data.SqlClient;
using System.Configuration;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace NooN
{
    public partial class WebForm2 : System.Web.UI.Page
    {
        string connStr = Db.ConnectionString;

        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                BindCategories();
                SearchProducts();
            }
        }

        private void SearchProducts()
        {
            using (SqlConnection con = new SqlConnection(connStr))
            {
                // ✅ استبدلنا categories بـ product_categories
                string query = @"SELECT p.product_id, p.name, p.price, 
                                        c.name_ar as category_name 
                                 FROM products p 
                                 INNER JOIN product_categories c 
                                        ON p.category_id = c.category_id
                                 WHERE c.is_active = 1
                                   AND (p.name LIKE @SearchText OR @SearchText = '')";

                // ✅ فلتر التصنيف
                if (ddlCategories.SelectedValue != "0" &&
                    ddlCategories.SelectedValue != "")
                {
                    query += " AND p.category_id = @CatID";
                }

                using (SqlCommand cmd = new SqlCommand(query, con))
                {
                    cmd.Parameters.AddWithValue("@SearchText",
                        "%" + txtSearch.Text.Trim() + "%");

                    if (ddlCategories.SelectedValue != "0" &&
                        ddlCategories.SelectedValue != "")
                    {
                        cmd.Parameters.AddWithValue("@CatID",
                            ddlCategories.SelectedValue);
                    }

                    using (SqlDataAdapter da = new SqlDataAdapter(cmd))
                    {
                        DataTable dt = new DataTable();
                        con.Open();
                        da.Fill(dt);
                        gvResults.DataSource = dt;
                        gvResults.DataBind();
                    }
                }
            }
        }

        private void BindCategories()
        {
            using (SqlConnection con = new SqlConnection(connStr))
            {
                // ✅ استبدلنا categories بـ product_categories
                // ✅ أضفنا شرط is_active = 1 لإظهار الفئات النشطة فقط
                string query = @"SELECT category_id, name_ar 
                                 FROM product_categories
                                 WHERE is_active = 1
                                 ORDER BY name_ar";

                using (SqlCommand cmd = new SqlCommand(query, con))
                {
                    con.Open();

                    using (SqlDataReader reader = cmd.ExecuteReader())
                    {
                        ddlCategories.DataSource = reader;
                        ddlCategories.DataTextField = "name_ar";
                        ddlCategories.DataValueField = "category_id";
                        ddlCategories.DataBind();
                    }

                    ddlCategories.Items.Insert(0,
                        new ListItem("--- كل التصنيفات ---", "0"));
                }
            }
        }

        protected void btnSearch_Click(object sender, EventArgs e)
        {
            SearchProducts();
        }

        protected void txtSearch_TextChanged1(object sender, EventArgs e)
        {
            SearchProducts();
        }

        protected void ddlCategories_SelectedIndexChanged(object sender, EventArgs e)
        {
            SearchProducts();
        }

        protected void gvResults_SelectedIndexChanged(object sender, EventArgs e) { }
        protected void rptProducts_ItemCommand(object source, RepeaterCommandEventArgs e) { }
        protected void txtSearch_TextChanged(object sender, EventArgs e) { }
    }
}