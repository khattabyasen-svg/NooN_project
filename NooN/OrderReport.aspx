<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="OrderReport.aspx.cs" Inherits="NooN.OrderReport" %>

<%@ Register Assembly="Microsoft.ReportViewer.WebForms"
    Namespace="Microsoft.Reporting.WebForms"
    TagPrefix="rsweb" %>

<!DOCTYPE html>
<html>
<head runat="server">
    <meta charset="UTF-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1.0" />
    <title>Order Details Report</title>
    <style>
        body { margin: 0; padding: 0; font-family: sans-serif; background: #f5f5f5; }
        .report-wrapper { width: 100%; overflow-x: auto; -webkit-overflow-scrolling: touch; }
    </style>
</head>
<body>
    <form id="form1" runat="server">

        <asp:ScriptManager ID="ScriptManager1" runat="server"></asp:ScriptManager>

        <div class="report-wrapper">
        <rsweb:ReportViewer ID="ReportViewer1" runat="server"
            Width="100%" Height="600px"
            ProcessingMode="Local">
        </rsweb:ReportViewer>
        </div>

    </form>
</body>
</html>
