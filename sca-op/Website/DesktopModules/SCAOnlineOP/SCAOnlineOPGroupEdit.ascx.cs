using System;
using System.Data;
using System.Collections;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using DotNetNuke;
using DotNetNuke.Common;
using DotNetNuke.Common.Utilities;
using DotNetNuke.Entities.Modules;
using DotNetNuke.Services.Localization;
using DotNetNuke.Services.Exceptions;
using DotNetNuke.Services.Search;
using JeffMartin.DNN.Modules.SCAOnlineOP.Data;


namespace JeffMartin.DNN.Modules.SCAOnlineOP
{
	partial class SCAOnlineOPGroupEdit : PortalModuleBase
	{
		
		#region protected Members
		protected int gid;
		#endregion

		#region Web Form Designer generated code
		override protected void OnInit(EventArgs e)
		{
			//
			// CODEGEN: This call is required by the ASP.NET Web Form Designer.
			//
			InitializeComponent();
			base.OnInit(e);
			this.Load+=new EventHandler(Page_Load);
			this.cmdUpdate.Click+=new EventHandler(cmdUpdate_Click);
			this.cmdDelete.Click+=new EventHandler(cmdDelete_Click);
			this.cmdCancel.Click+=new EventHandler(cmdCancel_Click);
		}
		
		/// <summary>
		///		Required method for Designer support - do not modify
		///		the contents of this method with the code editor.
		/// </summary>
		private void InitializeComponent()
		{
			this.Load += new System.EventHandler(this.Page_Load);

		}
		#endregion


