<%@ Control Language="c#" AutoEventWireup="true" Inherits="JeffMartin.DNN.Modules.SCAOnlineOP.SCAOnlineOPOfficeEdit"
    CodeBehind="SCAOnlineOPOfficeEdit.ascx.cs" %>
<%@ Register Assembly="DotNetNuke.Web" Namespace="DotNetNuke.Web.UI.WebControls"
    TagPrefix="cc1" %>
<%@ Register Assembly="System.Web.Entity, Version=4.0.0.0, Culture=neutral, PublicKeyToken=b77a5c561934e089"
    Namespace="System.Web.UI.WebControls" TagPrefix="asp" %>
<%@ Register Src="~/controls/URLControl.ascx" TagName="URL" TagPrefix="Portal" %>
<%@ Register Assembly="DotNetNuke" Namespace="DotNetNuke.UI.WebControls" TagPrefix="Portal" %>
<%@ Import Namespace="JeffMartin.ScaData" %>
<%@ Import Namespace="System.Data.Objects" %>

<%@ Register assembly="AjaxControlToolkit" namespace="AjaxControlToolkit" tagprefix="asp" %>

<asp:EntityDataSource ID="edsOfficerPosition" runat="server" EnableDelete="True"
    EnableFlattening="false" EnableInsert="True" EnableUpdate="True" ContextTypeName="JeffMartin.ScaData.ScaOpEntities"
    EntitySetName="OfficerPositions" 
    Include="Badge, Group, OfficePositionType" AutoPage="true"
    AutoSort="true" Where='(it.GroupId == @groupid OR @groupid== 0) and (it.Title LIKE ("%" + @positionName + "%") )'
    OrderBy="it.[Group].Name, it.Title">
    <WhereParameters>
        <asp:ControlParameter ControlID="ddlGroupFilter" PropertyName="SelectedValue" Name="groupid"
            Type="Int32" />
            <asp:ControlParameter ControlID="txtPositionNameFilter" PropertyName="Text" Name="positionName" Type="String" DefaultValue="_" />
    </WhereParameters>
</asp:EntityDataSource>
<asp:EntityDataSource ID="edsOfficerPositionInsert" runat="server" EnableDelete="False"
    EnableFlattening="false" EnableInsert="True" EnableUpdate="False" ContextTypeName="JeffMartin.ScaData.ScaOpEntities"
    EntitySetName="OfficerPositions">
</asp:EntityDataSource>
<asp:EntityDataSource ID="edsPositionTypeNew" runat="server" ContextTypeName="JeffMartin.ScaData.ScaOpEntities"
    EntitySetName="OfficerPositionTypes">
</asp:EntityDataSource>
<asp:EntityDataSource ID="edsPositionTypeEdit" runat="server" ContextTypeName="JeffMartin.ScaData.ScaOpEntities"
    EntitySetName="OfficerPositionTypes">
</asp:EntityDataSource>
<asp:ObjectDataSource ID="odsGroupSource" runat="server" TypeName="JeffMartin.DNN.Modules.SCAOnlineOP.Data.SqlDataProvider"
    OnObjectCreating="DataSource_ObjectCreating" SelectMethod="ListGroups"></asp:ObjectDataSource>
<h2>
    List of Offices</h2>
<div>
    <a href="#Insert">Jump to Insert a record.</a></div>
<div>
    You can sort the list by clicking on the row headers. If you want more filters or
    have suggestions, please let Godfrey know.</div>
<div>
    <span>Filters: Group:</span>
    <asp:DropDownList ID="ddlGroupFilter" runat="server" DataSourceID="odsGroupSource"
        DataValueField="GroupId" DataTextField="Name" AutoPostBack="true" AppendDataBoundItems="true">
        <asp:ListItem Value="0">&lt;No Group Filter&gt;</asp:ListItem>
    </asp:DropDownList> 
    <span>Position Name</span> <asp:TextBox runat="server" 
        ID="txtPositionNameFilter" AutoPostBack="True" />  
