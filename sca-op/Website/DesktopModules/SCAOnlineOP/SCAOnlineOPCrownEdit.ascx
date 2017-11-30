<%@ Register TagPrefix="dnn" TagName="TextEditor" Src="~/controls/TextEditor.ascx" %>
<%@ Register TagPrefix="Portal" TagName="URL" Src="~/controls/URLControl.ascx" %>
<%@ Control Language="c#" AutoEventWireup="false" Inherits="JeffMartin.DNN.Modules.SCAOnlineOP.SCAOnlineOPCrownEdit" targetSchema="http://schemas.microsoft.com/intellisense/ie5" Codebehind="SCAOnlineOPCrownEdit.ascx.cs" %>
<asp:panel id="pnlDisplayCrown" cssclass="EditContainer" Visible="true" Runat="server">
	<TABLE cellSpacing="3" cellPadding="3" width="100%" border="0">
		<TR>
			<TD id="tdEditAward" vAlign="top" colSpan="2" runat="server">
				<asp:HyperLink id="hlReturnToDisplay" Runat="server">Return To Reign Display</asp:HyperLink></TD>
		</TR>
		<TR>
			<TD>
				<TABLE>
					<TR>
						<TD>Reign Number:</TD>
						<TD>
							<asp:TextBox id="txtReign" Runat="server"></asp:TextBox></TD>
					</TR>
					<TR>
						<TD>This crown is heir to throne:</TD>
						<TD>
							<asp:CheckBox id="chkHeir" Runat="server"></asp:CheckBox></TD>
					</TR>
					<TR>
						<TD>This record is a Regency (Regent,Vicar, etc):</TD>
						<TD>
							<asp:CheckBox id="chkRegent" Runat="server"></asp:CheckBox></TD>
					</TR>
					<TR>
						<TD>Group:</TD>
						<TD>
							<asp:DropDownList id="ddlGroup" Runat="server"></asp:DropDownList></TD>
					</TR>
					<TR>
						<TD>Email:</TD>
						<TD>
							<asp:TextBox id="txtEmail" Runat="server"></asp:TextBox></TD>
					</TR>
					<TR>
						<TD>Sovereign:</TD>
						<TD>
							<asp:HyperLink id="hlSovereign" Runat="server"></asp:HyperLink><BR>
							<asp:TextBox id="txtSovereignId" Runat="server"></asp:TextBox></TD>
					</TR>
					<TR>
						<TD>Consort:</TD>
						<TD>
							<asp:HyperLink id="hlConsort" Runat="server"></asp:HyperLink><BR>
							<asp:TextBox id="txtConsortId" Runat="server"></asp:TextBox></TD>
					</TR>
					<TR>
						<TD>Start Date:</TD>
						<TD>
							<asp:TextBox id="txtStartDate" Runat="server"></asp:TextBox>
							<asp:HyperLink id="hlStartDateCalendar" Runat="server">Calendar</asp:HyperLink></TD>
					</TR>
					<TR>
						<TD>End Date:</TD>
						<TD>
							<asp:TextBox id="txtEndDate" Runat="server"></asp:TextBox>
							<asp:HyperLink id="hlEndDateCalendar" Runat="server">Calendar</asp:HyperLink></TD>
					</TR>
					<TR>
						<TD>Crown Tournament Date:</TD>
						<TD>
							<asp:TextBox id="txtCrownDate" Runat="server"></asp:TextBox>
							<asp:HyperLink id="hlCrownDateCalendar" Runat="server">Calendar</asp:HyperLink></TD>
					</TR>
					<TR>
						<TD>Crown Tournament Location:</TD>
						<TD>
							<asp:TextBox id="txtCrownLocation" Runat="server"></asp:TextBox></TD>
					</TR>
					<TR>
						<TD>Coronation Location:</TD>
						<TD>
							<asp:TextBox id="txtCoronationLocation" Runat="server"></asp:TextBox></TD>
					</TR>
					<TR>
						<TD>Stepping Down Location:</TD>
						<TD>
							<asp:TextBox id="txtStepDownLocation" Runat="server"></asp:TextBox></TD>
					</TR>
					<TR>
						<TD>Notes (public):</TD>
						<TD>
							<asp:TextBox id="txtNotes" Runat="server" Height="200" Width="300" TextMode="MultiLine"></asp:TextBox></TD>
					</TR>
				</TABLE>
			</TD>
			<TD vAlign="top">
				<FIELDSET><LEGEND>People Id Look Up</LEGEND><SPAN class="InstructionNote">Use this to 
						look up Sovereign and Consort Ids</SPAN><BR>
					<asp:TextBox id="txtSearchOP" Runat="server"></asp:TextBox>
					<asp:Button id="btnSearchOP" Runat="server" Text="Find Member"></asp:Button><BR>
					Return
					<BR>
					<asp:RadioButtonList id="rblFilterType" Runat="server" RepeatDirection="Vertical" RepeatLayout="Flow">
						<asp:ListItem Value="b" Selected="True">items that begin with search text</asp:ListItem>
						<asp:ListItem Value="c">items that contain search text</asp:ListItem>
					</asp:RadioButtonList>
					<asp:DataGrid id="dgResultList" cssclass="ResultList" Runat="server" AutoGenerateColumns="False"
						AllowPaging="True">
						<Columns>
							<asp:BoundColumn DataField="PeopleId" HeaderText="People Id"></asp:BoundColumn>
							<asp:HyperLinkColumn Target="_blank" DataNavigateUrlField="PeopleId" DataTextField="SCAName" HeaderText="Name/Alias"></asp:HyperLinkColumn>
						</Columns>
						<PagerStyle Visible="False"></PagerStyle>
					</asp:DataGrid></FIELDSET>
			</TD>
		</TR>
	</TABLE>
	<TABLE cellSpacing="0" cellPadding="0" border="0">
		<TR>
			<TD vAlign="top">
				<FIELDSET><LEGEND>Alternate Display Page</LEGEND><BR>
					<portal:url id="urlInternalUrl" runat="server" showtrack="False" shownewwindow="False" showlog="False"
						showUrls="true" showfiles="False" showtabs="True" width="300" showNone="true"></portal:url></FIELDSET>
			</TD>
			<TD>
				<DIV></DIV>
			</TD>
		</TR>
	</TABLE>
	<TABLE cellSpacing="0" cellPadding="0" border="0">
		<TR>
			<TD vAlign="top">
				<FIELDSET><LEGEND>Picture 1</LEGEND>
					<asp:Image id="imgPicture1" Runat="server"></asp:Image><BR>
					<portal:url id="urlPicture1Url" runat="server" showtrack="False" shownewwindow="False" showlog="False"
						showUrls="True" showfiles="True" showtabs="False" width="300" showNone="True"></portal:url>
						<DIV>Caption:
					<asp:TextBox id="txtPicture1Caption" Runat="server" Width="300"></asp:TextBox><BR>
					Credit:
					<asp:TextBox id="txtPicture1Credit" Runat="server" Width="300"></asp:TextBox><BR>
				</DIV>
				</FIELDSET>
				
			</TD>
			<TD>
				<FIELDSET><LEGEND>Picture 2</LEGEND>
					<asp:Image id="imgPicture2" Runat="server"></asp:Image><BR>
					<portal:url id="urlPicture2Url" runat="server" showtrack="False" shownewwindow="False" showlog="False"
						showUrls="True" showfiles="True" showtabs="False" width="300" showNone="True"></portal:url>
						<DIV>Caption:
					<asp:TextBox id="txtPicture2Caption" Runat="server" Width="300"></asp:TextBox><BR>
					Credit:
					<asp:TextBox id="txtPicture2Credit" Runat="server" Width="300"></asp:TextBox><BR>
				</DIV>
				</FIELDSET>
				
			</TD>
		</TR>
	</TABLE>
	<BR>
	<BR>
	<asp:linkbutton id="cmdUpdate" runat="server" CssClass="CommandButton" resourcekey="cmdUpdate" BorderStyle="None">Update</asp:linkbutton>
	<asp:linkbutton id="cmdCancel" runat="server" CssClass="CommandButton" resourcekey="cmdCancel" BorderStyle="None"
		CausesValidation="False">Cancel</asp:linkbutton>
	<asp:linkbutton id="cmdDelete" Visible="False" runat="server" CssClass="CommandButton" resourcekey="cmdDelete"
		BorderStyle="None" CausesValidation="False">Delete</asp:linkbutton>
</asp:panel>

