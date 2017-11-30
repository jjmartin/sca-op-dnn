<%@ Register TagPrefix="dnn" TagName="TextEditor" Src="~/controls/TextEditor.ascx" %>
<%@ Register TagPrefix="Portal" TagName="URL" Src="~/controls/URLControl.ascx" %>
<%@ Control Language="c#" AutoEventWireup="false" Inherits="JeffMartin.DNN.Modules.SCAOnlineOP.SCAOnlineOPGroupEdit" targetSchema="http://schemas.microsoft.com/intellisense/ie5" Codebehind="SCAOnlineOPGroupEdit.ascx.cs" %>
<asp:panel id="pnlDisplayCrown" Runat="server" Visible="true" cssclass="EditContainer">
	<TABLE cellSpacing="3" cellPadding="3" width="100%" border="0">
		<TR>
			<TD id="tdEditAward" vAlign="top" colSpan="2" runat="server">
				<asp:HyperLink id="hlReturnToDisplay" Runat="server">Return To Group Display</asp:HyperLink></TD>
		</TR>
		<TR>
			<TD>
				<TABLE>
					<TR>
						<TD>Group Id:</TD>
						<TD><%=gid.ToString()%></TD>
					</TR>
					<TR>
						<TD>Name:</TD>
						<TD>
							<asp:TextBox id="txtName" Runat="server"></asp:TextBox></TD>
					</TR>
					<TR>
						<TD>Branch Status:</TD>
						<TD>
							<asp:DropDownList id="ddlBranchStatus" Runat="server"></asp:DropDownList></TD>
					</TR>
					<TR>
						<TD>SCA Branch Designation:</TD>
						<TD>
							<asp:DropDownList id="ddlDesignation" Runat="server"></asp:DropDownList></TD>
					</TR>
					<TR>
						<TD>Reign Type (as in type of rulers):</TD>
						<TD>
							<asp:DropDownList id="ddlReignType" Runat="server">
								<asp:ListItem Value="">&lt;None Selected&gt;</asp:ListItem>
								<asp:ListItem Value="Crown">Crown</asp:ListItem>
								<asp:ListItem Value="Coronet">Coronet</asp:ListItem>
							</asp:DropDownList></TD>
					</TR>
					<TR>
						<TD>Parent Group:</TD>
						<TD>
							<asp:DropDownList id="ddlParentGroup" Runat="server"></asp:DropDownList></TD>
					</TR>
					<TR>
						<TD>Code:</TD>
						<TD>
							<asp:TextBox id="txtCode" Runat="server"></asp:TextBox></TD>
					</TR>
					<TR>
						<TD>Location:</TD>
						<TD>
							<asp:TextBox id="txtLocation" Runat="server"></asp:TextBox></TD>
					</TR>
					<TR>
						<TD>Precedence Number:</TD>
						<TD>
							<asp:TextBox id="txtPrecedence" Runat="server"></asp:TextBox></TD>
					</TR>
					<TR>
						<TD>Founding Date:</TD>
						<TD>
							<asp:TextBox id="txtFoundingDate" Runat="server"></asp:TextBox></TD>
					</TR>
					<TR>
						<TD>Hidden:</TD>
						<TD>
							<asp:CheckBox id="chkHidden" runat="server"></asp:CheckBox></TD>
					</TR>
					<TR>
						<TD vAlign="top">Arms Blazon:</TD>
						<TD>
							<asp:TextBox id="txtArmsBlazon" Runat="server" TextMode="MultiLine" Width="300" Height="200"></asp:TextBox></TD>
					</TR>
					<TR>
						<TD>Sovereign Male Title:</TD>
						<TD>
							<asp:TextBox id="txtSovereignMaleTitle" Runat="server"></asp:TextBox></TD>
					</TR>
					<TR>
						<TD>Sovereign Female Title:</TD>
						<TD>
							<asp:TextBox id="txtSovereignFemaleTitle" Runat="server"></asp:TextBox></TD>
					</TR>
					<TR>
						<TD>Consort Male Title:</TD>
						<TD>
							<asp:TextBox id="txtConsortMaleTitle" Runat="server"></asp:TextBox></TD>
					</TR>
					<TR>
						<TD>Consort Female Title:</TD>
						<TD>
							<asp:TextBox id="txtConsortFemaleTitle" Runat="server"></asp:TextBox></TD>
					</TR>
					<TR>
						<TD>Regency Type(Regency/Vicary):</TD>
						<TD>
							<asp:TextBox id="txtRegencyType" Runat="server"></asp:TextBox></TD>
					</TR>
					<TR>
						<TD>Regent Male Title:</TD>
						<TD>
							<asp:TextBox id="txtRegentMaleTitle" Runat="server"></asp:TextBox></TD>
					</TR>
					<TR>
						<TD>Regent Female Title:</TD>
						<TD>
							<asp:TextBox id="txtRegentFemaleTitle" Runat="server"></asp:TextBox></TD>
					</TR>
					<TR>
						<TD vAlign="top">Sovereign Blazon:</TD>
						<TD>
							<asp:TextBox id="txtSovereignBlazon" Runat="server" TextMode="MultiLine" Width="300" Height="200"></asp:TextBox></TD>
					</TR>
					<TR>
						<TD vAlign="top">Consort Blazon:</TD>
						<TD>
							<asp:TextBox id="txtConsortBlazon" Runat="server" TextMode="MultiLine" Width="300" Height="200"></asp:TextBox></TD>
					</TR>
					<TR>
						<TD>Notes (public):</TD>
						<TD>
							<asp:TextBox id="txtNotes" Runat="server" TextMode="MultiLine" Width="300" Height="200"></asp:TextBox></TD>
					</TR>
				</TABLE>
			</TD>
			<TD vAlign="top">&nbsp;</TD>
		</TR>
	</TABLE>
	<TABLE cellSpacing="0" cellPadding="0" border="0">
		<TR>
			<TD vAlign="top">
				<FIELDSET><LEGEND>Alternate Display Page</LEGEND><BR>
					<portal:url id="urlInternalUrl" runat="server" showNone="true" width="300" showtabs="True" showfiles="False"
						showUrls="true" showlog="False" shownewwindow="False" showtrack="False"></portal:url></FIELDSET>
			</TD>
			<TD>
				<FIELDSET><LEGEND>External Display Page</LEGEND><BR>
					<portal:url id="urlWebSiteUrl" runat="server" showNone="true" width="300" showtabs="True" showfiles="False"
						showUrls="true" showlog="False" shownewwindow="False" showtrack="False"></portal:url></FIELDSET>
			</TD>
		</TR>
	</TABLE>
	<TABLE cellSpacing="0" cellPadding="0" border="0">
		<TR>
			<TD vAlign="top">
				<FIELDSET><LEGEND>Group Arms</LEGEND>
					<asp:Image id="imgGroupArms" Runat="server"></asp:Image><BR>
					<portal:url id="urlGroupArmsUrl" runat="server" showNone="True" width="300" showtabs="False"
						showfiles="True" showUrls="True" showlog="False" shownewwindow="False" showtrack="False"></portal:url></FIELDSET>
			</TD>
			<TD>
				<FIELDSET><LEGEND>Sovereign Arms</LEGEND>
					<asp:Image id="imgSovereignArms" Runat="server"></asp:Image><BR>
					<portal:url id="urlSovereignArmsUrl" runat="server" showNone="True" width="300" showtabs="False"
						showfiles="True" showUrls="True" showlog="False" shownewwindow="False" showtrack="False"></portal:url></FIELDSET>
			</TD>
			<TD>
				<FIELDSET><LEGEND>Consort Arms</LEGEND>
					<asp:Image id="imgConsortArms" Runat="server"></asp:Image><BR>
					<portal:url id="urlConsortArmsUrl" runat="server" showNone="True" width="300" showtabs="False"
						showfiles="True" showUrls="True" showlog="False" shownewwindow="False" showtrack="False"></portal:url></FIELDSET>
			</TD>
		</TR>
	</TABLE>
	<BR>
	<BR>
	<asp:linkbutton id="cmdUpdate" runat="server" BorderStyle="None" resourcekey="cmdUpdate" CssClass="CommandButton">Update</asp:linkbutton>
	<asp:linkbutton id="cmdCancel" runat="server" BorderStyle="None" resourcekey="cmdCancel" CssClass="CommandButton"
		CausesValidation="False">Cancel</asp:linkbutton>
	<asp:linkbutton id="cmdDelete" Visible="False" runat="server" BorderStyle="None" resourcekey="cmdDelete"
		CssClass="CommandButton" CausesValidation="False">Delete</asp:linkbutton>
</asp:panel>

