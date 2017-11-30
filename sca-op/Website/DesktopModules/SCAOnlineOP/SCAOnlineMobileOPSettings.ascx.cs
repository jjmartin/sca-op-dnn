using System;
using System.Collections;
using System.Collections.Generic;
using DotNetNuke.Common;
using DotNetNuke.Entities.Modules;
using DotNetNuke.Entities.Portals;
using DotNetNuke.Services.Exceptions;

namespace JeffMartin.DNN.Modules.SCAOnlineOP
{
    partial class SCAOnlineMobileOPSettings : ModuleSettingsBase
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

        #region Page_Load

        private void Page_Load(object sender, EventArgs e)
        {
            try
            {
                if (!Page.IsPostBack)
                {
                    PortalController pc = new PortalController();
                    ArrayList Portals = pc.GetPortals();
                    ddlPortalList.DataTextField = "PortalName";
                    ddlPortalList.DataValueField = "PortalID";
                    ddlPortalList.DataSource = Portals;
                    ddlPortalList.DataBind();
                }
            }
            catch (Exception exc)
            {
                Exceptions.ProcessModuleLoadException(this, exc);
            }
        }

        #endregion

        public override void LoadSettings()
        {
            try
            {
                if (!Page.IsPostBack)
                {
                    //	string setting1 = ((string)TabModuleSettings["settingname1"]);
                    string BasePortalId = ((string) Settings["BasePortal"]);
                    ddlPortalList.SelectedValue = BasePortalId;
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
                //objModules.UpdateTabModuleSetting(TabModuleId, "settingname1", "value");
                objModules.UpdateModuleSetting(ModuleId, "BasePortal", ddlPortalList.SelectedValue);
                Response.Redirect(Globals.NavigateURL(), true);
            }
            catch (Exception exc)
            {
                Exceptions.ProcessModuleLoadException(this, exc);
            }
        }
    }
}