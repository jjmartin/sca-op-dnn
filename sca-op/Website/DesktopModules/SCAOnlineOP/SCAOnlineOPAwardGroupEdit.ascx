<%@ Control Language="c#" AutoEventWireup="false" Inherits="JeffMartin.DNN.Modules.SCAOnlineOP.SCAOnlineOPAwardGroupEdit" Codebehind="SCAOnlineOPAwardGroupEdit.ascx.cs" %>
<div>Award Groups combine awards so they appear as the same award in the "Award Charters" display.  The precedence and sort are used so the award group shows up in the right 
order when shown against other awards. All subawards should have the same precedence. When the group is displayed, it is assumed the charter of the sub-awards are all the same.</div>
<asp:DataGrid id="dgAwardGroups" runat="server" AllowSorting="True" ShowFooter="True" PageSize="100"
	AllowPaging="True" AutoGenerateColumns="False">
	<Columns>
		<asp:BoundColumn DataField="AwardGroupId" ReadOnly="True" HeaderText="AwardGroupId"></asp:BoundColumn>
		<asp:TemplateColumn HeaderText="Award Group Name">
			<ItemTemplate>
				<asp:Label id="Label1" runat="server" Text='<%# DataBinder.Eval(Container, "DataItem.AwardGroupName") %>'>
				</asp:Label>
			</ItemTemplate>
			<FooterTemplate>
				<asp:TextBox id="txtAdd_AwardGroupName" runat="server" Text='<%# DataBinder.Eval(Container, "DataItem.AwardGroupName") %>'>
				</asp:TextBox>
			</FooterTemplate>
			<EditItemTemplate>
				<asp:TextBox id="txtEdit_AwardGroupName" runat="server" Text='<%# DataBinder.Eval(Container, "DataItem.AwardGroupName") %>'>
				</asp:TextBox>
			</EditItemTemplate>
		</asp:TemplateColumn>
		<asp:TemplateColumn HeaderText="Group">
			<ItemTemplate>
				<asp:Label id="Label2" runat="server" Text='<%# DataBinder.Eval(Container, "DataItem.GroupName") %>'>
				</asp:Label>
			</ItemTemplate>
			<FooterTemplate>
				<asp:DropDownList id="ddlAdd_Group" runat="server"></asp:DropDownList>
			</FooterTemplate>
			<EditItemTemplate>
				<asp:DropDownList id="ddlEdit_Group" runat="server"></asp:DropDownList>
			</EditItemTemplate>
		</asp:TemplateColumn>
		<asp:TemplateColumn HeaderText="Precedence">
			<ItemTemplate>
				<asp:Label id="Label3" runat="server" Text='<%# DataBinder.Eval(Container, "DataItem.Precedence") %>'>
				</asp:Label>
			</ItemTemplate>
			<FooterTemplate>
				<asp:TextBox id="txtAdd_Precedence" runat="server" Text='0'>
				</asp:TextBox>
			</FooterTemplate>
			<EditItemTemplate>
				<asp:TextBox id="txtEdit_Precedence" runat="server" Text='<%# DataBinder.Eval(Container, "DataItem.Precedence") %>'>
				</asp:TextBox>
			</EditItemTemplate>
		</asp:TemplateColumn>
		<asp:TemplateColumn HeaderText="Sort Order">
			<ItemTemplate>
				<asp:Label id="Label4" runat="server" Text='<%# DataBinder.Eval(Container, "DataItem.SortOrder") %>'>
				</asp:Label>
			</ItemTemplate>
			<FooterTemplate>
				<asp:TextBox id="txtAdd_SortOrder" runat="server" Text='0'>
				</asp:TextBox>
			</FooterTemplate>
			<EditItemTemplate>
				<asp:TextBox id="txtEdit_SortOrder" runat="server" Text='<%# DataBinder.Eval(Container, "DataItem.SortOrder") %>'>
				</asp:TextBox>
			</EditItemTemplate>
		</asp:TemplateColumn>
		<asp:TemplateColumn HeaderText="Edit">
			<ItemTemplate>
				<asp:LinkButton id="LinkButton1" CausesValidation="false" runat="server" Text="Edit" CommandName="Edit"></asp:LinkButton>
			</ItemTemplate>
			<FooterTemplate>
				<asp:LinkButton id="LinkButton4" runat="server" Text="Add" CommandName="Add"></asp:LinkButton>
			</FooterTemplate>
			<EditItemTemplate>
				<asp:LinkButton id="LinkButton3" runat="server" Text="Update" CommandName="Update"></asp:LinkButton>&nbsp;
				<asp:LinkButton id="LinkButton2" CausesValidation="false" runat="server" Text="Cancel" CommandName="Cancel"></asp:LinkButton>
			</EditItemTemplate>
		</asp:TemplateColumn>
		<asp:TemplateColumn>
			<ItemTemplate>
				<asp:LinkButton id="cmdDelete" CausesValidation="false" runat="server" Text="Delete" CommandName="Delete"></asp:LinkButton>
			</ItemTemplate>
		</asp:TemplateColumn>
	</Columns>
</asp:DataGrid>
<asp:linkbutton id="cmdCancel" CssClass="CommandButton" runat="server" CausesValidation="False"
	BorderStyle="None">Done</asp:linkbutton>

