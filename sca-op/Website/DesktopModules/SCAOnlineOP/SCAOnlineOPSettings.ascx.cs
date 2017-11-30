using System;
using System.Collections;
using DotNetNuke.Common;
using DotNetNuke.Entities.Modules;
using DotNetNuke.Entities.Portals;
using DotNetNuke.Services.Exceptions;

namespace JeffMartin.DNN.Modules.SCAOnlineOP
{
    partial class ScaOnlineOpSettings : ModuleSettingsBase
    {
        #region Web Form Designer generated code

        protected override void OnInit(EventArgs e)
        {
            //
            // CODEGEN: This call is required by the ASP.NET Web Form Designer.
            //
            InitializeComponent();
            base.OnInit(e);
            this.Load += new System.EventHandler(this.Page_Load);
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
                if (!Page.IsPostBack)
                {
                    BindControls();
                }
            }
            catch (Exception exc)
            {
                Exceptions.ProcessModuleLoadException(this, exc);
            }
        }

        private bool boundOnce;

        private void BindControls()
        {
            if (!boundOnce)
            {
                PortalController pc = new PortalController();
                ArrayList Portals = pc.GetPortals();
                ddlPortalList.DataTextField = "PortalName";
                ddlPortalList.DataValueField = "PortalID";
                ddlPortalList.DataSource = Portals;
                ddlPortalList.DataBind();

                ModuleController mc = new ModuleController();
                ModuleInfo mInfo = mc.GetModuleByDefinition(PortalId, "Dynamic Forms");
                if (mInfo == null)
                {
                    phAwardRecsSettings.Visible = false;
                }
                else
                {
                   
                    phAwardRecsSettings.Visible = true;
                    ArrayList moduleTabs = mc.GetAllTabsModules(0, false);
                    for (int i = moduleTabs.Count-1; i >=0; i--)
                    {
                        if(((ModuleInfo)moduleTabs[i]).ModuleDefinition.DesktopModuleID!=mInfo.ModuleDefinition.DesktopModuleID)
                        {
                            moduleTabs.RemoveAt(i);
                        }
                    }
                    ddlDynamicForms.DataTextField = "ModuleTitle";
                    ddlDynamicForms.DataValueField = "TabId";
                    ddlDynamicForms.DataSource = moduleTabs;
                    ddlDynamicForms.DataBind();
                }
                boundOnce = true;
            }
        }


        public override void LoadSettings()
        {
            try
            {
                if (!Page.IsPostBack)
                {
                    BindControls();
                    string basePortalId = ((string) Settings["BasePortal"]);
                    if (basePortalId == null)
                        ddlPortalList.SelectedValue = "0";
                    else
                        ddlPortalList.SelectedValue = basePortalId;

                    string awardRecTabId = ((string) Settings["AwardRecTabId"]);
                    if (awardRecTabId != null)
                        ddlPortalList.SelectedValue = awardRecTabId;

                    bool linkToRec = Convert.ToBoolean(Settings["LinkToRec"]);
                    chkLinkToRec.Checked = linkToRec;
                }
            }
            catch (Exception exc)
            {
                Exceptions.ProcessModuleLoadException(this, exc);
            }
        }

        public override void UpdateSettings()
        {
            try
            {
                ModuleController objModules = new ModuleController();
                objModules.UpdateModuleSetting(ModuleId, "BasePortal", ddlPortalList.SelectedValue);
                objModules.UpdateModuleSetting(ModuleId, "AwardRecTabId", ddlDynamicForms.SelectedValue);
                objModules.UpdateModuleSetting(ModuleId, "LinkToRec", chkLinkToRec.Checked.ToString());

                Response.Redirect(Globals.NavigateURL(), true);
            }
            catch (Exception exc)
            {
                Exceptions.ProcessModuleLoadException(this, exc);
            }
        }
    }
}