</div>
<asp:UpdatePanel runat="server" ID="upGrid">
    <ContentTemplate>
        <asp:GridView ID="gvOffices" runat="server" AllowPaging="true" 
            AllowSorting="True" AutoGenerateColumns="False" 
            DataKeyNames="OfficerPositionId" DataSourceID="edsOfficerPosition" 
            OnRowUpdating="gvOffices_RowUpdating" PagerSettings-Mode="NumericFirstLast" 
            PagerSettings-Position="TopAndBottom" PageSize="20">
            <Columns>
                <asp:BoundField DataField="OfficerPositionId" HeaderText="Office Id" 
                    InsertVisible="false" ReadOnly="true" SortExpression="OfficerPositionId" />
                <asp:HyperLinkField DataNavigateUrlFields="OfficerPositionId" 
                    HeaderText="History" InsertVisible="False" Text="History" />
                <asp:TemplateField HeaderText="Office Title/Office Email" 
                    SortExpression="Title, [Group].Name">
                    <EditItemTemplate>
                        <div>
                            <label>
                            Title:
                            </label>
                            <asp:TextBox ID="TextBox1" runat="server" Text='<%# Bind("Title") %>'></asp:TextBox>
                        </div>
                        <div>
                            <label>
                            Email:
                            </label>
                            <asp:TextBox ID="TextBox2" runat="server" Text='<%# Bind("OfficeEmail") %>'></asp:TextBox>
                        </div>
                    </EditItemTemplate>
                    <ItemTemplate>
                        <asp:Label ID="Label3" runat="server" Text='<%# Eval("Title") %>'></asp:Label>
                        <br />
                        <a href='mailto:<%# DataBinder.Eval(Container.DataItem,"OfficeEmail") %>'>
                    <%# DataBinder.Eval(Container.DataItem,"OfficeEmail") %></a>
                    </ItemTemplate>
                </asp:TemplateField>
                <asp:TemplateField HeaderText="Badge">
                    <EditItemTemplate>
                        <div>
                            <asp:Literal ID="fileIdBinder" runat="server" Text='<%# Bind("FileId") %>' 
                                Visible="false"></asp:Literal>
                            <Portal:URL ID="urlOfficeBadge" runat="server" 
                                FileFilter="jpg,jpeg,jpe,gif,bmp,png,swf" ShowFiles="True" ShowImages="False" 
                                ShowLog="False" ShowNewWindow="False" ShowNone="True" ShowTabs="False" 
                                ShowTrack="False" ShowUrls="False" 
                                Url='<%#  Eval("FileId")==null?"": Eval("FileId", "FileID={0}") %>' 
                                Width="300" />
                        </div>
                    </EditItemTemplate>
                    <ItemTemplate>
                        <asp:Image ID="imgOfficeBadge" runat="server" 
                            Height='<%#  Convert.ToInt32( Eval("Badge.Height")??"0" ) %>' 
                            ImageUrl='<%# Eval("Badge")!=null ? (PortalSettings.HomeDirectory + Eval("Badge.Folder") + Eval("Badge.FileName")) :""    %>' 
                            Visible='<%# Eval("Badge")!=null %>' 
                            Width='<%#  Convert.ToInt32( Eval("Badge.Width")??"0" ) %>' />
                    </ItemTemplate>
                </asp:TemplateField>
                <asp:TemplateField HeaderText="Group" SortExpression="[Group].[Name], Title">
                    <ItemTemplate>
                        <asp:Label ID="Label2" runat="server" Text='<%# Eval("Group.Name") %>'>
                        </asp:Label>
                    </ItemTemplate>
                    <EditItemTemplate>
                        <label>
                        Group:
                        </label>
                        <asp:DropDownList ID="ddlEdit_Group" runat="server" AppendDataBoundItems="true" 
                            DataSourceID="odsGroupSource" DataTextField="Name" DataValueField="GroupId" 
                            SelectedValue='<%# Bind("GroupId")%>'>
                            <asp:ListItem Value="">&lt;Choose a Group&gt;</asp:ListItem>
                        </asp:DropDownList>
                    </EditItemTemplate>
                </asp:TemplateField>
                <asp:TemplateField HeaderText="Position Type" 
                    SortExpression="OfficePositionType.Name">
                    <ItemTemplate>
                        <asp:Literal ID="litPositionType" runat="server" 
                            Text='<%# Eval("OfficePositionType.Name")%>'></asp:Literal>
                    </ItemTemplate>
                    <EditItemTemplate>
                        <div>
                            Choose a Position Type:</label><asp:DropDownList ID="ddlPositionType" 
                                runat="server" AppendDataBoundItems="true" DataSourceID="edsPositionTypeEdit" 
                                DataTextField="Name" DataValueField="OfficerPositionTypeId" 
                                SelectedValue='<%# Bind("OfficerPositionTypeId") %>'>
                                <asp:ListItem Value="">&lt;Choose a Type&gt;</asp:ListItem>
                            </asp:DropDownList>
                            <div>
                                This will affect how the office behaves, read the description for details.</div>
                        </div>
                    </EditItemTemplate>
                </asp:TemplateField>
                <asp:TemplateField HeaderText="Description">
                    <ItemTemplate>
                        <asp:Literal ID="litDescription" runat="server" 
                            Text='<%# Eval("Description") %>'></asp:Literal>
                    </ItemTemplate>
                    <EditItemTemplate>
                        <label>
                        Enter a Description for the Position</label><Portal:DNNRichTextEditControl 
                            ID="textDescriptionEdit" runat="server" Value='<%# Bind("Description") %>' />
                    </EditItemTemplate>
                </asp:TemplateField>
                <asp:TemplateField HeaderText="Sort Order" 
                    SortExpression="[Group].Name, ListOrder">
                    <ItemTemplate>
                        <asp:Label ID="Label1" runat="server" Text='<%# Eval("ListOrder") %>'></asp:Label>
                    </ItemTemplate>
                    <EditItemTemplate>
                        <label>
                        Sort Order</label>
                        <asp:TextBox ID="txtSortEdit" runat="server" Text='<%# Bind("ListOrder") %>'></asp:TextBox>
                        <asp:CompareValidator ID="CompareValidator1" runat="server" 
                            ControlToValidate="txtSortEdit" CssClass="NormalRed" EnableClientScript="true" 
                            ErrorMessage="Sort Order requires a number" Operator="DataTypeCheck" 
                            Type="Integer" ValidationGroup="Edit" ValueToCompare="Text" />
                        <asp:RequiredFieldValidator ID="CompareValidator3" runat="server" 
                            ControlToValidate="txtSortEdit" CssClass="NormalRed" EnableClientScript="true" 
                            ErrorMessage="Sort Order requires a number" ValidationGroup="Edit" 
                            ValueToCompare="Text" />
                    </EditItemTemplate>
                </asp:TemplateField>
                <asp:TemplateField ShowHeader="False">
                    <EditItemTemplate>
                        <asp:LinkButton ID="LinkButton1" runat="server" CausesValidation="True" 
                            CommandName="Update" Text="Update" ValidationGroup="Edit"></asp:LinkButton>
                        &nbsp;<asp:LinkButton ID="LinkButton2" runat="server" CausesValidation="False" 
                            CommandName="Cancel" Text="Cancel"></asp:LinkButton>
                    </EditItemTemplate>
                    <ItemTemplate>
                        <asp:LinkButton ID="LinkButton1" runat="server" CausesValidation="False" 
                            CommandName="Edit" Text="Edit"></asp:LinkButton>
                        &nbsp;<asp:LinkButton ID="LinkButton2" runat="server" CausesValidation="False" 
                            CommandName="Delete" Text="Delete"></asp:LinkButton>
                    </ItemTemplate>
                </asp:TemplateField>
            </Columns>
        </asp:GridView>
        <asp:UpdateProgress ID="UpdateProgress1" runat="server" 
            AssociatedUpdatePanelID="upGrid">
            <progresstemplate>
              <img border="0" runat="server" src="~/images/dnnanim.gif" />
            </progresstemplate>
        </asp:UpdateProgress>
    </ContentTemplate>
    <triggers>
               <asp:AsyncPostBackTrigger ControlID="ddlGroupFilter" 
            EventName="SelectedIndexChanged" />
        <asp:AsyncPostBackTrigger ControlID="gvOffices" EventName="RowCommand" />
        <asp:AsyncPostBackTrigger ControlID="gvOffices" EventName="PageIndexChanged" />
        <asp:AsyncPostBackTrigger ControlID="fv_OfficerPosition" 
            EventName="ItemInserted" />
    </triggers>