		private void Page_Load(object sender, System.EventArgs e)
		{
			try 
			{

				if (!(Request.Params["gid"] == null)) 
				{
					gid = Int32.Parse(Request.Params["gid"]);
				} 
				else 
				{
					gid = Null.NullInteger;
				}
				hlReturnToDisplay.NavigateUrl = Globals.NavigateURL(this.TabId,"", "list=group");
				if (!Page.IsPostBack) 
				{
					BindGroupDDL(ddlParentGroup);
					BindBranchStatusDDL(ddlBranchStatus);
					BindDesignationDDL(ddlDesignation);
					cmdDelete.Attributes.Add("onClick", "javascript:return confirm('Confirm Group Delete. This will not work if any Crowns, Awards, OfficerPosistions, GroupAwards are attached to this group.');");
					if (!Null.IsNull(gid)) 
					{
						DisplayGroupInfo(gid);
						cmdDelete.Visible = true;
					}
				}
				
				
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
			ddl.Items.Insert(0, new ListItem("<none selected>", Null.NullInteger.ToString()));
		}
		private void BindDesignationDDL(DropDownList ddl)
		{
			DataTable dt = DataProvider.ConvertDataReaderToDataTable(DataProvider.Instance().ListGroupDesignation());
			ddl.DataSource = dt;
			ddl.DataTextField = "Name";
			ddl.DataValueField = "GroupDesignationId";
			ddl.DataBind();
			ddl.Items.Insert(0, new ListItem("<none selected>", Null.NullInteger.ToString()));
		}
		private void BindBranchStatusDDL(DropDownList ddl)
		{
			DataTable dt = DataProvider.ConvertDataReaderToDataTable(DataProvider.Instance().ListBranchStatus());
			ddl.DataSource = dt;
			ddl.DataTextField = "Name";
			ddl.DataValueField = "BranchStatusId";
			ddl.DataBind();
		}

		private void cmdUpdate_Click(object sender, EventArgs e)
		{
			try 
			{
				int precedence = Null.NullInteger;
				if(txtPrecedence.Text.Trim()!=string.Empty)
					precedence = Convert.ToInt32(txtPrecedence.Text);
				DateTime FoundingDate = Null.NullDate;
				if(txtFoundingDate.Text.Trim()!=string.Empty)
					FoundingDate = Convert.ToDateTime(txtFoundingDate.Text);
				if (Page.IsValid == true) 
				{						
					if (Null.IsNull(gid)) 
					{
						gid = DataProvider.Instance().AddGroups(
							txtName.Text,
							txtCode.Text,
							txtLocation.Text,
							precedence,
							FoundingDate,
							Convert.ToInt32(ddlDesignation.SelectedValue),//Designation
							chkHidden.Checked,
							urlGroupArmsUrl.Url,
							txtArmsBlazon.Text,
							Convert.ToInt32(ddlBranchStatus.SelectedValue),
							txtNotes.Text,
							txtSovereignMaleTitle.Text,
							txtSovereignFemaleTitle.Text,
							txtConsortMaleTitle.Text,
							txtConsortFemaleTitle.Text,
							Convert.ToInt32(ddlParentGroup.SelectedValue),
							urlSovereignArmsUrl.Url,
							txtSovereignBlazon.Text,
							urlConsortArmsUrl.Url,
							urlWebSiteUrl.Url,
							urlInternalUrl.Url,
							txtConsortBlazon.Text,
							ddlReignType.SelectedValue,
							txtRegentMaleTitle.Text, //RegentMaleTitle
							txtRegentFemaleTitle.Text, //RegentFemaleTitle
							txtRegencyType.Text
							);
					} 
					else 
					{
						DataProvider.Instance().UpdateGroups(
							gid,
							txtName.Text,
							txtCode.Text,
							txtLocation.Text,
							precedence,
							FoundingDate,
							Convert.ToInt32(ddlDesignation.SelectedValue),//Designation
							chkHidden.Checked,
							urlGroupArmsUrl.Url,
							txtArmsBlazon.Text,
							Convert.ToInt32(ddlBranchStatus.SelectedValue),
							txtNotes.Text,
							txtSovereignMaleTitle.Text,
							txtSovereignFemaleTitle.Text,
							txtConsortMaleTitle.Text,
							txtConsortFemaleTitle.Text,
							Convert.ToInt32(ddlParentGroup.SelectedValue),
							urlSovereignArmsUrl.Url,
							txtSovereignBlazon.Text,
							urlConsortArmsUrl.Url,
							urlWebSiteUrl.Url,
							urlInternalUrl.Url,
							txtConsortBlazon.Text,
							ddlReignType.SelectedValue,
							txtRegentMaleTitle.Text, //RegentMaleTitle
							txtRegentFemaleTitle.Text, //RegentFemaleTitle
							txtRegencyType.Text
							);
					}
                    DataCache.ClearCache("group");
					if(Request.QueryString["list"]!=null)
					{
						Response.Redirect(Globals.NavigateURL(this.TabId,"", "list=" + Request.QueryString["list"],
							"pg=" + Request.QueryString["pg"], 
							"ps=" + Request.QueryString["ps"],
							"f=" + Request.QueryString["f"]
							),
							true);
					}
					else
						Response.Redirect(Globals.NavigateURL(this.TabId, "", "gid=" + gid.ToString()), true);
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
				if(Request.QueryString["list"]!=null)
				{
					Response.Redirect(Globals.NavigateURL(this.TabId,"", "list=" + Request.QueryString["list"],
						"pg=" + Request.QueryString["pg"], 
						"ps=" + Request.QueryString["ps"],
						"f=" + Request.QueryString["f"]
						),
						true);
				}
				else if(gid!=Null.NullInteger)
					Response.Redirect(Globals.NavigateURL(this.TabId, "", "gid=" + gid.ToString()), true);
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
				if (!Null.IsNull(gid)) 
				{
					try
					{
						DataProvider.Instance().DeleteGroups(gid);
                        DataCache.ClearCache("group");
						Response.Redirect(Globals.NavigateURL(), true);
					}
					catch
					{
						DotNetNuke.UI.Skins.Skin.AddModuleMessage(this, "Delete Failed.", "Delete group failed. Group can't have any awards, officers, crowns, etc.", DotNetNuke.UI.Skins.Controls.ModuleMessage.ModuleMessageType.RedError);
					}
				}
				
			} 
			catch (Exception exc) 
			{
				Exceptions.ProcessModuleLoadException(this, exc);
			}
		}
		
		private void DisplayGroupInfo(int gid)
		{
			IDataReader dr = DataProvider.Instance().GetGroups(gid);

			if(dr.Read())
			{
				//Award Name
				txtName.Text= dr["Name"].ToString();
				if(!dr.IsDBNull(dr.GetOrdinal("ParentGroupId")))
					ddlParentGroup.SelectedValue = dr["ParentGroupId"].ToString();
				hlReturnToDisplay.NavigateUrl = Globals.NavigateURL(this.TabId,"", "list=group", "f=" + ddlParentGroup.SelectedValue);
				
				ddlBranchStatus.SelectedValue = dr["BranchStatusId"].ToString();
                
				ddlReignType.SelectedValue = dr["ReignType"].ToString();

				if(!dr.IsDBNull(dr.GetOrdinal("GroupDesignationId")))
					ddlDesignation.SelectedValue = dr["GroupDesignationId"].ToString();
                
				txtCode.Text = dr["Code"].ToString();
				txtLocation.Text = dr["Location"].ToString();
				txtPrecedence.Text =dr["Precedence"].ToString();
				txtFoundingDate.Text = dr["FoundingDate"].ToString();
				chkHidden.Checked = Convert.ToBoolean(dr["Hidden"]);

				
				txtArmsBlazon.Text = dr["ArmsBlazon"].ToString();
				
				txtSovereignMaleTitle.Text = dr["SovereignMaleTitle"].ToString();
				txtSovereignFemaleTitle.Text = dr["SovereignFemaleTitle"].ToString();
				txtConsortMaleTitle.Text = dr["ConsortMaleTitle"].ToString();
				txtConsortFemaleTitle.Text = dr["ConsortFemaleTitle"].ToString();
				txtRegencyType.Text = dr["RegentType"].ToString();
				txtRegentMaleTitle.Text = dr["RegentMaleTitle"].ToString();
				txtRegentFemaleTitle.Text = dr["RegentFemaleTitle"].ToString();
				
				txtSovereignBlazon.Text = dr["SovereignBlazon"].ToString();
				txtConsortBlazon.Text = dr["ConsortBlazon"].ToString();

				txtNotes.Text = dr["Notes"].ToString();
			
				urlInternalUrl.Url = dr["InternalUrl"].ToString();
				urlWebSiteUrl.Url = dr["WebsiteUrl"].ToString();

				imgGroupArms.ImageUrl = dr["ArmsURL"].ToString();
				if(imgGroupArms.ImageUrl.IndexOf("://")== -1 )
					imgGroupArms.ImageUrl = PortalSettings.HomeDirectory + imgGroupArms.ImageUrl;

				imgGroupArms.Height = (int)dr["ArmsURLHeight"];
				imgGroupArms.Width = (int)dr["ArmsURLWidth"];
				imgGroupArms.AlternateText = "Arms of " + txtName.Text + ": " + txtArmsBlazon.Text;
				urlGroupArmsUrl.Url = dr["ArmsURL"].ToString();

				imgSovereignArms.ImageUrl = dr["ArmsURL"].ToString();
				if(imgSovereignArms.ImageUrl.IndexOf("://")== -1 )
					imgSovereignArms.ImageUrl = PortalSettings.HomeDirectory + imgSovereignArms.ImageUrl;

				imgSovereignArms.Height = (int)dr["SovereignArmsUrlHeight"];
				imgSovereignArms.Width = (int)dr["SovereignArmsUrlWidth"];
				imgSovereignArms.AlternateText = "Arms of Sovereign of " + txtName.Text + ": " + txtSovereignBlazon.Text;
				urlSovereignArmsUrl.Url = dr["SovereignArmsUrl"].ToString();

				imgConsortArms.ImageUrl = dr["ConsortArmsUrl"].ToString();
				if(imgConsortArms.ImageUrl.IndexOf("://")== -1 )
					imgConsortArms.ImageUrl = PortalSettings.HomeDirectory + imgConsortArms.ImageUrl;

				imgConsortArms.Height = (int)dr["ConsortArmsUrlHeight"];
				imgConsortArms.Width = (int)dr["ConsortArmsUrlWidth"];
				imgConsortArms.AlternateText = "Arms of Consort of " + txtName.Text + ": " + txtConsortBlazon.Text;
				urlConsortArmsUrl.Url = dr["ConsortArmsURL"].ToString();

			}
				//Cleanup
				dr.Close();
			
		}

		
	}
}

