<%@ Control Language="c#" AutoEventWireup="true" Inherits="JeffMartin.DNN.Modules.SCAOnlineOP.SCAOnlineOP"
    CodeBehind="SCAOnlineOP.ascx.cs" %>
<%@ Register Src="~/controls/SectionHeadControl.ascx" TagName="SectionHead" TagPrefix="dnn" %>
<%@ Register TagPrefix="sca" TagName="CrownDisplay" Src="SCAOnlineOPDisplayCrown.ascx" %>
<%@ Register TagPrefix="sca" TagName="GroupDisplay" Src="SCAOnlineOPDisplayGroup.ascx" %>
<asp:Panel ID="pnlOptionList" runat="server" CssClass="Normal">
    <div id="OptionList">
        <asp:Panel ID="pnlSearch" runat="server" CssClass="SearchBox" DefaultButton="btnSearchOP">
            <asp:TextBox ID="txtSearchOP" CssClass="SearchOPTextBox" runat="server"></asp:TextBox>
            <asp:Button ID="btnSearchOP" runat="server" Text="Search for People"></asp:Button><br>
            <dnn:SectionHead ID="dshAdvancedSearch" runat="server" CssClass="Head" IncludeRule="true"
                IsExpanded="False" MaxImageUrl="collapse.gif" MinImageUrl="expand.gif" Section="divSearchControls"
                Text="Advanced Search Settings" />
            <div id="divSearchControls" runat="server">
                <div class="ControlBox Outline">
                    <h4>
                        Search Options</h4>
                    <div class="ControlBox"> 
                        <h5>
                            Search By</h5>
                        <asp:RadioButtonList ID="rblSearchField" runat="server" RepeatLayout="Flow" EnableViewState="false"
                            RepeatDirection="Vertical">
                            <asp:ListItem Value="n" Selected="True">Name</asp:ListItem>
                            <asp:ListItem Value="b">Blazon</asp:ListItem>
                        </asp:RadioButtonList>
                    </div>
                    <div class="ControlBox">
                        <h5>
                            Where to Search</h5>
                        <span>The Results will</span><br />
                        <asp:RadioButtonList ID="rblFilterType" runat="server" RepeatDirection="Vertical"
                            EnableViewState="false" RepeatLayout="Flow">
                            <asp:ListItem Selected="True" Value="b">Begin with</asp:ListItem>
                            <asp:ListItem Value="c">Contain</asp:ListItem>
                        </asp:RadioButtonList>
                        <br />
                        <span>my Search Text.</span>
                    </div>
                    <div class="ControlBox">
                        <h5>
                            Order By</h5>
                        <asp:RadioButtonList ID="rblOrderBy" runat="server" RepeatLayout="Flow" EnableViewState="false"
                            RepeatDirection="Vertical">
                            <asp:ListItem Value="a" Selected="True">Auto (based on Search By)</asp:ListItem>
                            <asp:ListItem Value="n">Name</asp:ListItem>
                            <asp:ListItem Value="b">Blazon</asp:ListItem>
                            <asp:ListItem Value="p">Precedence</asp:ListItem>
                        </asp:RadioButtonList>
                    </div>
                </div>
                <div class="ControlBox Outline">
                    <h4>
                        Result List Options</h4>
                    <div class="ControlBox">
                        <h5>
                            Show</h5>
                        <asp:CheckBox ID="chkShowPhotos" Text="Photos" runat="server" EnableViewState="false" /><br />
                        <asp:CheckBox ID="chkShowDevices" Text="Devices" runat="server" EnableViewState="false" /><br />
                        <asp:CheckBox ID="chkShowAliases" runat="server" Text="Aliases" Checked="true" EnableViewState="false" /><br />
                        <asp:CheckBox ID="chkShowResidence" runat="server" Checked="false" Text="Residence"
                            EnableViewState="false" />
                    </div>
                    <div class="ControlBox">
                        <h5>
                            Limit to People who</h5>
                        <asp:CheckBox ID="chkIncludeOnlyPhotos" Text="Have a Photo" runat="server" EnableViewState="false" /><br />
                        <asp:CheckBox ID="chkIncludeOnlyDevices" runat="server" Text="Have a Device Graphic"
                            EnableViewState="false" /><br />
                        <asp:CheckBox ID="chkIncludeLivingStatus" runat="server" Text="Are:" EnableViewState="false" /><br />
                        <asp:RadioButtonList ID="rblLivingStatus" runat="server" EnableViewState="false"
                            RepeatLayout="flow" CssClass="RadioList">
                            <asp:ListItem Text="Alive" Selected="true" Value="A"></asp:ListItem>
                            <asp:ListItem Text="Deceased" Value="D"></asp:ListItem>
                        </asp:RadioButtonList>
                        <asp:CheckBox ID="chkIncludeResidentStatus" EnableViewState="false" runat="server"
                            Text="Located:" /><br />
                        <asp:RadioButtonList ID="rblResidentStatus" EnableViewState="false" runat="server"
                            CssClass="RadioList" RepeatLayout="flow">
                            <asp:ListItem Text="In Kingdom" Selected="true" Value="I"></asp:ListItem>
                            <asp:ListItem Text="Out of Kingdom" Value="O"></asp:ListItem>
                        </asp:RadioButtonList>
                    </div>
                    <div class="ControlBox">
                        <h5>
                            Results Per Page</h5>
                        <asp:DropDownList runat="server" EnableViewState="false" ID="ddlSearchResultsPerPage">
                            <asp:ListItem>10</asp:ListItem>
                            <asp:ListItem>25</asp:ListItem>
                            <asp:ListItem Selected="True">50</asp:ListItem>
                            <asp:ListItem>100</asp:ListItem>
                            <asp:ListItem>150</asp:ListItem>
                            <asp:ListItem>200</asp:ListItem>
                        </asp:DropDownList>
                    </div>
                </div>
            </div>
            <div class="break">
            </div>
        </asp:Panel>
        <dnn:SectionHead ID="dshQuickSearch" runat="server" CssClass="Head" IncludeRule="true"
            IsExpanded="True" MaxImageUrl="collapse.gif" MinImageUrl="expand.gif" Section="divQuickAndOther"
            Text="Quick Searches" />
        <div class="ControlBox" id="divQuickAndOther" runat="server">
            <ul>
                <li>By First Letter of First Name:&nbsp;<asp:PlaceHolder ID="phAlphaButtons" runat="server">
                </asp:PlaceHolder>
                </li>
                <li>
                    <asp:HyperLink ID="hlListByPrecedence" runat="server">List Members By Precedence</asp:HyperLink></li>
                <li>
                    <asp:HyperLink ID="hlRollofArms" runat="server">Roll of Arms</asp:HyperLink></li>
                <li>
                    <asp:HyperLink ID="hlRollofPhotos" runat="server">Portrait Gallery</asp:HyperLink></li>
                <li>
                    <asp:HyperLink ID="hlMemorialRolls" runat="server">Memorial Rolls</asp:HyperLink></li>
                <li>
                    <asp:HyperLink ID="hlNonResidence" runat="server">Non Resident List</asp:HyperLink></li>
            </ul>
            <div>
                <h3>
                    Search Awards by Date</h3>
                Year:
                <asp:DropDownList runat="server" ID="ddlYear" EnableViewState="true" />
                Month:
                <asp:DropDownList EnableViewState="false" runat="server" ID="ddlMonth">
                    <asp:ListItem Text="January" Value="1"></asp:ListItem>
                    <asp:ListItem Text="February" Value="2"></asp:ListItem>
                    <asp:ListItem Text="March" Value="3"></asp:ListItem>
                    <asp:ListItem Text="April" Value="4"></asp:ListItem>
                    <asp:ListItem Text="May" Value="5"></asp:ListItem>
                    <asp:ListItem Text="June" Value="6"></asp:ListItem>
                    <asp:ListItem Text="July" Value="7"></asp:ListItem>
                    <asp:ListItem Text="August" Value="8"></asp:ListItem>
                    <asp:ListItem Text="September" Value="9"></asp:ListItem>
                    <asp:ListItem Text="October" Value="10"></asp:ListItem>
                    <asp:ListItem Text="November" Value="11"></asp:ListItem>
                    <asp:ListItem Text="December" Value="12"></asp:ListItem>
                </asp:DropDownList>
                <asp:Button ID="btnSearchByDate" EnableViewState="false" runat="server" Text="Search By Award Date" />
            </div>
        </div>
        <div class="break">
        </div>
        <dnn:SectionHead ID="dshOtherLists" runat="server" CssClass="Head" IncludeRule="true"
            IsExpanded="True" MaxImageUrl="collapse.gif" MinImageUrl="expand.gif" Section="divOtherLists"
            Text="Other Lists" />
        <div id="divOtherLists" runat="server">
            <div class="OtherListBox">
                <h4>
                    SCA Branches</h4>
                <asp:Panel ID="pnlGroupLinks" runat="server" CssClass="OtherLinkList">
                </asp:Panel>
            </div>
            <div class="OtherListBox">
                <h4>
                    Award Charters</h4>
                <asp:Panel ID="pnlAwardCharterLinks" runat="server" CssClass="OtherLinkList">
                </asp:Panel>
            </div>
            <div class="OtherListBox">
                <h4>
                    Crowns and Coronets</h4>
                <asp:Panel ID="pnlCrownLinks" runat="server" CssClass="OtherLinkList">
                </asp:Panel>
            </div>
        </div>
    </div>
    <div class="break">
    </div>
