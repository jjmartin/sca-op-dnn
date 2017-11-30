<%@ Control Language="c#" AutoEventWireup="true" Inherits="JeffMartin.DNN.Modules.SCAOnlineOP.SCAOnlineOPOfficePositionTypeEdit"
    CodeBehind="SCAOnlineOPOfficePositionTypeEdit.ascx.cs" %>
<%@ Register Assembly="System.Web.Entity, Version=4.0.0.0, Culture=neutral, PublicKeyToken=b77a5c561934e089"
    Namespace="System.Web.UI.WebControls" TagPrefix="asp" %>
<%@ Register Src="~/controls/URLControl.ascx" TagName="URL" TagPrefix="Portal" %>
<%@ Import Namespace="JeffMartin.ScaData" %>
<%@ Import Namespace="System.Data.Objects" %>
<%@ Register Assembly="DotNetNuke" Namespace="DotNetNuke.UI.WebControls" TagPrefix="Portal" %>
<style type="text/css">
    .NoWrap td
    {
        white-space: nowrap;
    }
</style>
<asp:EntityDataSource ID="edsOfficerPositionType" runat="server" EnableDelete="True"
    EnableInsert="True" EnableUpdate="True" ContextTypeName="JeffMartin.ScaData.ScaOpEntities"
    EnableFlattening="False" EntitySetName="OfficerPositionTypes" 
    ondeleting="edsOfficerPositionType_Deleting">
</asp:EntityDataSource>
<h2>
    Office Types</h2>
<div>
    Office Types help gives offices certain functionality in addition to normal functionality.
</div>
<div>
    The the TypeFlags have the following effects:
    <ul>
        <li>UsesDisplayDates: Not Implemented.</li>
        <li>ReleatedToReign: Allows an office assignment to be linked to a specific reign of
            the group the office is in.</li>
        <li>Warranted: Not Implemented.</li>
    </ul>
