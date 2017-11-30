using System;
using System.Collections;
using System.Data;
using System.Web.UI.WebControls;
using DotNetNuke.Common;
using DotNetNuke.Entities.Modules;
using DotNetNuke.Entities.Modules.Actions;
using DotNetNuke.Security;
using DotNetNuke.Services.Exceptions;
using DotNetNuke.UI.UserControls;
using JeffMartin.DNN.Modules.SCAOnlineOP.Data;

namespace JeffMartin.DNN.Modules.SCAOnlineOP
{
    partial class SCAOnlineOPOfficeEdit : PortalModuleBase, IActionable
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
        protected void Page_Load(object sender, EventArgs e)
        {
            DotNetNuke.Framework.jQuery.RequestRegistration();
            try
            {
                if (!Page.IsPostBack)
                {
                    //History Link
                    ((HyperLinkField)gvOffices.Columns[1]).DataNavigateUrlFormatString =
                        Globals.NavigateURL(TabId, "", "list=oh", "f=" + int.MaxValue).Replace(
                            int.MaxValue.ToString(), "{0}") + "#results";
                }
            }
            catch (Exception exc)
            {
                Exceptions.ProcessModuleLoadException(this, exc);
            }
        }


        protected void cmdCancel_Click(object sender, EventArgs e)
        {
            try
            {
                Response.Redirect(Globals.NavigateURL(), true);
            }
            catch (Exception exc)
            {
                Exceptions.ProcessModuleLoadException(this, exc);
            }
        }


        private void BindGroupDDL(DropDownList ddl)
        {
            DataTable dt = DataProvider.ConvertDataReaderToDataTable(DataProvider.Instance().ListGroups());
            ddl.DataSource = dt;
            ddl.DataTextField = "Name";
            ddl.DataValueField = "GroupId";
            ddl.DataBind();
        }


        protected void DataSource_ObjectCreating(object sender, ObjectDataSourceEventArgs e)
        {
            e.ObjectInstance = DataProvider.Instance();
        }



        private static void MoveControls(System.Web.UI.Control fromContainer, System.Web.UI.Control toContainer)
        {
            ArrayList controls = new ArrayList(fromContainer.Controls);
            foreach (System.Web.UI.Control control in controls)
            {
                toContainer.Controls.Add(control);
            }
        }


        protected void gvOffices_RowUpdating(object sender, GridViewUpdateEventArgs e)
        {
            GridViewRow row = ((GridView)sender).Rows[e.RowIndex];

            // UrlControl has limited separation of concerns and allows many variations to come out of the Url property
            // in this case, we have specified that the there has to be a file chosen from the DNN system.
            // UrlControl will use the FileID={fileid} output.  We are only interested in the actual file id.
            UrlControl urlOfficeBadge = row.FindControl("urlOfficeBadge") as UrlControl;
            if (urlOfficeBadge != null)
            {
                if (urlOfficeBadge.Url.StartsWith("FileID="))
                {
                    int fileid;
                    if (int.TryParse(urlOfficeBadge.Url.Substring(7), out fileid))
                        e.NewValues["FileId"] = fileid;
                }
                else if (urlOfficeBadge.Url.Equals(String.Empty))
                {
                    e.NewValues["FileId"] = null;
                }
            }
        }


        protected void fv_OfficerPosition_ItemInserting(object sender, FormViewInsertEventArgs e)
        {
            FormViewRow row = ((FormView)sender).Row;
            // UrlControl has limited separation of concerns and allows many variations to come out of the Url property
            // in this case, we have specified that the there has to be a file chosen from the DNN system.
            // UrlControl will use the FileID={fileid} output.  We are only interested in the actual file id.

            UrlControl urlOfficeBadge = row.FindControl("urlOfficeBadge") as UrlControl;
            if (urlOfficeBadge != null)
            {
                if (urlOfficeBadge.Url.StartsWith("FileID="))
                {
                    int fileid;
                    if (int.TryParse(urlOfficeBadge.Url.Substring(7), out fileid))
                        e.Values["FileId"] = fileid;
                }
                else if (urlOfficeBadge.Url.Equals(String.Empty))
                {
                    e.Values["FileId"] = null;
                }
            }
        }

        protected void fv_OfficerPosition_ItemInserted(object sender, FormViewInsertedEventArgs e)
        {
            gvOffices.DataBind();
        }
    }
}