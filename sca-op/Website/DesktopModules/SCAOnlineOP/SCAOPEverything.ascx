<%@ Import namespace="DotNetNuke.Common" %>
<%@ Import namespace="DotNetNuke.Entities.Modules" %>
<%@ Control Language="c#" AutoEventWireup="false" Inherits="JeffMartin.DNN.Modules.SCAOnlineOP.SCAOPEverything" targetSchema="http://schemas.microsoft.com/intellisense/ie5" Codebehind="SCAOPEverything.ascx.cs" %>
<div class="SCAOPEverything">
	<div runat="server" id="divReportControl">
	Full Reports:<br />
		<asp:LinkButton Runat="server" ID="lbGeneratePdf">Generate PDF Report</asp:LinkButton><br />
        <asp:LinkButton ID="lbGeneratePdfNoDead" runat="server">Generate PDF Report (no deceased or non-residents)</asp:LinkButton><br /><br />
        Crown Award Report:<br />
		<asp:DropDownList id="ddlEdit_GivenBy" EnableViewState="true" CssClass="awardList" Width="270px" runat="server"></asp:DropDownList><br />
		<asp:LinkButton Runat="server" ID="lbGenerateCrownAwardReport">Generate Crown Award Report</asp:LinkButton><br />
		<br />
		Southwind Report:<br />
		Enter Days back to run the report: <asp:TextBox runat="server" ID="txtDays" Width="70px" Text="31"></asp:TextBox><br />
        Choose a group or leave on None for all awards during the time span: <asp:DropDownList ID="ddlGroupList" runat="server" CssClass="awardList" EnableViewState="true" Width="270px" /><br />
        <asp:LinkButton ID="lbGenerateSouthwindReport" runat="server">Generate SouthWind Report</asp:LinkButton><br />
		
		View the Reports<br />
		<asp:Label Runat="server" ID="lblResults"></asp:Label><br />
		
		<asp:HyperLink Runat="server" ID="hlPdfReportLink">Download Pdf Report (right-click, save)</asp:HyperLink><br />
		<asp:HyperLink Runat="server" ID="hlCrownAwardReport">Download Last Crown Award Pdf Report (right-click, save)</asp:HyperLink><br />
        <asp:HyperLink ID="hlSouthwindAwardReport" runat="server">Download Last Southwind Award Pdf Report (right-click, save)</asp:HyperLink>
        
        <br />
        <br />
        
	</div>
 	
</div>