</asp:Panel>
<asp:Panel ID="pnlResultList" runat="server" CssClass="Normal">
    <a name="results"></a>
    <asp:Table ID="tblResult" CssClass="ResultList" runat="server">
        <asp:TableRow runat="server" ID="Tablerow1">
            <asp:TableCell ID="tcListTitle" ColumnSpan="2" CssClass="ListTitle" runat="Server"></asp:TableCell>
        </asp:TableRow>
        <asp:TableRow CssClass="ResultList" runat="server">
            <asp:TableCell ID="tcListPaging" runat="Server">
                Results per Page:
                <asp:DropDownList ID="ddlResultsPerPage" runat="server" AutoPostBack="True" EnableViewState="false"
                    OnSelectedIndexChanged="ddlResultsPerPage_SelectedIndexChanged">
                    <asp:ListItem>10</asp:ListItem>
                    <asp:ListItem>25</asp:ListItem>
                    <asp:ListItem Selected="True">50</asp:ListItem>
                    <asp:ListItem>100</asp:ListItem>
                    <asp:ListItem>150</asp:ListItem>
                    <asp:ListItem>200</asp:ListItem>
                </asp:DropDownList>
            </asp:TableCell>
            <asp:TableCell ID="Tablecell1" runat="Server">
                Jump to Page:
                <asp:DropDownList ID="ddlJumpToPage" runat="server" AutoPostBack="True" OnSelectedIndexChanged="ddlJumpToPage_SelectedIndexChanged">
                </asp:DropDownList>
            </asp:TableCell>
            <asp:TableCell ID="tcListGroups" runat="server" Visible="False">
                <span class="InstructionNote">
                    <asp:Literal ID="litGroupFilterText" runat="server" />
                </span>
                <asp:DropDownList runat="server" ID="ddlGroupFilter" AutoPostBack="True">
                </asp:DropDownList>
            </asp:TableCell></asp:TableRow>
        <asp:TableRow runat="server">
            <asp:TableCell ID="tcGridContainer" runat="Server" ColumnSpan="2">
                <asp:DataGrid CssClass="ResultList" ID="dgResultList" runat="server" AllowPaging="True"
                    AllowSorting="False" AutoGenerateColumns="False" PageSize="50">
                    <PagerStyle Position="TopAndBottom" Mode="NumericPages"></PagerStyle>
                </asp:DataGrid>
                <div class="ImageResultListContainer">
                    <div class="ImageResultList">
                        <asp:Repeater ID="rptResultList" EnableViewState="false" runat="server">
                            <ItemTemplate>
                                <div class="ResultItem" id="divContainer" runat="server">
                                    <asp:HyperLink EnableViewState="false" runat="server" ID="hlResultLink">
                                        <asp:Image EnableViewState="false" ID="imgResultPersonalPic" runat="server" CssClass="ResultPhoto" />
                                        <asp:Image EnableViewState="false" ID="imgResultMemberArms" runat="server" CssClass="ResultDevice" />
                                        <div runat="server" id="spanSCAName" class="ResultItemName">
                                        </div>
                                    </asp:HyperLink>
                                    <div id="spanArmsBlazon" runat="server" class="ResultItemBlazon">
                                    </div>
                                    <div id="spanBranchResidence" runat="server" class="ResultItemResidence">
                                        <asp:HyperLink EnableViewState="false" ID="hlBranchResidence" runat="server"></asp:HyperLink>
                                    </div>
                                </div>
                                </div>
                            </ItemTemplate>
                        </asp:Repeater>
                    </div>
                </div>
            </asp:TableCell></asp:TableRow>
        <asp:TableRow runat="server" CssClass="ResultList">
            <asp:TableCell ID="tcListPagingBottom" runat="Server">
                Results per Page:
                <asp:DropDownList EnableViewState="false" ID="ddlResultsPerPageBottom" runat="server"
                    AutoPostBack="True" OnSelectedIndexChanged="ddlResultsPerPage_SelectedIndexChanged">
                    <asp:ListItem>10</asp:ListItem>
                    <asp:ListItem>25</asp:ListItem>
                    <asp:ListItem Selected="True">50</asp:ListItem>
                    <asp:ListItem>100</asp:ListItem>
                    <asp:ListItem>150</asp:ListItem>
                    <asp:ListItem>200</asp:ListItem>
                </asp:DropDownList>
            </asp:TableCell><asp:TableCell runat="Server">
                Jump to Page:
                <asp:DropDownList ID="ddlJumpToPageBottom" runat="server" AutoPostBack="True" OnSelectedIndexChanged="ddlJumpToPage_SelectedIndexChanged">
                </asp:DropDownList>
            </asp:TableCell></asp:TableRow>
    </asp:Table>
