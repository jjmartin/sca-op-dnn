using System;
using System.Collections;
using System.Collections.Generic;
using DotNetNuke.Common;
using DotNetNuke.Entities.Modules;
using DotNetNuke.Entities.Portals;
using DotNetNuke.Services.Exceptions;
using JeffMartin.DNN.Modules.ScaOnlineOP.Utility;

namespace JeffMartin.DNN.Modules.SCAOnlineOP
{
    partial class OfficerListSettings : ModuleSettingsBase
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
                    PortalController pc = new PortalController();
                    ArrayList Portals = pc.GetPortals();
                    ddlPortalList.DataTextField = "PortalName";
                    ddlPortalList.DataValueField = "PortalID";
                    ddlPortalList.DataSource = Portals;
                    ddlPortalList.DataBind();

                    string BasePortalId = ((string)Settings["BasePortal"]);
                    if (BasePortalId == null)
                        ddlPortalList.SelectedValue = "0";
                    else
                        ddlPortalList.SelectedValue = BasePortalId;

                    if (Settings["HeaderTemplate"] == null)
                    {
                        txtHeaderTemplate.Text = "<table>";
                    }
                    else
                        txtHeaderTemplate.Text = Settings["HeaderTemplate"].ToString();

                    if (Settings["ItemTemplate"] == null)
                    {
                        txtItemTemplate.Text = SCAOfficerListUtility.DefaultItemTemplate;
                    }
                    else
                        txtItemTemplate.Text = Settings["ItemTemplate"].ToString();

                    if (Settings["FooterTemplate"] == null)
                    {
                        txtFooterTemplate.Text = "</table>";
                    }
                    else
                        txtFooterTemplate.Text = Settings["FooterTemplate"].ToString();
      
                }
            }
            catch (Exception exc)
            {
                Exceptions.ProcessModuleLoadException(this, exc);
            }
        }

        protected void btnReset_Click(object sender, EventArgs e)
        {
            txtItemTemplate.Text = SCAOfficerListUtility.DefaultItemTemplate;
        }

        public override void UpdateSettings()
        {
            try
            {
                ModuleController objModules = new ModuleController();
                objModules.UpdateModuleSetting(ModuleId, "BasePortal", ddlPortalList.SelectedValue);
                objModules.UpdateModuleSetting(ModuleId, "HeaderTemplate", txtHeaderTemplate.Text);
                objModules.UpdateModuleSetting(ModuleId, "ItemTemplate", txtItemTemplate.Text);
                objModules.UpdateModuleSetting(ModuleId, "FooterTemplate", txtFooterTemplate.Text);

                Response.Redirect(Globals.NavigateURL(), true);
            }
            catch (Exception exc)
            {
                Exceptions.ProcessModuleLoadException(this, exc);
            }
        }
    }
}