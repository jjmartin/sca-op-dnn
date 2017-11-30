using System;
using System.Data;
using System.Linq;
using System.Web.UI;
using System.Web.UI.WebControls;
using DotNetNuke.Common;
using DotNetNuke.Common.Utilities;
using DotNetNuke.Entities.Modules;
using DotNetNuke.Entities.Modules.Actions;
using DotNetNuke.Framework;
using DotNetNuke.Security;
using DotNetNuke.Services.Exceptions;
using JeffMartin.DNN.Modules.SCAOnlineOP.Data;
using JeffMartin.ScaData;
using Calendar = DotNetNuke.Common.Utilities.Calendar;


namespace JeffMartin.DNN.Modules.SCAOnlineOP
{
    partial class SCAOnlineOPEdit : PortalModuleBase, IActionable
    {

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

                return Actions;
            }
        }
        #region Private Members

        private int memid;

        #endregion

        #region Web Form Designer generated code

        protected override void OnInit(EventArgs e)
        {
            //
            // CODEGEN: This call is required by the ASP.NET Web Form Designer.
            //
            InitializeComponent();
            base.OnInit(e);
            this.Load += new EventHandler(Page_Load);
            this.cmdUpdate.Click += new EventHandler(cmdUpdate_Click);
            this.cmdUpdateAndReturn.Click += new EventHandler(cmdUpdate_Click);
            this.cmdDelete.Click += new EventHandler(cmdDelete_Click);
            this.cmdCancel.Click += new EventHandler(cmdCancel_Click);
            this.cmdResetOPOrder.Click += new EventHandler(cmdResetOPOrder_Click);
            this.dgAliases.ItemCommand += new DataGridCommandEventHandler(dgAliases_ItemCommand);
            this.dgAliases.ItemDataBound += new DataGridItemEventHandler(dgAliases_ItemDataBound);
            this.dgAwards.ItemCommand += new DataGridCommandEventHandler(dgAwards_ItemCommand);
            this.dgAwards.ItemDataBound += new DataGridItemEventHandler(dgAwards_ItemDataBound);
            this.dgOffices.ItemCommand += new DataGridCommandEventHandler(dgOffices_ItemCommand);
            this.dgOffices.ItemDataBound += new DataGridItemEventHandler(dgOffices_ItemDataBound);
        }

        /// <summary>
        ///		Required method for Designer support - do not modify
        ///		the contents of this method with the code editor.
        /// </summary>
        private void InitializeComponent()
        {
        }

        #endregion

        private void Page_Load(object sender, EventArgs e)
        {
            try
            {
                Calendar.InvokePopupCal(txtMemberName);//HACK: this is to make sure the popupcal script is registered even on postbacks... 
                if (!(Request.Params["memid"] == null))
                {
                    memid = Int32.Parse(Request.Params["memid"]);
                }
                else
                {
                    memid = Null.NullInteger;
                }
                if (!Page.IsPostBack)
                {
                    cmdDelete.Attributes.Add("onClick",
                                             "javascript:return confirm('Are you sure you wish to delete this person\\'s Record?\\nThis will delete the person\\'s alias and any awards they have.\\nIf this person is associated with a reign, the reign must be updated.');");
                    BindGroupDDL(ddlResidenceGroupList, "<Unknown>");
                    if (!Null.IsNull(memid))
                    {
                        DisplayMemberInfo(memid);
                        cmdDelete.Visible = true;
                    }
                    urlMemberArms.FileFilter = Globals.glbImageFileTypes;
                    urlPersonalPhoto.FileFilter = Globals.glbImageFileTypes;
                }
                hlNewOffice.NavigateUrl = EditUrl("Office");
                hlNewAward.NavigateUrl = EditUrl("Award");
                hlReturnToDisplay.NavigateUrl = Globals.NavigateURL(TabId, "", "memid=" + memid.ToString());
            }
            catch (Exception exc)
            {
                Exceptions.ProcessModuleLoadException(this, exc);
            }
        }

        private void cmdUpdate_Click(object sender, EventArgs e)
        {
            try
            {
                if (Page.IsValid == true)
                {
                    if (Null.IsNull(memid))
                    {
                        memid = DataProvider.Instance().AddPeople(
                            txtMemberName.Text,
                            txtMundaneName.Text,
                            txtAddress1.Text,
                            txtAddress2.Text,
                            txtCity.Text,
                            txtState.Text,
                            txtZip.Text,
                            txtPhone1.Text,
                            txtPhone2.Text,
                            txtEmailAddress.Text,
                            urlPersonalPhoto.Url,
                            urlMemberArms.Url,
                            txtBlazon.Text,
                            chkShowImagePermissions.Checked,
                            chkShowEmailPermissions.Checked,
                            txtAdminNotes.Text,
                            txtOfficerNotes.Text,
                            ddlGender.SelectedValue,
                            txtTitle.Text,
                            txtSuffix.Text, chkDeceased.Checked,
                            int.Parse(txtDeceasedWhen.Text == string.Empty
                                          ? Null.NullInteger.ToString()
                                          : txtDeceasedWhen.Text),
                            int.Parse(ddlResidenceGroupList.SelectedValue)
                            );
                    }
                    else
                    {
                        DataProvider.Instance().UpdatePeople(
                            memid,
                            txtMemberName.Text,
                            txtMundaneName.Text,
                            txtAddress1.Text,
                            txtAddress2.Text,
                            txtCity.Text,
                            txtState.Text,
                            txtZip.Text,
                            txtPhone1.Text,
                            txtPhone2.Text,
                            txtEmailAddress.Text,
                            urlPersonalPhoto.Url,
                            urlMemberArms.Url,
                            txtBlazon.Text,
                            chkShowImagePermissions.Checked,
                            chkShowEmailPermissions.Checked,
                            txtAdminNotes.Text,
                            txtOfficerNotes.Text,
                            ddlGender.SelectedValue,
                            txtTitle.Text,
                            txtSuffix.Text,
                            chkDeceased.Checked,
                            int.Parse(txtDeceasedWhen.Text == string.Empty
                                          ? Null.NullInteger.ToString()
                                          : txtDeceasedWhen.Text),
                            int.Parse(ddlResidenceGroupList.SelectedValue)
                            );
                    }
                    if (sender == cmdUpdateAndReturn)
                    {
                        if (Request.QueryString["list"] != null)
                        {
                            Response.Redirect(Globals.NavigateURL(TabId, "", "list=" + Request.QueryString["list"],
                                                                  "pg=" + Request.QueryString["pg"],
                                                                  "ps=" + Request.QueryString["ps"],
                                                                  "f=" + Request.QueryString["f"],
                                                                  "t=" + Request.QueryString["t"]
                                                  ),
                                              true);
                        }
                        else
                            Response.Redirect(Globals.NavigateURL(TabId, "", "memid=" + memid.ToString()), true);
                    }
                    else
                    {
                        Response.Redirect(EditUrl("memid", memid.ToString()), true);
                    }
                }
            }
            catch (Exception exc)
            {
                Exceptions.ProcessModuleLoadException(this, exc);
            }
        }

        private void cmdCancel_Click(object sender, EventArgs e)
        {
            try
            {
                if (Request.QueryString["list"] != null)
                {
                    Response.Redirect(Globals.NavigateURL(TabId, "", "list=" + Request.QueryString["list"],
                                                          "pg=" + Request.QueryString["pg"],
                                                          "ps=" + Request.QueryString["ps"],
                                                          "f=" + Request.QueryString["f"]
                                          ),
                                      true);
                }
                else if (memid != Null.NullInteger)
                    Response.Redirect(Globals.NavigateURL(TabId, "", "memid=" + memid.ToString()), true);
                else
                    Response.Redirect(Globals.NavigateURL(), true);
            }
            catch (Exception exc)
            {
                Exceptions.ProcessModuleLoadException(this, exc);
            }
        }

        private void cmdDelete_Click(object sender, EventArgs e)
        {
            try
            {
                if (!Null.IsNull(memid))
                {
                    DataProvider.Instance().DeletePeople(memid);
                }
                Response.Redirect(Globals.NavigateURL(), true);
            }
            catch (Exception exc)
            {
                Exceptions.ProcessModuleLoadException(this, exc);
            }
        }


        private void DisplayMemberInfo(int memid)
        {
            IDataReader dr = DataProvider.Instance().GetPeople(memid);
            //			Hashtable MemberInfo = new Hashtable();
            //			int intFieldCount = dr.FieldCount;
            //			for(int intCounter = 0; intCounter<intFieldCount;intCounter++)
            //			{
            //				MemberInfo.Add(dr.GetName(intCounter), dr[intCounter]);
            //			}
            //			dr.Close();

            //Edit controls
            if (dr.Read())
            {
                //Member Name
                h1MemberName.InnerText = dr["SCAName"].ToString();
                txtMemberName.Text = dr["SCAName"].ToString();

                if (dr.IsDBNull(dr.GetOrdinal("Gender")))
                {
                    ddlGender.SelectedValue = string.Empty;
                }
                else
                {
                    if (ddlGender.Items.FindByValue(dr["Gender"].ToString()) != null)
                        ddlGender.SelectedValue = dr["Gender"].ToString();
                    else
                        ddlGender.SelectedValue = string.Empty;
                }

                if (dr.IsDBNull(dr.GetOrdinal("BranchResidenceId")))
                {
                    ddlResidenceGroupList.SelectedValue = "-1";
                }
                else
                {
                    if (ddlResidenceGroupList.Items.FindByValue(dr["BranchResidenceId"].ToString()) != null)
                        ddlResidenceGroupList.SelectedValue = dr["BranchResidenceId"].ToString();
                    else
                        ddlResidenceGroupList.SelectedValue = string.Empty;
                }
                chkDeceased.Checked = dr.GetBoolean(dr.GetOrdinal("Deceased"));
                txtDeceasedWhen.Text = dr["DeceasedWhen"].ToString();

                //Rank
                litRank.Text = dr["OPNum"].ToString();

                //Email

                chkShowEmailPermissions.Checked = dr.GetBoolean(dr.GetOrdinal("ShowEmailPermission"));
                txtEmailAddress.Text = dr["EmailAddress"].ToString();


                //Arms Image and Blazon

                trBlazon.Visible = true;
                txtBlazon.Text = dr["ArmsBlazon"].ToString();

                imgMemberArms.Visible = true;
                imgMemberArms.ImageUrl = dr["ArmsURL"].ToString();
                if (imgMemberArms.ImageUrl.IndexOf("://") == -1)
                    imgMemberArms.ImageUrl = PortalSettings.HomeDirectory + imgMemberArms.ImageUrl;


                imgMemberArms.Height = (int)dr["ArmsURLHeight"];
                imgMemberArms.Width = (int)dr["ArmsURLWidth"];
                imgMemberArms.AlternateText = "Arms of " + h1MemberName.InnerText + ": " + txtBlazon.Text;
                urlMemberArms.Url = dr["ArmsURL"].ToString();

                //Personal Pic
                chkShowImagePermissions.Checked = dr.GetBoolean(dr.GetOrdinal("ShowPicPermission"));
                imgPersonalPic.Visible = true;
                imgPersonalPic.ImageUrl = dr["PhotoURL"].ToString();
                if (imgPersonalPic.ImageUrl.IndexOf("://") == -1)
                    imgPersonalPic.ImageUrl = PortalSettings.HomeDirectory + imgPersonalPic.ImageUrl;

                imgPersonalPic.Height = (int)dr["PhotoURLHeight"];
                imgPersonalPic.Width = (int)dr["PhotoURLWidth"];
                imgPersonalPic.AlternateText = "Image of " + h1MemberName.InnerText;
                urlPersonalPhoto.Url = dr["PhotoURL"].ToString();

                //Officer info
                txtTitle.Text = dr["TitlePrefix"].ToString();
                txtSuffix.Text = dr["HonorsSuffix"].ToString();
                txtMundaneName.Text = dr["MundaneName"].ToString();
                txtAddress1.Text = dr["Address1"].ToString();
                txtAddress2.Text = dr["Address2"].ToString();
                txtCity.Text = dr["City"].ToString();
                txtState.Text = dr["State"].ToString();
                txtZip.Text = dr["Zip"].ToString();
                txtPhone1.Text = dr["Phone1"].ToString();
                txtPhone2.Text = dr["Phone2"].ToString();
                txtOfficerNotes.Text = dr["OfficerNotes"].ToString();
                txtAdminNotes.Text = dr["AdminNotes"].ToString();
            }
            //Cleanup
            dr.Close();


            //Aliases
            DataTable AliasTable =
                DataProvider.ConvertDataReaderToDataTable(DataProvider.Instance().GetAliasByPeople(memid));
            dgAliases.DataSource = AliasTable;
            dgAliases.DataBind();


            //Awards
            DataTable AwardTable =
                DataProvider.ConvertDataReaderToDataTable(DataProvider.Instance().GetPeopleAwardByPeople(memid));
            //Award Link
            //move this to databinding...

            //Group Link
            ((HyperLinkColumn)dgAwards.Columns[2]).DataNavigateUrlFormatString =
                Globals.NavigateURL(TabId, "", "gid=" + int.MaxValue.ToString()).Replace(int.MaxValue.ToString(), "{0}");
            //Crown Link
            //move this to databinding...

            dgAwards.DataSource = AwardTable;
            dgAwards.DataBind();

            //Offices
            DataTable OfficeTable =
                DataProvider.ConvertDataReaderToDataTable(DataProvider.Instance().GetPeopleCombinedOfficesByPeople(memid));
            //Group Link
            ((HyperLinkColumn)dgOffices.Columns[2]).DataNavigateUrlFormatString =
                Globals.NavigateURL(TabId, "", "gid=" + int.MaxValue.ToString()).Replace(int.MaxValue.ToString(), "{0}");
            dgOffices.DataSource = OfficeTable;
            dgOffices.DataBind();
            ((CDefault)Page).Title += "- Editing " + txtMemberName.Text;
        }

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

        public string FormatYesNo(object CurrentlyHeld)
        {
            bool Current = Convert.ToBoolean(CurrentlyHeld);
            return Current ? "Yes" : "No";
        }

        private void cmdResetOPOrder_Click(object sender, EventArgs e)
        {
            DataProvider.Instance().UpdateAllOPNum();
            Response.Redirect(Globals.NavigateURL(TabId, "", "memid=" + memid.ToString()), true);
        }

        private void dgAliases_ItemCommand(object source, DataGridCommandEventArgs e)
        {
            DataTable AliasTable;
            switch (e.CommandName)
            {
                case "Edit":
                    AliasTable =
                        DataProvider.ConvertDataReaderToDataTable(DataProvider.Instance().GetAliasByPeople(memid));
                    dgAliases.EditItemIndex = e.Item.ItemIndex;
                    dgAliases.ShowFooter = false;
                    dgAliases.Visible = true;
                    dgAliases.DataSource = AliasTable;
                    dgAliases.DataBind();
                    break;
                case "Add":
                    DataProvider.Instance().AddAlias(
                        memid,
                        ((TextBox)e.Item.FindControl("txtAdd_SCAName")).Text,
                        ((CheckBox)e.Item.FindControl("chkAdd_Registered")).Checked,
                        ((CheckBox)e.Item.FindControl("chkAdd_Preferred")).Checked
                        );
                    AliasTable =
                        DataProvider.ConvertDataReaderToDataTable(DataProvider.Instance().GetAliasByPeople(memid));
                    dgAliases.DataSource = AliasTable;
                    dgAliases.DataBind();
                    break;
                case "Update":
                    DataProvider.Instance().UpdateAlias(
                        Convert.ToInt32(e.Item.Cells[0].Text),
                        memid,
                        ((TextBox)e.Item.FindControl("txtEdit_SCAName")).Text,
                        ((CheckBox)e.Item.FindControl("chkEdit_Registered")).Checked,
                        ((CheckBox)e.Item.FindControl("chkEdit_Preferred")).Checked
                        );
                    AliasTable =
                        DataProvider.ConvertDataReaderToDataTable(DataProvider.Instance().GetAliasByPeople(memid));
                    dgAliases.DataSource = AliasTable;
                    dgAliases.ShowFooter = true;
                    dgAliases.EditItemIndex = -1;
                    dgAliases.DataBind();

                    break;
                case "Cancel":
                    AliasTable =
                        DataProvider.ConvertDataReaderToDataTable(DataProvider.Instance().GetAliasByPeople(memid));
                    dgAliases.DataSource = AliasTable;
                    dgAliases.ShowFooter = true;
                    dgAliases.EditItemIndex = -1;
                    dgAliases.DataBind();
                    break;
                case "Delete":
                    DataProvider.Instance().DeleteAlias(Convert.ToInt32(e.Item.Cells[0].Text));
                    AliasTable =
                        DataProvider.ConvertDataReaderToDataTable(DataProvider.Instance().GetAliasByPeople(memid));
                    dgAliases.DataSource = AliasTable;
                    dgAliases.ShowFooter = true;
                    dgAliases.EditItemIndex = -1;
                    dgAliases.DataBind();
                    break;
            }
        }

        private void dgAwards_ItemCommand(object source, DataGridCommandEventArgs e)
        {
            DataTable AwardTable;
            DateTime date = Null.NullDate;
            switch (e.CommandName)
            {
                case "Edit":
                    AwardTable =
                        DataProvider.ConvertDataReaderToDataTable(DataProvider.Instance().GetPeopleAwardByPeople(memid));
                    dgAwards.EditItemIndex = e.Item.ItemIndex;
                    dgAwards.ShowFooter = false;
                    dgAwards.Visible = true;
                    dgAwards.DataSource = AwardTable;
                    dgAwards.DataBind();
                    //DropDownLists Set during Databind Event
                    break;
                case "Add":
                    date =
                        DateTime.Parse(((TextBox)e.Item.FindControl("txtAdd_Date")).Text + " " +
                                       ((DropDownList)e.Item.FindControl("ddlAdd_Hours")).SelectedValue);
                    DataProvider.Instance().AddPeopleAward(
                        Convert.ToInt32(((DropDownList)e.Item.FindControl("ddlAdd_Award")).SelectedValue),
                        memid,
                        date,
                        Convert.ToInt32(((DropDownList)e.Item.FindControl("ddlAdd_GivenBy")).SelectedValue),
                        ((TextBox)e.Item.FindControl("txtAdd_Notes")).Text,
                        Convert.ToInt32(((DropDownList)e.Item.FindControl("ddlAdd_AliasId")).SelectedValue),
                        ((CheckBox)e.Item.FindControl("chkAdd_Retired")).Checked
                        );
                    DataProvider.Instance().UpdateAllOPNum();
                    Response.Redirect(EditUrl("memid", memid.ToString()), true);
                    break;
                case "Update":
                    date =
                        DateTime.Parse(((TextBox)e.Item.FindControl("txtEdit_Date")).Text + " " +
                                       ((DropDownList)e.Item.FindControl("ddlEdit_Hours")).SelectedValue);
                    DataProvider.Instance().UpdatePeopleAward(
                        Convert.ToInt32(e.Item.Cells[0].Text),
                        Convert.ToInt32(((DropDownList)e.Item.FindControl("ddlEdit_Award")).SelectedValue),
                        memid,
                        date,
                        Convert.ToInt32(((DropDownList)e.Item.FindControl("ddlEdit_GivenBy")).SelectedValue),
                        ((TextBox)e.Item.FindControl("txtEdit_Notes")).Text,
                        Convert.ToInt32(((DropDownList)e.Item.FindControl("ddlEdit_AliasId")).SelectedValue),
                        ((CheckBox)e.Item.FindControl("chkEdit_Retired")).Checked
                        );
                    DataProvider.Instance().UpdateAllOPNum();
                    Response.Redirect(EditUrl("memid", memid.ToString()), true);

                    break;
                case "Cancel":
                    AwardTable =
                        DataProvider.ConvertDataReaderToDataTable(DataProvider.Instance().GetPeopleAwardByPeople(memid));
                    dgAwards.DataSource = AwardTable;
                    dgAwards.ShowFooter = true;
                    dgAwards.EditItemIndex = -1;
                    dgAwards.DataBind();
                    break;
                case "Delete":
                    DataProvider.Instance().DeletePeopleAward(Convert.ToInt32(e.Item.Cells[0].Text));
                    Response.Redirect(EditUrl("memid", memid.ToString()), true);
                    break;
            }
        }

        private void dgAwards_ItemDataBound(object sender, DataGridItemEventArgs e)
        {
            LinkButton cmdDeleteAward = (LinkButton)e.Item.FindControl("cmdDeleteAward");
            if (cmdDeleteAward != null)
            {
                cmdDeleteAward.Attributes.Add("onClick", "javascript:return confirm('Confirm Delete.');");
            }
            if (e.Item.ItemType == ListItemType.EditItem)
            {
                DropDownList ddlEdit_Award = (DropDownList)e.Item.FindControl("ddlEdit_Award");
                DropDownList ddlEdit_Group = (DropDownList)e.Item.FindControl("ddlEdit_Group");
                DropDownList ddlEdit_GivenBy = (DropDownList)e.Item.FindControl("ddlEdit_GivenBy");
                DropDownList ddlEdit_AliasId = (DropDownList)e.Item.FindControl("ddlEdit_AliasId");
                HyperLink hlEdit_Calendar = (HyperLink)e.Item.FindControl("hlEdit_Calendar");
                TextBox txtEdit_Date = (TextBox)e.Item.FindControl("txtEdit_Date");
                DropDownList ddlEdit_Hours = (DropDownList)e.Item.FindControl("ddlEdit_Hours");

                BindGroupDDL(ddlEdit_Group, "<Select a group to get awards>", groupFilter.Awards);

                if (ddlEdit_Group.Items.FindByValue(((DataRowView)e.Item.DataItem)["GroupId"].ToString()) != null)
                    ddlEdit_Group.SelectedValue = ((DataRowView)e.Item.DataItem)["GroupId"].ToString();

                BindAwardDDL(ddlEdit_Award, ddlEdit_Group.SelectedValue);

                if (ddlEdit_Award.Items.FindByValue(((DataRowView)e.Item.DataItem)["AwardId"].ToString()) != null)
                    ddlEdit_Award.SelectedValue = ((DataRowView)e.Item.DataItem)["AwardId"].ToString();

                BindGivenByDDL(ddlEdit_GivenBy, ddlEdit_Group.SelectedValue);
                BindAliasDDL(ddlEdit_AliasId);
                BindHoursDDL(ddlEdit_Hours);


                if (ddlEdit_Award.Items.FindByValue(((DataRowView)e.Item.DataItem)["AwardId"].ToString()) != null)
                    ddlEdit_Award.SelectedValue = ((DataRowView)e.Item.DataItem)["AwardId"].ToString();

                if (ddlEdit_GivenBy.Items.FindByValue(((DataRowView)e.Item.DataItem)["CrownId"].ToString()) != null)
                    ddlEdit_GivenBy.SelectedValue = ((DataRowView)e.Item.DataItem)["CrownId"].ToString();

                if (ddlEdit_AliasId.Items.FindByValue(((DataRowView)e.Item.DataItem)["AliasId"].ToString()) != null)
                    ddlEdit_AliasId.SelectedValue = ((DataRowView)e.Item.DataItem)["AliasId"].ToString();

                DateTime date = (DateTime)((DataRowView)e.Item.DataItem)["Date"];
                if (ddlEdit_Hours.Items.FindByValue(date.Hour.ToString() + ":00") != null)
                    ddlEdit_Hours.SelectedValue = date.Hour.ToString() + ":00";


                hlEdit_Calendar.NavigateUrl = Calendar.InvokePopupCal(txtEdit_Date);
            }
            else if (e.Item.ItemType == ListItemType.Item ||
                     e.Item.ItemType == ListItemType.AlternatingItem)
            {
                ((HyperLink)e.Item.FindControl("hlAward")).NavigateUrl = Globals.NavigateURL(TabId, "",
                                                                                              "aid=" +
                                                                                              ((DataRowView)
                                                                                               e.Item.DataItem)[
                                                                                                  "AwardId"].ToString());
                ((HyperLink)e.Item.FindControl("hlCrown")).NavigateUrl = Globals.NavigateURL(TabId, "",
                                                                                              "cid=" +
                                                                                              ((DataRowView)
                                                                                               e.Item.DataItem)[
                                                                                                  "CrownId"].ToString());
            }
            else if (e.Item.ItemType == ListItemType.Footer)
            {
                DropDownList ddlAdd_Award = (DropDownList)e.Item.FindControl("ddlAdd_Award");
                DropDownList ddlAdd_Group = (DropDownList)e.Item.FindControl("ddlAdd_Group");
                DropDownList ddlAdd_GivenBy = (DropDownList)e.Item.FindControl("ddlAdd_GivenBy");
                DropDownList ddlAdd_AliasId = (DropDownList)e.Item.FindControl("ddlAdd_AliasId");
                HyperLink hlAdd_Calendar = (HyperLink)e.Item.FindControl("hlAdd_Calendar");
                TextBox txtAdd_Date = (TextBox)e.Item.FindControl("txtAdd_Date");
                DropDownList ddlAdd_Hours = (DropDownList)e.Item.FindControl("ddlAdd_Hours");

                BindGroupDDL(ddlAdd_Group, "<Select a group to get awards>");
                BindAwardDDL(ddlAdd_Award, ddlAdd_Group.SelectedValue);

                BindGivenByDDL(ddlAdd_GivenBy, ddlAdd_Group.SelectedValue);
                BindAliasDDL(ddlAdd_AliasId);
                BindHoursDDL(ddlAdd_Hours);
                hlAdd_Calendar.NavigateUrl = Calendar.InvokePopupCal(txtAdd_Date);
            }
        }

        private void dgOffices_ItemCommand(object source, DataGridCommandEventArgs e)
        {
            DataTable OfficeTable;
            DateTime startDate = Null.NullDate;
            DateTime endDate = Null.NullDate;
            string PositionSubTitle = Null.NullString;
            string PositionNotes = Null.NullString;
            string VerifiedNotes = Null.NullString;
            string EmailToUse = Null.NullString;
            string EmailOverride = Null.NullString;
            int CrownId = Null.NullInteger;
            DropDownList ddlOfficePosition;
            switch (e.CommandName)
            {
                case "Edit":
                    OfficeTable =
                        DataProvider.ConvertDataReaderToDataTable(
                            DataProvider.Instance().GetPeopleCombinedOfficesByPeople(memid));
                    dgOffices.EditItemIndex = e.Item.ItemIndex;
                    dgOffices.ShowFooter = false;
                    dgOffices.Visible = true;
                    dgOffices.DataSource = OfficeTable;
                    dgOffices.DataBind();
                    //DropDownLists Set during Databind Event
                    break;
                case "Add":
                    if (((TextBox)e.Item.FindControl("txtAdd_StartDate")).Text.Trim() != string.Empty)
                        startDate = DateTime.Parse(((TextBox)e.Item.FindControl("txtAdd_StartDate")).Text.Trim());
                    if (((TextBox)e.Item.FindControl("txtAdd_EndDate")).Text.Trim() != string.Empty)
                        endDate = DateTime.Parse(((TextBox)e.Item.FindControl("txtAdd_EndDate")).Text.Trim());
                    if (((TextBox)e.Item.FindControl("txtAdd_PositionSubTitle")).Text.Trim() != string.Empty)
                        PositionSubTitle = ((TextBox)e.Item.FindControl("txtAdd_PositionSubTitle")).Text.Trim();
                    if (((TextBox)e.Item.FindControl("txtAdd_PositionNotes")).Text.Trim() != string.Empty)
                        PositionNotes = ((TextBox)e.Item.FindControl("txtAdd_PositionNotes")).Text.Trim();
                    if (((TextBox)e.Item.FindControl("txtAdd_VerifiedNotes")).Text.Trim() != string.Empty)
                        VerifiedNotes = ((TextBox)e.Item.FindControl("txtAdd_VerifiedNotes")).Text.Trim();
                    EmailToUse = ((DropDownList)e.Item.FindControl("ddlAdd_EmailToUse")).SelectedValue;
                    if (((TextBox)e.Item.FindControl("txtAdd_EmailOverride")).Text.Trim() != string.Empty)
                        EmailOverride = ((TextBox)e.Item.FindControl("txtAdd_EmailOverride")).Text.Trim();
                    ddlOfficePosition = (DropDownList)e.Item.FindControl("ddlAdd_OfficePosition");
                    if (e.Item.FindControl("phCrown").Visible)
                    {
                        CrownId = Convert.ToInt32(((DropDownList)e.Item.FindControl("ddlAdd_Crown")).SelectedValue);
                    }
                    DataProvider.Instance().AddPeopleOfficer(
                        memid,
                        Convert.ToInt32(ddlOfficePosition.SelectedValue),
                        startDate,
                        endDate,
                        ((CheckBox)e.Item.FindControl("chkAdd_Current")).Checked,
                        ((CheckBox)e.Item.FindControl("chkAdd_Acting")).Checked,
                        ((CheckBox)e.Item.FindControl("chkAdd_Verified")).Checked,
                        PositionSubTitle,
                        PositionNotes, EmailToUse, EmailOverride, VerifiedNotes, CrownId);
                    OfficeTable =
                        DataProvider.ConvertDataReaderToDataTable(
                            DataProvider.Instance().GetPeopleCombinedOfficesByPeople(memid));
                    dgOffices.DataSource = OfficeTable;
                    dgOffices.DataBind();
                    break;
                case "Update":
                    if (((TextBox)e.Item.FindControl("txtEdit_StartDate")).Text.Trim() != string.Empty)
                        startDate = DateTime.Parse(((TextBox)e.Item.FindControl("txtEdit_StartDate")).Text);
                    if (((TextBox)e.Item.FindControl("txtEdit_EndDate")).Text.Trim() != string.Empty)
                        endDate = DateTime.Parse(((TextBox)e.Item.FindControl("txtEdit_EndDate")).Text);
                    if (((TextBox)e.Item.FindControl("txtEdit_PositionSubTitle")).Text.Trim() != string.Empty)
                        PositionSubTitle = ((TextBox)e.Item.FindControl("txtEdit_PositionSubTitle")).Text;
                    if (((TextBox)e.Item.FindControl("txtEdit_PositionNotes")).Text.Trim() != string.Empty)
                        PositionNotes = ((TextBox)e.Item.FindControl("txtEdit_PositionNotes")).Text;
                    if (((TextBox)e.Item.FindControl("txtEdit_VerifiedNotes")).Text.Trim() != string.Empty)
                        VerifiedNotes = ((TextBox)e.Item.FindControl("txtEdit_VerifiedNotes")).Text.Trim();
                    EmailToUse = ((DropDownList)e.Item.FindControl("ddlEdit_EmailToUse")).SelectedValue;
                    if (((TextBox)e.Item.FindControl("txtEdit_EmailOverride")).Text.Trim() != string.Empty)
                        EmailOverride = ((TextBox)e.Item.FindControl("txtEdit_EmailOverride")).Text.Trim();
                    ddlOfficePosition = (DropDownList)e.Item.FindControl("ddlEdit_OfficePosition");
                    if (e.Item.FindControl("phCrown").Visible)
                    {
                        CrownId = Convert.ToInt32(((DropDownList)e.Item.FindControl("ddlEdit_Crown")).SelectedValue);
                    }
                    DataProvider.Instance().UpdatePeopleOfficer(
                        Convert.ToInt32(e.Item.Cells[0].Text),
                        memid,
                        Convert.ToInt32(ddlOfficePosition.SelectedValue),
                        startDate,
                        endDate,
                        ((CheckBox)e.Item.FindControl("chkEdit_Current")).Checked,
                        ((CheckBox)e.Item.FindControl("chkEdit_Acting")).Checked,
                        ((CheckBox)e.Item.FindControl("chkEdit_Verified")).Checked,
                        PositionSubTitle,
                        PositionNotes, EmailToUse, EmailOverride, VerifiedNotes, CrownId
                        );
                    OfficeTable =
                        DataProvider.ConvertDataReaderToDataTable(
                            DataProvider.Instance().GetPeopleCombinedOfficesByPeople(memid));
                    dgOffices.DataSource = OfficeTable;
                    dgOffices.ShowFooter = true;
                    dgOffices.EditItemIndex = -1;
                    dgOffices.DataBind();

                    break;
                case "Cancel":
                    OfficeTable =
                        DataProvider.ConvertDataReaderToDataTable(
                            DataProvider.Instance().GetPeopleCombinedOfficesByPeople(memid));
                    dgOffices.DataSource = OfficeTable;
                    dgOffices.ShowFooter = true;
                    dgOffices.EditItemIndex = -1;
                    dgOffices.DataBind();
                    break;
                case "Delete":
                    DataProvider.Instance().DeletePeopleOfficer(Convert.ToInt32(e.Item.Cells[0].Text));
                    OfficeTable =
                        DataProvider.ConvertDataReaderToDataTable(
                            DataProvider.Instance().GetPeopleCombinedOfficesByPeople(memid));
                    dgOffices.DataSource = OfficeTable;
                    dgOffices.ShowFooter = true;
                    dgOffices.EditItemIndex = -1;
                    dgOffices.DataBind();
                    break;
            }
        }

        private void dgOffices_ItemDataBound(object sender, DataGridItemEventArgs e)
        {
            LinkButton cmdDeleteOfficer = (LinkButton)e.Item.FindControl("cmdDeleteOfficer");
            if (cmdDeleteOfficer != null)
            {
                cmdDeleteOfficer.Attributes.Add("onClick", "javascript:return confirm('Confirm Delete.');");
            }

            if (e.Item.ItemType == ListItemType.EditItem)
            {
                DropDownList ddlEdit_Group = (DropDownList)e.Item.FindControl("ddlEdit_Group");
                DropDownList ddlEdit_EmailToUse = (DropDownList)e.Item.FindControl("ddlEdit_EmailToUse");
                DropDownList ddlEdit_OfficePosition = (DropDownList)e.Item.FindControl("ddlEdit_OfficePosition");
                HyperLink hlEdit_StartDateCalendar = (HyperLink)e.Item.FindControl("hlEdit_StartDateCalendar");
                HyperLink hlEdit_EndDateCalendar = (HyperLink)e.Item.FindControl("hlEdit_EndDateCalendar");
                TextBox txtEdit_StartDate = (TextBox)e.Item.FindControl("txtEdit_StartDate");
                TextBox txtEdit_EndDate = (TextBox)e.Item.FindControl("txtEdit_EndDate");
                TextBox txtEdit_PositionSubTitle = (TextBox)e.Item.FindControl("txtEdit_PositionSubTitle");
                TextBox txtEdit_PositionNotes = (TextBox)e.Item.FindControl("txtEdit_PositionNotes");
                DropDownList ddlEdit_Crown = (DropDownList)e.Item.FindControl("ddlEdit_Crown");
                ddlEdit_Crown.Visible = Convert.ToBoolean(((DataRowView)e.Item.DataItem)["LinkedToCrown"]);

                BindGroupDDL(ddlEdit_Group, "<Select a group to list Offices>", groupFilter.Offices);
                if (
                   ddlEdit_Group.Items.FindByValue(
                       ((DataRowView)e.Item.DataItem)["GroupId"].ToString()) != null)
                    ddlEdit_Group.SelectedValue =
                        ((DataRowView)e.Item.DataItem)["GroupId"].ToString();
                BindOfficeDDL(ddlEdit_OfficePosition, ddlEdit_Group.SelectedValue);
                if (
                   ddlEdit_OfficePosition.Items.FindByValue(
                       ((DataRowView)e.Item.DataItem)["OfficerPositionId"].ToString()) != null)
                    ddlEdit_OfficePosition.SelectedValue =
                        ((DataRowView)e.Item.DataItem)["OfficerPositionId"].ToString();
                SetCrownDdlVisibility(ddlEdit_OfficePosition);
                BindCrownDDL(ddlEdit_Crown, ddlEdit_Group.SelectedValue);
                if (
                   ddlEdit_Crown.Items.FindByValue(
                       ((DataRowView)e.Item.DataItem)["LinkedCrownId"].ToString()) != null)
                    ddlEdit_Crown.SelectedValue =
                        ((DataRowView)e.Item.DataItem)["LinkedCrownId"].ToString();

                if (
                   ddlEdit_EmailToUse.Items.FindByValue(
                       ((DataRowView)e.Item.DataItem)["EmailToUse"].ToString()) != null)
                    ddlEdit_EmailToUse.SelectedValue =
                        ((DataRowView)e.Item.DataItem)["EmailToUse"].ToString();
            }
            else if (e.Item.ItemType == ListItemType.Item ||
                     e.Item.ItemType == ListItemType.AlternatingItem)
            {
                ((LinkButton)e.Item.FindControl("cmdEditOfficer")).Visible =
                    !Null.IsNull(((DataRowView)e.Item.DataItem)["OfficerPositionId"]);
                cmdDelete.Visible = !Null.IsNull(((DataRowView)e.Item.DataItem)["OfficerPositionId"]);
                if (Null.IsNull(((DataRowView)e.Item.DataItem)["OfficerPositionId"]))
                {
                    HyperLink hlEditCrown = new HyperLink();
                    hlEditCrown.Text = "Edit Crown";
                    hlEditCrown.NavigateUrl = EditUrl("cid", ((DataRowView)e.Item.DataItem)["ID"].ToString(), "crown");
                    ((LinkButton)e.Item.FindControl("cmdEditOfficer")).Parent.Controls.Add(hlEditCrown);
                }
                HyperLink hlEmail = (HyperLink)e.Item.FindControl("hlEmail");
                switch (((DataRowView)e.Item.DataItem)["EmailToUse"].ToString())
                {
                    case "OfficePosition":
                        hlEmail.NavigateUrl = "mailto:" + ((DataRowView)e.Item.DataItem)["OfficeEmail"].ToString();
                        hlEmail.Text = ((DataRowView)e.Item.DataItem)["OfficeEmail"].ToString();
                        break;
                    case "Override":
                        hlEmail.NavigateUrl = "mailto:" + ((DataRowView)e.Item.DataItem)["EmailOverride"].ToString();
                        hlEmail.Text = ((DataRowView)e.Item.DataItem)["EmailOverride"].ToString();
                        break;
                    default:
                        string email = txtEmailAddress.Text.Trim();
                        if (!string.IsNullOrEmpty(email))
                        {
                            hlEmail.NavigateUrl = "mailto:" + email;
                            hlEmail.Text = email;
                        }
                        else
                            hlEmail.Visible = false;
                        break;
                }
            }

        }

        private void dgAliases_ItemDataBound(object sender, DataGridItemEventArgs e)
        {
            LinkButton cmdDeleteAlias = (LinkButton)e.Item.FindControl("cmdDeleteAlias");
            if (cmdDeleteAlias != null)
            {
                cmdDeleteAlias.Attributes.Add("onClick", "javascript:return confirm('Confirm Delete.');");
            }
        }

        private void BindAwardDDL(DropDownList ddl, string filter)
        {
            DataTable dt =
                DataProvider.ConvertDataReaderToDataTable(DataProvider.Instance().GetAwardListByGroups(int.Parse(filter)));
            DataView dv = new DataView(dt, "", "name", DataViewRowState.OriginalRows);
            ddl.DataSource = dv;
            ddl.DataTextField = "name";
            ddl.DataValueField = "AwardId";
            ddl.DataBind();
        }

        enum groupFilter
        {
            None,
            Awards,
            Offices

        }
        private void BindGroupDDL(DropDownList ddl, string emptyValueString)
        {
            BindGroupDDL(ddl, emptyValueString, groupFilter.None);
        }
        private void BindGroupDDL(DropDownList ddl, string emptyValueString, groupFilter filter)
        {
            using (ScaOpEntities context = new ScaOpEntities())
            {
                switch (filter)
                {
                    case groupFilter.Offices:
                        var OfficeQuery = from scagroup in context.Groups
                                          where scagroup.OfficerPositions.Count > 0
                                          orderby scagroup.Name
                                          select scagroup;
                        ddl.DataSource = OfficeQuery;
                        break;
                    case groupFilter.Awards:
                        var AwardQuery = from scagroup in context.Groups
                                         where scagroup.Awards.Count > 0
                                         orderby scagroup.Name
                                         select scagroup;
                        ddl.DataSource = AwardQuery;
                        break;
                    default:
                        var Query = from scagroup in context.Groups
                                    orderby scagroup.Name
                                    select scagroup;
                        ddl.DataSource = Query;
                        break;
                }

                ddl.DataTextField = "Name";
                ddl.DataValueField = "GroupId";
                ddl.DataBind();
                ddl.Items.Insert(0, new ListItem(emptyValueString, Null.NullInteger.ToString()));
                ddl.SelectedValue = "26";//TODO: Atenveldt Default... 
            }
        }

        private void BindGivenByDDL(DropDownList ddl, string filter)
        {
            DataTable dt = DataProvider.Instance().GetCrownsByGroups(int.Parse(filter));
            ddl.DataSource = dt;
            ddl.DataTextField = "GroupCrownReign";
            ddl.DataValueField = "CrownId";
            ddl.DataBind();
            ddl.Items.Insert(0, new ListItem("<none selected>", Null.NullInteger.ToString()));
        }

        private void BindAliasDDL(DropDownList ddl)
        {
            DataTable dt = DataProvider.ConvertDataReaderToDataTable(DataProvider.Instance().GetAliasByPeople(memid));
            ddl.DataSource = dt;
            ddl.DataTextField = "SCAName";
            ddl.DataValueField = "AliasId";
            ddl.DataBind();
            ddl.Items.Insert(0, new ListItem("<none selected>", Null.NullInteger.ToString()));
        }

        private void BindHoursDDL(DropDownList ddl)
        {
            for (int i = 0; i <= 23; i++)
            {
                ddl.Items.Add(new ListItem(i.ToString() + ":00", i.ToString() + ":00"));
            }
        }

        private void BindOfficeDDL(DropDownList ddl, string filter)
        {
            DataTable dt = DataProvider.Instance().ListOfficerPositionByGroup(int.Parse(filter));
            ddl.DataSource = dt;
            ddl.DataTextField = "TypeAndTitle";
            ddl.DataValueField = "OfficerPositionId";
            ddl.DataBind();
        }

        private void BindCrownDDL(DropDownList ddl, string filter)
        {
            DataTable dt = DataProvider.Instance().GetCrownsByGroups(int.Parse(filter));
            ddl.DataSource = dt;
            ddl.DataBind();
        }

        public string GetRegisteredName()
        {
            return DataProvider.Instance().GetRegisteredName(memid);
        }

        protected void GroupDdlInAwards_SelectedIndexChanged(object sender, EventArgs e)
        {
            if (sender is DropDownList)
            {
                DropDownList ddlGroup = (DropDownList)sender;
                string AwardDdlId, GivenByDdlId;
                if (ddlGroup.ID.ToLower().IndexOf("add") > 0)
                {
                    AwardDdlId = "ddlAdd_Award";
                    GivenByDdlId = "ddlAdd_GivenBy";
                }
                else
                {
                    AwardDdlId = "ddlEdit_Award";
                    GivenByDdlId = "ddlEdit_GivenBy";
                }

                FindAndBindDdl(ddlGroup, AwardDdlId, BindAwardDDL);
                FindAndBindDdl(ddlGroup, GivenByDdlId, BindGivenByDDL);
            }
        }

        protected void GroupDdlInOffices_SelectedIndexChanged(object sender, EventArgs e)
        {
            if (sender is DropDownList)
            {
                DropDownList ddlGroup = (DropDownList)sender;
                string OfficeDdlId, CrownDdlId;
                if (ddlGroup.ID.ToLower().IndexOf("add") > 0)
                {
                    OfficeDdlId = "ddlAdd_OfficePosition";
                    CrownDdlId = "ddlAdd_Crown";
                }
                else
                {
                    OfficeDdlId = "ddlEdit_OfficePosition";
                    CrownDdlId = "ddlEdit_Crown";
                }


                FindAndBindDdl(ddlGroup, OfficeDdlId, BindOfficeDDL);
                FindAndBindDdl(ddlGroup, CrownDdlId, BindCrownDDL);
            }
        }

        private delegate void BindDDL(DropDownList ddl, string filter);

        private void FindAndBindDdl(DropDownList nearByGroupDdl, string ddlId, BindDDL bindDdl)
        {
            DropDownList targetDdl = (DropDownList)nearByGroupDdl.Parent.FindControl(ddlId);
            if (targetDdl == null)
            {
                foreach (Control control in nearByGroupDdl.Parent.Controls[0].Controls)
                {
                    targetDdl = (DropDownList)control.FindControl(ddlId);
                    if (targetDdl != null)
                        break;
                }
            }
            bindDdl(targetDdl, nearByGroupDdl.SelectedValue);
        }
        protected void ddlOfficePosition_SelectedIndexChanged(object sender, EventArgs e)
        {
            DropDownList ddlOfficePosition = sender as DropDownList;
            if (ddlOfficePosition != null)
            {
                SetCrownDdlVisibility(ddlOfficePosition);

            }
        }

        private void SetCrownDdlVisibility(DropDownList ddlOfficePosition)
        {
            using (ScaOpEntities context = new ScaOpEntities())
            {
                int selectedPositionId = Convert.ToInt32(ddlOfficePosition.SelectedValue);
                OfficerPosition chosenPosition = context.OfficerPositions.Single(op =>
                    op.OfficerPositionId == selectedPositionId);
                ddlOfficePosition.Parent.FindControl("phCrown").Visible = chosenPosition.OfficePositionType != null && chosenPosition.OfficePositionType.TypeFlags.HasFlag(OfficerPositionTypeFlags.RelatedToReign);
            }
        }

        protected void dgOffices_ItemCreated(object sender, DataGridItemEventArgs e)
        {
            if (e.Item.ItemType == ListItemType.Footer)
            {
                DropDownList ddlAdd_OfficePosition = (DropDownList)e.Item.FindControl("ddlAdd_OfficePosition");
                DropDownList ddlAdd_Crown = (DropDownList)e.Item.FindControl("ddlAdd_Crown");
                DropDownList ddlAdd_Group = (DropDownList)e.Item.FindControl("ddlAdd_Group");
                HyperLink hlAdd_StartDateCalendar = (HyperLink)e.Item.FindControl("hlAdd_StartDateCalendar");
                HyperLink hlAdd_EndDateCalendar = (HyperLink)e.Item.FindControl("hlAdd_EndDateCalendar");
                TextBox txtAdd_StartDate = (TextBox)e.Item.FindControl("txtAdd_StartDate");
                TextBox txtAdd_EndDate = (TextBox)e.Item.FindControl("txtAdd_EndDate");

                BindGroupDDL(ddlAdd_Group, "<Select a group to list Offices>", groupFilter.Offices);
                BindOfficeDDL(ddlAdd_OfficePosition, ddlAdd_Group.SelectedValue);
                SetCrownDdlVisibility(ddlAdd_OfficePosition);
                BindCrownDDL(ddlAdd_Crown, ddlAdd_Group.SelectedValue);
            }
        }

    }
}