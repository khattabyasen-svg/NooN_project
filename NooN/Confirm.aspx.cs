using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace NooN
{
    public partial class Confirm : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            // هنا يمكنك إضافة كود لإفراغ السلة (Clear Cart) 
            // بعد نجاح العملية إذا كنت تستخدم Session أو Cookies
        }

        // هذه الدالة تربط زر "متابعة التسوق" بالصفحة الرئيسية
        protected void btnContinueShopping_Click(object sender, EventArgs e)
        {
            // نفترض أن الصفحة الرئيسية اسمها Default.aspx أو Home.aspx
            Response.Redirect("Default.aspx");
        }
    }
}