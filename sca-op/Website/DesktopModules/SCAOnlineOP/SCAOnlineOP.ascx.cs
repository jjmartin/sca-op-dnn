using System;
using System.Collections;
using System.Collections.Generic;
using System.Data;
using System.Data.Objects;
using System.IO;
using System.Text.RegularExpressions;
using System.Web.UI;
using System.Web.UI.HtmlControls;
using System.Web.UI.WebControls;
using DotNetNuke.Common.Utilities;
using DotNetNuke.Entities.Modules;
using DotNetNuke.Entities.Modules.Actions;
using DotNetNuke.Entities.Portals;
using DotNetNuke.Framework;
using DotNetNuke.Security;
using DotNetNuke.Services.Exceptions;
using DotNetNuke.Services.Search;
using DotNetNuke.UI.Utilities;
using JeffMartin.DNN.Modules.SCAOnlineOP.Data;
using JeffMartin.ScaData;
using DataCache = DotNetNuke.Common.Utilities.DataCache;
using Globals = DotNetNuke.Common.Globals;
using System.Web;
using System.Collections.Specialized;
using System.Text;


namespace JeffMartin.DNN.Modules.SCAOnlineOP
{
    partial class SCAOnlineOP : PortalModuleBase, IActionable, IPortable, ISearchable
    {
        private string BasePortalHttpAddress;
        private PortalInfo BasePortalInfo;
        protected bool isMobile = false;

        ScaData.ScaOpEntities context;

        Dictionary<String, int> gvOfficesColumnsByHeader = new Dictionary<string, int>();


        NameValueCollection _newQueryString;

        public NameValueCollection newQueryString
        {
            get
            {
                if (_newQueryString == null)
                {

                    _newQueryString = HttpUtility.ParseQueryString(Request.Url.Query, Encoding.Default);
                }
                return _newQueryString;
            }

        }

        private PagedDataSource pdsPhotoDevice = new PagedDataSource();

        protected override void OnInit(EventArgs e)
        {
            base.OnInit(e);

            GenerateAlphaButtons();
            hlReturn.NavigateUrl = Globals.NavigateURL();
            dgResultList.PageIndexChanged += new DataGridPageChangedEventHandler(dgResultList_PageIndexChanged);


            ddlGroupFilter.SelectedIndexChanged += new EventHandler(ddlGroupFilter_SelectedIndexChanged);
            btnSearchOP.Click += new EventHandler(btnSearchOP_Click);
            if (btnSearchByDate != null)
                btnSearchByDate.Click += new EventHandler(btnSearchByDate_Click);

            dgResultList.ItemDataBound += new DataGridItemEventHandler(dgResultList_ItemDataBound);
            rptResultList.ItemDataBound += new RepeaterItemEventHandler(rptResultList_ItemDataBound);

            this.dgAwards.ItemDataBound += new DataGridItemEventHandler(Awards_ItemDataBound);
            this.dgHonorary.ItemDataBound += new DataGridItemEventHandler(Awards_ItemDataBound);
            //TODO: move these events to the design layer.

            if (gvOffices != null)// null when mobile page is loading
            {
                gvOffices.RowDataBound += new GridViewRowEventHandler(gvOffices_RowDataBound);
                gvOffices.RowCreated += new GridViewRowEventHandler(gvOffices_RowCreated);
            }
            dgAwardMembers.ItemDataBound += new DataGridItemEventHandler(dgAwardMembers_ItemDataBound);
            dgAwardMembers.PageIndexChanged += new DataGridPageChangedEventHandler(dgAwardMembers_PageIndexChanged);
            scaGroupDisplay.MyModule = this;
            scaCrownDisplay.MyModule = this;


        }




