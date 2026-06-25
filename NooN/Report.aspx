<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="Report.aspx.cs" Inherits="NooN.Report" %>

<%@ Register Assembly="Microsoft.ReportViewer.WebForms"
    Namespace="Microsoft.Reporting.WebForms"
    TagPrefix="rsweb" %>

<!DOCTYPE html>
<html>
<head runat="server">
    <title>RDLC Report</title>
</head>
<body>
    <form id="form1" runat="server">

        <asp:ScriptManager ID="ScriptManager1" runat="server"></asp:ScriptManager>

        <rsweb:ReportViewer ID="ReportViewer1" runat="server"
            Width="100%" Height="600px"
            ProcessingMode="Local">
        </rsweb:ReportViewer>

    </form>
</body>
</html>