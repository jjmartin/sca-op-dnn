using System;
using System.Data.Objects;
using System.Web.UI.WebControls;
using DotNetNuke.Common;
using DotNetNuke.Entities.Modules;
using DotNetNuke.Entities.Modules.Actions;
using DotNetNuke.Security;
using DotNetNuke.Services.Exceptions;
using DotNetNuke.UI.WebControls;
using JeffMartin.ScaData;

namespace JeffMartin.DNN.Modules.SCAOnlineOP
{
    partial class SCAOnlineOPOfficePositionTypeEdit : PortalModuleBase, IActionable
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
        protected void gvOfficePositionTypes_RowCommand(object sender, GridViewCommandEventArgs e)
        {
            if (e.CommandName == "Insert")
            {
                using (ScaOpEntities context = new ScaOpEntities())
                {
                    OfficerPositionType opt = new OfficerPositionType();
                    opt.Name = ((TextBox)gvOfficePositionTypes.FooterRow.FindControl("NameAdd")).Text;
                    string description = ((DNNRichTextEditControl)gvOfficePositionTypes.FooterRow.FindControl("textDescriptionAdd")).Value as string;
                    opt.Description = description ?? "";
                    opt.TypeFlags = GetValueFromTypeFlagCheckBoxList((CheckBoxList)gvOfficePositionTypes.FooterRow.FindControl("cblTypeFlagsAdd"));
                    string sortOrder = ((TextBox)gvOfficePositionTypes.FooterRow.FindControl("SortOrderAdd")).Text;
                    opt.SortOrder = Convert.ToInt32(String.IsNullOrWhiteSpace(sortOrder) ? "0" : sortOrder);

                    context.OfficerPositionTypes.AddObject(opt);
                    context.SaveChanges();
                }
                Response.Redirect(Request.Url.PathAndQuery);
            }
        }



        protected void gvOfficePositionTypes_RowCreated(object sender, GridViewRowEventArgs e)
        {
            if (e.Row.RowType == DataControlRowType.DataRow)
            {
                CheckBoxList cblTypeFlags = e.Row.FindControl("cblTypeFlagsEdit") as CheckBoxList;

                BindTypeFlagCheckBoxList(cblTypeFlags);
            }
            if (e.Row.RowType == DataControlRowType.Footer)
            {
                CheckBoxList cblTypeFlags = e.Row.FindControl("cblTypeFlagsAdd") as CheckBoxList;
                BindTypeFlagCheckBoxList(cblTypeFlags);
            }
        }



        protected void gvOfficePositionTypes_RowDataBound(object sender, GridViewRowEventArgs e)
        {
            if (e.Row.RowType == DataControlRowType.DataRow)
            {
                OfficerPositionType opt = e.Row.DataItem as OfficerPositionType;
                if (opt != null)
                {
                    CheckBoxList cblTypeFlags = e.Row.FindControl("cblTypeFlagsEdit") as CheckBoxList;
                    if (cblTypeFlags != null)
                    {
                        foreach (ListItem item in cblTypeFlags.Items)
                        {
                            item.Selected = ((OfficerPositionTypeFlags)int.Parse(item.Value) & opt.TypeFlags) != 0;
                        }
                    }
                }
            }
        }

        private void BindTypeFlagCheckBoxList(CheckBoxList cblTypeFlags)
        {
            if (cblTypeFlags != null)
            {
                foreach (int val in Enum.GetValues(typeof(OfficerPositionTypeFlags)))
                {
                    if (val != 0)
                    {
                        ListItem item = new ListItem(Enum.GetName(typeof(OfficerPositionTypeFlags), val), val.ToString());
                        cblTypeFlags.Items.Add(item);
                    }
                }
            }
        }

        private OfficerPositionTypeFlags GetValueFromTypeFlagCheckBoxList(CheckBoxList checkBoxList)
        {
            OfficerPositionTypeFlags flags = OfficerPositionTypeFlags.None;
            foreach (ListItem item in checkBoxList.Items)
            {
                if (item.Selected)
                    flags |= (OfficerPositionTypeFlags)int.Parse(item.Value);
            }
            return flags;
        }

        protected void gvOfficePositionTypes_RowUpdating(object sender, GridViewUpdateEventArgs e)
        {
            e.NewValues["intTypeFlags"] = (int)GetValueFromTypeFlagCheckBoxList((CheckBoxList)gvOfficePositionTypes.Rows[e.RowIndex].FindControl("cblTypeFlagsEdit"));

        }

        protected void edsOfficerPositionType_Deleting(object sender, EntityDataSourceChangingEventArgs e)
        {
            var opt = (OfficerPositionType)e.Entity;
            e.Context.Refresh(RefreshMode.StoreWins, opt);
            if (opt.OfficePostionsOfThisType.Count > 0)
            {
                Literal deleteError = new Literal();
                deleteError.Text = string.Format("The \"{0}\" office position type is assigned to office positions and can't be deleted until those offices are reassigned.", opt.Name);
                errorContainer.Controls.Add(deleteError);
                e.Cancel = true;
            }
        }

    }
}