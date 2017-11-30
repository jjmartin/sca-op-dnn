<%@ Control Language="c#" AutoEventWireup="false" Inherits="JeffMartin.DNN.Modules.SCAOnlineOP.SCAOnlineDisplayGroup" targetSchema="http://schemas.microsoft.com/intellisense/ie5" Codebehind="SCAOnlineOPDisplayGroup.ascx.cs" %>
<%@ Import namespace="DotNetNuke.Entities.Modules" %>
<%@ Import namespace="DotNetNuke.Common" %>
<asp:panel id="pnlDefault" Runat="server">
	<asp:HyperLink id="hlEditGroup" Runat="server">
		<asp:image Runat="server" ID="imgGroupEdit" ImageUrl="~/images/edit.gif" />
	</asp:HyperLink>
	<TABLE>
		<TR>
			<TD vAlign="top">
				<asp:Image id="imgArms" Runat="server"></asp:Image></TD>
			<TD vAlign="top">
				<H1 id="H1GroupName" runat="server">Group Name</H1>
				<div><strong>Reports To:</strong> <span id="divPartOf" runat="server"></span></div>
				<div><strong>Modern Location:</strong> <span id="divLocation" runat="server">Location, Loc</span></div>
				<div><strong>Branch Status:</strong> <span id="divStatus" runat="server"></span>
                </div>
				<asp:HyperLink id="hlWebSiteUrl" Runat="server" target="_blank"></asp:HyperLink>
				<h3>Notes:</h3>
				<DIV id="divNotes" runat="server"></DIV>
			</TD>
		</TR>
		<TR id="trAwardsHeader" runat="server" visible="false">
			<TD colspan="2">
				<asp:HyperLink id="hlAwardList" Runat="server">View the Awards from this Group</asp:HyperLink></TD>
		</TR>
        <tr id="trCrownsHeader" runat="server" visible="false">
            <td colspan="2">
                <asp:HyperLink ID="hlCrownList" runat="server">View the History of Rulers from this Group</asp:HyperLink></td>
        </tr>
		<TR id="trRegnumHeader" runat="server" >
			<TD colSpan="2">
				<H2>Regnum:</H2>
			</TD>
		</TR>
		<TR>
			<TD colSpan="2">
                <asp:Repeater ID="rptRegnum" runat="server">
                    <HeaderTemplate>
                        <table>
                    </HeaderTemplate>
                    <ItemTemplate>
                        <tr>
                            <td>
                                <asp:Image ID="imgOfficeBadge" runat="server" Height='<%# Convert.ToInt32(DataBinder.Eval(Container.DataItem, "BadgeURLHeight")) %>'
                                    ImageUrl='<%# BasePortalHttpAddress +  BasePortalInfo.HomeDirectory  + DataBinder.Eval(Container.DataItem, "BadgeUrl") %>'
                                    Visible='<%# ! Convert.ToBoolean(DataBinder.Eval(Container.DataItem, "BadgeUrl").ToString().Trim().Equals(String.Empty) || DataBinder.Eval(Container.DataItem, "BadgeUrl").ToString().ToLower().StartsWith("fileid=") )%>'
                                    Width='<%# Convert.ToInt32(DataBinder.Eval(Container.DataItem, "BadgeURLWidth")) %>' /></td>
                            <td valign="top">
                                <asp:Image ID="imgPhoto" runat="server" Height='<%# Convert.ToInt32(DataBinder.Eval(Container.DataItem, "PhotoURLHeight")) %>'
                                    ImageUrl='<%# BasePortalHttpAddress +  BasePortalInfo.HomeDirectory + DataBinder.Eval(Container.DataItem, "PhotoUrl") %>'
                                    Visible='<%# ! Convert.ToBoolean(DataBinder.Eval(Container.DataItem, "PhotoUrl").ToString().Trim().Equals(String.Empty) || DataBinder.Eval(Container.DataItem, "PhotoUrl").ToString().ToLower().StartsWith("fileid=") )%>'
                                    Width='<%# Convert.ToInt32(DataBinder.Eval(Container.DataItem, "PhotoURLWidth")) %>' /></td>
                            <td valign="top">
                                <table>
                                    <tr>
                                        <td class="OfficerPosition">
                                            <%# Convert.ToBoolean(DataBinder.Eval(Container.DataItem, "Acting"))?"ACTING ":String.Empty %>
                                            <%# DataBinder.Eval(Container.DataItem, "Title") %>
                                            <%# (DataBinder.Eval(Container.DataItem, "PositionSubTitle").ToString().Trim().Equals(String.Empty)) ? ("") : "<br />" + (DataBinder.Eval(Container.DataItem, "PositionSubTitle"))%>
                                        </td>
                                    </tr>
                                    <tr>
                                        <td class="Normal">
                                            <asp:HyperLink ID="hlPersonLink" runat="server" NavigateUrl='<%# DotNetNuke.Common.Globals.NavigateURL(MyModule.TabId, "", "memid=" + DataBinder.Eval(Container.DataItem, "PeopleId").ToString()) %>'>
															<%# (DataBinder.Eval(Container.DataItem, "TitlePrefix").ToString().Trim().Equals(String.Empty))?(""):(DataBinder.Eval(Container.DataItem, "TitlePrefix")+ " " ) %>
															<%# DataBinder.Eval(Container.DataItem, "SCAName") %>
															<%# (DataBinder.Eval(Container.DataItem, "HonorsSuffix").ToString().Trim().Equals(String.Empty))?(""):", " + (DataBinder.Eval(Container.DataItem, "HonorsSuffix") ) %>
                                            </asp:HyperLink>
                                            <%# (DataBinder.Eval(Container.DataItem, "MundaneName").ToString().Trim().Equals(String.Empty))?(""):("(" + DataBinder.Eval(Container.DataItem, "MundaneName") + ")") %>
                                        </td>
                                    </tr>
                                    <tr id="tdAddress" runat="server">
                                        <td class="Normal">
                                            <%# DisplayAddress( DataBinder.Eval(Container.DataItem, "Address1"), DataBinder.Eval(Container.DataItem, "Address2") ,
							DataBinder.Eval(Container.DataItem, "City"), DataBinder.Eval(Container.DataItem, "State"),DataBinder.Eval(Container.DataItem, "Zip")) %>
                                        </td>
                                    </tr>
                                    <tr id="tdPhone" runat="server">
                                        <td class="Normal">
                                            <%# (DataBinder.Eval(Container.DataItem, "Phone1").ToString()!=string.Empty)?(DataBinder.Eval(Container.DataItem, "Phone1")+"<br>"):"" %>
                                            <%# DataBinder.Eval(Container.DataItem, "Phone2") %>
                                        </td>
                                    </tr>
                                    <tr>
                                        <td class="Normal">
                                            <%#DisplayEmail(DataBinder.Eval(Container.DataItem, "EmailToUse"), DataBinder.Eval(Container.DataItem, "EmailAddress"), DataBinder.Eval(Container.DataItem, "OfficeEmail"), DataBinder.Eval(Container.DataItem, "EmailOverride"))%>
                                        </td>
                                    </tr>
                                    <tr>
                                        <td class="Normal">
                                            <%# DataBinder.Eval(Container.DataItem, "OfficerNotes")%>
                                        </td>
                                    </tr>
                                </table>
                            </td>
                        </tr>
                    </ItemTemplate>
                    <FooterTemplate>
                        </table>
                    </FooterTemplate>
                </asp:Repeater>
            </TD>
		</TR>
	</TABLE>
</asp:panel>