</asp:Panel>
<p>
    <asp:HyperLink Visible="False" ID="hlReturn" CssClass="Normal" runat="server">Return to OP Home</asp:HyperLink></p>
<%// MemberDisplay%>
<asp:Panel ID="pnlDisplayMember" runat="server" Visible="False"
    CssClass="Normal">
    <br>
    <div class="SCAMemberHeader">
        <div id="divEditMember" runat="server" class="SCAEditMember">
            <asp:HyperLink ID="hlEditMember" runat="server">
                <asp:Image runat="server" ID="imgEdit" ImageUrl="~/images/edit.gif" />
            </asp:HyperLink></div>
        <div class="SCAMemberArms">
            <h1 id="h1MemberName" runat="server" class="SCAMemberName">
                Member Name</h1>
            <asp:Label ID="lblEmail" runat="server"></asp:Label><asp:Label ID="lblDeceased" runat="server"
                CssClass="DeceasedText"></asp:Label><strong>Last Known Residence:</strong>
            <asp:HyperLink ID="lnkBranchResidence" runat="server"></asp:HyperLink><br />
            <asp:Image ID="imgMemberArms" runat="server" /><div id="divBlazon" runat="server"
                class="SCAMemberBlazon">
                <div>
                    <strong>Blazon:</strong>
                </div>
                <div id="divBlazonText" runat="server">
                </div>
            </div>
        </div>
        <div align="right" class="SCAMemberRankImage">
            Rank in OP:
            <asp:Literal ID="litRank" runat="server"></asp:Literal><asp:Image ID="imgPersonalPic"
                runat="server" /></div>
        <div id="divAliases" runat="server" class="SCAMemberAliases">
            <asp:DataGrid ID="dgAliases" runat="server" AutoGenerateColumns="False" CssClass="ResultList">
                <Columns>
                    <asp:TemplateColumn HeaderText="Additional Names or Spellings:">
                        <ItemTemplate>
                            <asp:Label ID="lblAlias" runat="server" Text='<%# DataBinder.Eval(Container, "DataItem.SCAName") %>'>
                            </asp:Label><asp:Literal ID="Literal1" runat="server" Visible='<%# Convert.ToBoolean(DataBinder.Eval(Container, "DataItem.Registered")) %>'>(R)</asp:Literal><asp:Literal
                                ID="Literal2" runat="server" Visible='<%# Convert.ToBoolean(DataBinder.Eval(Container, "DataItem.Preferred")) %>'>(P)</asp:Literal></ItemTemplate>
                    </asp:TemplateColumn>
                </Columns>
            </asp:DataGrid><span class="InstructionNote">(R) indicates the name the person has registered
                with the college of heralds.<br>
                (P) indicates the person&#39;s preferred name/spelling. </span>
        </div>
    </div>
    <h2 class="SCAMemberAwardsHeader">
        Awards Received</h2>
    <asp:HyperLink ID="hlRecommend" runat="server" CssClass="RecommendLink">Recommend this person for an award.</asp:HyperLink><div
        class="break">
    </div>
    <asp:Literal ID="litNoAwards" runat="server" Visible="false">No Awards Recorded.<br /></asp:Literal>
    <asp:Panel ID="pnlAwards" runat="server" Visible="true">
        <asp:DataGrid ID="dgAwards" runat="server" AutoGenerateColumns="False" EnableViewState="false"
            CssClass="ResultList">
            <Columns>
                <asp:TemplateColumn HeaderText="Award Name">
                    <ItemTemplate>
                        <asp:HyperLink ID="hlAward" runat="server" NavigateUrl='<%# DataBinder.Eval(Container, "DataItem.AwardId") %>'
                            Text='<%# DataBinder.Eval(Container, "DataItem.AwardName") %>'>
                        </asp:HyperLink><asp:Literal runat="server" Visible='<%# Convert.ToBoolean(DataBinder.Eval(Container, "DataItem.Retired")) %>'>(Retired)</asp:Literal></ItemTemplate>
                </asp:TemplateColumn>
                <asp:HyperLinkColumn DataNavigateUrlField="GroupId" DataTextField="GroupName" HeaderText="Group Name">
                </asp:HyperLinkColumn>
                <asp:BoundColumn DataField="Date" DataFormatString="{0:d}" HeaderText="Date"></asp:BoundColumn>
                <asp:HyperLinkColumn DataNavigateUrlField="CrownId" DataTextField="AwardedBy" HeaderText="Given By">
                </asp:HyperLinkColumn>
                <asp:BoundColumn DataField="NameOnScroll" HeaderText="Name on Scroll"></asp:BoundColumn>
                <asp:BoundColumn DataField="Notes" HeaderText="Notes"></asp:BoundColumn>
            </Columns>
        </asp:DataGrid></asp:Panel>
    <asp:Panel ID="pnlHonorary" runat="server">
        <h2 class="SCAMemberAwardsHeader">
            Honorary Titles</h2>
        <div class="break">
            <asp:Literal ID="litNoHonorary" runat="server" Visible="false">No Titles Recorded.<br /></asp:Literal></div>
        <asp:Panel ID="pnlHonoraryTitles" runat="server" Visible="true">
            <asp:DataGrid ID="dgHonorary" runat="server" AutoGenerateColumns="False" CssClass="ResultList"
                EnableViewState="false">
                <Columns>
                    <asp:TemplateColumn HeaderText="Award Name">
                        <ItemTemplate>
                            <asp:HyperLink ID="hlAward" runat="server" NavigateUrl='<%# DataBinder.Eval(Container, "DataItem.AwardId") %>'
                                Text='<%# DataBinder.Eval(Container, "DataItem.AwardName") %>'>
                            </asp:HyperLink><asp:Literal ID="Literal5" runat="server" Visible='<%# Convert.ToBoolean(DataBinder.Eval(Container, "DataItem.Retired")) %>'>(Retired)</asp:Literal></ItemTemplate>
                    </asp:TemplateColumn>
                    <asp:HyperLinkColumn DataNavigateUrlField="GroupId" DataTextField="GroupName" HeaderText="Group Name">
                    </asp:HyperLinkColumn>
                    <asp:BoundColumn DataField="Date" DataFormatString="{0:d}" HeaderText="Date"></asp:BoundColumn>
                    <asp:HyperLinkColumn DataNavigateUrlField="CrownId" DataTextField="AwardedBy" HeaderText="Given By">
                    </asp:HyperLinkColumn>
                    <asp:BoundColumn DataField="NameOnScroll" HeaderText="Name on Scroll"></asp:BoundColumn>
                    <asp:BoundColumn DataField="Notes" HeaderText="Notes"></asp:BoundColumn>
                </Columns>
            </asp:DataGrid></asp:Panel>
    </asp:Panel>
    <h2>
        Offices and Other Positions Held</h2>
    <asp:Literal ID="litNoOffices" runat="server" Visible="false">No Offices Recorded.<br /></asp:Literal><%// Literal (unverified in itemtemplate) below is purposely always false. %><asp:Panel
        ID="pnlOffices" runat="server" Visible="true">
        <asp:GridView ID="gvOffices" runat="server" AutoGenerateColumns="False" CssClass="ResultList"
            EnableViewState="False">
            <Columns>
                <asp:BoundField DataField="PositionType" HeaderText="Position Type" />
                <asp:TemplateField HeaderText="Office">
                    <ItemTemplate>
                        <asp:Literal ID="Literal3" runat="server" Visible='<%# Convert.ToBoolean(DataBinder.Eval(Container, "DataItem.Acting")) %>'>ACTING </asp:Literal><asp:Label
                            ID="lblTitle" runat="server" Text='<%# DataBinder.Eval(Container, "DataItem.Title") %>'>
                        </asp:Label><asp:PlaceHolder ID="PlaceHolder1" runat="server" Visible='<%# (Convert.ToBoolean(DataBinder.Eval(Container, "DataItem.LinkedToCrown"))) %>'>
                            for
                            <asp:HyperLink ID="hlCrown" runat="server" NavigateUrl='<%# DotNetNuke.Common.Globals.NavigateURL(TabId, "", "cid=" + DataBinder.Eval(Container, "DataItem.LinkedCrownId")) %>'
                                Text='<%# DataBinder.Eval(Container, "DataItem.LinkedCrownDisplay") %>'></asp:HyperLink></asp:PlaceHolder>
                        <asp:Literal ID="Literal4" runat="server" Visible='<%# (! Convert.ToBoolean(DataBinder.Eval(Container, "DataItem.Verified"))) && false %>'><br>(unverified)</asp:Literal><asp:Literal
                            ID="Literal6" runat="server" Visible='<%# ! string.IsNullOrEmpty( DataBinder.Eval(Container, "DataItem.PositionSubTitle").ToString().Trim()) %>'>
					<br /></asp:Literal><asp:Label ID="Label1" runat="server" Text='<%# DataBinder.Eval(Container, "DataItem.PositionSubTitle") %>'></asp:Label><br />
                        <asp:Label ID="lblOfficeEmail" runat="server"></asp:Label><asp:Literal ID="Literal7"
                            runat="server" Visible='<%# ! string.IsNullOrEmpty( DataBinder.Eval(Container, "DataItem.PositionNotes").ToString()) %>'>
					<br /><strong>Notes:</strong></asp:Literal><asp:Label ID="Label2" runat="server"
                        Text='<%# DataBinder.Eval(Container, "DataItem.PositionNotes") %>'></asp:Label></ItemTemplate>
                </asp:TemplateField>
                <asp:TemplateField HeaderText="Group">
                    <ItemTemplate>
                        <asp:HyperLink ID="hlGroup" runat="server" NavigateUrl='<%#  DotNetNuke.Common.Globals.NavigateURL(TabId, "", "gid=" + Eval("GroupId")) %>'
                            Text='<%# Eval("GroupName") %>'></asp:HyperLink></ItemTemplate>
                </asp:TemplateField>
                <asp:BoundField DataField="Startdate" DataFormatString="{0:d}" HeaderText="Start Date" />
                <asp:TemplateField HeaderText="End Date">
                    <ItemTemplate>
                        <asp:Label ID="Label3" runat="server" Text='<%# FormatEndDate( DataBinder.Eval(Container, "DataItem.EndDate"), DataBinder.Eval(Container, "DataItem.CurrentlyHeld")) %>'>
                        </asp:Label></ItemTemplate>
                </asp:TemplateField>
            </Columns>
        </asp:GridView>
        <span class="InstructionNote">Offices marked (unverified) cannot be used for purposes
            of entering a crown list without further verification.</span><br></br>
    </asp:Panel>
    <br />
    <a href='http://atensubmissions.nexiliscom.com/cgi-bin/heraldry/OandA/oanda_np.cgi?b=broad&amp;p=<%=Server.UrlEncode("^" + GetRegisteredName() + "$")%>'
        target="armorial">Search SCA Armorial for
        <%=h1MemberName.InnerText%></a><br />
    <span class="InstructionNote">If this link doesn&#39;t return any results and you find
        this person under a different name, Please notify
        <%=HtmlUtils.FormatEmail("abacus@atenveldt.org")%>or
        <%=HtmlUtils.FormatEmail("webmin@atenveldt.org")%></span><br>
    <br />
    Do another search:<br />
    <asp:PlaceHolder ID="phSearchSpot" runat="server"></asp:PlaceHolder>