</div>
<asp:Panel runat="server" ID="errorContainer" CssClass="NormalRed" />
<asp:GridView ID="gvOfficePositionTypes" runat="server" DataSourceID="edsOfficerPositionType"
    DataKeyNames="OfficerPositionTypeId" AutoGenerateColumns="False" ShowFooter="True"
    AllowSorting="True" EnableTheming="True" ShowHeaderWhenEmpty="True" Width="100%"
    OnRowCommand="gvOfficePositionTypes_RowCommand" OnRowCreated="gvOfficePositionTypes_RowCreated"
    OnRowDataBound="gvOfficePositionTypes_RowDataBound" OnRowUpdating="gvOfficePositionTypes_RowUpdating">
    <Columns>
        <asp:TemplateField HeaderText="OfficerPositionTypeId" SortExpression="OfficerPositionTypeId">
            <EditItemTemplate>
                <asp:Label ID="Label1" runat="server" Text='<%# Eval("OfficerPositionTypeId") %>'></asp:Label>
            </EditItemTemplate>
            <ItemTemplate>
                <asp:Label ID="Label1" runat="server" Text='<%# Eval("OfficerPositionTypeId") %>'></asp:Label>
            </ItemTemplate>
        </asp:TemplateField>
        <asp:TemplateField HeaderText="Name" SortExpression="Name">
            <EditItemTemplate>
                <asp:TextBox ID="NameEdit" runat="server" Text='<%# Bind("Name") %>'></asp:TextBox>
                <asp:RequiredFieldValidator ControlToValidate="NameEdit" runat="server" ErrorMessage="Name is required"
                    SetFocusOnError="true" ValidationGroup="Update"></asp:RequiredFieldValidator>
            </EditItemTemplate>
            <FooterTemplate>
                <asp:TextBox ID="NameAdd" runat="server" Text='<%# Bind("Name") %>'></asp:TextBox>
                <asp:RequiredFieldValidator ID="RequiredFieldValidator1" ControlToValidate="NameAdd"
                    runat="server" ErrorMessage="Name is required" ValidationGroup="Add" SetFocusOnError="true"></asp:RequiredFieldValidator>
            </FooterTemplate>
            <ItemTemplate>
                <asp:Label ID="Label2" runat="server" Text='<%# Eval("Name") %>'></asp:Label>
            </ItemTemplate>
        </asp:TemplateField>
        <asp:TemplateField HeaderText="Description" SortExpression="Title, GroupName">
            <EditItemTemplate>
                <label>
                    Enter a Description for the Position</label><Portal:DNNRichTextEditControl ID="textDescriptionEdit"
                        runat="server" Value='<%# Bind("Description") %>' />
            </EditItemTemplate>
            <ItemTemplate>
                <asp:Literal runat="server" ID="litDescription" Text='<%# Bind("Description") %>'></asp:Literal>
            </ItemTemplate>
            <FooterTemplate>
                <label>
                    Enter a Description for the Position</label><Portal:DNNRichTextEditControl ID="textDescriptionAdd"
                        runat="server" Value='<%# Bind("Description") %>' />
            </FooterTemplate>
        </asp:TemplateField>
        <asp:TemplateField HeaderText="TypeFlags" SortExpression="TypeFlags">
            <EditItemTemplate>
                <asp:Literal runat="server" Visible="false" ID="typeFlagBinder" Text='<%# Bind("intTypeFlags") %>'></asp:Literal><%//This is here so we have 2-way databinding - see the updating event%>
                <asp:CheckBoxList CssClass="NoWrap" runat="server" ID="cblTypeFlagsEdit">
                </asp:CheckBoxList>
                <div class="InstructionNote">
                    Only Related to Reign currently has any functionality.</div>
            </EditItemTemplate>
            <ItemTemplate>
                <asp:Label ID="Label3" runat="server" Text='<%# Eval("TypeFlags") %>'></asp:Label>
            </ItemTemplate>
            <FooterTemplate>
                <asp:CheckBoxList CssClass="NoWrap" runat="server" ID="cblTypeFlagsAdd">
                </asp:CheckBoxList>
                <div class="InstructionNote">
                    Only Related to Reign currently has any functionality.</div>
            </FooterTemplate>
        </asp:TemplateField>
        <asp:TemplateField HeaderText="Sort Order" SortExpression="SortOrder">
            <EditItemTemplate>
                <asp:TextBox ID="SortOrderEdit" runat="server" Text='<%# Bind("SortOrder") %>'></asp:TextBox>
            </EditItemTemplate>
            <FooterTemplate>
                <asp:TextBox ID="SortOrderAdd" runat="server" Text='<%# Bind("SortOrder") %>'></asp:TextBox>
            </FooterTemplate>
            <ItemTemplate>
                <asp:Label ID="SortOrderLabel" runat="server" Text='<%# Bind("SortOrder") %>'></asp:Label>
            </ItemTemplate>
        </asp:TemplateField>
        <asp:TemplateField ShowHeader="False">
            <EditItemTemplate>
                <asp:LinkButton ID="LinkButton1" runat="server" CausesValidation="True" CommandName="Update"
                    ValidationGroup="Update" Text="Update"></asp:LinkButton>
                &nbsp;<asp:LinkButton ID="LinkButton2" runat="server" CausesValidation="False" CommandName="Cancel"
                    Text="Cancel"></asp:LinkButton>
            </EditItemTemplate>
            <FooterTemplate>
                <asp:LinkButton ID="LinkButton1" runat="server" CausesValidation="True" CommandName="Insert"
                    ValidationGroup="Add" Text="Add New"></asp:LinkButton>
            </FooterTemplate>
            <ItemTemplate>
                <asp:LinkButton ID="LinkButton1" runat="server" CausesValidation="False" CommandName="Edit"
                    Text="Edit"></asp:LinkButton>
                &nbsp;<asp:LinkButton ID="LinkButton2" runat="server" CausesValidation="False" CommandName="Delete"
                    OnClientClick="javascript:return confirm('Confirm Type Delete. This will not work if any offices have been assigned this type.');"
                    Text="Delete"></asp:LinkButton>
            </ItemTemplate>
        </asp:TemplateField>
    </Columns>
    <EmptyDataTemplate>
        No Types Yet, some should have been added with the upgrade, contact Godfrey for
        help.
    </EmptyDataTemplate>
</asp:GridView>
<asp:LinkButton ID="cmdCancel" CssClass="CommandButton" runat="server" CausesValidation="False"
    BorderStyle="None" OnClick="cmdCancel_Click">Done</asp:LinkButton>
