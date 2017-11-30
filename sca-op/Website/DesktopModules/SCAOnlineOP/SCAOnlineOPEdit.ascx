<%@ Register TagPrefix="Portal" TagName="URL" Src="~/controls/URLControl.ascx" %>
<%@ Control Language="c#" AutoEventWireup="false" Inherits="JeffMartin.DNN.Modules.SCAOnlineOP.SCAOnlineOPEdit"
    TargetSchema="http://schemas.microsoft.com/intellisense/ie5" CodeBehind="SCAOnlineOPEdit.ascx.cs" %>
<asp:Panel ID="pnlDisplayMember" CssClass="EditContainer" runat="server">
    <table cellspacing="3" cellpadding="3" width="100%" border="0">
        <tr>
            <td>
                <h1 class="MemberName" id="h1MemberName" runat="server">
                    Member Name</h1>
                <asp:TextBox ID="txtMemberName" runat="server" Width="200"></asp:TextBox>(PeopleId:
                <%=Request.QueryString["memid"]%>
                )<br>
                Gender:
                <asp:DropDownList ID="ddlGender" runat="server">
                    <asp:ListItem Value="">None Selected</asp:ListItem>
                    <asp:ListItem Value="F">Female</asp:ListItem>
                    <asp:ListItem Value="M">Male</asp:ListItem>
                    <asp:ListItem Value="P">Pet/Animal</asp:ListItem>
                </asp:DropDownList>
                <br />
                Deceased:
                <asp:CheckBox ID="chkDeceased" runat="server" /><br />
                Deceased When (Year):
                <asp:TextBox ID="txtDeceasedWhen" runat="server"></asp:TextBox><br />
                Last Known Branch of Residence:
                <asp:DropDownList runat="server" ID="ddlResidenceGroupList">
                </asp:DropDownList>
            </td>
            <td id="tdEmail" runat="server">
                Email:
                <asp:TextBox ID="txtEmailAddress" runat="server"></asp:TextBox><br>
                <asp:CheckBox ID="chkShowEmailPermissions" runat="server" Text="Member has given permissions for Email display">
                </asp:CheckBox>
            </td>
            <td style="width: 200px" valign="top" align="right" width="200">
                Rank in OP:
                <asp:Literal ID="litRank" runat="server"></asp:Literal><br>
                <asp:LinkButton ID="cmdResetOPOrder" runat="server">Re-Calculate</asp:LinkButton><br>
                <span class="InstructionNote">Note that OPNum recalculation is done automatically when
                    someone is assigned an award or an award is created or edited.</span>
            </td>
        </tr>
    </table>
    <table cellspacing="0" cellpadding="0" border="0">
        <tr>
            <td valign="top">
                <fieldset>
                    <legend>Member Arms</legend>
                    <asp:Image ID="imgMemberArms" runat="server"></asp:Image><br>
                    <Portal:URL ID="urlMemberArms" runat="server" ShowTrack="False" ShowNewWindow="False"
                        ShowLog="False" ShowUrls="True" ShowFiles="True" ShowTabs="False" Width="300"
                        ShowNone="True"></Portal:URL>
                </fieldset>
            </td>
            <td valign="top">
                <fieldset>
                    <legend>Personal Photo</legend>
                    <asp:Image ID="imgPersonalPic" runat="server"></asp:Image><br>
                    <asp:CheckBox ID="chkShowImagePermissions" runat="server" Text="Member has given permissions for image display">
                    </asp:CheckBox>
                    <Portal:URL ID="urlPersonalPhoto" runat="server" ShowTrack="False" ShowNewWindow="False"
                        ShowLog="False" ShowUrls="True" ShowFiles="True" ShowTabs="False" Width="300"
                        ShowNone="True"></Portal:URL>
                </fieldset>
            </td>
        </tr>
        <tr id="trBlazon" runat="server">
            <td id="tdBlazon" valign="top" colspan="2" runat="server">
                Blazon:
                <asp:TextBox ID="txtBlazon" runat="server" Width="300" TextMode="MultiLine" Height="100"></asp:TextBox>
            </td>
        </tr>
    </table>
    <fieldset>
        <legend>Address Info</legend><span class="InstructionNote">This is used for displaying
            officer information. The officer info assumes permission is given to display anything
            in here on the officer page.</span>
        <table>
            <tr>
                <td class="SubHead" valign="top" width="165">
                    Title (Name Prefix):
                </td>
                <td>
                    <asp:TextBox ID="txtTitle" CssClass="NormalTextBox" runat="server" MaxLength="100"></asp:TextBox>
                </td>
            </tr>
            <tr>
                <td class="SubHead" valign="top" width="165">
                    Honors (Name Suffix):
                </td>
                <td>
                    <asp:TextBox ID="txtSuffix" CssClass="NormalTextBox" runat="server" MaxLength="100"></asp:TextBox>
                </td>
            </tr>
            <tr>
                <td class="SubHead" valign="top" width="165">
                    Modern Name:
                </td>
                <td>
                    <asp:TextBox ID="txtMundaneName" CssClass="NormalTextBox" runat="server" MaxLength="100"></asp:TextBox>
                </td>
            </tr>
            <tr>
                <td class="SubHead" valign="top" width="165">
                    Address1:
                </td>
                <td>
                    <asp:TextBox ID="txtAddress1" CssClass="NormalTextBox" runat="server" MaxLength="100"></asp:TextBox>
                </td>
            </tr>
            <tr>
                <td class="SubHead" valign="top" width="165">
                    Address2:
                </td>
                <td>
                    <asp:TextBox ID="txtAddress2" CssClass="NormalTextBox" runat="server" MaxLength="100"></asp:TextBox>
                </td>
            </tr>
            <tr>
                <td class="SubHead" valign="top" width="165">
                    City:
                </td>
                <td>
                    <asp:TextBox ID="txtCity" CssClass="NormalTextBox" runat="server" MaxLength="50"></asp:TextBox>
                </td>
            </tr>
            <tr>
                <td class="SubHead" valign="top" width="165">
                    State:
                </td>
                <td>
                    <asp:TextBox ID="txtState" CssClass="NormalTextBox" runat="server" MaxLength="50"></asp:TextBox>
                </td>
            </tr>
            <tr>
                <td class="SubHead" valign="top" width="165">
                    Zip:
                </td>
                <td>
                    <asp:TextBox ID="txtZip" CssClass="NormalTextBox" runat="server" MaxLength="50"></asp:TextBox>
                </td>
            </tr>
            <tr>
                <td class="SubHead" valign="top" width="165">
                    Phone1:
                </td>
                <td>
                    <asp:TextBox ID="txtPhone1" CssClass="NormalTextBox" runat="server" MaxLength="50"></asp:TextBox>
                </td>
            </tr>
            <tr>
                <td class="SubHead" valign="top" width="165">
                    Phone2:
                </td>
                <td>
                    <asp:TextBox ID="txtPhone2" CssClass="NormalTextBox" runat="server" MaxLength="50"></asp:TextBox>
                </td>
            </tr>
            <tr>
                <td class="SubHead" valign="top" width="165">
                    Officer Notes:(will display on officer page)
                </td>
                <td>
                    <asp:TextBox ID="txtOfficerNotes" CssClass="NormalTextBox" runat="server" TextMode="MultiLine"
                        MaxLength="500" Rows="5" Columns="50"></asp:TextBox>
                </td>
            </tr>
            <tr>
                <td class="SubHead" valign="top" width="165">
                    Admin Notes:(no display - for admin notes)
                </td>
                <td>
                    <asp:TextBox ID="txtAdminNotes" CssClass="NormalTextBox" runat="server" TextMode="MultiLine"
                        MaxLength="500" Rows="5" Columns="50"></asp:TextBox>
                </td>
            </tr>
        </table>
    </fieldset>
    <asp:LinkButton ID="cmdUpdate" CssClass="CommandButton" runat="server" resourcekey="cmdUpdate"
        BorderStyle="None">Update</asp:LinkButton>
    <asp:LinkButton ID="cmdUpdateAndReturn" CssClass="CommandButton" runat="server" resourcekey="cmdUpdateAndReturn"
        BorderStyle="None">Update and Return</asp:LinkButton>
    <asp:LinkButton ID="cmdCancel" CssClass="CommandButton" runat="server" resourcekey="cmdCancel"
        BorderStyle="None" CausesValidation="False">Cancel</asp:LinkButton>
    <asp:LinkButton ID="cmdDelete" CssClass="CommandButton" runat="server" resourcekey="cmdDelete"
        BorderStyle="None" CausesValidation="False" Visible="False">Delete</asp:LinkButton>
    <h2>
        Aliases</h2>
    <asp:DataGrid ID="dgAliases" runat="server" CssClass="ResultList" AutoGenerateColumns="False"
        ShowFooter="True">
        <Columns>
            <asp:BoundColumn DataField="AliasId" ReadOnly="True" HeaderText="AliasId"></asp:BoundColumn>
            <asp:TemplateColumn HeaderText="Also Known By:">
                <ItemTemplate>
                    <asp:Label ID="lblAlias" runat="server" Text='<%# DataBinder.Eval(Container, "DataItem.SCAName") %>'>
                    </asp:Label>
                    <asp:Literal runat="server" Visible='<%# Convert.ToBoolean(DataBinder.Eval(Container, "DataItem.Registered")) %>'
                        ID="Literal1">(R)</asp:Literal>
                    <asp:Literal runat="server" Visible='<%# Convert.ToBoolean(DataBinder.Eval(Container, "DataItem.Preferred")) %>'
                        ID="Literal2">(P)</asp:Literal>
                </ItemTemplate>
                <FooterTemplate>
                    <asp:TextBox runat="server" Text='<%# DataBinder.Eval(Container, "DataItem.SCAName") %>'
                        ID="txtAdd_SCAName">
                    </asp:TextBox>
                </FooterTemplate>
                <EditItemTemplate>
                    <asp:TextBox runat="server" Text='<%# DataBinder.Eval(Container, "DataItem.SCAName") %>'
                        ID="txtEdit_SCAName">
                    </asp:TextBox>
                </EditItemTemplate>
            </asp:TemplateColumn>
            <asp:TemplateColumn HeaderText="Registered">
                <ItemTemplate>
                    <asp:Label runat="server" Text='<%# DataBinder.Eval(Container, "DataItem.Registered") %>'>
                    </asp:Label>
                </ItemTemplate>
                <FooterTemplate>
                    <asp:CheckBox runat="server" ID="chkAdd_Registered"></asp:CheckBox>
                </FooterTemplate>
                <EditItemTemplate>
                    <asp:CheckBox runat="server" Checked='<%# Convert.ToBoolean(DataBinder.Eval(Container, "DataItem.Registered")) %>'
                        ID="chkEdit_Registered"></asp:CheckBox>
                </EditItemTemplate>
            </asp:TemplateColumn>
            <asp:TemplateColumn HeaderText="Preferred">
                <ItemTemplate>
                    <asp:Label runat="server" Text='<%# DataBinder.Eval(Container, "DataItem.Preferred") %>'>
                    </asp:Label>
                </ItemTemplate>
                <FooterTemplate>
                    <asp:CheckBox runat="server" ID="chkAdd_Preferred"></asp:CheckBox>
                </FooterTemplate>
                <EditItemTemplate>
                    <asp:CheckBox runat="server" Checked='<%# Convert.ToBoolean(DataBinder.Eval(Container, "DataItem.Preferred")) %>'
                        Text='' ID="chkEdit_Preferred"></asp:CheckBox>
                </EditItemTemplate>
            </asp:TemplateColumn>
            <asp:TemplateColumn HeaderText="Edit">
                <ItemTemplate>
                    <asp:LinkButton runat="server" Text="Edit" CommandName="Edit" CausesValidation="false"></asp:LinkButton>
                </ItemTemplate>
                <FooterTemplate>
                    <asp:LinkButton runat="server" Text="Add" CommandName="Add"></asp:LinkButton>
                </FooterTemplate>
                <EditItemTemplate>
                    <asp:LinkButton runat="server" Text="Update" CommandName="Update"></asp:LinkButton>&nbsp;
                    <asp:LinkButton runat="server" Text="Cancel" CommandName="Cancel" CausesValidation="false"></asp:LinkButton>
                </EditItemTemplate>
            </asp:TemplateColumn>
            <asp:TemplateColumn HeaderText="Delete">
                <ItemTemplate>
                    <asp:LinkButton runat="server" ID="cmdDeleteAlias" Text="Delete" CommandName="Delete"
                        CausesValidation="false"></asp:LinkButton>
                </ItemTemplate>
            </asp:TemplateColumn>
        </Columns>
    </asp:DataGrid>
    <span class="InstructionNote">(R) indicates the name the person has registered with
        the college of heralds.<br>
        (P) indicates the person's preferred name/spelling.</span><h2>
            Awards Received</h2>
    <asp:DataGrid ID="dgAwards" runat="server" CssClass="ResultList" AutoGenerateColumns="False"
        ShowFooter="True">
        <Columns>
            <asp:BoundColumn DataField="PeopleAwardId" ReadOnly="True" HeaderText="PeopleAwardId">
            </asp:BoundColumn>
            <asp:TemplateColumn HeaderText="Award Name">
                <ItemTemplate>
                    <asp:HyperLink ID="hlAward" runat="server" Text='<%# DataBinder.Eval(Container, "DataItem.AwardName") %>'
                        NavigateUrl='<%# DataBinder.Eval(Container, "DataItem.AwardId") %>'>
                    </asp:HyperLink>
                </ItemTemplate>
                <FooterTemplate>
                    <asp:DropDownList ID="ddlAdd_Group" AutoPostBack="True" OnSelectedIndexChanged="GroupDdlInAwards_SelectedIndexChanged"
                        runat="server" CssClass="awardList" Width="270px">
                    </asp:DropDownList>
                    <asp:DropDownList ID="ddlAdd_Award" runat="server" CssClass="awardList" Width="270px">
                    </asp:DropDownList>
                    <br>
                    On date:<br>
                    <asp:TextBox ID="txtAdd_Date" runat="server" Text='<%# DataBinder.Eval(Container, "DataItem.Date", "{0:d}") %>'> </asp:TextBox>
                    <asp:DropDownList ID="ddlAdd_Hours" runat="server">
                    </asp:DropDownList>
                    <asp:HyperLink ID="hlAdd_Calendar" runat="server">Calendar</asp:HyperLink><br>
                    Given by:<br>
                    <asp:DropDownList ID="ddlAdd_GivenBy" CssClass="awardList" runat="server" Width="270px">
                    </asp:DropDownList>
                    <br>
                    Notes:<br>
                    <asp:TextBox ID="txtAdd_Notes" runat="server" Width="270px" Text='<%# DataBinder.Eval(Container, "DataItem.Notes") %>'
                        TextMode="MultiLine" Columns="30" Rows="5"> </asp:TextBox><br>
                    Name on Scroll (add alias first):
                    <asp:DropDownList ID="ddlAdd_AliasId" runat="server">
                    </asp:DropDownList>
                </FooterTemplate>
                <EditItemTemplate>
                    <asp:DropDownList ID="ddlEdit_Group" AutoPostBack="True" OnSelectedIndexChanged="GroupDdlInAwards_SelectedIndexChanged"
                        Width="270px" CssClass="awardList" runat="server">
                    </asp:DropDownList>
                    <asp:DropDownList ID="ddlEdit_Award" Width="270px" CssClass="awardList" runat="server">
                    </asp:DropDownList>
                    <br>
                    On date:<br>
                    <asp:TextBox ID="txtEdit_Date" runat="server" Text='<%# DataBinder.Eval(Container, "DataItem.Date", "{0:d}") %>'> </asp:TextBox>
                    <asp:DropDownList ID="ddlEdit_Hours" runat="server">
                    </asp:DropDownList>
                    <asp:HyperLink ID="hlEdit_Calendar" runat="server">Calendar</asp:HyperLink><br>
                    Given by:<br>
                    <asp:DropDownList ID="ddlEdit_GivenBy" CssClass="awardList" Width="270px" runat="server">
                    </asp:DropDownList>
                    <br>
                    Notes:<br>
                    <asp:TextBox ID="txtEdit_Notes" Width="270px" runat="server" Text='<%# DataBinder.Eval(Container, "DataItem.Notes") %>'
                        TextMode="MultiLine" Columns="30" Rows="5"> </asp:TextBox><br>
                    Name on Scroll (add alias first):
                    <asp:DropDownList ID="ddlEdit_AliasId" runat="server">
                    </asp:DropDownList>
                </EditItemTemplate>
            </asp:TemplateColumn>
            <asp:HyperLinkColumn DataNavigateUrlField="GroupId" DataTextField="GroupName" HeaderText="Group Name">
            </asp:HyperLinkColumn>
            <asp:TemplateColumn HeaderText="Date">
                <ItemTemplate>
                    <asp:Label ID="Label3" runat="server" Text='<%# DataBinder.Eval(Container, "DataItem.Date", "{0:d}") %>'>
                    </asp:Label>
                </ItemTemplate>
                <FooterTemplate>
                </FooterTemplate>
                <EditItemTemplate>
                </EditItemTemplate>
            </asp:TemplateColumn>
            <asp:TemplateColumn HeaderText="Given By">
                <ItemTemplate>
                    <asp:HyperLink ID="hlCrown" runat="server" Text='<%# DataBinder.Eval(Container, "DataItem.AwardedBy") %>'
                        NavigateUrl='<%# DataBinder.Eval(Container, "DataItem.CrownId") %>'>
                    </asp:HyperLink>
                </ItemTemplate>
                <FooterTemplate>
                </FooterTemplate>
                <EditItemTemplate>
                </EditItemTemplate>
            </asp:TemplateColumn>
            <asp:TemplateColumn HeaderText="Notes">
                <ItemTemplate>
                    <asp:Label runat="server" Text='<%# DataBinder.Eval(Container, "DataItem.Notes") %>'>
                    </asp:Label>
                </ItemTemplate>
                <FooterTemplate>
                </FooterTemplate>
                <EditItemTemplate>
                </EditItemTemplate>
            </asp:TemplateColumn>
            <asp:TemplateColumn HeaderText="Name on Scroll">
                <ItemTemplate>
                    <asp:Label runat="server" Text='<%# DataBinder.Eval(Container, "DataItem.NameOnScroll") %>'>
                    </asp:Label>
                </ItemTemplate>
                <FooterTemplate>
                </FooterTemplate>
                <EditItemTemplate>
                </EditItemTemplate>
            </asp:TemplateColumn>
            <asp:TemplateColumn HeaderText="Retired">
                <ItemTemplate>
                    <asp:Label ID="Label4" runat="server" Text='<%# DataBinder.Eval(Container, "DataItem.Retired") %>'>
                    </asp:Label>
                </ItemTemplate>
                <FooterTemplate>
                    <asp:CheckBox ID="chkAdd_Retired" runat="server"></asp:CheckBox>
                </FooterTemplate>
                <EditItemTemplate>
                    <asp:CheckBox ID="chkEdit_Retired" Checked='<%# Convert.ToBoolean(DataBinder.Eval(Container, "DataItem.Retired")) %>'
                        runat="server"></asp:CheckBox>
                </EditItemTemplate>
            </asp:TemplateColumn>
            <asp:TemplateColumn HeaderText="Edit">
                <ItemTemplate>
                    <asp:LinkButton ID="LinkButton1" runat="server" CausesValidation="false" Text="Edit"
                        CommandName="Edit"></asp:LinkButton>
                </ItemTemplate>
                <FooterTemplate>
                    <asp:LinkButton ID="Linkbutton4" runat="server" Text="Add" CommandName="Add"></asp:LinkButton>
                </FooterTemplate>
                <EditItemTemplate>
                    <asp:LinkButton ID="LinkButton3" runat="server" Text="Update" CommandName="Update"></asp:LinkButton>&nbsp;
                    <asp:LinkButton ID="LinkButton2" runat="server" CausesValidation="false" Text="Cancel"
                        CommandName="Cancel"></asp:LinkButton>
                </EditItemTemplate>
            </asp:TemplateColumn>
            <asp:TemplateColumn HeaderText="Delete">
                <ItemTemplate>
                    <asp:LinkButton runat="server" ID="cmdDeleteAward" Text="Delete" CommandName="Delete"
                        CausesValidation="false"></asp:LinkButton>
                </ItemTemplate>
            </asp:TemplateColumn>
        </Columns>
    </asp:DataGrid>
    <asp:HyperLink ID="hlNewAward" runat="server">Create New Award</asp:HyperLink>
    <h2>
        Offices and Other Positions Held</h2>
    <span class="InstructionNote">This will only edit/add Officers and Edit Crowns. To add
        a crown, you must use the crown page.</span>
    <asp:DataGrid ID="dgOffices" runat="server" CssClass="ResultList" AutoGenerateColumns="False"
        ShowFooter="True" onitemcreated="dgOffices_ItemCreated">
        <Columns>
            <asp:BoundColumn DataField="ID" ReadOnly="True" HeaderText="Id"></asp:BoundColumn>
            <asp:TemplateColumn HeaderText="Office or Honor">
                <ItemTemplate>
                    <asp:Literal runat="server" Visible='<%# Convert.ToBoolean(DataBinder.Eval(Container, "DataItem.Acting")) %>'>ACTING </asp:Literal>
                    <asp:Label runat="server" Text='<%# DataBinder.Eval(Container, "DataItem.Title") %>'>
                    </asp:Label><asp:PlaceHolder ID="Literal3" runat="server" Visible='<%# (Convert.ToBoolean(DataBinder.Eval(Container, "DataItem.LinkedToCrown"))) %>'>
                        for
                        <asp:HyperLink ID="hlCrown" Text='<%# DataBinder.Eval(Container, "DataItem.LinkedCrownDisplay") %>'
                            runat="server" NavigateUrl='<%# DotNetNuke.Common.Globals.NavigateURL(TabId, "", "cid=" + DataBinder.Eval(Container, "DataItem.LinkedCrownId")) %>'></asp:HyperLink></asp:PlaceHolder>
                    <asp:Literal runat="server" Visible='<%# ! Convert.ToBoolean(DataBinder.Eval(Container, "DataItem.Verified")) %>'><br>(unverified)</asp:Literal>
                    <br />
                    <asp:Label runat="server" Text='<%# DataBinder.Eval(Container, "DataItem.PositionSubTitle") %>'></asp:Label>
                    <br />
                    Using Email:
                    <asp:Label ID="Label7" runat="server" Text='<%# DataBinder.Eval(Container, "DataItem.EmailToUse") %>'></asp:Label>
                    <br />
                    <asp:HyperLink runat="server" ID="hlEmail"></asp:HyperLink><br />
                    <strong>Notes:</strong>
                    <asp:Label runat="server" Text='<%# DataBinder.Eval(Container, "DataItem.PositionNotes") %>'></asp:Label>
                </ItemTemplate>
                <FooterTemplate>
                    <asp:DropDownList ID="ddlAdd_Group" AutoPostBack="True" OnSelectedIndexChanged="GroupDdlInOffices_SelectedIndexChanged"
                        Width="270px" CssClass="awardList" runat="server">
                    </asp:DropDownList>
                    <asp:DropDownList ID="ddlAdd_OfficePosition" CssClass="awardList" Width="270px" runat="server"
                        AutoPostBack="True" OnSelectedIndexChanged="ddlOfficePosition_SelectedIndexChanged">
                    </asp:DropDownList>
                    <br />
                    <asp:PlaceHolder ID="phCrown" runat="server">Linked to Reign:
                        <asp:DropDownList ID="ddlAdd_Crown" runat="server" DataTextField="ReignCrown" DataValueField="CrownId"
                            CssClass="awardList">
                        </asp:DropDownList>
                        <br />
                    </asp:PlaceHolder>
                    Subtitle:<asp:TextBox ID="txtAdd_PositionSubTitle" runat="server"></asp:TextBox><br />
                    Notes:<asp:TextBox ID="txtAdd_PositionNotes" runat="server" TextMode="MultiLine"></asp:TextBox><br />
                    Email To Use for this office:
                    <asp:DropDownList runat="server" ID="ddlAdd_EmailToUse">
                        <asp:ListItem Selected="True" Value="OfficePosition">Office Position</asp:ListItem>
                        <asp:ListItem Value="Override">This Override</asp:ListItem>
                        <asp:ListItem Value="Personal">Personal</asp:ListItem>
                    </asp:DropDownList>
                    <br />
                    Email Override:
                    <asp:TextBox ID="txtAdd_EmailOverride" runat="server"></asp:TextBox><br />
                </FooterTemplate>
                <EditItemTemplate>
                    <asp:DropDownList ID="ddlEdit_Group" AutoPostBack="True" OnSelectedIndexChanged="GroupDdlInOffices_SelectedIndexChanged"
                        Width="270px" CssClass="awardList" runat="server">
                    </asp:DropDownList>
                    <asp:DropDownList ID="ddlEdit_OfficePosition" Width="270px" CssClass="awardList"
                        AutoPostBack="True" OnSelectedIndexChanged="ddlOfficePosition_SelectedIndexChanged"
                        runat="server">
                    </asp:DropDownList>
                    <br />
                    <asp:PlaceHolder ID="phCrown" runat="server">Linked to Reign:
                        <asp:DropDownList ID="ddlEdit_Crown" runat="server" DataTextField="ReignCrown" DataValueField="CrownId"
                            CssClass="awardList">
                        </asp:DropDownList>
                        <br />
                    </asp:PlaceHolder>
                    Subtitle<asp:TextBox ID="txtEdit_PositionSubTitle" runat="server" Text='<%# DataBinder.Eval(Container, "DataItem.PositionSubTitle") %>'></asp:TextBox><br />
                    Notes:<asp:TextBox ID="txtEdit_PositionNotes" runat="server" Text='<%# DataBinder.Eval(Container, "DataItem.PositionNotes") %>'
                        TextMode="MultiLine"></asp:TextBox><br />
                    Email To Use for this office:
                    <asp:DropDownList runat="server" ID="ddlEdit_EmailToUse">
                        <asp:ListItem Value="OfficePosition">Office Position</asp:ListItem>
                        <asp:ListItem Value="Override">This Override</asp:ListItem>
                        <asp:ListItem Value="Personal">Personal</asp:ListItem>
                    </asp:DropDownList>
                    <br />
                    Email Override:
                    <asp:TextBox ID="txtEdit_EmailOverride" runat="server" Text='<%# DataBinder.Eval(Container, "DataItem.EmailOverride") %>'></asp:TextBox><br />
                </EditItemTemplate>
            </asp:TemplateColumn>
            <asp:HyperLinkColumn DataNavigateUrlField="GroupId" DataTextField="GroupName" HeaderText="Group Name">
            </asp:HyperLinkColumn>
            <asp:TemplateColumn HeaderText="Start Date">
                <ItemTemplate>
                    <asp:Label runat="server" Text='<%# DataBinder.Eval(Container, "DataItem.Startdate", "{0:d}") %>'>
                    </asp:Label>
                </ItemTemplate>
                <FooterTemplate>
                    Start Date:
                    <asp:TextBox ID="txtAdd_StartDate" runat="server"></asp:TextBox><asp:HyperLink ID="hlAdd_StartDateCalendar" NavigateUrl='<%# DotNetNuke.Common.Utilities.Calendar.InvokePopupCal((TextBox)Container.FindControl("txtAdd_StartDate")) %>'
                        runat="server">Calendar</asp:HyperLink>
                    <asp:RequiredFieldValidator ID="RequiredFieldValidator2" ControlToValidate="txtAdd_StartDate"
                        Display="Dynamic" CssClass="NormalRed" runat="server" ErrorMessage="Start Date is Required"
                        SetFocusOnError="true" ValidationGroup="Add" />
                    <asp:CompareValidator ID="CompareValidator1" ControlToValidate="txtAdd_StartDate"
                        Display="Dynamic" CssClass="NormalRed" runat="server" ErrorMessage="Start Date must be a date"
                        Type="Date" Operator="DataTypeCheck" SetFocusOnError="true" ValidationGroup="Add" />
                    <br />
                    End Date:
                    <asp:TextBox ID="txtAdd_EndDate" runat="server"></asp:TextBox><asp:HyperLink ID="hlAdd_EndDateCalendar" NavigateUrl='<%# DotNetNuke.Common.Utilities.Calendar.InvokePopupCal((TextBox)Container.FindControl("txtAdd_EndDate")) %>'
                        runat="server">Calendar</asp:HyperLink>
                    <asp:RequiredFieldValidator ID="RequiredFieldValidator3" ControlToValidate="txtAdd_EndDate"
                        Display="Dynamic" CssClass="NormalRed" runat="server" ErrorMessage="End Date is Required"
                        SetFocusOnError="true" ValidationGroup="Add" />
                    <asp:CompareValidator ID="RequiredFieldValidator1" ControlToValidate="txtAdd_EndDate"
                        Display="Dynamic" CssClass="NormalRed" runat="server" ErrorMessage="End Date must be a date"
                        Type="Date" Operator="DataTypeCheck" SetFocusOnError="true" ValidationGroup="Add" />
                </FooterTemplate>
                <EditItemTemplate>
                    <asp:TextBox ID="txtEdit_StartDate" runat="server" Text='<%# DataBinder.Eval(Container, "DataItem.Startdate", "{0:d}") %>'>
                    </asp:TextBox>
                    <asp:HyperLink ID="hlEdit_StartDateCalendar" runat="server" NavigateUrl='<%# DotNetNuke.Common.Utilities.Calendar.InvokePopupCal((TextBox)Container.FindControl("txtEdit_StartDate")) %>'>Calendar</asp:HyperLink> 
                    <asp:RequiredFieldValidator ID="RequiredFieldValidator2" ControlToValidate="txtEdit_EndDate"
                        Display="Dynamic" CssClass="NormalRed" runat="server" ErrorMessage="Start Date is Required"
                        SetFocusOnError="true" ValidationGroup="Edit" />
                    <asp:CompareValidator ID="CompareValidator1" ControlToValidate="txtEdit_EndDate"
                        Display="Dynamic" CssClass="NormalRed" runat="server" ErrorMessage="Start Date must be a date"
                        Type="Date" Operator="DataTypeCheck" SetFocusOnError="true" ValidationGroup="Edit" />
                    <br />
                    End Date:
                    <asp:TextBox ID="txtEdit_EndDate" runat="server" Text='<%# DataBinder.Eval(Container, "DataItem.EndDate", "{0:d}") %>'>
                    </asp:TextBox>
                    <asp:HyperLink ID="hlEdit_EndDateCalendar" runat="server" NavigateUrl='<%# DotNetNuke.Common.Utilities.Calendar.InvokePopupCal((TextBox)Container.FindControl("txtEdit_EndDate")) %>'>Calendar</asp:HyperLink>
                    <asp:RequiredFieldValidator ControlToValidate="txtEdit_EndDate" runat="server" ErrorMessage="End Date is Required"
                        Display="Dynamic" CssClass="NormalRed" SetFocusOnError="true" ValidationGroup="Edit" />
                    <asp:CompareValidator ID="RequiredFieldValidator1" ControlToValidate="txtEdit_EndDate"
                        Display="Dynamic" CssClass="NormalRed" runat="server" ErrorMessage="End Date must be a date"
                        Type="Date" Operator="DataTypeCheck" SetFocusOnError="true" ValidationGroup="Edit" />
                </EditItemTemplate>
            </asp:TemplateColumn>
            <asp:TemplateColumn HeaderText="End Date">
                <ItemTemplate>
                    <asp:Label runat="server" Text='<%# FormatEndDate( DataBinder.Eval(Container, "DataItem.EndDate"), DataBinder.Eval(Container, "DataItem.CurrentlyHeld")) %>'
                        ID="Label1">
                    </asp:Label>
                </ItemTemplate>
            </asp:TemplateColumn>
            <asp:TemplateColumn HeaderText="Acting">
                <ItemTemplate>
                    <asp:Label runat="server" Text='<%# FormatYesNo( DataBinder.Eval(Container, "DataItem.Acting")) %>'
                        ID="Label5">
                    </asp:Label>
                </ItemTemplate>
                <FooterTemplate>
                    <asp:CheckBox ID="chkAdd_Acting" runat="server"></asp:CheckBox>
                </FooterTemplate>
                <EditItemTemplate>
                    <asp:CheckBox ID="chkEdit_Acting" Checked='<%# Convert.ToBoolean(DataBinder.Eval(Container, "DataItem.Acting")) %>'
                        runat="server"></asp:CheckBox>
                </EditItemTemplate>
            </asp:TemplateColumn>
            <asp:TemplateColumn HeaderText="Verified">
                <ItemTemplate>
                    <asp:Label runat="server" Text='<%# FormatYesNo( DataBinder.Eval(Container, "DataItem.Verified")) %>'
                        ID="Label6">
                    </asp:Label><br />
                    <asp:Label ID="Label8" runat="server" class="InstructionNote" Text='<%# DataBinder.Eval(Container, "DataItem.VerifiedNotes") %>'></asp:Label>
                </ItemTemplate>
                <FooterTemplate>
                    <asp:CheckBox ID="chkAdd_Verified" Checked="true" Visible="false" runat="server">
                    </asp:CheckBox><br />
                 <asp:TextBox ID="txtAdd_VerifiedNotes" Visible="false" Text='<%# "AUTOVERIFIED-" +  DateTime.Today.ToShortDateString()%>'
                        runat="server" TextMode="MultiLine"></asp:TextBox>
                </FooterTemplate>
                <EditItemTemplate>
                    <asp:CheckBox ID="chkEdit_Verified" Checked='<%# Convert.ToBoolean(DataBinder.Eval(Container, "DataItem.Verified")) %>'
                        runat="server"></asp:CheckBox>
                    Notes on Verification:<asp:TextBox ID="txtEdit_VerifiedNotes" runat="server" TextMode="MultiLine"
                        Text='<%# DataBinder.Eval(Container, "DataItem.VerifiedNotes") %>'></asp:TextBox>
                </EditItemTemplate>
            </asp:TemplateColumn>
            <asp:TemplateColumn HeaderText="Current">
                <ItemTemplate>
                    <asp:Label runat="server" Text='<%# FormatYesNo( DataBinder.Eval(Container, "DataItem.CurrentlyHeld")) %>'
                        ID="Label2">
                    </asp:Label>
                </ItemTemplate>
                <FooterTemplate>
                    <asp:CheckBox ID="chkAdd_Current" runat="server"></asp:CheckBox>
                </FooterTemplate>
                <EditItemTemplate>
                    <asp:CheckBox ID="chkEdit_Current" Checked='<%# Convert.ToBoolean(DataBinder.Eval(Container, "DataItem.CurrentlyHeld")) %>'
                        runat="server"></asp:CheckBox>
                </EditItemTemplate>
            </asp:TemplateColumn>
            <asp:TemplateColumn HeaderText="Edit">
                <ItemTemplate>
                    <asp:LinkButton runat="server" ID="cmdEditOfficer" Text="Edit" CommandName="Edit"
                        ValidationGroup="Edit" CausesValidation="true"></asp:LinkButton>
                </ItemTemplate>
                <EditItemTemplate>
                    <asp:LinkButton runat="server" Text="Update" CommandName="Update"></asp:LinkButton>&nbsp;
                    <asp:LinkButton runat="server" Text="Cancel" CommandName="Cancel" CausesValidation="false"></asp:LinkButton>
                </EditItemTemplate>
                <FooterTemplate>
                    <asp:LinkButton ID="Linkbutton5" runat="server" Text="Add" ValidationGroup="Add"
                        CausesValidation="true" CommandName="Add"></asp:LinkButton>
                </FooterTemplate>
            </asp:TemplateColumn>
            <asp:TemplateColumn HeaderText="Delete">
                <ItemTemplate>
                    <asp:LinkButton runat="server" Text="Delete" ID="cmdDeleteOfficer" CommandName="Delete"
                        CausesValidation="false"></asp:LinkButton>
                </ItemTemplate>
            </asp:TemplateColumn>
        </Columns>
    </asp:DataGrid>
    <asp:HyperLink ID="hlNewOffice" runat="server">Create New Office</asp:HyperLink>
    <br>
    <br>
    <a href="http://atensubmissions.nexiliscom.com/cgi-bin/heraldry/OandA/oanda_np.cgi?b=broad&p=<%=Server.UrlEncode("^" + GetRegisteredName() + "$")%>"
        target="armorial">Search SCA Armorial for
        <%=h1MemberName.InnerText%>
    </a>
    <br>
    <span class="InstructionNote">If this link doesn't return any results and you find this
        person under a different name, Please notify
        <%=HtmlUtils.FormatEmail("abacus@atenveldt.org")%>
        or
        <%=HtmlUtils.FormatEmail("webmin@atenveldt.org")%>
    </span>
    <br>
    <br>
    <asp:HyperLink ID="hlReturnToDisplay" runat="server">Back to Display View</asp:HyperLink>
</asp:Panel>
