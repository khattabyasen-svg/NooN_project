using System;
using System.Collections.Generic;
using System.Configuration;
using System.Data;
using System.Data.SqlClient;
using System.IO;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace NooN
{
    public partial class AddnewItem : Page
    {
        string connStr = Db.ConnectionString;
        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                LoadCategories();
            }

        }

        // تحميل التصنيفات في القائمة المنسدلة
        private void LoadCategories()
        {
            try
            {
                using (SqlConnection conn = new SqlConnection(connStr))
                using (SqlCommand cmd = new SqlCommand(
                    "SELECT category_id, name_en FROM product_categories WHERE is_active = 1 ORDER BY name_en", conn))
                {
                    conn.Open();
                    using (SqlDataReader reader = cmd.ExecuteReader())
                    {
                        ddlCategory.Items.Clear();
                        ddlCategory.Items.Add(new ListItem("Choose a category", "0"));
                        while (reader.Read())
                        {
                            ddlCategory.Items.Add(new ListItem(
                                reader["name_en"].ToString(),
                                reader["category_id"].ToString()));
                        }
                    }
                }
            }
            catch (Exception ex)
            {
                ShowMessage("Error loading categories: " + ex.Message, false);
            }
        }

        protected void btnSubmit_Click(object sender, EventArgs e)
        {
            // 1) التحقق من المدخلات
            if (!ValidateInput())
                return;

            try
            {
                // 2) معالجة رفع الصور وإرجاعها كنص مفصول بفواصل
                string imagesCsv = SaveUploadedImages();

                // 3) تجميع الألوان والمقاسات المختارة
                string colors = GetSelectedColors();
                string sizes = GetSelectedValues(cblSizes);

                // 4) الإدخال في قاعدة البيانات
                int newId = InsertProduct(imagesCsv, colors, sizes);

                ShowMessage($"The product was successfully saved (Product Number: {newId})", true);
                ClearForm();
            }
            catch (SqlException sqlEx)
            {
                // التعامل مع تكرار الـ SKU أو الـ Slug (UNIQUE constraints)
                if (sqlEx.Number == 2627 || sqlEx.Number == 2601)
                    ShowMessage("The product code (SKU) or alternative link (Slug) is already in use.", false);
                else
                    ShowMessage("Database error:" + sqlEx.Message, false);
            }
            catch (Exception ex)
            {
                ShowMessage("حدث خطأ: " + ex.Message, false);
            }
        }

        // التحقق من الحقول الإلزامية
        private bool ValidateInput()
        {
            if (string.IsNullOrWhiteSpace(txtName.Text))
            {
                ShowMessage("Please register the product name.", false);
                return false;
            }
            if (string.IsNullOrWhiteSpace(txtSlug.Text))
            {
                ShowMessage("Please enter the alternative link (Slug).", false);
                return false;
            }
            if (ddlCategory.SelectedValue == "0")
            {
                ShowMessage("Please select a category.", false);
                return false;
            }
            if (string.IsNullOrWhiteSpace(txtSKU.Text))
            {
                ShowMessage("Please enter the product code (SKU).", false);
                return false;
            }
            if (!decimal.TryParse(txtPrice.Text, out decimal price) || price <= 0)
            {
                ShowMessage("Please enter a valid price greater than zero.", false);
                return false;
            }
            // Old price (optional): If entered, it must be a positive number and greater than the current price
            if (!string.IsNullOrWhiteSpace(txtOldPrice.Text))
            {
                if (!decimal.TryParse(txtOldPrice.Text, out decimal oldPrice) || oldPrice <= 0)
                {
                    ShowMessage("Please enter a valid old price greater than zero.", false);
                    return false;
                }
                if (oldPrice <= price)
                {
                    ShowMessage("The old price should be higher than the current price.", false);
                    return false;
                }
            }
            // الخصم (اختياري): إن أُدخل يجب أن يكون بين 0 و 100
            if (!string.IsNullOrWhiteSpace(txtDiscount.Text))
            {
                if (!decimal.TryParse(txtDiscount.Text, out decimal discount) || discount < 0 || discount > 100)
                {
                    ShowMessage("Please enter a correct discount percentage between 0 and 100.", false);
                    return false;
                }
            }
            // Stock quantity (optional): if entered it must be zero or a positive whole number.
            if (!string.IsNullOrWhiteSpace(txtStockQty.Text))
            {
                if (!int.TryParse(txtStockQty.Text, out int stockQty) || stockQty < 0)
                {
                    ShowMessage("Please enter a valid stock quantity (0 or more).", false);
                    return false;
                }
            }
            return true;
        }

        // حفظ الصور المرفوعة في مجلد وإرجاع مساراتها كـ CSV
        private string SaveUploadedImages()
        {
            if (!fileImages.HasFiles)
                return null;

            // مجلد التخزين داخل المشروع: ~/Uploads/Products
            string folderVirtual = "~/Uploads/Products/";
            string folderPhysical = Server.MapPath(folderVirtual);

            if (!Directory.Exists(folderPhysical))
                Directory.CreateDirectory(folderPhysical);

            List<string> savedPaths = new List<string>();
            string[] allowed = { ".jpg", ".jpeg", ".png", ".gif", ".webp" };

            foreach (HttpPostedFile file in fileImages.PostedFiles)
            {
                if (file.ContentLength == 0)
                    continue;

                string ext = Path.GetExtension(file.FileName).ToLower();
                if (!allowed.Contains(ext))
                    throw new Exception($"File type not supported: {ext}");

                // اسم فريد لتجنب التكرار
                string uniqueName = $"{Guid.NewGuid():N}{ext}";
                string savePath = Path.Combine(folderPhysical, uniqueName);
                file.SaveAs(savePath);

                // خزّن المسار النسبي في قاعدة البيانات
                savedPaths.Add(folderVirtual.TrimStart('~') + uniqueName);
            }

            return string.Join(",", savedPaths);
        }

        // الألوان = المختارة من القائمة + لون مخصص إن وجد
        private string GetSelectedColors()
        {
            List<string> colors = cblColors.Items.Cast<ListItem>()
                .Where(i => i.Selected)
                .Select(i => i.Value)
                .ToList();

            if (!string.IsNullOrWhiteSpace(txtCustomColor.Text))
                colors.Add(txtCustomColor.Text.Trim());

            return colors.Count > 0 ? string.Join(",", colors) : null;
        }

        private string GetSelectedValues(CheckBoxList list)
        {
            var selected = list.Items.Cast<ListItem>()
                .Where(i => i.Selected)
                .Select(i => i.Value)
                .ToList();
            return selected.Count > 0 ? string.Join(",", selected) : null;
        }

        // الإدخال باستخدام ADO.NET مع باراميترات (آمن ضد الـ SQL Injection)
        private int InsertProduct(string imagesCsv, string colors, string sizes)
        {
            string sql = @"
                INSERT INTO products
                    (category_id, name, slug, description, price, old_price,
                     discount_pct, brand, sku, images, status, created_at, updated_at,
                     available_colors, available_sizes)
                OUTPUT INSERTED.product_id
                VALUES
                    (@category_id, @name, @slug, @description, @price, @old_price,
                     @discount_pct, @brand, @sku, @images, @status, GETDATE(), GETDATE(),
                     @available_colors, @available_sizes);";

            using (SqlConnection conn = new SqlConnection(connStr))
            using (SqlCommand cmd = new SqlCommand(sql, conn))
            {
                cmd.Parameters.AddWithValue("@category_id", int.Parse(ddlCategory.SelectedValue));
                cmd.Parameters.AddWithValue("@name", txtName.Text.Trim());
                cmd.Parameters.AddWithValue("@slug", txtSlug.Text.Trim());
                cmd.Parameters.AddWithValue("@description",
                    string.IsNullOrWhiteSpace(txtDescription.Text) ? (object)DBNull.Value : txtDescription.Text.Trim());
                cmd.Parameters.AddWithValue("@price", decimal.Parse(txtPrice.Text));
                cmd.Parameters.AddWithValue("@old_price",
                    string.IsNullOrWhiteSpace(txtOldPrice.Text) ? (object)DBNull.Value : decimal.Parse(txtOldPrice.Text));
                cmd.Parameters.AddWithValue("@discount_pct",
                    string.IsNullOrWhiteSpace(txtDiscount.Text) ? 0 : decimal.Parse(txtDiscount.Text));
                cmd.Parameters.AddWithValue("@brand",
                    string.IsNullOrWhiteSpace(txtBrand.Text) ? (object)DBNull.Value : txtBrand.Text.Trim());
                cmd.Parameters.AddWithValue("@sku", txtSKU.Text.Trim());
                cmd.Parameters.AddWithValue("@images", (object)imagesCsv ?? DBNull.Value);
                cmd.Parameters.AddWithValue("@status", "active");
                cmd.Parameters.AddWithValue("@available_colors", (object)colors ?? DBNull.Value);
                cmd.Parameters.AddWithValue("@available_sizes", (object)sizes ?? DBNull.Value);

                conn.Open();
                // OUTPUT INSERTED.product_id يرجع رقم المنتج الجديد
                return (int)cmd.ExecuteScalar();
            }
        }

        protected void btnCancel_Click(object sender, EventArgs e)
        {
            Response.Redirect("Prouduct.aspx");
        }

        private void ClearForm()
        {
            txtName.Text = txtSlug.Text = txtBrand.Text = txtSKU.Text = "";
            txtPrice.Text = txtOldPrice.Text = txtDiscount.Text = "";
            txtDescription.Text = txtCustomColor.Text = "";
            ddlCategory.SelectedValue = "0";
            foreach (ListItem i in cblColors.Items) i.Selected = false;
            foreach (ListItem i in cblSizes.Items) i.Selected = false;
        }

        private void ShowMessage(string message, bool success)
        {
            lblMessage.Visible = true;
            lblMessage.Text = message;
            lblMessage.CssClass = success
                ? "block mb-4 p-3 rounded-lg bg-green-100 text-green-700"
                : "block mb-4 p-3 rounded-lg bg-red-100 text-red-700";
        }
    }
}