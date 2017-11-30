<%@ Control Language="c#" AutoEventWireup="false" Inherits="JeffMartin.DNN.Modules.SCAOnlineOP.SCAOnlineDisplayCrown" targetSchema="http://schemas.microsoft.com/intellisense/ie5" Codebehind="SCAOnlineOPDisplayCrown.ascx.cs" %>
<%@ Import namespace="DotNetNuke.Entities.Modules" %>
<%@ Import namespace="DotNetNuke.Common" %>
<asp:panel id="pnlDefault" Runat="server">
	<asp:HyperLink id="hlEditCrown" Runat="server">
		<asp:image Runat="server" ID="imgGroupCrown" ImageUrl="~/images/edit.gif" />
	</asp:HyperLink>(Still working on this screen - send comments to <a href="mailto:webmin@atenveldt.org">webmin@atenveldt.com</a>)
	<H1 id="H1CrownName" runat="server">Crown Names</H1>
	<DIV class="HeirsNotify" id="divHeirsNotify" runat="server">(Heirs)</DIV>
	<H2>
		<asp:Literal id="litCrownOrdinal" Runat="server">xxth</asp:Literal>
		<asp:Literal id="litReignType" Runat="server"></asp:Literal> of
		<asp:hyperlink id="hlGroup" Runat="server">Some place</asp:hyperlink></H2>
	<asp:HyperLink id="hlEmail" Runat="server">Email</asp:HyperLink>
	<TABLE>
		<TR>
			<TD>
				<asp:Image id="imgCrownPhoto1" Runat="server"></asp:Image></TD>
			<TD>
				<asp:Image id="imgCrownPhoto2" Runat="server"></asp:Image></TD>
		</TR>
		<TR>
			<TD>
				<asp:Literal id="litCaption1" Runat="server"></asp:Literal></TD>
			<TD>
				<asp:Literal id="litCaption2" Runat="server"></asp:Literal></TD>
		</TR>
		<TR>
			<TD>
				<asp:Literal id="litCredit1" Runat="server"></asp:Literal></TD>
			<TD>
				<asp:Literal id="litCredit2" Runat="server"></asp:Literal></TD>
		</TR>
		<TR>
			<TD align="center" colSpan="2">
				<DIV style="TEXT-ALIGN: left">
					<TABLE>
						<TR id="trCrown" runat="server">
							<TD>Crown:</TD>
							<TD id="tdCrownInfo" runat="server"></TD>
						</TR>
						<TR id="trCoronation" runat="server">
							<TD>Coronation:</TD>
							<TD id="tdCoronationInfo" runat="server"></TD>
						</TR>
						<TR id="trStepDown" runat="server">
							<TD>Stepped Down:</TD>
							<TD id="tdStepDownInfo" runat="server"></TD>
						</TR>
						<TR>
							<TD>Notes:</TD>
							<TD id="tdNotes" runat="server"></TD>
						</TR>
					</TABLE>
				</DIV>
			</TD>
		</TR>
	</TABLE>
	<TABLE>
		<TR>
			<TD>
				<asp:Image id="imgSovereignArms" Runat="server"></asp:Image></TD>
			<TD>
				<asp:HyperLink id="hlSovereignName" Runat="server"></asp:HyperLink>
				<DIV id="divSovereignBlazon" runat="server"></DIV>
			</TD>
			<TD>
				<asp:Image id="imgSovereignPersonalArms" Runat="server"></asp:Image></TD>
		</TR>
		<TR>
			<TD>
				<asp:Image id="imgConsortArms" Runat="server"></asp:Image></TD>
			<TD>
				<asp:HyperLink id="hlConsortName" Runat="server"></asp:HyperLink>
				<DIV id="divConsortBlazon" runat="server"></DIV>
			</TD>
			<TD>
				<asp:Image id="imgConsortPersonalArms" Runat="server"></asp:Image></TD>
		</TR>
	</TABLE>
</asp:panel>