</asp:UpdatePanel>
<a name="Insert"></a>
<asp:FormView ID="fv_OfficerPosition" runat="server" DataSourceID="edsOfficerPositionInsert"
    EnableModelValidation="true" DefaultMode="Insert" OnItemInserting="fv_OfficerPosition_ItemInserting"
    OnItemInserted="fv_OfficerPosition_ItemInserted">
    <InsertItemTemplate>
        <h3>
            Add a new office position</h3>
        <div>
            <label>
                Title:
            </label>
            <asp:TextBox ID="txtTitle" runat="server" Text='<%# Bind("Title") %>'></asp:TextBox></div>
        <div>
            <label>
                Email:
            </label>
            <asp:TextBox ID="txtEmail" runat="server" Text='<%# Bind("OfficeEmail") %>'></asp:TextBox></div>
        <asp:Literal runat="server" Visible="false" ID="fileIdBinder" Text='<%# Bind("FileId") %>'></asp:Literal>
        <Portal:URL ID="urlOfficeBadge" runat="server" ShowFiles="True" ShowLog="False" ShowNewWindow="False"
            FileFilter="jpg,jpeg,jpe,gif,bmp,png,swf" ShowNone="True" ShowTabs="False" ShowTrack="False"
            ShowUrls="True" Width="300" />
        <label>
            Group:
        </label>
        <asp:DropDownList ID="ddlGroup" runat="server" DataSourceID="odsGroupSource" DataValueField="GroupId"
            AppendDataBoundItems="true" DataTextField="Name" SelectedValue='<%# Bind("GroupId")%>'>
            <asp:ListItem Value="">&lt;Choose a Group&gt;</asp:ListItem>
        </asp:DropDownList>
        <div>
            <label>
                Choose a Position Type:</label><asp:DropDownList runat="server" ID="ddlPositionType"
                    SelectedValue='<%# Bind("OfficerPositionTypeId") %>' DataSourceID="edsPositionTypeNew"
                    DataTextField="Name" DataValueField="OfficerPositionTypeId">
                </asp:DropDownList>
            This will affect how the office behaves, read the description of the types for details.</div>
        <label>
            Enter a Description for the Position</label><Portal:DNNRichTextEditControl ID="textDescriptionAdd"
                runat="server" Value='<%# Bind("Description") %>' />
        <label>
            Sort Order</label>
        <asp:TextBox ID="txtSort" Width="30" runat="server" Text='<%# Bind("ListOrder") %>'></asp:TextBox>
        <asp:CompareValidator Operator="DataTypeCheck" SetFocusOnError="true" ValidationGroup="Add"
            ID="sortValidator" ValueToCompare="Text" Type="Integer" runat="server" ControlToValidate="txtSort"
            CssClass="NormalRed" EnableClientScript="true" ErrorMessage="Sort Order requires a number" />
        <asp:RequiredFieldValidator SetFocusOnError="true" ValidationGroup="Add" ID="CompareValidator2"
            CssClass="NormalRed" ValueToCompare="Text" runat="server" ControlToValidate="txtSort"
            EnableClientScript="true" ErrorMessage="Sort Order requires a number" />
        <div>
            <asp:LinkButton ID="LinkButton1" runat="server" CausesValidation="True" CommandName="Insert"
                ValidationGroup="Add" Text="Add New"></asp:LinkButton></div>
    </InsertItemTemplate>
</asp:FormView>
<p>
    <asp:LinkButton ID="cmdCancel" CssClass="CommandButton" runat="server" CausesValidation="False"
        BorderStyle="None" OnClick="cmdCancel_Click">Done</asp:LinkButton>
</p>