</asp:Panel>
<%// AwardDisplay%>
<asp:Panel ID="pnlDisplayAward" runat="server" Visible="False" CssClass="Normal">
    <table border="0" cellpadding="3" cellspacing="3" width="100%">
        <tr>
            <td id="tdEditAward" runat="server" valign="top" visible="false">
                <asp:HyperLink ID="hlEditAward" runat="server">
                    <asp:Image runat="server" ID="imgEditAward" ImageUrl="~/images/edit.gif" />
                </asp:HyperLink>
            </td>
            <td>
                <h1 id="H1AwardName" runat="server" class="MemberName">
                    Award Name</h1>
                <asp:Panel ID="pnlAwardIncludeList" runat="server" Visible="False">
                    <asp:DataGrid ID="dgIncludedAwards" runat="server" AutoGenerateColumns="False" CssClass="ResultList">
                        <Columns>
                        </Columns>
                    </asp:DataGrid></asp:Panel>
                <asp:Panel ID="pnlOtherKingdomAwards" runat="server" Visible="False">
                    <p>
                        This award is known across multiple Kingdoms. To see people awarded this award in
                        another kingdom, select a Kingdom below or you may see the awardees from all groups.</p>
                    <asp:DataGrid ID="dgAwardsSameName" runat="server" AutoGenerateColumns="False" CssClass="ResultList"
                        ShowFooter="True">
                        <Columns>
                            <asp:TemplateColumn HeaderText="Award Name">
                                <ItemTemplate>
                                    <asp:HyperLink ID="hlAwardGroups" runat="server" NavigateUrl='<%# DataBinder.Eval(Container, "DataItem.AwardId") %>'
                                        Text='<%# DataBinder.Eval(Container, "DataItem.GroupName") %>'>
                                    </asp:HyperLink>(<%#DataBinder.Eval(Container, "DataItem.AwardeeCount")%><asp:Literal
                                        ID="singlePerson" runat="server" Visible='<%# Convert.ToInt32(DataBinder.Eval(Container, "DataItem.AwardeeCount"))==1 %>'> person </asp:Literal><asp:Literal
                                            ID="pluralPeople" runat="server" Visible='<%# Convert.ToInt32(DataBinder.Eval(Container, "DataItem.AwardeeCount"))>1 %>'> people </asp:Literal>with
                                    this award)</ItemTemplate>
                                <FooterTemplate>
                                    <asp:HyperLink ID="hlAllGroups" runat="server" Text="See Awardees from All groups" /></FooterTemplate>
                            </asp:TemplateColumn>
                        </Columns>
                    </asp:DataGrid></asp:Panel>
                <asp:Panel ID="pnlAwardGroupMember" runat="server" Visible="False">
                    <div>
                        Belongs to
                        <asp:HyperLink ID="hlAwardGroup" runat="server"></asp:HyperLink></div>
                </asp:Panel>
                <h2 id="H2GroupName" runat="server">
                    Group Name</h2>
                <asp:Literal ID="litAwardClosed" runat="server">(Award Closed)</asp:Literal><asp:Literal
                    ID="litHonoraryAward" runat="server">(This is an honorary title.)</asp:Literal>
            </td>
        </tr>
    </table>
    <table cellspacing="0" cellpadding="0" border="0">
        <tr>
            <td valign="top">
                <asp:Image ID="imgAwardBadge" runat="server"></asp:Image>
            </td>
            <td id="tdAwardBlazon" valign="top" runat="server">
                Blazon:<br>
                <div id="divAwardBlazon" runat="server">
                </div>
            </td>
        </tr>
    </table>
    <h2 id="H2AwardCharter" runat="server">
        Award Charter</h2>
    <div id="divCharter" runat="server">
    </div>
    <h2>
        <asp:Literal ID="litMemberCount" runat="server"></asp:Literal>People with this Award</h2>
    <asp:DataGrid ID="dgAwardMembers" runat="server" Visible="true" AutoGenerateColumns="False"
        CssClass="ResultList" PageSize="50" AllowPaging="True">
        <Columns>
            <asp:TemplateColumn HeaderText="SCA Name">
                <ItemTemplate>
                    <asp:HyperLink runat="server" ID="hlMember" Text='<%# DataBinder.Eval(Container, "DataItem.SCAName") %>'
                        NavigateUrl='<%# DataBinder.Eval(Container, "DataItem.PeopleId") %>'>
                    </asp:HyperLink><asp:Literal runat="server" Visible='<%# Convert.ToBoolean(DataBinder.Eval(Container, "DataItem.Retired")) %>'>(Retired)</asp:Literal></ItemTemplate>
            </asp:TemplateColumn>
            <asp:TemplateColumn HeaderText="Award Name" Visible="False">
                <ItemTemplate>
                    <asp:HyperLink runat="server" ID="hlAwardName" Text='<%# DataBinder.Eval(Container, "DataItem.AwardName") %>'
                        NavigateUrl='<%# DataBinder.Eval(Container, "DataItem.AwardId") %>' />
                </ItemTemplate>
            </asp:TemplateColumn>
            <asp:BoundColumn DataField="Date" HeaderText="Date" DataFormatString="{0:d}"></asp:BoundColumn>
            <asp:BoundColumn HeaderText="Group" DataField="GroupName" Visible="False"></asp:BoundColumn>
            <asp:HyperLinkColumn DataNavigateUrlField="CrownId" DataTextField="AwardedBy" HeaderText="Given By">
            </asp:HyperLinkColumn>
            <asp:BoundColumn DataField="NameOnScroll" HeaderText="Name on Scroll"></asp:BoundColumn>
            <asp:BoundColumn DataField="Notes" HeaderText="Notes"></asp:BoundColumn>
        </Columns>
        <PagerStyle Position="TopAndBottom" Mode="NumericPages"></PagerStyle>
    </asp:DataGrid>
</asp:Panel>
<asp:Panel ID="pnlCrown" runat="server" Visible="False">
    <sca:CrownDisplay ID="scaCrownDisplay" runat="server"></sca:CrownDisplay>
</asp:Panel>
<asp:Panel ID="pnlGroup" runat="server" Visible="False">
    <sca:GroupDisplay ID="scaGroupDisplay" runat="server"></sca:GroupDisplay>
</asp:Panel>
