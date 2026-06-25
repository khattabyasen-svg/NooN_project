

<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="WebForm1.aspx.cs" Inherits="NooN.WebForm1" %>

<%@ Register assembly="System.Web, Version=4.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a" namespace="System.Web.UI" tagprefix="cc1" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title></title>
</head>
<body>
    <form id="form1" runat="server">
        <div>
        </div>
        <asp:ScriptManager ID="ScriptManager1" runat="server">
        </asp:ScriptManager>
        <asp:ScriptManagerProxy ID="ScriptManagerProxy1" runat="server">
        </asp:ScriptManagerProxy>
        <asp:Timer ID="Timer1" runat="server">
        </asp:Timer>
        <asp:UpdatePanel ID="UpdatePanel1" runat="server">
        </asp:UpdatePanel>
        <asp:UpdateProgress ID="UpdateProgress1" runat="server">
        </asp:UpdateProgress>
        <cc1:Control ID="Control1" runat="server">
        </cc1:Control>
        <ajaxToolkit:AccordionPane ID="AccordionPane1" runat="server">
        </ajaxToolkit:AccordionPane>
        <ajaxToolkit:Accordion ID="Accordion1" runat="server">
        </ajaxToolkit:Accordion>
        <ajaxToolkit:AjaxFileUpload ID="AjaxFileUpload1" runat="server" />
        <ajaxToolkit:AreaChart ID="AreaChart1" runat="server">
        </ajaxToolkit:AreaChart>
        <ajaxToolkit:AsyncFileUpload ID="AsyncFileUpload1" runat="server" />
        <ajaxToolkit:BubbleChart ID="BubbleChart1" runat="server">
        </ajaxToolkit:BubbleChart>
        <ajaxToolkit:Gravatar ID="Gravatar1" runat="server" />
        <ajaxToolkit:LineChart ID="LineChart1" runat="server">
        </ajaxToolkit:LineChart>
        <ajaxToolkit:NoBot ID="NoBot1" runat="server" />
        <ajaxToolkit:Twitter ID="Twitter1" runat="server">
        </ajaxToolkit:Twitter>
    </form>
</body>
</html>
