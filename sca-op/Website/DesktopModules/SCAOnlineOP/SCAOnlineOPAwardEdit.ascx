<%@ Control Language="c#" AutoEventWireup="false" Inherits="JeffMartin.DNN.Modules.SCAOnlineOP.SCAOnlineOPAwardEdit" targetSchema="http://schemas.microsoft.com/intellisense/ie5" Codebehind="SCAOnlineOPAwardEdit.ascx.cs" %>
<%@ Register TagPrefix="Portal" TagName="URL" Src="~/controls/URLControl.ascx" %>
<%@ Register TagPrefix="dnn" TagName="TextEditor" Src="~/controls/TextEditor.ascx" %>
<asp:panel id="pnlDisplayAward" Runat="server" Visible="true" cssclass="EditContainer">
	<TABLE cellSpacing="3" cellPadding="3" width="100%" border="0">
		<TR>
			<TD id="tdEditAward" vAlign="top" runat="server">
				<asp:HyperLink id="hlReturnToDisplay" Runat="server">Return To Award Display</asp:HyperLink></TD>
		</TR>
		<TR>
			<TD>
				<H1 class="MemberName" id="H1AwardName" runat="server">Award Name</H1>
				<asp:textbox id="txtAwardName" Runat="server" Width="300"></asp:textbox><BR>
				<asp:DropDownList id="ddlGroup" Runat="server"></asp:DropDownList><BR>
				<asp:CheckBox id="chkClosed" Runat="server" Text="Award Closed"></asp:CheckBox><BR>
				Awarded By:
				<asp:RadioButtonList id="rblAwardedBy" Runat="server" RepeatLayout="Table" RepeatDirection="Horizontal">
					<asp:ListItem Value="1">Both</asp:ListItem>
					<asp:ListItem Value="2">Sovereign</asp:ListItem>
					<asp:ListItem Value="3">Consort</asp:ListItem>
				</asp:RadioButtonList><BR>
				Precedence Value:
				<asp:textbox id="txtPrecedence" Runat="server"></asp:textbox><BR>
				<asp:CheckBox ID="chkHonorary" runat="server" Text="Honorary Award"></asp:CheckBox><br>
				SortOrder Value:
				<asp:textbox id="txtSortOrder" Runat="server"></asp:textbox><BR>
				Award Group:
				<asp:DropDownList id="ddlAwardGroup" Runat="server"></asp:DropDownList><BR>
			</TD>
		</TR>
	</TABLE>
	<TABLE cellSpacing="0" cellPadding="0" border="0">
		<TR>
			<TD vAlign="top">
				<FIELDSET><LEGEND>Member Arms</LEGEND>
					<asp:Image id="imgAwardBadge" Runat="server"></asp:Image><BR>
					<portal:url id="urlBadge" runat="server" showtrack="False" shownewwindow="False" showlog="False"
						showUrls="True" showfiles="True" showtabs="False" width="300" showNone="True"></portal:url></FIELDSET>
			</TD>
			<TD id="tdAwardBlazon" vAlign="top" runat="server">Blazon:<BR>
				<asp:TextBox id="txtBlazon" Runat="server" Width="300" TextMode="MultiLine" Height="100"></asp:TextBox>
				<DIV></DIV>
			</TD>
		</TR>
	</TABLE>
	<H2 id="H2AwardCharter" runat="server">Award Charter</H2>
	<dnn:texteditor id="teCharter" runat="server" width="450" height="300"></dnn:texteditor>
	<BR>
	<BR>
	<asp:linkbutton id="cmdUpdate" runat="server" CssClass="CommandButton" resourcekey="cmdUpdate" BorderStyle="None">Update</asp:linkbutton>
	<asp:linkbutton id="cmdCancel" runat="server" CssClass="CommandButton" resourcekey="cmdCancel" BorderStyle="None"
		CausesValidation="False">Cancel</asp:linkbutton>
	<asp:linkbutton id="cmdDelete" Visible="False" runat="server" CssClass="CommandButton" resourcekey="cmdDelete"
		BorderStyle="None" CausesValidation="False">Delete</asp:linkbutton>
</asp:panel>

