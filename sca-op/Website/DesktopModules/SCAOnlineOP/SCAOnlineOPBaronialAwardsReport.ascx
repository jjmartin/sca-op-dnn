<%@ Import namespace="DotNetNuke.Common" %>
<%@ Import namespace="DotNetNuke.Entities.Modules" %>
<%@ Control Language="c#" AutoEventWireup="false" Inherits="JeffMartin.DNN.Modules.SCAOnlineOP.SCAOPBaronialAwardsReport" targetSchema="http://schemas.microsoft.com/intellisense/ie5" Codebehind="SCAOnlineOPBaronialAwardsReport.ascx.cs" %>
<div class="SCAOPEverything">
	<div runat="server" id="divReportControl">
		
		<asp:DropDownList id="ddlBarony" EnableViewState="true"  Width="270px" runat="server"></asp:DropDownList><br />
		<asp:LinkButton Runat="server" ID="lbGenerateBaronialAwardReport">Generate Baronial Award Report</asp:LinkButton><br />
		<asp:HyperLink Runat="server" ID="hlBaronialAwardReport">Download Last Baronial Award Pdf Report (right-click, save)</asp:HyperLink>
	</div>
 	
</div>

