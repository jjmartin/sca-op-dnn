using System;
using System.Collections.Generic;
using System.Data;
using System.Web.UI.WebControls;
using DotNetNuke.Common;
using DotNetNuke.Common.Utilities;
using DotNetNuke.Entities.Modules;
using DotNetNuke.Services.Exceptions;
using JeffMartin.DNN.Modules.SCAOnlineOP.Data;

namespace JeffMartin.DNN.Modules.SCAOnlineOP
{
    /// <summary>
    ///		Summary description for SCAOfficer.
    /// </summary>
    public partial class SCAOfficerListEdit : PortalModuleBase
    {
        private void Page_Load(object sender, EventArgs e)
        {
            hlDisplayDateCalendar.NavigateUrl = DotNetNuke.Common.Utilities.Calendar.InvokePopupCal(txtDisplayDate);

            if (!IsPostBack)
            {
                BindGroupDDL(ddlEditGroup);


                if (ddlEditGroup.Items.FindByValue((string)Settings["GroupId"]) != null)
                {
                    ddlEditGroup.SelectedValue = ((string)Settings["GroupId"]);

                    chkIncludeRulers.Checked = Convert.ToBoolean(Settings["IncludeRulers"]);
                    chkShowVacant.Checked = Convert.ToBoolean(Settings["ShowVacant"]);
                    chkShowHistory.Checked = Convert.ToBoolean(Settings["ShowHistory"]);
                    chkUseCrownLink.Checked = Convert.ToBoolean(Settings["UseCrownLink"]);
                    chkUseDisplayDate.Checked = Convert.ToBoolean(Settings["UseDisplayDate"]);

                    txtDisplayDate.Text = Settings["DisplayDate"] as String;


                    //This needs to happen after other settings are applied
                    ddlEditGroup_SelectedIndexChanged(ddlEditGroup, EventArgs.Empty);
                    ddlCrown.SelectedValue = ((string)Settings["CrownId"]);

                    string[] selectedOfficePositions =
                        ((string)Settings["OfficePositionsId"]).Split(new[] { "," },
                                                                       StringSplitOptions.RemoveEmptyEntries);
                    foreach (string officePosition in selectedOfficePositions)
                    {
                        if (lstOffices.Items.FindByValue(officePosition) != null)
                            lstOffices.Items.FindByValue(officePosition).Selected = true;
                    }
                }
            }
        }



        protected override void OnInit(EventArgs e)
        {
            base.OnInit(e);

            this.cmdCancel.Click += new EventHandler(cmdCancel_Click);
            this.cmdUpdate.Click += new EventHandler(cmdUpdate_Click);
            this.Load += new System.EventHandler(this.Page_Load);
        }

        private void BindCrownDDL(DropDownList ddl, string filter)
        {
            DataTable dt = DataProvider.Instance().GetCrownsByGroups(int.Parse(filter));
            ddl.DataSource = dt;
            if (ddl.SelectedValue == "" || dt.Select("CrownId = " + ddl.SelectedValue).Length == 0) ddl.SelectedValue = null;
            ddl.DataBind();
        }

        private void cmdUpdate_Click(object sender, EventArgs e)
        {
            try
            {
                ModuleController objModules = new ModuleController();
                //objModules.UpdateTabModuleSetting(TabModuleId, "settingname1", "value");

                objModules.UpdateModuleSetting(ModuleId, "GroupId", ddlEditGroup.SelectedValue);
                objModules.UpdateModuleSetting(ModuleId, "CrownId", ddlCrown.SelectedValue);
                objModules.UpdateModuleSetting(ModuleId, "IncludeRulers", chkIncludeRulers.Checked.ToString());
                objModules.UpdateModuleSetting(ModuleId, "ShowVacant", chkShowVacant.Checked.ToString());
                objModules.UpdateModuleSetting(ModuleId, "ShowHistory", chkShowHistory.Checked.ToString());
                objModules.UpdateModuleSetting(ModuleId, "UseCrownLink", chkUseCrownLink.Checked.ToString());
                objModules.UpdateModuleSetting(ModuleId, "UseDisplayDate", chkUseDisplayDate.Checked.ToString());
                objModules.UpdateModuleSetting(ModuleId, "DisplayDate", txtDisplayDate.Text);

                List<string> OfficePositions = new List<string>();
                foreach (ListItem item in lstOffices.Items)
                {
                    if (item.Selected)
                        OfficePositions.Add(item.Value);
                }

                objModules.UpdateModuleSetting(ModuleId, "OfficePositionsId",
                                               string.Join(",", OfficePositions.ToArray()));
                Response.Redirect(Globals.NavigateURL(), true);
            }
            catch (Exception exc)
            {
                Exceptions.ProcessModuleLoadException(this, exc);
            }
        }

        private void cmdCancel_Click(object sender, EventArgs e)
        {
            Response.Redirect(Globals.NavigateURL(), true);
        }





        private static void BindGroupDDL(DropDownList ddl)
        {
            DataTable dt = DataProvider.ConvertDataReaderToDataTable(DataProvider.Instance().ListOfficeGroups());
            ddl.DataSource = dt;
            ddl.DataTextField = "GroupNameOfficeCount";
            ddl.DataValueField = "GroupId";
            ddl.DataBind();
            ddl.Items.Insert(0, new ListItem("<none selected>", Null.NullInteger.ToString()));
        }

        protected void ddlEditGroup_SelectedIndexChanged(object sender, EventArgs e)
        {
            pnlGroupOfficeList.Visible = true;
            BindCrownDDL(ddlCrown, ddlEditGroup.SelectedValue);
            BindOfficeList();
        }

        private void BindOfficeList()
        {
            DataTable dt =
                DataProvider.Instance().ListOfficerPositionByGroup(Convert.ToInt32(ddlEditGroup.SelectedValue));
            if (chkUseCrownLink.Checked)
                dt.DefaultView.RowFilter = "LinkedToCrown=1";

            lstOffices.DataSource = dt.DefaultView;
            lstOffices.DataTextField = "Title";
            lstOffices.DataValueField = "OfficerPositionId";
            lstOffices.DataBind();
            if (lstOffices.Items.Count > 24)
            {
                lstOffices.RepeatColumns = lstOffices.Items.Count / 24;
            }
        }
        protected void chkUseCrownLink_CheckedChanged(object sender, EventArgs e)
        {
            BindOfficeList();
        }
    }
}