        private void SetupScript()
        {
            //This was an attempt to put some autocomplete into the project but I couldn't get the ready method ever to fire.

            jQuery.RequestRegistration();

            if (!Page.ClientScript.IsClientScriptIncludeRegistered("autocomplete"))
                Page.ClientScript.RegisterClientScriptInclude("autocomplete",
                                                              TemplateSourceDirectory +
                                                              "/resources/jquery/jquery.autocomplete.js");
            string autocompleteScript =
                @"<script type=""text/javascript"">
	
	$(document).ready(function() {
		alert('bing');
		$(""#" +
                txtSearchOP.ClientID + @""").autocomplete('" + TemplateSourceDirectory +
                @"/resources/names.ashx');
	})
</script>";
            ClientAPI.RegisterClientScriptBlock(Page, "autocomplete-op", autocompleteScript);
        }

        #region Page_Load

        private void Page_Load(object sender, EventArgs e)
        {
            try
            {
                SetupBasePortalInfo();
                //Set up Section Headers
                dshAdvancedSearch.MaxImageUrl = TemplateSourceDirectory + "/expand.gif";
                dshAdvancedSearch.MinImageUrl = TemplateSourceDirectory + "/collapse.gif";
                dshQuickSearch.MaxImageUrl = TemplateSourceDirectory + "/expand.gif";
                dshQuickSearch.MinImageUrl = TemplateSourceDirectory + "/collapse.gif";
                dshOtherLists.MaxImageUrl = TemplateSourceDirectory + "/expand.gif";
                dshOtherLists.MinImageUrl = TemplateSourceDirectory + "/collapse.gif";

                CreateStaticLinks();

                string ResultCount;
                int intFilter;
                DataSet ds;
                string filter;



                if (newQueryString["list"] != null)
                {
                    #region Prep Result List

                    rptResultList.Visible = false;
                    dshOtherLists.IsExpanded = false;

                    switch (newQueryString["list"].ToLower())
                    {
                        case "charters":

                            #region Award List

                            if (!IsPostBack)
                            {
                                BindAwardGroupDdl(false);
                            }
                            if (newQueryString["f"] != null)
                            {
                                filter = newQueryString["f"];
                                if (!IsPostBack)
                                {
                                    if (ddlGroupFilter.Items.FindByValue(filter) != null)
                                        ddlGroupFilter.SelectedValue = filter;
                                    else
                                    {
                                        filter = "26";
                                        ddlGroupFilter.SelectedValue = filter;
                                    }
                                }
                                filter = ddlGroupFilter.SelectedValue;
                            }
                            else
                            {
                                if (!IsPostBack)
                                {
                                    filter = "26";
                                    ddlGroupFilter.SelectedValue = filter;
                                }
                                filter = ddlGroupFilter.SelectedValue;
                            }

                            ds =
                                DataProvider.ConvertDataReaderToDataSet(
                                    DataProvider.Instance().GetAwardsByGroups(
                                        filter.Replace('-', ',').Replace("all", "*")));
                            ResultCount = ds.Tables[0].Rows.Count.ToString();
                            DataColumn dc =
                                new DataColumn("AwardQueryString", typeof(string),
                                               "AwardType + '/' + Convert(AwardId, System.String)");
                            ds.Tables[0].Columns.Add(dc);
                            dgResultList.DataSource = ds;
                            if (isMobile)
                                SetDataGridColumns("AwardName");
                            else
                            {
                                SetDataGridColumns("Group", "AwardName");
                            }

                            litGroupFilterText.Text = "View awards from other SCA Branches (may not be complete)";
                            tcListGroups.Visible = true;
                            tcGridContainer.ColumnSpan = 3;
                            tcListTitle.ColumnSpan = 3;
                            tcListTitle.Text = "List of Awards for " + ddlGroupFilter.SelectedItem.Text;
                            ((CDefault)Page).Title += "- " + tcListTitle.Text;

                            #endregion

                            break;
                        case "crown":

                            #region Crown List

                            intFilter = 26;
                            if (newQueryString["f"] != null)
                            {
                                try
                                {
                                    intFilter = Convert.ToInt32(newQueryString["f"]);
                                }
                                catch
                                {
                                }
                            }

                            DataTable crownDt = DataProvider.Instance().GetCrownsByGroups(intFilter);
                            DataView dv = new DataView(crownDt);
                            if (!IsEditable)
                            {
                                dv.RowFilter = "heir=false";
                            }
                            dgResultList.DataSource = dv;
                            ResultCount = dv.Count.ToString();
                            SetDataGridColumns("Reign", "Rulers", "DateRange");

                            tcListGroups.Visible = true;
                            tcGridContainer.ColumnSpan = 3;
                            tcListTitle.ColumnSpan = 3;
                            if (!IsPostBack)
                            {
                                BindCrownGroupDdl();
                                ddlGroupFilter.SelectedValue = intFilter.ToString();
                                tcListTitle.Text = "List of Reigns for " + ddlGroupFilter.SelectedItem.Text;
                                ((CDefault)Page).Title += "- " + tcListTitle.Text;
                            }

                            #endregion

                            break;
                        case "group":

                            #region Group List

                            if (!IsPostBack)
                            {
                                BindGroupGroupDdl(true);
                            }

                            if (newQueryString["f"] != null)
                            {
                                filter = newQueryString["f"];
                                if (!IsPostBack)
                                {
                                    if (ddlGroupFilter.Items.FindByValue(filter) != null)
                                        ddlGroupFilter.SelectedValue = filter;
                                }
                                filter = ddlGroupFilter.SelectedValue;
                            }
                            else
                            {
                                filter = ddlGroupFilter.SelectedValue;
                            }

                            ds =
                                DataProvider.ConvertDataReaderToDataSet(
                                    DataProvider.Instance().ListGroupsByGroupsGroup(filter));
                            ResultCount = ds.Tables[0].Rows.Count.ToString();
                            dgResultList.DataSource = ds;
                            SetDataGridColumns("Group", "Location", "WebSite");
                            litGroupFilterText.Text = "View Groups in other SCA Kingdoms (may not be complete)";
                            tcListGroups.Visible = true;
                            tcGridContainer.ColumnSpan = 3;
                            tcListTitle.ColumnSpan = 3;


                            tcListTitle.Text = "List of Groups";
                            ((CDefault)Page).Title += "- " + tcListTitle.Text;

                            #endregion

                            break;

                        case "abd": //award by date

                            #region Award by Date List

                            int filterMonth = 0;
                            int filterYear = 0;
                            if (newQueryString["f"] != null)
                            {
                                filter = newQueryString["f"];
                                filterMonth = Convert.ToInt32(filter.Split('-')[0]);
                                filterYear = Convert.ToInt32(filter.Split('-')[1]);

                                if (!IsPostBack)
                                {
                                    if (ddlMonth.Items.FindByValue(filterMonth.ToString()) != null)
                                        ddlMonth.SelectedValue = filterMonth.ToString();
                                    if (ddlYear.Items.FindByValue(filterYear.ToString()) != null)
                                        ddlYear.SelectedValue = filterYear.ToString();
                                }
                            }
                            else
                            {
                                filterMonth = Convert.ToInt32(ddlMonth.SelectedValue);
                                filterYear = Convert.ToInt32(ddlYear.SelectedValue);
                            }

                            ds =
                                DataProvider.ConvertDataReaderToDataSet(
                                    DataProvider.Instance().GetPeopleAwardByTime(Null.NullInteger,
                                                                                 new DateTime(filterYear, filterMonth, 1),
                                                                                 (new DateTime(filterYear, filterMonth,
                                                                                               1)).AddMonths(1)));
                            ResultCount = ds.Tables[0].Rows.Count.ToString();
                            dc =
                                new DataColumn("AwardQueryString", typeof(string),
                                               "AwardType + '/' + Convert(AwardId, System.String)");
                            ds.Tables[0].Columns.Add(dc);
                            dgResultList.DataSource = ds;
                            SetDataGridColumns("Date", "SCAName", "AwardName", "Group");
                            tcGridContainer.ColumnSpan = 4;
                            tcListTitle.ColumnSpan = 4;

                            litGroupFilterText.Visible = false;
                            tcListGroups.Visible = false;


                            tcListTitle.Text = "View Awards given by date.  Month of " + ddlMonth.SelectedItem.Text +
                                               ", " + ddlYear.SelectedValue;
                            ((CDefault)Page).Title += "- " + tcListTitle.Text;

                            #endregion

                            break;

                        case "oh": //officer history

                            #region Award by Date List

                            if (newQueryString["f"] != null)
                            {
                                filter = newQueryString["f"];
                            }
                            else
                            {
                                filter = "1";
                            }


                            ds =
                                DataProvider.ConvertDataReaderToDataSet(
                                    DataProvider.Instance().GetPeopleOfficerByOfficerPosition(Convert.ToInt32(filter)));
                            ResultCount = ds.Tables[0].Rows.Count.ToString();

                            dgResultList.DataSource = ds;
                            SetDataGridColumns("SCAName", "PositionSubTitle", "OfficeStart", "OfficeEnd");
                            tcGridContainer.ColumnSpan = 4;
                            tcListTitle.ColumnSpan = 4;

                            litGroupFilterText.Visible = false;
                            tcListGroups.Visible = false;

                            string OfficeName = "";
                            if (Convert.ToInt32(ResultCount) > 0)
                                OfficeName = ds.Tables[0].Rows[0]["Title"].ToString();

                            tcListTitle.Text = "View history of office: " + OfficeName;
                            ((CDefault)Page).Title += "- " + tcListTitle.Text;

                            #endregion

                            break;

                        default: //alpha

                            #region People List

                            // this needs to load on postback so paging will work.
                            // is enable viewstate broken?
                            filter = "%";
                            string filterType = "b";
                            if (!string.IsNullOrEmpty(newQueryString["f"]))
                            {
                                filter = newQueryString["f"];
                                if (filter.Trim() == string.Empty) filter = "%";
                                if (!IsPostBack)
                                {
                                    txtSearchOP.Text = newQueryString["f"];
                                    dshAdvancedSearch.IsExpanded = true;
                                    dshQuickSearch.IsExpanded = false;
                                    dshOtherLists.IsExpanded = false;
                                }
                            }
                            string filterField = "n";
                            if (!string.IsNullOrEmpty(newQueryString["ff"]) && !IsPostBack)
                            {
                                filterField = newQueryString["ff"].ToLower();
                                if (filterField.Trim() == string.Empty) filterField = "n";
                                rblSearchField.SelectedValue = filterField;
                            }

                            string orderBy = "a";
                            if (!string.IsNullOrEmpty(newQueryString["o"]) && !IsPostBack)
                            {
                                orderBy = newQueryString["o"].ToLower();
                                if (orderBy.Trim() == string.Empty) orderBy = "a";
                                rblOrderBy.SelectedValue = orderBy;
                            }

                            bool showPhotos = false;
                            if (!string.IsNullOrEmpty(newQueryString["dp"]) && !IsPostBack)
                                chkShowPhotos.Checked = showPhotos = newQueryString["dp"] == "1";

                            bool showDevices = false;
                            if (!string.IsNullOrEmpty(newQueryString["dd"]) && !IsPostBack)
                                chkShowDevices.Checked = showDevices = newQueryString["dd"] == "1";

                            bool showResidence = false;
                            if (!string.IsNullOrEmpty(newQueryString["drr"]) && !IsPostBack)
                                chkShowResidence.Checked = showResidence = newQueryString["drr"] == "1";

                            bool limitPhotos = false;
                            if (!string.IsNullOrEmpty(newQueryString["lp"]) && !IsPostBack)
                                chkIncludeOnlyPhotos.Checked = limitPhotos = newQueryString["lp"] == "1";

                            bool limitDevices = false;
                            if (!string.IsNullOrEmpty(newQueryString["ld"]) && !IsPostBack)
                                chkIncludeOnlyDevices.Checked = limitDevices = newQueryString["ld"] == "1";

                            bool includeAliases = true;
                            if (!string.IsNullOrEmpty(newQueryString["da"]) && !IsPostBack)
                                chkShowAliases.Checked = includeAliases = newQueryString["da"] == "1";

                            bool limitDeceased = false;
                            bool limitLiving = false;
                            if (!string.IsNullOrEmpty(newQueryString["dc"]) && !IsPostBack)
                            {
                                limitDeceased = newQueryString["dc"] == "1";
                                chkIncludeLivingStatus.Checked = limitDeceased;
                                rblLivingStatus.SelectedValue = limitDeceased ? "D" : "A";
                            }


                            if (!string.IsNullOrEmpty(newQueryString["dl"]) && !IsPostBack)
                            {
                                limitLiving = newQueryString["dl"] == "1";
                                chkIncludeLivingStatus.Checked = (limitLiving || limitDeceased);
                                rblLivingStatus.SelectedValue = limitLiving ? "A" : "D";
                            }


                            bool limitResident = false;
                            bool limitNonResident = false;
                            if (!string.IsNullOrEmpty(newQueryString["dr"]) && !IsPostBack)
                            {
                                limitResident = newQueryString["dr"] == "1";
                                chkIncludeResidentStatus.Checked = limitResident;
                                rblResidentStatus.SelectedValue = limitResident ? "I" : "O";
                            }


                            if (!string.IsNullOrEmpty(newQueryString["dnr"]) && !IsPostBack)
                            {
                                limitNonResident = newQueryString["dnr"] == "1";
                                rblResidentStatus.SelectedValue = limitNonResident ? "O" : "I";
                                chkIncludeResidentStatus.Checked = (limitNonResident || limitResident);
                            }


                            if (!string.IsNullOrEmpty(newQueryString["st"]))
                                filterType = newQueryString["st"].ToLower();

                            if (filterType == "c" && !IsPostBack)
                            {
                                filter = "%" + filter + "%";
                                rblFilterType.SelectedValue = "c";
                            }
                            else
                                filter += "%";

                            try
                            {
                                IDataReader dr =
                                    DataProvider.Instance().ListPeople(filter, filterField, orderBy, limitPhotos,
                                                                       limitDevices, includeAliases, limitDeceased,
                                                                       limitLiving, 26, limitResident,
                                                                       limitNonResident);
                                ds = DataProvider.ConvertDataReaderToDataSet(dr);
                            }
                            catch (Exception exc)
                            {
                                Exceptions.ProcessModuleLoadException(
                                    "An error occured attempting a search of the OP.  This could be a timeout, please narrow your search and try again.",
                                    this, exc);
                                return;
                            }

                            ResultCount = ds.Tables[0].Rows.Count.ToString();
                            if (ds.Tables[0].Rows.Count == 1)
                            {
                                Response.Redirect(
                                    string.Format(
                                        Globals.NavigateURL(TabId, "", "memid=" + int.MaxValue).Replace(
                                            int.MaxValue.ToString(), "{0}"),
                                        ds.Tables[0].Rows[0]["PeopleId"]),
                                    true);
                                return;
                            }
                            if (showDevices || showPhotos)
                            {
                                dgResultList.Visible = false;
                                rptResultList.Visible = true;

                                pdsPhotoDevice.DataSource = ds.Tables[0].DefaultView;
                            }
                            else
                            {
                                rptResultList.Visible = false;
                                dgResultList.Visible = true;
                                dgResultList.DataSource = ds;
                                if (orderBy == "p")
                                    if (showResidence)
                                        SetDataGridColumns("rank", "highestawardname", "highestawarddate", "SCAName",
                                                           "BranchResidence");
                                    else
                                        SetDataGridColumns("rank", "highestawardname", "highestawarddate", "SCAName");
                                else if (showResidence)
                                    SetDataGridColumns("SCAName", "BranchResidence");
                                else
                                    SetDataGridColumns("SCAName");
                            }
                            tcListTitle.Text = "Listing People ";
                            if (limitDeceased)
                                tcListTitle.Text = tcListTitle.Text.Replace("People", "Memorial Rolls");
                            if (filter.Replace("%", "") != string.Empty)
                            {
                                tcListTitle.Text += " with ";
                                if (filterField == "n")
                                    tcListTitle.Text += " Names ";
                                else
                                    tcListTitle.Text += " Blazons ";
                                tcListTitle.Text += (filterType == "c" ? "containing '" : "beginning with '");
                                tcListTitle.Text += filter.Replace("%", "") + "'";
                            }
                            tcListTitle.Text += " <br />";
                            if (includeAliases)
                                tcListTitle.Text += " (including aliases) ";
                            if (limitPhotos || limitNonResident || limitLiving || limitDevices || limitResident)
                                tcListTitle.Text += " (only those";
                            if (limitPhotos)
                                tcListTitle.Text += " with photos,";
                            if (limitDevices)
                                tcListTitle.Text += " with devices,";
                            if (limitLiving)
                                tcListTitle.Text += " who are living,";
                            if (limitNonResident)
                                tcListTitle.Text += " who are out of kingdom,";
                            if (limitResident)
                                tcListTitle.Text += " who are in kingdom,";
                            if (limitPhotos || limitNonResident || limitLiving || limitDevices || limitResident)
                            {
                                tcListTitle.Text = tcListTitle.Text.Remove(tcListTitle.Text.LastIndexOf(','));
                                if (tcListTitle.Text.Contains(","))
                                    tcListTitle.Text =
                                        tcListTitle.Text.Substring(0, tcListTitle.Text.LastIndexOf(',')) + " and " +
                                        tcListTitle.Text.Substring(tcListTitle.Text.LastIndexOf(',') + 1);
                                tcListTitle.Text += ")<br />";
                            }
                            string Showing = string.Empty;
                            if (showPhotos || showDevices || showResidence)
                                Showing += " showing ";
                            if (showPhotos)
                                Showing += " pictures,";
                            if (showDevices)
                                Showing += " devices,";
                            if (showResidence)
                                Showing += " residence,";
                            if (showPhotos || showDevices || showResidence)
                            {
                                Showing = Showing.Remove(Showing.LastIndexOf(','));
                                if (Showing.Contains(","))
                                    Showing =
                                        Showing.Substring(0, Showing.LastIndexOf(',')) + " and " +
                                        Showing.Substring(Showing.LastIndexOf(',') + 1);
                                Showing += "<br />";
                            }
                            tcListTitle.Text += Showing;


                            switch (orderBy)
                            {
                                case "a":
                                    if (filterField == "n")
                                        tcListTitle.Text += " Ordered by Name.";
                                    else
                                        tcListTitle.Text += " Ordered by Blazon.";
                                    break;
                                case "n":
                                    tcListTitle.Text += " ordered by Name.";
                                    break;
                                case "b":
                                    tcListTitle.Text += " ordered by Blazon.";
                                    break;
                                case "p":
                                    tcListTitle.Text += " ordered by Precedence.";
                                    break;
                            }


                            ((CDefault)Page).Title += "- " + tcListTitle.Text.Replace("<br />", "");

                            #endregion

                            break;
                    }

                    #endregion

                    #region Bind Result List and Pages

                    tcListTitle.Text += "<br>(" + ResultCount + " total results.)";
                    if (newQueryString["ps"] != null && !IsPostBack)
                    {
                        try
                        {
                            if (ddlResultsPerPage.Items.FindByValue(newQueryString["ps"]) != null)
                            {
                                ddlResultsPerPage.SelectedValue = newQueryString["ps"];
                                ddlResultsPerPageBottom.SelectedValue = newQueryString["ps"];
                            }
                        }
                        catch
                        {
                        }
                        try
                        {
                            if (ddlSearchResultsPerPage.Items.FindByValue(newQueryString["ps"]) != null)
                            {
                                ddlSearchResultsPerPage.SelectedValue = newQueryString["ps"];
                            }
                        }
                        catch
                        {
                        }
                    }

                    if (newQueryString["pg"] != null && !IsPostBack)
                    {
                        try
                        {
                            dgResultList.CurrentPageIndex = int.Parse(newQueryString["pg"]);
                            pdsPhotoDevice.CurrentPageIndex = int.Parse(newQueryString["pg"]);
                            if ((int.Parse(ResultCount) / int.Parse(ddlResultsPerPage.SelectedValue)
                                 + ((int.Parse(ResultCount) % int.Parse(ddlResultsPerPage.SelectedValue) == 0) ? 0 : 1))
                                < dgResultList.CurrentPageIndex + 1)
                            {
                                dgResultList.CurrentPageIndex = 0;
                                pdsPhotoDevice.CurrentPageIndex = 0;
                            }
                        }
                        catch
                        {
                            dgResultList.CurrentPageIndex = 0;
                            pdsPhotoDevice.CurrentPageIndex = 0;
                        }
                    }
                    if (dgResultList.Visible)
                    {
                        dgResultList.PageSize = int.Parse(ddlResultsPerPage.SelectedValue);

                        dgResultList.DataBind();
                        if (dgResultList.PageCount == 1)
                        {
                            dgResultList.PagerStyle.Visible = false;
                        }
                    }
                    else
                    {
                        pdsPhotoDevice.PageSize = int.Parse(ddlResultsPerPage.SelectedValue);
                        rptResultList.DataSource = pdsPhotoDevice;
                        rptResultList.DataBind();
                    }
                    BindPageJumper(rptResultList.Visible);

                    #endregion
                }
                else
                {
                    pnlResultList.Visible = false;

                    #region Person Display

                    if (newQueryString["memid"] != null)
                    {
                        int memid = 0;
                        try
                        {
                            memid = int.Parse(newQueryString["memid"]);
                        }
                        catch
                        {
                            Response.Redirect(hlReturn.NavigateUrl, true);
                        }
                        pnlOptionList.Visible = false;
                        pnlDisplayMember.Visible = true;
                        hlReturn.Visible = true;
                        DisplayMemberInfo(memid);
                        phSearchSpot.Controls.Add(pnlSearch);
                    }

                    #endregion

                    #region Award Display

                    if (newQueryString["aid"] != null)
                    {
                        int aid = 0;
                        try
                        {
                            aid = int.Parse(newQueryString["aid"]);
                        }
                        catch
                        {
                            Response.Redirect(hlReturn.NavigateUrl, true);
                        }
                        pnlOptionList.Visible = false;
                        pnlDisplayMember.Visible = false;
                        pnlDisplayAward.Visible = true;
                        hlReturn.Visible = true;
                        DisplayAwardInfo(aid);
                    }
                    if (newQueryString["gaid"] != null)
                    {
                        int gaid = 0;
                        try
                        {
                            gaid = int.Parse(newQueryString["gaid"]);
                        }
                        catch
                        {
                            Response.Redirect(hlReturn.NavigateUrl, true);
                        }
                        pnlOptionList.Visible = false;
                        pnlDisplayMember.Visible = false;
                        pnlDisplayAward.Visible = true;
                        hlReturn.Visible = true;
                        DisplayGroupAwardInfo(gaid);
                    }

                    #endregion

                    #region Crown Display

                    if (newQueryString["cid"] != null)
                    {
                        int cid = 0;
                        try
                        {
                            cid = int.Parse(newQueryString["cid"]);
                        }
                        catch
                        {
                            Response.Redirect(hlReturn.NavigateUrl, true);
                        }
                        pnlOptionList.Visible = false;
                        pnlCrown.Visible = true;
                        hlReturn.Visible = false;
                        DisplayCrownInfo(cid);
                    }

                    #endregion

                    #region Group Display

                    if (newQueryString["gid"] != null)
                    {
                        int gid = 0;
                        try
                        {
                            gid = int.Parse(newQueryString["gid"]);
                        }
                        catch
                        {
                            Response.Redirect(hlReturn.NavigateUrl, true);
                        }
                        pnlOptionList.Visible = false;
                        pnlGroup.Visible = true;
                        hlReturn.Visible = true;
                        DisplayGroupInfo(gid);
                    }

                    #endregion
                }
            }
            catch (Exception exc)
            {
                Exceptions.ProcessModuleLoadException(this, exc);
            }
        }

        private void CreateStaticLinks()
        {
            DataTable dt;
            if (!isMobile)
            {
                if (DataCache.GetCache("groupTable") == null)
                {
                    dt = DataProvider.ConvertDataReaderToDataTable(DataProvider.Instance().ListGroupGroups());
                    DataCache.SetCache("groupTable", dt, DateTime.Now.AddMinutes(60));
                }
                else
                {
                    dt = (DataTable)DataCache.GetCache("groupTable");
                }
                BindLinkList(pnlGroupLinks, dt, "gid", true);
            }

            if (DataCache.GetCache("groupAwardTable") == null)
            {
                dt = DataProvider.ConvertDataReaderToDataTable(DataProvider.Instance().ListAwardGroupFilters());
                DataCache.SetCache("groupAwardTable", dt, DateTime.Now.AddMinutes(60));
            }
            else
            {
                dt = (DataTable)DataCache.GetCache("groupAwardTable");
            }
            BindLinkList(pnlAwardCharterLinks, dt, "list=charters", false);

            if (!isMobile)
            {
                if (DataCache.GetCache("groupCrownTable") == null)
                {
                    dt = DataProvider.ConvertDataReaderToDataTable(DataProvider.Instance().ListCrownGroups());
                    DataCache.SetCache("groupCrownTable", dt, DateTime.Now.AddMinutes(60));
                }
                else
                {
                    dt = (DataTable)DataCache.GetCache("groupCrownTable");
                }
                BindLinkList(pnlCrownLinks, dt, "list=crown", false);

                BindYearDDL();

                hlListByPrecedence.NavigateUrl =
                    Globals.NavigateURL(TabId, "", "list=alpha", "o=p", "da=0", "dl=1", "dr=1") +
                    "#results";
                hlRollofArms.NavigateUrl =
                    Globals.NavigateURL(TabId, "", "list=alpha", "o=a", "dd=1", "ld=1", "da=0", "dr=1") +
                    "#results";
                hlRollofPhotos.NavigateUrl =
                    Globals.NavigateURL(TabId, "", "list=alpha", "o=a", "dp=1", "lp=1", "dr=1", "da=0") + "#results";
                hlMemorialRolls.NavigateUrl =
                    Globals.NavigateURL(TabId, "", "list=alpha", "o=a", "dc=1", "da=0", "dp=1") + "#results";
                hlNonResidence.NavigateUrl =
                    Globals.NavigateURL(TabId, "", "list=alpha", "o=a", "dnr=1", "da=0", "drr=1") + "#results";



                pdsPhotoDevice.AllowPaging = true;
            }
        }

        private void BindYearDDL()
        {
            if (!IsPostBack)
            {
                DataTable dt;
                if (DataCache.GetCache("AwardYears") == null)
                {
                    dt = DataProvider.ConvertDataReaderToDataTable(DataProvider.Instance().GetAwardYears());
                    DataCache.SetCache("AwardYears", dt, DateTime.Now.AddMinutes(60));
                }
                else
                {
                    dt = (DataTable)DataCache.GetCache("AwardYears");
                }
                ddlYear.DataSource = dt;
                ddlYear.DataValueField = "Year";
                ddlYear.DataTextField = "Year";
                ddlYear.DataBind();

                ddlMonth.SelectedValue = DateTime.Now.Month.ToString();
            }
        }

        private void SetupBasePortalInfo()
        {
            PortalController pc = new PortalController();
            int basePortalId = Convert.ToInt32(Settings["BasePortal"]);
            if (basePortalId < 0) basePortalId = 0;
            BasePortalInfo = pc.GetPortal(basePortalId);
            if (!BasePortalInfo.HomeDirectory.EndsWith("/"))
                BasePortalInfo.HomeDirectory += "/";
            PortalAliasController pac = new PortalAliasController();
            ArrayList aliases = pac.GetPortalAliasArrayByPortalID(basePortalId);
            BasePortalHttpAddress = Globals.AddHTTP(((PortalAliasInfo)aliases[0]).HTTPAlias);
            if (!BasePortalHttpAddress.EndsWith("/"))
                BasePortalHttpAddress += "/";
        }

        #endregion

        #region GetRegisteredName

        public string GetRegisteredName()
        {
            return DataProvider.Instance().GetRegisteredName(int.Parse(newQueryString["memid"]));
        }

        #endregion

        #region BindAwardGroupDdl

        private void BindAwardGroupDdl(bool OnlyCompositeGroups)
        {
            DataTable dt = DataProvider.ConvertDataReaderToDataTable(DataProvider.Instance().ListAwardGroupFilters());

            ddlGroupFilter.Items.Add(new ListItem(string.Format("All {0} Groups (with Awards)", dt.Rows.Count), "all"));
            string LastParent = string.Empty;
            string childGroupIds = string.Empty;
            int AwardsCount = 0;
            foreach (DataRow row in dt.Rows)
            {
                if (row["lvl1"].ToString() != LastParent)
                {
                    if (LastParent != string.Empty)
                    {
                        childGroupIds = childGroupIds.Remove(childGroupIds.Length - 1, 1);
                        if (childGroupIds.Split('-').Length > 1)
                        {
                            string GroupEntry = LastParent + " and all branches. (" + AwardsCount +
                                                " Awards )";
                            ddlGroupFilter.Items.Add(new ListItem(GroupEntry, childGroupIds));
                            if (LastParent.IndexOf("Atenveldt") > -1)
                            {
                                ddlGroupFilter.SelectedValue = childGroupIds;
                            }
                        }
                    }
                    LastParent = row["lvl1"].ToString();
                    childGroupIds = string.Empty;
                    AwardsCount = 0;
                }
                childGroupIds += row["GroupId"] + "-";

                AwardsCount += Convert.ToInt32(row["AwardCount"]);
                string indent = row["GroupName"].ToString() == row["lvl1"].ToString() ? "" : "...";
                if (!OnlyCompositeGroups)
                {
                    ddlGroupFilter.Items.Add(
                        new ListItem(indent + row["GroupNameAwardCount"], row["GroupId"].ToString()));
                }
            }
        }

        #endregion

        #region BindCharterLinkList

        private void BindLinkList(Panel targetPanel, DataTable dt, string listTarget, bool directLink)
        {
            HtmlGenericControl parentControl = new HtmlGenericControl("div");

            int LastLevel = 1;

            Dictionary<int, string> LastParentGroup = new Dictionary<int, string>();

            foreach (DataRow row in dt.Rows)
            {
                int CurrentLevel = Convert.ToInt32(row["Level"]);
                bool NoParent = false;
                if (CurrentLevel > 1 && LastParentGroup.Count == 0)
                    NoParent = true;
                int ParentLevel = CurrentLevel == 1 ? 1 : (CurrentLevel - 1);
                if (CurrentLevel == 1 || !LastParentGroup.ContainsKey(ParentLevel) ||
                    LastParentGroup[ParentLevel] != row["lvl" + ParentLevel].ToString() ||
                    !LastParentGroup.ContainsKey(CurrentLevel) ||
                    LastParentGroup[CurrentLevel] != row["lvl" + CurrentLevel].ToString()
                    )
                {
                    if (LastLevel != CurrentLevel || CurrentLevel == 1)
                    {
                        if (CurrentLevel == 1 ||
                            (CurrentLevel == 2 && LastParentGroup.Count > ParentLevel && LastParentGroup[ParentLevel] !=
                                                                                         row["lvl" + ParentLevel].
                                                                                             ToString()))
                        {
                            parentControl = new HtmlGenericControl("div");
                            if (Convert.ToInt32(row["GroupId"]) == 26)
                            {
                                targetPanel.Controls.AddAt(0, parentControl);
                            }
                            else
                            {
                                targetPanel.Controls.Add(parentControl);
                            }
                            if (CurrentLevel == 2 && LastParentGroup[ParentLevel] !=
                                                     row["lvl" + ParentLevel].ToString())
                            {
                                AddLinkToUL(parentControl, row["lvl1"].ToString(), Convert.ToInt32(row["GroupId"]),
                                            directLink, listTarget, true);
                                HtmlGenericControl newParentControl = new HtmlGenericControl("ul");
                                parentControl.Controls.Add(newParentControl);
                                parentControl = newParentControl;
                            }
                            LastLevel = CurrentLevel;
                        }
                        else
                        {
                            if (NoParent)
                            {
                                parentControl = new HtmlGenericControl("div");
                                if (Convert.ToInt32(row["GroupId"]) == 26)
                                {
                                    targetPanel.Controls.AddAt(0, parentControl);
                                }
                                else
                                {
                                    targetPanel.Controls.Add(parentControl);
                                }
                                AddLinkToUL(parentControl, row["lvl1"].ToString(), Convert.ToInt32(row["GroupId"]),
                                            directLink, listTarget, true);
                                HtmlGenericControl newParentControl = new HtmlGenericControl("ul");
                                parentControl.Controls.Add(newParentControl);
                                parentControl = newParentControl;
                            }
                            if (CurrentLevel > LastLevel)
                            {
                                HtmlGenericControl newParentControl = new HtmlGenericControl("ul");
                                parentControl.Controls.Add(newParentControl);
                                parentControl = newParentControl;
                            }
                            else
                            {
                                HtmlGenericControl newParentControl = (HtmlGenericControl)parentControl.Parent;
                                parentControl = newParentControl;
                            }
                            LastLevel = CurrentLevel;
                        }
                        LastParentGroup[ParentLevel] =
                            row["lvl" + ParentLevel].ToString();
                    }
                }
                AddLinkToUL(parentControl, row["GroupName"].ToString(), Convert.ToInt32(row["GroupId"]),
                            directLink, listTarget, false);
            }
        }

        private void AddLinkToUL(HtmlGenericControl ParentControl, string GroupName, int GroupId,
                                 bool directLink, string listTarget, bool NoLink)
        {
            HyperLink listLink = new HyperLink();
            listLink.Text = GroupName;
            if (directLink && GroupId != 26 && !NoLink)
                listLink.NavigateUrl = Globals.NavigateURL(TabId, "", listTarget + "=" + GroupId) +
                                       "#results";
            else if (!directLink && !NoLink)
                listLink.NavigateUrl = Globals.NavigateURL(TabId, "", listTarget, "f=" + GroupId) +
                                       "#results";
            if (ParentControl.TagName == "div") ParentControl.Controls.Add((listLink));
            else
            {
                HtmlGenericControl liItem = new HtmlGenericControl("li");
                liItem.Controls.Add(listLink);
                ParentControl.Controls.Add(liItem);
            }
        }

        #endregion

        #region BindCrownGroupDdl

        private void BindCrownGroupDdl()
        {
            DataTable dt = DataProvider.ConvertDataReaderToDataTable(DataProvider.Instance().ListCrownGroups());
            ddlGroupFilter.DataSource = dt;
            ddlGroupFilter.DataTextField = "GroupNameCrownCount";
            ddlGroupFilter.DataValueField = "GroupId";
            ddlGroupFilter.DataBind();
        }

        #endregion

        #region BindGroupGroupDdl

        private void BindGroupGroupDdl(bool OnlyCompositeGroups)
        {
            DataTable dt = DataProvider.ConvertDataReaderToDataTable(DataProvider.Instance().ListGroupGroups());
            ddlGroupFilter.Items.Add(new ListItem(string.Format("All {0} Groups", dt.Rows.Count), "*"));
            string LastParent = string.Empty;
            string childGroupIds = string.Empty;
            foreach (DataRow row in dt.Rows)
            {
                if (row["lvl1"].ToString() != LastParent)
                {
                    if (LastParent != string.Empty)
                    {
                        childGroupIds = childGroupIds.Remove(childGroupIds.Length - 1, 1);
                        if (childGroupIds.Split(',').Length > 1 || OnlyCompositeGroups)
                        {
                            string GroupEntry = LastParent + " and all branches.";
                            ddlGroupFilter.Items.Add(new ListItem(GroupEntry, childGroupIds));
                            if (LastParent.IndexOf("Atenveldt") > -1)
                            {
                                ddlGroupFilter.SelectedValue = childGroupIds;
                            }
                        }
                    }
                    LastParent = row["lvl1"].ToString();
                    childGroupIds = string.Empty;
                }
                childGroupIds += row["GroupId"] + ",";
                if (!OnlyCompositeGroups)
                {
                    ddlGroupFilter.Items.Add(new ListItem(row["Name"].ToString(), row["GroupId"].ToString()));
                }
            }
        }

        #endregion

        #region DisplayMemberInfo

        private void DisplayMemberInfo(int memid)
        {
            IDataReader dr = DataProvider.Instance().GetPeople(memid);
            string Residence = "Unknown";
            //Edit controls
            if (dr.Read())
            {
                if (IsEditable) divEditMember.Visible = true;
                else divEditMember.Visible = false;
                hlEditMember.NavigateUrl = EditUrl("memid", memid.ToString());

                //Member Name
                h1MemberName.InnerText = dr["SCAName"].ToString();
                ((CDefault)Page).Title += "- " + h1MemberName.InnerText;

                //Rank
                litRank.Text = dr["OPNum"].ToString();

                //Residence

                if (!dr.IsDBNull(dr.GetOrdinal("BranchResidenceId")))
                    Residence = dr["BranchResidence"].ToString();
                lnkBranchResidence.Text = Residence;
                if (!dr.IsDBNull(dr.GetOrdinal("BranchResidenceId")) &&
                    dr.GetInt32(dr.GetOrdinal("BranchResidenceId")) != 26)
                {
                    lnkBranchResidence.NavigateUrl = Globals.NavigateURL(TabId, "", "gid=" + dr["BranchResidenceId"]);
                }

                //Deceased
                if (dr.GetBoolean(dr.GetOrdinal("Deceased")))
                {
                    lblDeceased.Text = string.Format("This {0} is deceased.",
                                                     dr["Gender"].ToString() == "P" ? "pet" : "person");
                    if (!dr.IsDBNull(dr.GetOrdinal("DeceasedWhen")))
                    {
                        lblDeceased.Text += string.Format("({0})", dr["DeceasedWhen"]);
                    }
                    lblDeceased.Text += "<br />";
                }
                //Email
                if (dr.GetBoolean(dr.GetOrdinal("ShowEmailPermission"))
                    && !dr.IsDBNull(dr.GetOrdinal("EmailAddress")))
                {
                    lblEmail.Visible = true;
                    lblEmail.Text = HtmlUtils.FormatEmail(dr["EmailAddress"].ToString()) + "<br />";
                }
                else
                {
                    lblEmail.Visible = false;
                }

                //Arms Image and Blazon
                if (dr.IsDBNull(dr.GetOrdinal("ArmsBlazon")))
                {
                    divBlazon.Visible = false;
                }
                else
                {
                    divBlazon.Visible = true;
                    divBlazonText.InnerText = dr["ArmsBlazon"].ToString();
                }
                if (dr.IsDBNull(dr.GetOrdinal("ArmsURL")) ||
                    dr["ArmsURL"].ToString().Trim().Equals(string.Empty))
                {
                    imgMemberArms.Visible = false;
                }
                else
                {
                    imgMemberArms.Visible = true;
                    imgMemberArms.ImageUrl = dr["ArmsURL"].ToString();
                    if (imgMemberArms.ImageUrl.IndexOf("://") == -1)
                        imgMemberArms.ImageUrl = BasePortalHttpAddress + BasePortalInfo.HomeDirectory +
                                                 imgMemberArms.ImageUrl;
                    imgMemberArms.Height = ((int)dr["ArmsURLHeight"] == 0 ? Unit.Empty : (int)dr["ArmsURLHeight"]);
                    imgMemberArms.Width = ((int)dr["ArmsURLWidth"] == 0 ? Unit.Empty : (int)dr["ArmsURLWidth"]);
                    imgMemberArms.AlternateText = "Arms of " + h1MemberName.InnerText + ": " + divBlazonText.InnerText;
                }

                //Personal Pic
                if (dr.GetBoolean(dr.GetOrdinal("ShowPicPermission"))
                    && !dr.IsDBNull(dr.GetOrdinal("PhotoURL"))
                    && !dr["PhotoURL"].ToString().Trim().Equals(string.Empty))
                {
                    imgPersonalPic.Visible = true;
                    imgPersonalPic.ImageUrl = dr["PhotoURL"].ToString();
                    if (imgPersonalPic.ImageUrl.IndexOf("://") == -1)
                        imgPersonalPic.ImageUrl = BasePortalHttpAddress + BasePortalInfo.HomeDirectory +
                                                  imgPersonalPic.ImageUrl;
                    imgPersonalPic.Height = ((int)dr["PhotoURLHeight"] == 0 ? Unit.Empty : (int)dr["PhotoURLHeight"]);
                    imgPersonalPic.Width = ((int)dr["PhotoURLWidth"] == 0 ? Unit.Empty : (int)dr["PhotoURLWidth"]);
                    imgPersonalPic.AlternateText = "Image of " + h1MemberName.InnerText;
                }
                else
                {
                    imgPersonalPic.Visible = false;
                }
            }
            //Cleanup
            dr.Close();


            //Aliases
            DataTable AliasTable =
                DataProvider.ConvertDataReaderToDataTable(DataProvider.Instance().GetAliasByPeople(memid));
            if (AliasTable.Rows.Count == 0)
            {
                divAliases.Visible = false;
            }
            else
            {
                dgAliases.DataSource = AliasTable;
                dgAliases.DataBind();
            }


            //Awards
            if (Convert.ToBoolean(Settings["LinkToRec"]))
            {
                hlRecommend.NavigateUrl = Globals.NavigateURL(Convert.ToInt32(Settings["AwardRecTabId"]), "",
                                                              "Recommended=" + h1MemberName.InnerText, "memid=" + memid,
                                                              "branch=" + Residence);
            }
            else
            {
                hlRecommend.Visible = false;
            }

            DataTable AwardTable =
                DataProvider.ConvertDataReaderToDataTable(DataProvider.Instance().GetPeopleAwardByPeople(memid));
            DataView awardRows = new DataView(AwardTable) { RowFilter = "honorary=0" };
            DataView honoraryRows = new DataView(AwardTable) { RowFilter = "honorary=1" };
            if (awardRows.Count > 0)
            {
                pnlAwards.Visible = true;
                litNoAwards.Visible = false;

                //Group Link
                ((HyperLinkColumn)dgAwards.Columns[1]).DataNavigateUrlFormatString =
                    Globals.NavigateURL(TabId, "", "gid=" + int.MaxValue).Replace(int.MaxValue.ToString(), "{0}");
                //Crown Link
                ((HyperLinkColumn)dgAwards.Columns[3]).DataNavigateUrlFormatString =
                    Globals.NavigateURL(TabId, "", "cid=" + int.MaxValue).Replace(int.MaxValue.ToString(), "{0}");
                dgAwards.DataSource = awardRows;
                dgAwards.DataBind();
            }
            else
            {
                pnlAwards.Visible = false;
                litNoAwards.Visible = true;
            }
            if (!isMobile)
            {
                if (honoraryRows.Count > 0)
                {
                    pnlHonoraryTitles.Visible = true;
                    litNoHonorary.Visible = false;
                    pnlHonorary.Visible = true;

                    //Group Link
                    ((HyperLinkColumn)dgHonorary.Columns[1]).DataNavigateUrlFormatString =
                        Globals.NavigateURL(TabId, "", "gid=" + int.MaxValue).Replace(int.MaxValue.ToString(), "{0}");
                    //Crown Link
                    ((HyperLinkColumn)dgHonorary.Columns[3]).DataNavigateUrlFormatString =
                        Globals.NavigateURL(TabId, "", "cid=" + int.MaxValue).Replace(int.MaxValue.ToString(), "{0}");
                    dgHonorary.DataSource = honoraryRows;
                    dgHonorary.DataBind();
                }
                else
                {
                    pnlHonoraryTitles.Visible = false;
                    litNoHonorary.Visible = true;
                    pnlHonorary.Visible = false;
                }
            }
            //Offices
            if (!isMobile)
            {
                using (context = new ScaData.ScaOpEntities())
                {
                    ObjectSet<PersonOfficer> offices = context.PersonOfficers;

                }
                DataTable OfficeTable =
                 DataProvider.ConvertDataReaderToDataTable(
                     DataProvider.Instance().GetPeopleCombinedOfficesByPeople(memid));
                if (OfficeTable.Rows.Count > 0)
                {
                    pnlOffices.Visible = true;
                    litNoOffices.Visible = false;
                    //Group Link
                    //((HyperLinkField)gvOffices.Columns[1]).DataNavigateUrlFormatString =
                    //    Globals.NavigateURL(TabId, "", "gid=" + int.MaxValue).Replace(int.MaxValue.ToString(),
                    //                                                                  "{0}");
                    gvOffices.DataSource = OfficeTable;
                    gvOffices.DataBind();
                }
                else
                {
                    pnlOffices.Visible = false;
                    litNoOffices.Visible = true;
                }
            }
        }

        #endregion

        #region DisplayAwardInfo

        private void DisplayAwardInfo(int aid)
        {
            bool ShowAll = false;
            if (newQueryString["allgroups"] == "1")
                ShowAll = true;
            IDataReader dr = DataProvider.Instance().GetAwards(aid);

            if (dr.Read())
            {
                if (IsEditable)
                {
                    tdEditAward.Visible = true;
                    hlEditAward.NavigateUrl = EditUrl("aid", aid.ToString(), "Award");
                }
                else
                    tdEditAward.Visible = false;


                //Award Name
                H1AwardName.InnerText = dr["Name"].ToString();
                H2GroupName.InnerText = dr["GroupName"].ToString();
                if (ShowAll)
                    H2GroupName.InnerText = "Showing Awardees From All Groups with this Award";
                if (!dr.IsDBNull(dr.GetOrdinal("AwardGroupId")))
                {
                    pnlAwardGroupMember.Visible = true;
                    hlAwardGroup.Text = dr["AwardGroupName"].ToString();
                    if (!isMobile)
                        hlAwardGroup.NavigateUrl =
                            Globals.NavigateURL(TabId, string.Empty, "gaid=" + dr["AwardGroupId"]);
                }

                litAwardClosed.Visible = Convert.ToBoolean(dr["Closed"]);
                litHonoraryAward.Visible = Convert.ToBoolean(dr["Honorary"]);
                ((CDefault)Page).Title += "- " + H1AwardName.InnerText;

                //Arms Image and Blazon
                if (dr.IsDBNull(dr.GetOrdinal("BadgeBlazon")))
                {
                    tdAwardBlazon.Visible = false;
                }
                else
                {
                    tdAwardBlazon.Visible = true;
                    divAwardBlazon.InnerText = dr["BadgeBlazon"].ToString();
                }
                if (dr.IsDBNull(dr.GetOrdinal("BadgeUrl")) ||
                    dr["BadgeUrl"].ToString().Trim().Equals(string.Empty))
                {
                    imgAwardBadge.Visible = false;
                }
                else
                {
                    imgAwardBadge.Visible = true;
                    imgAwardBadge.ImageUrl = dr["BadgeUrl"].ToString();
                    if (imgAwardBadge.ImageUrl.IndexOf("://") == -1)
                        imgAwardBadge.ImageUrl = BasePortalHttpAddress + BasePortalInfo.HomeDirectory +
                                                 imgAwardBadge.ImageUrl;
                    imgAwardBadge.Height = (int)dr["BadgeUrlHeight"];
                    imgAwardBadge.Width = (int)dr["BadgeUrlWidth"];
                    imgAwardBadge.AlternateText = "Badge of " + H1AwardName.InnerText + ": " + divAwardBlazon.InnerText;
                }

                if (dr.IsDBNull(dr.GetOrdinal("Charter")))
                {
                    H2AwardCharter.Visible = false;
                    divCharter.Visible = false;
                }
                else
                {
                    H2AwardCharter.Visible = true;
                    divCharter.Visible = true;
                    divCharter.InnerHtml = Server.HtmlDecode(dr["Charter"].ToString());
                }


                //Cleanup
                dr.Close();
                //Same Named Awards
                DataTable SameNameAwards =
                    DataProvider.ConvertDataReaderToDataTable(DataProvider.Instance().GetAwardsSameName(aid, ShowAll));
                if (SameNameAwards.Rows.Count > 0)
                {
                    dgAwardsSameName.ItemDataBound += dgAwardsSameName_ItemDataBound;
                    dgAwardsSameName.DataSource = SameNameAwards;
                    dgAwardsSameName.DataBind();
                    pnlOtherKingdomAwards.Visible = true;
                }

                //Members
                DataTable AwardMemberTable =
                    DataProvider.ConvertDataReaderToDataTable(
                        DataProvider.Instance().GetPeopleAwardByAwards(aid, ShowAll));

                //Crown Link
                ((HyperLinkColumn)dgAwardMembers.Columns[4]).DataNavigateUrlFormatString =
                    Globals.NavigateURL(TabId, "", "cid=" + int.MaxValue).Replace(int.MaxValue.ToString(),
                                                                                  "{0}");
                dgAwardMembers.DataSource = AwardMemberTable;
                dgAwardMembers.DataBind();
                if (dgAwardMembers.PageCount == 1)
                    dgAwardMembers.PagerStyle.Visible = false;

                //Show Group Column only when Multiple groups are showing
                if (ShowAll && !isMobile)
                {
                    dgAwardMembers.Columns[3].Visible = true;
                    dgAwardsSameName.ShowFooter = false;
                }

                litMemberCount.Text = AwardMemberTable.Rows.Count + " ";
            }
        }

        #endregion

        #region DisplayGroupAwardInfo

        private void DisplayGroupAwardInfo(int gaid)
        {
            DataTable dt =
                DataProvider.ConvertDataReaderToDataTable(DataProvider.Instance().GetAwardsByAwardGroups(gaid));

            bool ShowAll = false;
            if (newQueryString["allgroups"] == "1")
                ShowAll = true;

            pnlAwardIncludeList.Visible = true;
            dgIncludedAwards.DataSource = dt;

            HyperLinkColumn AwardNameCol = new HyperLinkColumn();
            AwardNameCol.HeaderText = "Award Types";
            AwardNameCol.DataTextField = "name";
            AwardNameCol.DataNavigateUrlField = "AwardId";
            AwardNameCol.DataNavigateUrlFormatString =
                Globals.NavigateURL(TabId, "", "aid=" + int.MaxValue).Replace(int.MaxValue.ToString(), "{0}");
            dgIncludedAwards.Columns.Add(AwardNameCol);


            divEditMember.Visible = false;

            if (IsEditable)
            {
                //Show Precedence Value
                BoundColumn PrecedenceCol = new BoundColumn();
                PrecedenceCol.HeaderText = "Precedence Value";
                PrecedenceCol.DataField = "Precedence";
                dgIncludedAwards.Columns.Add(PrecedenceCol);
                //Show SortOrder Value
                BoundColumn SortOrderCol = new BoundColumn();
                SortOrderCol.HeaderText = "Sort Order";
                SortOrderCol.DataField = "SortOrder";
                dgIncludedAwards.Columns.Add(SortOrderCol);
                //Add Edit Column
                HyperLinkColumn EditAwardCmdCol = new HyperLinkColumn();
                EditAwardCmdCol.HeaderText = "Edit";
                EditAwardCmdCol.Text = "Edit";
                EditAwardCmdCol.DataNavigateUrlField = "AwardId";
                EditAwardCmdCol.DataNavigateUrlFormatString =
                    EditUrl("aid", int.MaxValue.ToString(), "Award", "list=" + newQueryString["list"],
                            "pg=" + newQueryString["pg"],
                            "ps=" + newQueryString["ps"],
                            "f=" + newQueryString["f"]).Replace(int.MaxValue.ToString(), "{0}");
                dgIncludedAwards.Columns.Add(EditAwardCmdCol);
            }

            dgIncludedAwards.DataBind();


            //Award Name
            H1AwardName.InnerText = dt.Rows[0]["AwardGroupName"].ToString();
            H2GroupName.InnerText = dt.Rows[0]["GroupName"].ToString();
            if (ShowAll)
                H2GroupName.InnerText = "Showing Awardees From All Groups with this Award";
            litAwardClosed.Visible = false;
            ((CDefault)Page).Title += "- " + H1AwardName.InnerText;

            //Arms Image and Blazon
            if (dt.Rows[0]["BadgeBlazon"] == DBNull.Value)
            {
                tdAwardBlazon.Visible = false;
            }
            else
            {
                tdAwardBlazon.Visible = true;
                divAwardBlazon.InnerText = dt.Rows[0]["BadgeBlazon"].ToString();
            }
            if (dt.Rows[0]["BadgeUrl"] == DBNull.Value ||
                dt.Rows[0]["BadgeUrl"].ToString().Trim().Equals(string.Empty))
            {
                imgAwardBadge.Visible = false;
            }
            else
            {
                imgAwardBadge.Visible = true;
                imgAwardBadge.ImageUrl = dt.Rows[0]["BadgeUrl"].ToString();
                if (imgAwardBadge.ImageUrl.IndexOf("://") == -1)
                    imgAwardBadge.ImageUrl = BasePortalHttpAddress + BasePortalInfo.HomeDirectory +
                                             imgAwardBadge.ImageUrl;
                imgAwardBadge.Height = (int)dt.Rows[0]["BadgeUrlHeight"];
                imgAwardBadge.Width = (int)dt.Rows[0]["BadgeUrlWidth"];
                imgAwardBadge.AlternateText = "Badge of " + H1AwardName.InnerText + ": " + divAwardBlazon.InnerText;
            }

            if (dt.Rows[0]["Charter"] == DBNull.Value)
            {
                H2AwardCharter.Visible = false;
                divCharter.Visible = false;
            }
            else
            {
                H2AwardCharter.Visible = true;
                divCharter.Visible = true;
                divCharter.InnerHtml = Server.HtmlDecode(dt.Rows[0]["Charter"].ToString());
            }

            DataTable SameNameAwards =
                DataProvider.ConvertDataReaderToDataTable(DataProvider.Instance().GetAwardGroupsSameName(gaid, ShowAll));
            if (SameNameAwards.Rows.Count > 0)
            {
                dgAwardsSameName.ItemDataBound +=
                    dgAwardsSameName_AwardGroup_ItemDataBound;
                dgAwardsSameName.DataSource = SameNameAwards;
                dgAwardsSameName.DataBind();
                pnlOtherKingdomAwards.Visible = true;
            }

            //Members
            DataTable AwardMemberTable =
                DataProvider.ConvertDataReaderToDataTable(
                    DataProvider.Instance().GetPeopleAwardByAwardGroup(gaid, ShowAll));
            dgAwardMembers.Columns[1].Visible = true;

            //Crown Link
            ((HyperLinkColumn)dgAwardMembers.Columns[4]).DataNavigateUrlFormatString =
                Globals.NavigateURL(TabId, "", "cid=" + int.MaxValue).Replace(int.MaxValue.ToString(), "{0}");
            dgAwardMembers.DataSource = AwardMemberTable;
            dgAwardMembers.DataBind();
            if (dgAwardMembers.PageCount == 1)
                dgAwardMembers.PagerStyle.Visible = false;

            litMemberCount.Text = AwardMemberTable.Rows.Count + " ";

            //Show Group only when Multiple groups are showing
            if (ShowAll)
            {
                dgAwardMembers.Columns[3].Visible = true;
                dgAwardsSameName.ShowFooter = false;
            }
        }

        #endregion

        #region DisplayCrownInfo

        private
            void DisplayCrownInfo(int cid)
        {
            IDataReader dr = DataProvider.Instance().GetCrowns(cid);


            if (dr.Read())
            {
                scaCrownDisplay.CrownId = cid;
                scaCrownDisplay.IsEditable = IsEditable;

                scaCrownDisplay.CrownName.InnerText = dr["Rulers"].ToString();

                if (dr.IsDBNull(dr.GetOrdinal("CrownTournamentDate")))
                    scaCrownDisplay.CrownInfo.InnerText = dr["CrownTournamentLocation"].ToString();
                else
                    scaCrownDisplay.CrownInfo.InnerText =
                        Convert.ToDateTime(dr["CrownTournamentDate"]).ToShortDateString() + " " +
                        dr["CrownTournamentLocation"];
                if (dr.IsDBNull(dr.GetOrdinal("StartDate")))
                    scaCrownDisplay.CoronationInfo.InnerText = dr["CoronationLocation"].ToString();
                else
                    scaCrownDisplay.CoronationInfo.InnerText = Convert.ToDateTime(dr["StartDate"]).ToShortDateString() +
                                                               " " + dr["CoronationLocation"];

                if (dr.IsDBNull(dr.GetOrdinal("EndDate")))
                    scaCrownDisplay.StepDownInfo.InnerText = dr["SteppingDownLocation"].ToString();
                else
                    scaCrownDisplay.StepDownInfo.InnerText = Convert.ToDateTime(dr["EndDate"]).ToShortDateString() + " " +
                                                             dr["SteppingDownLocation"];

                scaCrownDisplay.Group.Text = dr["GroupName"].ToString();
                if (Convert.ToInt32(dr["GroupId"]) != 26) //TODO: Get rid of hard codes for atenveldt.
                {
                    scaCrownDisplay.Group.NavigateUrl =
                        Globals.NavigateURL(TabId, "", "gid=" + dr["GroupId"]);
                }

                scaCrownDisplay.CrownOrdinal.Text = GetOrdinal(dr["Reign"].ToString());
                scaCrownDisplay.ReignType.Text = dr["ReignType"].ToString();
                scaCrownDisplay.HeirsNotify.Visible = Convert.ToBoolean(dr["Heir"]);

                scaCrownDisplay.CrownPhoto1.ImageUrl = dr["Picture1Url"].ToString();
                if (scaCrownDisplay.CrownPhoto1.ImageUrl.IndexOf("://") == -1)
                    scaCrownDisplay.CrownPhoto1.ImageUrl = BasePortalHttpAddress + BasePortalInfo.HomeDirectory +
                                                           scaCrownDisplay.CrownPhoto1.ImageUrl;
                scaCrownDisplay.CrownPhoto1.Height = new Unit(Convert.ToDouble(dr["Picture1Height"]), UnitType.Pixel);
                scaCrownDisplay.CrownPhoto1.Width = new Unit(Convert.ToDouble(dr["Picture1Width"]), UnitType.Pixel);

                scaCrownDisplay.CrownPhoto2.ImageUrl = dr["Picture2Url"].ToString();
                if (scaCrownDisplay.CrownPhoto2.ImageUrl.IndexOf("://") == -1)
                    scaCrownDisplay.CrownPhoto2.ImageUrl = BasePortalHttpAddress + BasePortalInfo.HomeDirectory +
                                                           scaCrownDisplay.CrownPhoto2.ImageUrl;
                scaCrownDisplay.CrownPhoto2.Height = new Unit(Convert.ToDouble(dr["Picture2Height"]), UnitType.Pixel);
                scaCrownDisplay.CrownPhoto2.Width = new Unit(Convert.ToDouble(dr["Picture2Width"]), UnitType.Pixel);

                scaCrownDisplay.Caption1.Text = dr["Picture1Caption"].ToString();
                scaCrownDisplay.Credit1.Text = dr["Picture1Credit"].ToString();
                scaCrownDisplay.Caption2.Text = dr["Picture2Caption"].ToString();
                scaCrownDisplay.Credit2.Text = dr["Picture2Credit"].ToString();


                scaCrownDisplay.SovereignArms.ImageUrl = dr["SovereignArmsURL"].ToString();
                if (scaCrownDisplay.SovereignArms.ImageUrl.IndexOf("://") == -1)
                    scaCrownDisplay.SovereignArms.ImageUrl = BasePortalHttpAddress + BasePortalInfo.HomeDirectory +
                                                             scaCrownDisplay.SovereignArms.ImageUrl;
                scaCrownDisplay.SovereignArms.Height =
                    new Unit(Convert.ToDouble(dr["SovereignArmsHeight"]), UnitType.Pixel);
                scaCrownDisplay.SovereignArms.Width =
                    new Unit(Convert.ToDouble(dr["SovereignArmsWidth"]), UnitType.Pixel);

                scaCrownDisplay.SovereignPersonalArms.ImageUrl = dr["SovereignPersonalArmsURL"].ToString();
                if (scaCrownDisplay.SovereignPersonalArms.ImageUrl.IndexOf("://") == -1)
                    scaCrownDisplay.SovereignPersonalArms.ImageUrl = BasePortalHttpAddress +
                                                                     BasePortalInfo.HomeDirectory +
                                                                     scaCrownDisplay.SovereignPersonalArms.ImageUrl;
                scaCrownDisplay.SovereignPersonalArms.Height =
                    new Unit(Convert.ToDouble(dr["SovereignPersonalArmsHeight"]), UnitType.Pixel);
                scaCrownDisplay.SovereignPersonalArms.Width =
                    new Unit(Convert.ToDouble(dr["SovereignPersonalArmsWidth"]), UnitType.Pixel);

                scaCrownDisplay.ConsortArms.ImageUrl = dr["ConsortArmsURL"].ToString();
                if (scaCrownDisplay.ConsortArms.ImageUrl.IndexOf("://") == -1)
                    scaCrownDisplay.ConsortArms.ImageUrl = BasePortalHttpAddress + BasePortalInfo.HomeDirectory +
                                                           scaCrownDisplay.ConsortArms.ImageUrl;
                scaCrownDisplay.ConsortArms.Height = new Unit(Convert.ToDouble(dr["ConsortArmsHeight"]), UnitType.Pixel);
                scaCrownDisplay.ConsortArms.Width = new Unit(Convert.ToDouble(dr["ConsortArmsWidth"]), UnitType.Pixel);

                scaCrownDisplay.ConsortPersonalArms.ImageUrl = dr["ConsortPersonalArmsURL"].ToString();
                if (scaCrownDisplay.ConsortPersonalArms.ImageUrl.IndexOf("://") == -1)
                    scaCrownDisplay.ConsortPersonalArms.ImageUrl = BasePortalHttpAddress + BasePortalInfo.HomeDirectory +
                                                                   scaCrownDisplay.ConsortPersonalArms.ImageUrl;
                scaCrownDisplay.ConsortPersonalArms.Height =
                    new Unit(Convert.ToDouble(dr["ConsortPersonalArmsHeight"]), UnitType.Pixel);
                scaCrownDisplay.ConsortPersonalArms.Width =
                    new Unit(Convert.ToDouble(dr["ConsortPersonalArmsWidth"]), UnitType.Pixel);
            }
            //Cleanup
            dr.Close();
        }

        #endregion

        #region DisplayGroupInfo

        private void DisplayGroupInfo(int gid)
        {
            bool BranchActive = false;
            if (gid != 26) //TODO: Hardcoded groupid
            {
                IDataReader dr = DataProvider.Instance().GetGroups(gid);

                scaGroupDisplay.BasePortalInfo = BasePortalInfo;
                scaGroupDisplay.BasePortalHttpAddress = BasePortalHttpAddress;

                if (dr.Read())
                {
                    scaGroupDisplay.GroupId = gid;
                    scaGroupDisplay.IsEditable = IsEditable;
                    scaGroupDisplay.GroupName = dr["Name"].ToString();
                    ((CDefault)Page).Title += "- " + scaGroupDisplay.GroupName;
                    scaGroupDisplay.GroupLocation = dr["Location"].ToString();
                    scaGroupDisplay.GroupStatus = dr["BranchStatus"].ToString();
                    BranchActive = Convert.ToInt32(dr["BranchStatusId"]) == 1;
                    scaGroupDisplay.ArmsUrl = dr["ArmsURL"].ToString();
                    scaGroupDisplay.ArmsHeight = Convert.ToDouble(dr["ArmsURLHeight"]);
                    scaGroupDisplay.ArmsWidth = Convert.ToDouble(dr["ArmsURLWidth"]);
                    scaGroupDisplay.WebsiteUrl = dr["WebSiteUrl"].ToString();
                    scaGroupDisplay.NotesHtml = dr["Notes"].ToString().Replace(Environment.NewLine, "<br>");
                    if (dr.IsDBNull(dr.GetOrdinal("ParentGroupId")))
                    {
                        scaGroupDisplay.ShowPartOf = false;
                    }
                    else
                    {
                        scaGroupDisplay.ShowPartOf = true;
                        int parentGroupId = Convert.ToInt32(dr["ParentGroupId"]);
                        if (parentGroupId != 26) //TODO: Hardcoded groupid
                            scaGroupDisplay.ParentGroupId = parentGroupId;
                        scaGroupDisplay.ParentGroupName = dr["ParentGroupName"].ToString();
                    }
                }
                //Cleanup
                dr.Close();
                //only show regnum if group is active
                DataTable RegnumTable = new DataTable();
                if (BranchActive)
                {
                    RegnumTable =
                        DataProvider.ConvertDataReaderToDataTable(DataProvider.Instance().GetRegnumforGroup(gid));
                }
                scaGroupDisplay.RegnumDataSource = RegnumTable;
                scaGroupDisplay.BindRegnum(); // use the bind method which will hide regnum if no records show.
            }
            DataTable awardsDt =
                DataProvider.ConvertDataReaderToDataTable(DataProvider.Instance().GetAwardsByGroups(gid.ToString()));
            if (awardsDt.Rows.Count > 0)
                scaGroupDisplay.ShowAwardsList = true;
            else
                scaGroupDisplay.ShowAwardsList = false;

            DataTable crownsDt = DataProvider.Instance().GetCrownsByGroups(gid);
            if (crownsDt.Rows.Count > 0)
                scaGroupDisplay.ShowCrownsList = true;
            else
                scaGroupDisplay.ShowCrownsList = false;
        }

        #endregion

        #region dgAwardMembers_PageIndexChanged

        private
            void dgAwardMembers_PageIndexChanged(object source, DataGridPageChangedEventArgs e)
        {
            if (newQueryString["aid"] != null)
            {
                DataTable AwardMemberTable =
                    DataProvider.ConvertDataReaderToDataTable(
                        DataProvider.Instance().GetPeopleAwardByAwards(Convert.ToInt32(newQueryString["aid"])));
                dgAwardMembers.DataSource = AwardMemberTable;
                dgAwardMembers.CurrentPageIndex = e.NewPageIndex;
                dgAwardMembers.DataBind();
            }
            if (newQueryString["gaid"] != null)
            {
                bool ShowAll = false;
                if (newQueryString["allgroups"] == "1")
                    ShowAll = true;
                DataTable AwardGroupMemberTable = DataProvider.ConvertDataReaderToDataTable(
                    DataProvider.Instance().GetPeopleAwardByAwardGroup(Convert.ToInt32(newQueryString["gaid"]),
                                                                       ShowAll));
                dgAwardMembers.DataSource = AwardGroupMemberTable;
                dgAwardMembers.CurrentPageIndex = e.NewPageIndex;
                dgAwardMembers.DataBind();
            }
        }

        #endregion

        #region GenerateAlphaButtons

        private
            void GenerateAlphaButtons()
        {
            DataTable dt;
            if (DataCache.GetCache("ListPeopleAlphaCount") == null)
            {
                dt = DataProvider.ConvertDataReaderToDataTable(DataProvider.Instance().ListPeopleAlphaCount());
                DataCache.SetCache("ListPeopleAlphaCount", dt, DateTime.Now.AddMinutes(60));
            }
            else
            {
                dt = (DataTable)DataCache.GetCache("ListPeopleAlphaCount");
            }
            foreach (DataRow row in dt.Rows)
            {
                HyperLink alphaLink = new HyperLink();
                alphaLink.Text = row[0].ToString();
                alphaLink.ToolTip = row[1] + " entries";
                alphaLink.NavigateUrl =
                    Globals.NavigateURL(TabId, "", "list=alpha", "f=" + HttpUtility.UrlEncode(row[0].ToString())) + "#results";
                phAlphaButtons.Controls.Add(alphaLink);
                Literal litSpace = new Literal();
                litSpace.Text = " ";
                phAlphaButtons.Controls.Add(litSpace);
            }
        }

        #endregion

        #region BindPageJumper

        private void BindPageJumper(bool ShowingPics)
        {
            if (!IsPostBack)
            {
                ddlJumpToPage.Items.Clear();
                if (ShowingPics)
                {
                    for (int i = 1; i <= pdsPhotoDevice.PageCount; i++)
                    {
                        ddlJumpToPage.Items.Add(new ListItem(i.ToString()));
                        ddlJumpToPageBottom.Items.Add(new ListItem(i.ToString()));
                    }
                    ddlJumpToPage.SelectedValue = (pdsPhotoDevice.CurrentPageIndex + 1).ToString();
                    ddlJumpToPageBottom.SelectedValue = (pdsPhotoDevice.CurrentPageIndex + 1).ToString();
                }
                else
                {
                    for (int i = 1; i <= dgResultList.PageCount; i++)
                    {
                        ddlJumpToPage.Items.Add(new ListItem(i.ToString()));
                        ddlJumpToPageBottom.Items.Add(new ListItem(i.ToString()));
                    }
                    ddlJumpToPage.SelectedValue = (dgResultList.CurrentPageIndex + 1).ToString();
                    ddlJumpToPageBottom.SelectedValue = (dgResultList.CurrentPageIndex + 1).ToString();
                }
            }
        }

        #endregion

        #region SetDataGridColumns

        private void SetDataGridColumns(params string[] ColumnNames)
        {
            foreach (string ColumnName in ColumnNames)
            {
                switch (ColumnName.ToLower())
                {
                    case "rank":
                        BoundColumn RankCol = new BoundColumn();
                        RankCol.HeaderText = "Rank";
                        RankCol.DataField = "OPNum";
                        RankCol.DataFormatString = "{0}";
                        dgResultList.Columns.Add(RankCol);
                        break;
                    case "highestawardname":
                        HyperLinkColumn AwardCol = new HyperLinkColumn();
                        AwardCol.HeaderText = "Highest Award";
                        AwardCol.DataTextField = "HighestAwardName";
                        AwardCol.DataNavigateUrlField = "HighestAwardId";
                        AwardCol.DataNavigateUrlFormatString =
                            Globals.NavigateURL(TabId, "", "aid=" + int.MaxValue).Replace(
                                int.MaxValue.ToString(), "{0}");
                        dgResultList.Columns.Add(AwardCol);
                        break;
                    case "highestawarddate":
                        BoundColumn HighAwardDateCol = new BoundColumn();
                        HighAwardDateCol.HeaderText = "Award Date";
                        HighAwardDateCol.DataField = "HighestAwardDate";
                        HighAwardDateCol.DataFormatString = "{0:d}";
                        dgResultList.Columns.Add(HighAwardDateCol);
                        break;
                    case "date":
                        BoundColumn AwardDateCol = new BoundColumn();
                        AwardDateCol.HeaderText = "Award Date";
                        AwardDateCol.DataField = "Date";
                        AwardDateCol.DataFormatString = "{0:d}";
                        dgResultList.Columns.Add(AwardDateCol);
                        break;
                    case "officestart":
                        BoundColumn StartDateCol = new BoundColumn();
                        StartDateCol.HeaderText = "Start Date";
                        StartDateCol.DataField = "StartDate";
                        StartDateCol.DataFormatString = "{0:d}";
                        dgResultList.Columns.Add(StartDateCol);
                        break;
                    case "officeend":
                        BoundColumn EndDateCol = new BoundColumn();
                        EndDateCol.HeaderText = "End Date";
                        EndDateCol.DataField = "EndDate";
                        EndDateCol.DataFormatString = "{0:d}";
                        dgResultList.Columns.Add(EndDateCol);
                        break;
                    case "positionsubtitle":
                        BoundColumn PositionSubTitleCol = new BoundColumn();
                        PositionSubTitleCol.HeaderText = "Sub Position";
                        PositionSubTitleCol.DataField = "PositionSubTitle";
                        dgResultList.Columns.Add(PositionSubTitleCol);
                        break;
                    case "scaname":
                        HyperLinkColumn NameCol = new HyperLinkColumn();
                        NameCol.HeaderText = "SCA Name";
                        NameCol.DataTextField = "SCAName";
                        NameCol.DataNavigateUrlField = "PeopleId";
                        NameCol.DataNavigateUrlFormatString =
                            Globals.NavigateURL(TabId, "", "memid=" + int.MaxValue).Replace(
                                int.MaxValue.ToString(), "{0}");

                        dgResultList.Columns.Add(NameCol);
                        break;
                    case "branchresidence":
                        HyperLinkColumn ResidenceCol = new HyperLinkColumn();
                        ResidenceCol.HeaderText = "Residence";
                        ResidenceCol.DataTextField = "BranchResidence";
                        ResidenceCol.DataNavigateUrlField = "BranchResidenceId";
                        ResidenceCol.DataNavigateUrlFormatString =
                            Globals.NavigateURL(TabId, "", "gid=" + int.MaxValue).Replace(
                                int.MaxValue.ToString(), "{0}");
                        dgResultList.Columns.Add(ResidenceCol);
                        break;
                    case "group":
                        HyperLinkColumn GroupNameCol = new HyperLinkColumn();
                        GroupNameCol.HeaderText = "Group Name";
                        GroupNameCol.DataTextField = "GroupName";
                        GroupNameCol.DataNavigateUrlField = "GroupId";
                        GroupNameCol.DataNavigateUrlFormatString =
                            Globals.NavigateURL(TabId, "", "gid=" + int.MaxValue).Replace(
                                int.MaxValue.ToString(), "{0}");
                        dgResultList.Columns.Add(GroupNameCol);
                        break;
                    case "awardname":
                        HyperLinkColumn AwardNameCol = new HyperLinkColumn();
                        AwardNameCol.HeaderText = "Award Name";
                        AwardNameCol.DataTextField = "AwardName";
                        AwardNameCol.DataNavigateUrlField = "AwardQueryString";
                        AwardNameCol.DataNavigateUrlFormatString =
                            Globals.NavigateURL(TabId, "", int.MaxValue.ToString()).Replace(int.MaxValue.ToString(),
                                                                                            "{0}");
                        dgResultList.Columns.Add(AwardNameCol);
                        break;
                    case "reign":
                        BoundColumn ReignCol = new BoundColumn();
                        ReignCol.HeaderText = "Reign";
                        ReignCol.DataField = "Reign";
                        ReignCol.DataFormatString = "{0}";
                        dgResultList.Columns.Add(ReignCol);
                        break;
                    case "daterange":
                        TemplateColumn DatesCol = new TemplateColumn();
                        DatesCol.HeaderText = "Date Range";
                        DatesCol.ItemTemplate = Page.LoadTemplate(ControlPath + "templates/reignListDateRangeTemplate.ascx");
                        dgResultList.Columns.Add(DatesCol);

                        break;
                    case "rulers":
                        HyperLinkColumn CrownNameCol = new HyperLinkColumn();
                        CrownNameCol.HeaderText = "Rulers";
                        CrownNameCol.DataTextField = "rulers";
                        CrownNameCol.DataNavigateUrlField = "CrownId";
                        CrownNameCol.DataNavigateUrlFormatString =
                            Globals.NavigateURL(TabId, "", "cid=" + int.MaxValue).Replace(
                                int.MaxValue.ToString(), "{0}");
                        dgResultList.Columns.Add(CrownNameCol);
                        break;
                    case "location":
                        BoundColumn LocationCol = new BoundColumn();
                        LocationCol.HeaderText = "Mundane Location";
                        LocationCol.DataField = "Location";
                        dgResultList.Columns.Add(LocationCol);
                        break;

                    case "website":
                        HyperLinkColumn WebsiteCol = new HyperLinkColumn();
                        WebsiteCol.HeaderText = "Website (External)";
                        WebsiteCol.DataTextField = "WebSiteUrl";
                        WebsiteCol.DataNavigateUrlField = "WebSiteUrl";
                        WebsiteCol.Target = "_blank";
                        dgResultList.Columns.Add(WebsiteCol);
                        break;
                }
            }
            if (IsEditable)
            {
                switch (newQueryString["list"].ToLower())
                {
                    case "charters":
                        //Show Precedence Value
                        BoundColumn PrecedenceCol = new BoundColumn();
                        PrecedenceCol.HeaderText = "Precedence Value";
                        PrecedenceCol.DataField = "Precedence";
                        dgResultList.Columns.Add(PrecedenceCol);
                        //Show SortOrder Value
                        BoundColumn SortOrderCol = new BoundColumn();
                        SortOrderCol.HeaderText = "Sort Order";
                        SortOrderCol.DataField = "SortOrder";
                        dgResultList.Columns.Add(SortOrderCol);

                        //Add Edit Column
                        HyperLinkColumn EditAwardCmdCol = new HyperLinkColumn();
                        EditAwardCmdCol.HeaderText = "Edit";
                        EditAwardCmdCol.Text = "Edit";
                        EditAwardCmdCol.DataNavigateUrlField = "AwardId";
                        EditAwardCmdCol.DataNavigateUrlFormatString =
                            EditUrl("aid", int.MaxValue.ToString(), "Award").Replace(int.MaxValue.ToString(), "{0}");
                        dgResultList.Columns.Add(EditAwardCmdCol);
                        break;

                    case "crown":
                        //Show Heir Value
                        BoundColumn HeirCol = new BoundColumn();
                        HeirCol.HeaderText = "Heir";
                        HeirCol.DataField = "Heir";
                        dgResultList.Columns.Add(HeirCol);
                        //Add Edit Column
                        HyperLinkColumn EditCrownCmdCol = new HyperLinkColumn();
                        EditCrownCmdCol.HeaderText = "Edit";
                        EditCrownCmdCol.Text = "Edit";
                        EditCrownCmdCol.DataNavigateUrlField = "CrownId";
                        EditCrownCmdCol.DataNavigateUrlFormatString =
                            EditUrl("cid", int.MaxValue.ToString(), "Crown").Replace(int.MaxValue.ToString(), "{0}");
                        dgResultList.Columns.Add(EditCrownCmdCol);
                        break;
                    case "group":

                        //Add Edit Column
                        HyperLinkColumn EditGroupCmdCol = new HyperLinkColumn();
                        EditGroupCmdCol.HeaderText = "Edit";
                        EditGroupCmdCol.Text = "Edit";
                        EditGroupCmdCol.DataNavigateUrlField = "GroupId";
                        EditGroupCmdCol.DataNavigateUrlFormatString =
                            EditUrl("gid", int.MaxValue.ToString(), "Group").Replace(int.MaxValue.ToString(), "{0}");
                        dgResultList.Columns.Add(EditGroupCmdCol);
                        break;
                    default:
                        HyperLinkColumn EditCmdCol = new HyperLinkColumn();
                        EditCmdCol.HeaderText = "Edit";
                        EditCmdCol.Text = "Edit";
                        EditCmdCol.DataNavigateUrlField = "PeopleId";
                        EditCmdCol.DataNavigateUrlFormatString =
                            EditUrl("memid", int.MaxValue.ToString(), "Edit").Replace(int.MaxValue.ToString(), "{0}");
                        dgResultList.Columns.Add(EditCmdCol);
                        break;
                }
            }
        }

        #endregion

        #region GetNavigateUrl

        /// <summary>
        /// Gets the navigate url with all available options.  replace option by putting them in to 
        /// </summary>
        /// <param name="newValues"></param>
        /// <returns></returns>
        private string GetNavigateUrl(Dictionary<string, string> newValues)
        {
            Dictionary<string, string> querystringValues = new Dictionary<string, string>();
            //pg = page, ps = pagesize, f= filter(Search Text), st = Search type (first or containing), ff= Filter field (Name or blazon), o = order by
            //dp = displayPhoto, dd = displayDevice, lp= limit by photos, ld =limitbydevice, da = display aliases, dc= only deceased, dl = only living, 
            //dr = display residents, dnr = display non-residents, drr=display residence.
            querystringValues.Add("list", newQueryString["list"]);
            querystringValues.Add("pg", newQueryString["pg"]);
            querystringValues.Add("ps", newQueryString["ps"]);
            querystringValues.Add("f", newQueryString["f"]);
            querystringValues.Add("st", newQueryString["st"]);
            querystringValues.Add("ff", newQueryString["ff"]);
            querystringValues.Add("o", newQueryString["o"]);
            querystringValues.Add("dp", newQueryString["dp"]);
            querystringValues.Add("dd", newQueryString["dd"]);
            querystringValues.Add("da", newQueryString["da"]);
            querystringValues.Add("lp", newQueryString["lp"]);
            querystringValues.Add("ld", newQueryString["ld"]);
            querystringValues.Add("dc", newQueryString["dc"]);
            querystringValues.Add("dl", newQueryString["dl"]);
            querystringValues.Add("dr", newQueryString["dr"]);
            querystringValues.Add("dnr", newQueryString["dnr"]);
            querystringValues.Add("drr", newQueryString["drr"]);

            if (newValues != null)
            {
                foreach (KeyValuePair<string, string> pair in newValues)
                {
                    querystringValues[pair.Key] = pair.Value;
                }
            }
            List<string> controlParams = new List<string>();
            foreach (KeyValuePair<string, string> pair in querystringValues)
            {
                if (!string.IsNullOrEmpty(pair.Value))
                    controlParams.Add(pair.Key + "=" + pair.Value);
            }

            return Globals.NavigateURL(TabId, "",
                                       controlParams.ToArray()
                       ) + "#results";
        }

        #endregion

        #region dgResultList_PageIndexChanged

        private void dgResultList_PageIndexChanged(object source, DataGridPageChangedEventArgs e)
        {
            Dictionary<string, string> newValues = new Dictionary<string, string>();
            newValues.Add("pg", e.NewPageIndex.ToString());

            Response.Redirect(GetNavigateUrl(newValues), true);
        }

        #endregion

        #region ddlJumpToPage_SelectedIndexChanged

        protected void ddlJumpToPage_SelectedIndexChanged(object sender, EventArgs e)
        {
            DropDownList PageJumper = sender as DropDownList;
            if (PageJumper != null)
            {
                Dictionary<string, string> newValues = new Dictionary<string, string>();
                newValues.Add("pg", (int.Parse(PageJumper.SelectedValue) - 1).ToString());

                Response.Redirect(GetNavigateUrl(newValues), true);
            }
        }

        #endregion

        #region ddlResultsPerPage_SelectedIndexChanged

        protected void ddlResultsPerPage_SelectedIndexChanged(object sender, EventArgs e)
        {
            DropDownList PageResultsCount = sender as DropDownList;
            if (PageResultsCount != null)
            {
                Dictionary<string, string> newValues = new Dictionary<string, string>();
                newValues.Add("ps", PageResultsCount.SelectedValue);
                newValues.Add("pg", "1");

                Response.Redirect(GetNavigateUrl(newValues), true);
            }
        }

        #endregion

        #region ddlGroupFilter_SelectedIndexChanged

        private void ddlGroupFilter_SelectedIndexChanged(object sender, EventArgs e)
        {
            Dictionary<string, string> newValues = new Dictionary<string, string>();
            newValues.Add("f", ddlGroupFilter.SelectedValue);

            Response.Redirect(GetNavigateUrl(newValues), true);
        }

        #endregion

        #region btnSearchOP_Click

        private void btnSearchOP_Click(object sender, EventArgs e)
        {
            Dictionary<string, string> newValues = new Dictionary<string, string>();
            newValues.Add("list", "alpha");
            newValues.Add("pg", "0");
            newValues.Add("ps", ddlSearchResultsPerPage.SelectedValue);
            newValues.Add("f", txtSearchOP.Text.Trim());
            newValues.Add("st", rblFilterType.SelectedValue);
            newValues.Add("ff", rblSearchField.SelectedValue);
            newValues.Add("o", rblOrderBy.SelectedValue);
            newValues.Add("dp", (chkShowPhotos.Checked ? "1" : "0"));
            newValues.Add("dd", (chkShowDevices.Checked ? "1" : "0"));
            newValues.Add("da", (chkShowAliases.Checked ? "1" : "0"));
            newValues.Add("drr", (chkShowResidence.Checked ? "1" : "0"));
            newValues.Add("lp", (chkIncludeOnlyPhotos.Checked ? "1" : "0"));
            newValues.Add("ld", (chkIncludeOnlyDevices.Checked ? "1" : "0"));
            newValues.Add("dc", (chkIncludeLivingStatus.Checked && rblLivingStatus.SelectedValue == "D" ? "1" : "0"));
            newValues.Add("dl", (chkIncludeLivingStatus.Checked && rblLivingStatus.SelectedValue == "A" ? "1" : "0"));
            newValues.Add("dr", (chkIncludeResidentStatus.Checked && rblResidentStatus.SelectedValue == "I" ? "1" : "0"));
            newValues.Add("dnr",
                          (chkIncludeResidentStatus.Checked && rblResidentStatus.SelectedValue == "O" ? "1" : "0"));


            Response.Redirect(GetNavigateUrl(newValues), true);
        }

        #endregion

        #region btnSearchByDate_Click

        private
            void btnSearchByDate_Click(object sender, EventArgs e)
        {
            Response.Redirect(
                Globals.NavigateURL(TabId, "", "list=abd", "f=" + ddlMonth.SelectedValue + "-" + ddlYear.SelectedValue),
                true);
        }

        #endregion

        #region FormatEndDate

        public string FormatEndDate(object EndDate, object CurrentlyHeld)
        {
            bool Current = Convert.ToBoolean(CurrentlyHeld);
            if (EndDate != null && EndDate != DBNull.Value)
            {
                DateTime dtEndDate = (DateTime)EndDate;
                return dtEndDate.ToShortDateString();
            }
            else
            {
                if (Current)
                {
                    return "Present";
                }
                else
                {
                    return "Unknown";
                }
            }
        }

        #endregion

        #region FormatYesNo

        public
            string FormatYesNo(object CurrentlyHeld)
        {
            bool Current = Convert.ToBoolean(CurrentlyHeld);
            return Current ? "Yes" : "No";
        }

        #endregion

        #region GetOrdinal

        public
            string GetOrdinal(string Number)
        {
            if (Number.EndsWith("1"))
                return Number + "<sup>st</sup>";
            else if (Number.EndsWith("2"))
                return Number + "<sup>nd</sup>";
            else if (Number.EndsWith("3"))
                return Number + "<sup>rd</sup>";
            else if (Char.IsDigit(Number[Number.Length - 1]))
                return Number + "<sup>th</sup>";
            else
                return Number;
        }

        #endregion

        #region Awards_ItemDataBound

        private void Awards_ItemDataBound(object sender, DataGridItemEventArgs e)
        {
            if (e.Item.ItemType == ListItemType.Item ||
                e.Item.ItemType == ListItemType.AlternatingItem)
            {
                ((HyperLink)e.Item.FindControl("hlAward")).NavigateUrl =
                    Globals.NavigateURL(TabId, "", "aid=" + ((DataRowView)e.Item.DataItem)["AwardId"]);
                //Disable link to atenveldt.
                DataRowView drv = (DataRowView)e.Item.DataItem;
                if (Convert.ToInt32(drv["GroupId"]) == 26) //TODO: Get rid of hard codes for atenveldt.
                {
                    TableCell cell = e.Item.Cells[1];
                    HyperLink groupLink = (HyperLink)cell.Controls[0];
                    if (groupLink.Text == drv["GroupName"].ToString())
                    {
                        Label groupLabel = new Label();
                        groupLabel.Text = groupLink.Text;
                        cell.Controls.AddAt(cell.Controls.IndexOf(groupLink), groupLabel);
                        cell.Controls.Remove(groupLink);
                    }
                }
            }
        }

        #endregion

        #region dgAwardMembers_ItemDataBound

        private void dgAwardMembers_ItemDataBound(object sender, DataGridItemEventArgs e)
        {
            DataRowView drv = (DataRowView)e.Item.DataItem;
            if (e.Item.ItemType == ListItemType.Item ||
                e.Item.ItemType == ListItemType.AlternatingItem)
            {
                ((HyperLink)e.Item.FindControl("hlMember")).NavigateUrl =
                    Globals.NavigateURL(TabId, "", "memid=" + drv["PeopleId"]);
                ((HyperLink)e.Item.FindControl("hlAwardName")).NavigateUrl =
               Globals.NavigateURL(TabId, "", "aid=" + ((DataRowView)e.Item.DataItem)["AwardId"]);
                foreach (TableCell cell in e.Item.Cells)
                {
                    foreach (Control controlItem in cell.Controls)
                    {
                        if (controlItem is HyperLink)
                        {
                            bool EditedCell = false;
                            HyperLink personLink = (HyperLink)controlItem;
                            if (personLink.Text == drv["SCAName"].ToString()
                                && !drv["ArmsUrl"].Equals(DBNull.Value))
                            {
                                Literal litSpace = new Literal();
                                litSpace.Text = "&nbsp;";
                                Image armsIcon = new Image();
                                armsIcon.ImageUrl = ControlPath + "sheild_icon.gif";
                                armsIcon.AlternateText = "This person has a display of Arms in the record";
                                cell.Controls.Add(litSpace);
                                cell.Controls.Add(armsIcon);
                                EditedCell = true;
                            }
                            if (personLink.Text == drv["SCAName"].ToString()
                                && !drv["PhotoUrl"].Equals(DBNull.Value) &&
                                drv["ShowPicPermission"].Equals(true))
                            {
                                Literal litSpace = new Literal();
                                litSpace.Text = "&nbsp;";
                                Image photoIcon = new Image();
                                photoIcon.ImageUrl = ControlPath + "photo_icon.gif";
                                photoIcon.AlternateText = "This person has a personal photo in the record";
                                cell.Controls.Add(litSpace);
                                cell.Controls.Add(photoIcon);
                                EditedCell = true;
                            }
                            if (EditedCell) break;
                        }
                    }
                }
            }
        }

        #endregion

        #region Optional Interfaces

        #region IActionable Members

        public ModuleActionCollection ModuleActions
        {
            get
            {
                ModuleActionCollection Actions = new ModuleActionCollection();
                Actions.Add(GetNextActionID(), "Edit Offices", ModuleActionType.AddContent, "", "", EditUrl("Office"),
                            false, SecurityAccessLevel.Edit, true, false);
                Actions.Add(GetNextActionID(), "Edit Office Types", ModuleActionType.AddContent, "", "", EditUrl("OfficeType"),
                            false, SecurityAccessLevel.Edit, true, false);
                Actions.Add(GetNextActionID(), "Edit AwardGroups", ModuleActionType.AddContent, "", "",
                            EditUrl("AwardGroups"), false, SecurityAccessLevel.Edit, true, false);
                Actions.Add(GetNextActionID(), "Add Member", ModuleActionType.AddContent, "", "", EditUrl("Edit"), false,
                            SecurityAccessLevel.Edit, true, false);
                Actions.Add(GetNextActionID(), "Add New Award", ModuleActionType.AddContent, "", "", EditUrl("Award"),
                            false, SecurityAccessLevel.Edit, true, false);
                Actions.Add(GetNextActionID(), "Add New Crown", ModuleActionType.AddContent, "", "", EditUrl("Crown"),
                            false, SecurityAccessLevel.Edit, true, false);
                Actions.Add(GetNextActionID(), "Add New Group", ModuleActionType.AddContent, "", "", EditUrl("Group"),
                            false, SecurityAccessLevel.Edit, true, false);
                if (newQueryString["memid"] != null)
                    Actions.Add(GetNextActionID(), "Edit this Member", ModuleActionType.AddContent, "", "",
                                EditUrl("memid", newQueryString["memid"]), false, SecurityAccessLevel.Edit, true,
                                false);
                return Actions;
            }
        }

        #endregion

        #region IPortable Members

        public string ExportModule(int ModuleID)
        {
            // included as a stub only so that the core knows this module Implements Entities.Modules.IPortable
            return null;
        }

        public void ImportModule(int ModuleID, string Content, string Version, int UserID)
        {
            // included as a stub only so that the core knows this module Implements Entities.Modules.IPortable
        }

        #endregion

        #region ISearchable Members

        public SearchItemInfoCollection GetSearchItems(ModuleInfo ModInfo)
        {
            // TODO: Add searchitems for Lands, Awards, Crowns, etc.
            SearchItemInfoCollection siic = new SearchItemInfoCollection();
            DataSet ds = DataProvider.ConvertDataReaderToDataSet(DataProvider.Instance().ListPeople());
            foreach (DataRow row in ds.Tables[0].Rows)
            {
                SearchItemInfo sii = new SearchItemInfo(row["SCAName"].ToString(),
                                                        "Order of Precedence information for " +
                                                        row["SCAName"],
                                                        0,
                                                        Null.NullDate,
                                                        ModInfo.ModuleID,
                                                        row["SCAName"].ToString(),
                                                        GetMemberContents((int)row["PeopleId"]),
                                                        "memid=" + row["PeopleId"]
                    );

                siic.Add(sii);
            }

            return siic;
        }

        #endregion

        private string GetMemberContents(int memid)
        {
            DisplayMemberInfo(memid);
            StringWriter sw = new StringWriter();
            HtmlTextWriter htmlW = new HtmlTextWriter(sw);
            pnlDisplayMember.RenderControl(htmlW);
            return sw.ToString();
        }

        #endregion

        #region dgResultList_ItemDataBound

        private void dgResultList_ItemDataBound(object sender, DataGridItemEventArgs e)
        {
            string[] GroupIdCol = { "GroupId", "BranchResidenceId" };
            string[] GroupNameCol = { "GroupName", "BranchResidence" };

            if (e.Item.DataItem is DataRowView)
            {
                DataRowView drv = (DataRowView)e.Item.DataItem;
                if (drv.Row.Table.Columns.Contains("Gender") && drv["Gender"].ToString() == "P" && !petStartFound)
                {
                    petStartFound = true;
                    DataGridItem breakControl = new DataGridItem(e.Item.ItemIndex - 1, 0, ListItemType.Separator);
                    TableCell breakCell = new TableCell();
                    breakCell.ColumnSpan = e.Item.Cells.Count;
                    breakCell.Text = "<div class=\"ListTitle\" style=\"clear:both;\">Pets and Animal Companions</div>";
                    breakControl.Cells.Add(breakCell);
                    dgResultList.Controls[0].Controls.AddAt(dgResultList.Controls[0].Controls.IndexOf(e.Item),
                                                            breakControl);
                }
                for (int i = 0; i < GroupIdCol.Length; i++)
                {
                    if (drv.Row.Table.Columns.Contains(GroupIdCol[i]) && drv.Row.Table.Columns.Contains(GroupNameCol[i]))
                    {
                        //Disable link to atenveldt.
                        if (drv[GroupIdCol[i]] != DBNull.Value && Convert.ToInt32(drv[GroupIdCol[i]]) == 26)
                        //TODO: Get rid of hard codes for atenveldt.
                        {
                            if (e.Item.ItemType == ListItemType.Item ||
                                e.Item.ItemType == ListItemType.AlternatingItem)
                            {
                                foreach (TableCell cell in e.Item.Cells)
                                {
                                    foreach (Control controlItem in cell.Controls)
                                    {
                                        if (controlItem is HyperLink)
                                        {
                                            HyperLink groupLink = (HyperLink)controlItem;
                                            if (groupLink.Text == drv[GroupNameCol[i]].ToString())
                                            {
                                                Label groupLabel = new Label();
                                                groupLabel.Text = groupLink.Text;
                                                cell.Controls.AddAt(cell.Controls.IndexOf(groupLink), groupLabel);
                                                cell.Controls.Remove(groupLink);
                                                break;
                                            }
                                        }
                                    }
                                }
                            }
                        }
                    }
                }
                if (drv.Row.Table.Columns.Contains("SCAName") && drv.Row.Table.Columns.Contains("ArmsUrl"))
                {
                    if (e.Item.ItemType == ListItemType.Item ||
                        e.Item.ItemType == ListItemType.AlternatingItem)
                    {
                        foreach (TableCell cell in e.Item.Cells)
                        {
                            foreach (Control controlItem in cell.Controls)
                            {
                                if (controlItem is HyperLink)
                                {
                                    bool EditedCell = false;
                                    HyperLink personLink = (HyperLink)controlItem;
                                    if (personLink.Text == drv["SCAName"].ToString()
                                        && !drv["ArmsUrl"].Equals(DBNull.Value))
                                    {
                                        Literal litSpace = new Literal();
                                        litSpace.Text = "&nbsp;";
                                        Image armsIcon = new Image();
                                        armsIcon.ImageUrl = ControlPath + "sheild_icon.gif";
                                        armsIcon.AlternateText = "This person has a display of Arms in the record";
                                        cell.Controls.Add(litSpace);
                                        cell.Controls.Add(armsIcon);
                                        EditedCell = true;
                                    }
                                    if (personLink.Text == drv["SCAName"].ToString()
                                        && !drv["PhotoUrl"].Equals(DBNull.Value) &&
                                        drv["ShowPicPermission"].Equals(true))
                                    {
                                        Literal litSpace = new Literal();
                                        litSpace.Text = "&nbsp;";
                                        Image photoIcon = new Image();
                                        photoIcon.ImageUrl = ControlPath + "photo_icon.gif";
                                        photoIcon.AlternateText = "This person has a personal photo in the record";
                                        cell.Controls.Add(litSpace);
                                        cell.Controls.Add(photoIcon);
                                        EditedCell = true;
                                    }
                                    if (personLink.Text == drv["SCAName"].ToString() && newQueryString["ff"] == "b")
                                    //Search was for blazon - so display it...
                                    {
                                        Literal litBr = new Literal();
                                        litBr.Text = "<br />";
                                        Literal litBlazon = new Literal();
                                        litBlazon.Text = "<em>" +
                                                         Regex.Replace(drv["ArmsBlazon"].ToString(),
                                                                       "(?<filter>" + newQueryString["f"] + ")",
                                                                       "<strong>${filter}</strong>",
                                                                       RegexOptions.IgnoreCase) + "</em>";
                                        cell.Controls.Add(litBr);
                                        cell.Controls.Add(litBlazon);
                                        EditedCell = true;
                                    }
                                    if (drv.Row.Table.Columns.Contains("HighestAwardName")
                                        && personLink.Text == drv["HighestAwardName"].ToString()
                                        && drv["HighestAwardId"].Equals(-1))
                                    {
                                        personLink.NavigateUrl =
                                            Globals.NavigateURL(TabId, "", "cid=" + drv["CrownId"]);
                                        EditedCell = true;
                                    }
                                    if (EditedCell) break;
                                }
                            }
                            if (cell.Text == "999999")
                            {
                                cell.Text = "Unranked";
                            }
                        }
                    }
                }
            }
        }

        #endregion

        #region rptResultList_ItemDataBound

        private bool petStartFound = false;

        private void rptResultList_ItemDataBound(object sender, RepeaterItemEventArgs e)
        {
            if (e.Item.DataItem is DataRowView)
            {
                DataRowView drv = (DataRowView)e.Item.DataItem;
                HtmlGenericControl divContainer = (HtmlGenericControl)e.Item.FindControl("divContainer");
                HtmlGenericControl spanName = (HtmlGenericControl)e.Item.FindControl("spanSCAName");
                HtmlGenericControl spanArmsBlazon = (HtmlGenericControl)e.Item.FindControl("spanArmsBlazon");
                HtmlGenericControl spanBranchResidence = (HtmlGenericControl)e.Item.FindControl("spanBranchResidence");
                HyperLink branchResidenceLink = (HyperLink)e.Item.FindControl("hlBranchResidence");

                if (drv["Gender"].ToString() == "P" && !petStartFound)
                {
                    petStartFound = true;
                    Literal breakControl = new Literal();
                    breakControl.Text =
                        "<div class=\"ListTitle\" style=\"clear:both;\">Pets and Animal Companions</div>";
                    e.Item.Controls.AddAt(0, breakControl);
                }

                branchResidenceLink.NavigateUrl = Globals.NavigateURL(TabId, "", "gid=" + drv["BranchResidenceId"]);
                branchResidenceLink.Text = drv["BranchResidence"].ToString();
                HyperLink link = (HyperLink)e.Item.FindControl("hlResultLink");
                link.NavigateUrl = Globals.NavigateURL(TabId, "", "memid=" + drv["PeopleId"]);

                spanName.InnerText = drv["SCAName"].ToString();
                spanArmsBlazon.InnerText = drv["ArmsBlazon"].ToString();

                Image imgPhoto = (Image)e.Item.FindControl("imgResultPersonalPic");
                int divWidth = 2; //border
                int divHeight = 60;
                int addlHeight = 0;
                if ((bool)drv["ShowPicPermission"]
                    && !string.IsNullOrEmpty(drv["PhotoURL"].ToString())
                    && newQueryString["dp"] == "1")
                {
                    imgPhoto.Visible = true;
                    imgPhoto.ImageUrl = drv["PhotoURL"].ToString();
                    if (imgPhoto.ImageUrl.IndexOf("://") == -1)
                        imgPhoto.ImageUrl = BasePortalHttpAddress + BasePortalInfo.HomeDirectory + imgPhoto.ImageUrl;
                    imgPhoto.Height = ((int)drv["PhotoURLHeight"] == 0 ? Unit.Empty : (int)drv["PhotoURLHeight"]);
                    imgPhoto.Width = ((int)drv["PhotoURLWidth"] == 0 ? Unit.Empty : (int)drv["PhotoURLWidth"]);
                    imgPhoto.AlternateText = "Image of " + spanName.InnerText;
                    divWidth += 150;
                    addlHeight = 150;
                }
                else if (newQueryString["dp"] == "1")
                {
                    imgPhoto.Visible = true;
                    imgPhoto.ImageUrl = TemplateSourceDirectory + "/nophoto.gif";

                    imgPhoto.Height = 145;
                    imgPhoto.Width = 145;
                    imgPhoto.AlternateText = "No Image of " + spanName.InnerText + " available";
                    divWidth += 150;
                    addlHeight = 150;
                }
                else
                {
                    imgPhoto.Visible = false;
                }

                Image imgDevice = (Image)e.Item.FindControl("imgResultMemberArms");

                if (!string.IsNullOrEmpty(drv["ArmsURL"].ToString())
                    && newQueryString["dd"] == "1")
                {
                    imgDevice.ImageUrl = drv["ArmsURL"].ToString();
                    if (imgDevice.ImageUrl.IndexOf("://") == -1)
                        imgDevice.ImageUrl = BasePortalHttpAddress + BasePortalInfo.HomeDirectory + imgDevice.ImageUrl;
                    imgDevice.Height = ((int)drv["ArmsURLHeight"] == 0 ? Unit.Empty : (int)drv["ArmsURLHeight"]);
                    imgDevice.Width = ((int)drv["ArmsURLWidth"] == 0 ? Unit.Empty : (int)drv["ArmsURLWidth"]);
                    imgDevice.AlternateText = "Arms of " + spanName.InnerText + ": " + spanArmsBlazon.InnerText;
                    divWidth += 200;
                    addlHeight = 250;
                }
                else if (newQueryString["dd"] == "1")
                {
                    imgDevice.ImageUrl = TemplateSourceDirectory + "/nodevice.gif";
                    imgDevice.Height = 200;
                    imgDevice.Width = 164;
                    imgDevice.AlternateText = "Personal Arms Image not available.";
                    divWidth += 200;
                    addlHeight = 250;
                }
                else
                    imgDevice.Visible = false;
                if (newQueryString["dd"] == "1" || newQueryString["ff"] == "b")
                {
                    spanArmsBlazon.Visible = true;
                    divHeight += 25;
                    if (divWidth < 225)
                        divHeight += 30;
                }
                else
                    spanArmsBlazon.Visible = false;

                if (newQueryString["drr"] == "1")
                {
                    spanBranchResidence.Visible = true;
                }
                else
                    spanBranchResidence.Visible = false;

                divHeight += addlHeight;
                divContainer.Style.Add("height", divHeight + "px");
                divContainer.Style.Add("width", divWidth + "px");
            }
        }

        #endregion

        #region gvOffices_RowDataBound

        void gvOffices_RowCreated(object sender, GridViewRowEventArgs e)
        {
            if (e.Row.RowType == DataControlRowType.Header)
            {
                foreach (TableCell cell in e.Row.Cells)
                {
                    gvOfficesColumnsByHeader.Add(cell.Text, e.Row.Cells.GetCellIndex(cell));
                }
            }
        }


        private void gvOffices_RowDataBound(object sender, GridViewRowEventArgs e)
        {
            if (e.Row.RowType == DataControlRowType.DataRow)
            {
                //Disable link to atenveldt.
                DataRowView drv = (DataRowView)e.Row.DataItem;
                if (Convert.ToInt32(drv["GroupId"]) == 26) //TODO: Get rid of hard codes for atenveldt.
                {

                    TableCell cell = e.Row.Cells[gvOfficesColumnsByHeader["Group"]];
                    HyperLink groupLink = (HyperLink)cell.FindControl("hlGroup");
                    if (groupLink.Text == drv["GroupName"].ToString())
                    {
                        Label groupLabel = new Label();
                        groupLabel.Text = groupLink.Text;
                        cell.Controls.AddAt(cell.Controls.IndexOf(groupLink), groupLabel);
                        cell.Controls.Remove(groupLink);
                    }
                }
                if (Convert.ToBoolean(drv["RulingOffice"]))
                {
                    TableCell cell = e.Row.Cells[gvOfficesColumnsByHeader["Office"]];
                    Label lblTitle = (Label)e.Row.FindControl("lblTitle");
                    lblTitle.Visible = false;
                    HyperLink hlTitle = new HyperLink();
                    hlTitle.Text = lblTitle.Text;
                    hlTitle.NavigateUrl = Globals.NavigateURL(TabId, "", "cid=" + drv["ID"]);
                    cell.Controls.AddAt(0, hlTitle);
                }

                bool OfficeIsCurrent = false;
                if ((!(drv["StartDate"] is DBNull) && !(drv["EndDate"] is DBNull) &&
                     DateTime.Today > Convert.ToDateTime(drv["StartDate"]) &&
                     DateTime.Today < Convert.ToDateTime(drv["EndDate"])) || // Between start and end
                    (!(drv["StartDate"] is DBNull) && (drv["EndDate"] is DBNull) &&
                     Convert.ToBoolean(drv["CurrentlyHeld"]) && DateTime.Today > Convert.ToDateTime(drv["StartDate"]))
                    // its now after start date, no end date but marked currently held
                    )

                    OfficeIsCurrent = true;
                Label lblOfficeEmail = (Label)e.Row.FindControl("lblOfficeEmail");
                if (OfficeIsCurrent)
                {
                    switch (((DataRowView)e.Row.DataItem)["EmailToUse"].ToString())
                    {
                        case "OfficePosition":
                            lblOfficeEmail.Text =
                                HtmlUtils.FormatEmail(((DataRowView)e.Row.DataItem)["OfficeEmail"].ToString());
                            break;
                        case "Override":
                            lblOfficeEmail.Text =
                                HtmlUtils.FormatEmail(((DataRowView)e.Row.DataItem)["EmailOverride"].ToString());
                            break;
                        default:
                            if (lblEmail.Visible)
                                lblOfficeEmail.Text = lblEmail.Text;
                            else
                                lblOfficeEmail.Visible = false;
                            break;
                    }
                }
                else
                    lblOfficeEmail.Visible = false;
            }
        }

        #endregion

        #region dgAwardsSameName_ItemDataBound

        private void dgAwardsSameName_ItemDataBound(object sender, DataGridItemEventArgs e)
        {
            if (e.Item.ItemType == ListItemType.Item ||
                e.Item.ItemType == ListItemType.AlternatingItem)
            {
                ((HyperLink)e.Item.FindControl("hlAwardGroups")).NavigateUrl =
                    Globals.NavigateURL(TabId, "", "aid=" + ((DataRowView)e.Item.DataItem)["AwardId"]);
            }
            if (e.Item.ItemType == ListItemType.Footer)
            {
                ((HyperLink)e.Item.FindControl("hlAllGroups")).NavigateUrl =
                    Globals.NavigateURL(TabId, "", "aid=" + newQueryString["aid"], "allgroups=1");
            }
        }

        private void dgAwardsSameName_AwardGroup_ItemDataBound(object sender, DataGridItemEventArgs e)
        {
            if (e.Item.ItemType == ListItemType.Item ||
                e.Item.ItemType == ListItemType.AlternatingItem)
            {
                ((HyperLink)e.Item.FindControl("hlAwardGroups")).NavigateUrl =
                    Globals.NavigateURL(TabId, "", "gaid=" + ((DataRowView)e.Item.DataItem)["AwardId"]);
            }
            if (e.Item.ItemType == ListItemType.Footer)
            {
                ((HyperLink)e.Item.FindControl("hlAllGroups")).NavigateUrl =
                    Globals.NavigateURL(TabId, "", "gaid=" + newQueryString["gaid"], "allgroups=1");
            }
        }

        #endregion
    }
}