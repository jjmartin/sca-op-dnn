using System;
using System.Data;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using DotNetNuke;
using DotNetNuke.Common;
using DotNetNuke.Common.Utilities;
using DotNetNuke.Entities.Modules;
using DotNetNuke.Services.Localization;
using DotNetNuke.Services.Exceptions;
using JeffMartin.DNN.Modules.SCAOnlineOP.Data;

namespace JeffMartin.DNN.Modules.SCAOnlineOP
{
	partial class SCAOnlineOPAwardGroupEdit : PortalModuleBase
	{
		#region Web Form Designer generated code
		override protected void OnInit(EventArgs e)
		{
			//
			// CODEGEN: This call is required by the ASP.NET Web Form Designer.
			//
			InitializeComponent();
			dgAwardGroups.ItemDataBound+=new DataGridItemEventHandler(dgAwardGroups_ItemDataBound);
			dgAwardGroups.ItemCommand+=new DataGridCommandEventHandler(dgAwardGroups_ItemCommand);
			base.OnInit(e);
		}
		
		/// <summary>
		///		Required method for Designer support - do not modify
		///		the contents of this method with the code editor.
		/// </summary>
		private void InitializeComponent()
		{
			this.cmdCancel.Click += new System.EventHandler(this.cmdCancel_Click);
			this.Load += new System.EventHandler(this.Page_Load);

		}
		#endregion

		#region Private Members

		#endregion

		#region Event Handlers
		private void Page_Load(object sender, System.EventArgs e)
		{
			try 
			{
				if (!Page.IsPostBack) 
				{
					DataTable AwardGroupsTable = DataProvider.ConvertDataReaderToDataTable(DataProvider.Instance().ListAwardGroups());
					dgAwardGroups.DataSource = AwardGroupsTable;
					dgAwardGroups.DataBind();
					
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
				Response.Redirect(Globals.NavigateURL(), true);
			} 
			catch (Exception exc) 
			{
				Exceptions.ProcessModuleLoadException(this, exc);
			}
		}

		
		#endregion

		private void dgAwardGroups_ItemDataBound(object sender, DataGridItemEventArgs e)
		{
			LinkButton cmdDelete = (LinkButton)e.Item.FindControl("cmdDelete");
			if(cmdDelete !=null)
			{
				cmdDelete.Attributes.Add("onClick", "javascript:return confirm('Confirm Delete.');"); 
			}

			if(e.Item.ItemType == ListItemType.EditItem)
			{
				DropDownList ddlEdit_Group = (DropDownList)e.Item.FindControl("ddlEdit_Group");
				
				BindGroupDDL(ddlEdit_Group);
				
				if(ddlEdit_Group.Items.FindByValue(((DataRowView)e.Item.DataItem)["GroupId"].ToString())!=null)
					ddlEdit_Group.SelectedValue = ((DataRowView)e.Item.DataItem)["GroupId"].ToString();

			}
			else if(e.Item.ItemType == ListItemType.Item ||
				e.Item.ItemType == ListItemType.AlternatingItem )
			{
			}
			else if(e.Item.ItemType == ListItemType.Footer)
			{
				DropDownList ddlAdd_Group = (DropDownList)e.Item.FindControl("ddlAdd_Group");
				
				BindGroupDDL(ddlAdd_Group);
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

		private void dgAwardGroups_ItemCommand(object source, DataGridCommandEventArgs e)
		{
			DataTable AwardGroupTable;
			
			switch(e.CommandName)
			{
				case "Edit":
					AwardGroupTable = DataProvider.ConvertDataReaderToDataTable(DataProvider.Instance().ListAwardGroups());
					dgAwardGroups.EditItemIndex = e.Item.ItemIndex;
					dgAwardGroups.ShowFooter=false;
					dgAwardGroups.DataSource = AwardGroupTable;
					dgAwardGroups.DataBind();
					//DropDownLists Set during Databind Event
					break;
				case "Add":
					DataProvider.Instance().AddAwardGroups(
						((TextBox)e.Item.FindControl("txtAdd_AwardGroupName")).Text,
						Convert.ToInt32(((TextBox)e.Item.FindControl("txtAdd_Precedence")).Text),
						Convert.ToInt32(((TextBox)e.Item.FindControl("txtAdd_SortOrder")).Text),
						Convert.ToInt32(((DropDownList)e.Item.FindControl("ddlAdd_Group")).SelectedValue)
						);
					AwardGroupTable = DataProvider.ConvertDataReaderToDataTable(DataProvider.Instance().ListAwardGroups());
					dgAwardGroups.DataSource = AwardGroupTable;
					dgAwardGroups.DataBind();
					break;
				case "Update":
					DataProvider.Instance().UpdateAwardGroups(
						Convert.ToInt32(e.Item.Cells[0].Text),
						((TextBox)e.Item.FindControl("txtEdit_AwardGroupName")).Text,
						Convert.ToInt32(((TextBox)e.Item.FindControl("txtEdit_Precedence")).Text),
						Convert.ToInt32(((TextBox)e.Item.FindControl("txtEdit_SortOrder")).Text),
						Convert.ToInt32(((DropDownList)e.Item.FindControl("ddlEdit_Group")).SelectedValue)
						);
					AwardGroupTable = DataProvider.ConvertDataReaderToDataTable(DataProvider.Instance().ListAwardGroups());
					dgAwardGroups.DataSource = AwardGroupTable;
					dgAwardGroups.ShowFooter=true;
					dgAwardGroups.EditItemIndex = -1;
					dgAwardGroups.DataBind();
					
					break;
				case "Cancel":
					AwardGroupTable = DataProvider.ConvertDataReaderToDataTable(DataProvider.Instance().ListAwardGroups());
					dgAwardGroups.DataSource = AwardGroupTable;
					dgAwardGroups.ShowFooter=true;
					dgAwardGroups.EditItemIndex = -1;
					dgAwardGroups.DataBind();
					break;
				case "Delete":
					DataProvider.Instance().DeleteAwardGroups(Convert.ToInt32(e.Item.Cells[0].Text));
					AwardGroupTable = DataProvider.ConvertDataReaderToDataTable(DataProvider.Instance().ListAwardGroups());
					dgAwardGroups.DataSource = AwardGroupTable;
					dgAwardGroups.ShowFooter=true;
					dgAwardGroups.EditItemIndex = -1;
					dgAwardGroups.DataBind();
					break;
			}
		}
	}
}
