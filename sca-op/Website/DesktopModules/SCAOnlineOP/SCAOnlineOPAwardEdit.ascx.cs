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
	partial class SCAOnlineOPAwardEdit : PortalModuleBase
	{
		
		
		
		#region protected Members
		protected int aid;
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

		}
		#endregion


		private void Page_Load(object sender, System.EventArgs e)
		{
			try 
			{

				if (!(Request.Params["aid"] == null)) 
				{
					aid = Int32.Parse(Request.Params["aid"]);
				} 
				else 
				{
					aid = Null.NullInteger;
				}
				if (!Page.IsPostBack) 
				{
					BindGroupDDL(ddlGroup);
					BindAwardGroupDDL(ddlAwardGroup);
					cmdDelete.Attributes.Add("onClick", "javascript:return confirm('Confirm Award Delete. This will not work if any members have this award.');");
					if (!Null.IsNull(aid)) 
					{
						DisplayAwardInfo(aid);
						cmdDelete.Visible = true;
					}
					urlBadge.FileFilter = Globals.glbImageFileTypes;
					
				}
				
				hlReturnToDisplay.NavigateUrl = Globals.NavigateURL(this.TabId,"", "aid=" +aid.ToString());
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

		private void BindAwardGroupDDL(DropDownList ddl)
		{
			DataTable dt = DataProvider.ConvertDataReaderToDataTable(DataProvider.Instance().ListAwardGroups());
			ddl.DataSource = dt;
			ddl.DataTextField = "AwardGroupNameGroup";
			ddl.DataValueField = "AwardGroupId";
			ddl.DataBind();
			ddl.Items.Insert(0, new ListItem("<none selected>", Null.NullInteger.ToString()));
		}

		private void cmdUpdate_Click(object sender, EventArgs e)
		{
			try 
			{
				if (Page.IsValid == true) 
				{
					int precedence = Null.NullInteger;
					if(txtPrecedence.Text.Trim()!=string.Empty)
						precedence = Convert.ToInt32(txtPrecedence.Text);
					int sortOrder = Null.NullInteger;
					if(txtSortOrder.Text.Trim()!=string.Empty)
						sortOrder = Convert.ToInt32(txtSortOrder.Text);
						
					if (Null.IsNull(aid)) 
					{
						aid = DataProvider.Instance().AddAwards(
							Convert.ToInt32(ddlGroup.SelectedValue),
							txtAwardName.Text,
							teCharter.Text,
							precedence,
							sortOrder,
							urlBadge.Url,
							txtBlazon.Text,
							chkClosed.Checked,
							Convert.ToInt32(rblAwardedBy.SelectedValue),
							Convert.ToInt32(ddlAwardGroup.SelectedValue),
                            chkHonorary.Checked
							);
					} 
					else 
					{
						DataProvider.Instance().UpdateAwards(
							aid,
							Convert.ToInt32(ddlGroup.SelectedValue),
							txtAwardName.Text,
							teCharter.Text,
							precedence,
							sortOrder,
							urlBadge.Url,
							txtBlazon.Text,
							chkClosed.Checked,
							Convert.ToInt32(rblAwardedBy.SelectedValue),
							Convert.ToInt32(ddlAwardGroup.SelectedValue),
		                    chkHonorary.Checked
							);
					}

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
						Response.Redirect(Globals.NavigateURL(this.TabId, "", "aid=" + aid.ToString()), true);
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
				else if(aid!=Null.NullInteger)
					Response.Redirect(Globals.NavigateURL(this.TabId, "", "aid=" + aid.ToString()), true);
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
				if (!Null.IsNull(aid)) 
				{
					try
					{
						DataProvider.Instance().DeleteAwards(aid);
						Response.Redirect(Globals.NavigateURL(), true);
					}
					catch
					{
						DotNetNuke.UI.Skins.Skin.AddModuleMessage(this, "Delete Failed.", "Delete Award Failed.  You must remove all members of this award before deleting.", DotNetNuke.UI.Skins.Controls.ModuleMessage.ModuleMessageType.RedError);
					}
				}
				
			} 
			catch (Exception exc) 
			{
				Exceptions.ProcessModuleLoadException(this, exc);
			}
		}
		
		private void DisplayAwardInfo(int aid)
		{
			IDataReader dr = DataProvider.Instance().GetAwards(aid);

			if(dr.Read())
			{

				//Award Name
				H1AwardName.InnerText = dr["Name"].ToString();
				txtAwardName.Text = dr["Name"].ToString();
				txtPrecedence.Text = dr["Precedence"].ToString();
				txtSortOrder.Text = dr["SortOrder"].ToString();

				ddlGroup.SelectedValue = dr["GroupId"].ToString();
				rblAwardedBy.SelectedValue = dr["AwardedById"].ToString();

				if(dr.IsDBNull(dr.GetOrdinal("AwardGroupId")))
                    ddlAwardGroup.SelectedValue = Null.NullInteger.ToString();
				else
					ddlAwardGroup.SelectedValue = dr["AwardGroupId"].ToString();

				chkClosed.Checked= Convert.ToBoolean(dr["Closed"]);
                chkHonorary.Checked = Convert.ToBoolean(dr["Honorary"]);

				//Arms Image and Blazon
				txtBlazon.Text = dr["BadgeBlazon"].ToString();
			
				if(dr.IsDBNull(dr.GetOrdinal("BadgeUrl"))||
					dr["BadgeUrl"].ToString().Trim().Equals(string.Empty))
				{
					imgAwardBadge.Visible = false;
				}
				else
				{
					imgAwardBadge.Visible=true;
					imgAwardBadge.ImageUrl = dr["BadgeUrl"].ToString();
					if(imgAwardBadge.ImageUrl.IndexOf("://")== -1 )
						imgAwardBadge.ImageUrl = PortalSettings.HomeDirectory + imgAwardBadge.ImageUrl;
					imgAwardBadge.Height = (int)dr["BadgeUrlHeight"];
					imgAwardBadge.Width = (int)dr["BadgeUrlWidth"];
					imgAwardBadge.AlternateText = "Badge of " + H1AwardName.InnerText + ": " + txtBlazon.Text;
					urlBadge.Url = dr["BadgeUrl"].ToString();
				}
				
				H2AwardCharter.Visible=true;
				teCharter.Visible  = true;
				teCharter.Text = dr["Charter"].ToString();
			
				
				//Cleanup
				dr.Close();

			}
		}

		


		}
}
