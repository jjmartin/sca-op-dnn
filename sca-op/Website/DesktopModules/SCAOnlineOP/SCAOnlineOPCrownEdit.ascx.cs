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
	partial class SCAOnlineOPCrownEdit : PortalModuleBase
	{
		
		
		#region Private Members
		private int cid;
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
			btnSearchOP.Click+=new EventHandler(btnSearchOP_Click);
			
			
			
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

				if (!(Request.Params["cid"] == null)) 
				{
					cid = Int32.Parse(Request.Params["cid"]);
				} 
				else 
				{
					cid = Null.NullInteger;
				}
				hlReturnToDisplay.NavigateUrl = Globals.NavigateURL(this.TabId,"", "list=crown");
				hlCrownDateCalendar.NavigateUrl = DotNetNuke.Common.Utilities.Calendar.InvokePopupCal(txtCrownDate);
				hlStartDateCalendar.NavigateUrl = DotNetNuke.Common.Utilities.Calendar.InvokePopupCal(txtStartDate);
				hlEndDateCalendar.NavigateUrl = DotNetNuke.Common.Utilities.Calendar.InvokePopupCal(txtEndDate);
				if (!Page.IsPostBack) 
				{
					BindGroupDDL(ddlGroup);
					cmdDelete.Attributes.Add("onClick", "javascript:return confirm('Confirm Crown Delete. This will not work if any awards have this been given by this crown.');");
					if (!Null.IsNull(cid)) 
					{
						DisplayCrownInfo(cid);
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
			if(ddl.Items.FindByValue("26")!=null)
			{
				ddl.SelectedValue="26";
			}
		}

		private void cmdUpdate_Click(object sender, EventArgs e)
		{
			try 
			{
				if (Page.IsValid == true) 
				{
					DateTime startDate = Null.NullDate;
					if(txtStartDate.Text.Trim()!=string.Empty)
						startDate = Convert.ToDateTime(txtStartDate.Text);

					DateTime EndDate = Null.NullDate;
					if(txtEndDate.Text.Trim()!=string.Empty)
						EndDate = Convert.ToDateTime(txtEndDate.Text);

					DateTime CrownDate = Null.NullDate;
					if(txtCrownDate.Text.Trim()!=string.Empty)
						CrownDate = Convert.ToDateTime(txtCrownDate.Text);
					
					int ConsortId = Null.NullInteger;
					if(txtConsortId.Text.Trim()!=string.Empty)
						ConsortId = Convert.ToInt32(txtConsortId.Text);
						
					if (Null.IsNull(cid)) 
					{
						cid = DataProvider.Instance().AddCrowns(
							Convert.ToInt32(ddlGroup.SelectedValue),
							Convert.ToInt32(txtReign.Text),
							Convert.ToInt32(txtSovereignId.Text),
							ConsortId,
							txtNotes.Text,
							startDate,
							EndDate,
							txtCoronationLocation.Text,
							CrownDate,
							txtCrownLocation.Text,
							txtStepDownLocation.Text,
							urlInternalUrl.Url,
							chkHeir.Checked,
							urlPicture1Url.Url, //picture1
							urlPicture2Url.Url, //picture2
							txtPicture1Caption.Text, //picture1caption
							txtPicture2Caption.Text, //picture2caption
							txtPicture1Credit.Text, //picture1credit
							txtPicture2Credit.Text, //picture2credit
							txtEmail.Text, //Email
							chkRegent.Checked //regent
							);
					} 
					else 
					{
						DataProvider.Instance().UpdateCrowns(
							cid,
							Convert.ToInt32(ddlGroup.SelectedValue),
							Convert.ToInt32(txtReign.Text),
							Convert.ToInt32(txtSovereignId.Text),
							ConsortId,
							txtNotes.Text,
							startDate,
							EndDate,
							txtCoronationLocation.Text,
							CrownDate,
							txtCrownLocation.Text,
							txtStepDownLocation.Text,
							urlInternalUrl.Url,						
							chkHeir.Checked,
							urlPicture1Url.Url, //picture1
							urlPicture2Url.Url, //picture2
							txtPicture1Caption.Text, //picture1caption
							txtPicture2Caption.Text, //picture2caption
							txtPicture1Credit.Text, //picture1credit
							txtPicture2Credit.Text, //picture2credit
							txtEmail.Text, //Email
							chkRegent.Checked //regent
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
						Response.Redirect(Globals.NavigateURL(this.TabId, "", "cid=" + cid.ToString()), true);
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
				else if(cid!=Null.NullInteger)
					Response.Redirect(Globals.NavigateURL(this.TabId, "", "cid=" + cid.ToString()), true);
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
				if (!Null.IsNull(cid)) 
				{
					try
					{
						DataProvider.Instance().DeleteCrowns(cid);
						Response.Redirect(Globals.NavigateURL(), true);
					}
					catch
					{
						DotNetNuke.UI.Skins.Skin.AddModuleMessage(this, "Delete Failed.", "Delete crown failed. Crown cannot have given any awards.", DotNetNuke.UI.Skins.Controls.ModuleMessage.ModuleMessageType.RedError);
					}
				}
				
			} 
			catch (Exception exc) 
			{
				Exceptions.ProcessModuleLoadException(this, exc);
			}
		}
		
		private void DisplayCrownInfo(int cid)
		{
			IDataReader dr = DataProvider.Instance().GetCrowns(cid);

			if(dr.Read())
			{
				//Award Name
				txtReign.Text= dr["Reign"].ToString();
				chkHeir.Checked = Convert.ToBoolean(dr["Heir"]);
				chkRegent.Checked = Convert.ToBoolean(dr["Regent"]);

				ddlGroup.SelectedValue = dr["GroupId"].ToString();
				hlReturnToDisplay.NavigateUrl = Globals.NavigateURL(this.TabId,"", "list=crown", "f=" + ddlGroup.SelectedValue);
				
				hlSovereign.Text = dr["SovereignName"].ToString();
				hlSovereign.NavigateUrl = Globals.NavigateURL(this.TabId, "", "memid=" + dr["SovereignId"].ToString());
				txtSovereignId.Text = dr["SovereignId"].ToString();

				hlConsort.Text = dr["ConsortName"].ToString();
				hlConsort.NavigateUrl = Globals.NavigateURL(this.TabId, "", "memid=" + dr["ConsortId"].ToString());
				txtConsortId.Text = dr["ConsortId"].ToString();

				if(!dr.IsDBNull(dr.GetOrdinal("StartDate")))
					txtStartDate.Text = ((DateTime)dr["StartDate"]).ToShortDateString();
				if(!dr.IsDBNull(dr.GetOrdinal("EndDate")))
					txtEndDate.Text = ((DateTime)dr["EndDate"]).ToShortDateString();
				if(!dr.IsDBNull(dr.GetOrdinal("CrownTournamentDate")))
					txtCrownDate.Text = ((DateTime)dr["CrownTournamentDate"]).ToShortDateString();

				txtCrownLocation.Text = dr["CrownTournamentLocation"].ToString();
				txtCoronationLocation.Text = dr["CoronationLocation"].ToString();
				txtStepDownLocation.Text = dr["SteppingDownLocation"].ToString();

				txtNotes.Text = dr["Notes"].ToString();
			
				urlInternalUrl.Url = dr["InternalUrl"].ToString();

				imgPicture1.ImageUrl = dr["Picture1Url"].ToString();
				if(imgPicture1.ImageUrl.IndexOf("://")== -1 )
					imgPicture1.ImageUrl = PortalSettings.HomeDirectory + imgPicture1.ImageUrl;

				imgPicture1.Height = (int)dr["Picture1Height"];
				imgPicture1.Width = (int)dr["Picture1Width"];
				imgPicture1.AlternateText = dr["Picture1Caption"].ToString();

				urlPicture1Url.Url = dr["Picture1Url"].ToString();
				txtPicture1Caption.Text= dr["Picture1Caption"].ToString();
				txtPicture1Credit.Text= dr["Picture1Credit"].ToString();

				imgPicture2.ImageUrl = dr["Picture2Url"].ToString();
				if(imgPicture2.ImageUrl.IndexOf("://")== -1 )
					imgPicture2.ImageUrl = PortalSettings.HomeDirectory + imgPicture2.ImageUrl;

				imgPicture2.Height = (int)dr["Picture2Height"];
				imgPicture2.Width = (int)dr["Picture2Width"];
				imgPicture2.AlternateText = dr["Picture2Caption"].ToString();

				urlPicture2Url.Url = dr["Picture2Url"].ToString();
				txtPicture2Caption.Text= dr["Picture2Caption"].ToString();
				txtPicture2Credit.Text= dr["Picture2Credit"].ToString();

				txtEmail.Text = dr["Email"].ToString();



			}
				//Cleanup
				dr.Close();
			
		}

		private void btnSearchOP_Click(object sender, EventArgs e)
		{
			((HyperLinkColumn)dgResultList.Columns[1]).DataNavigateUrlFormatString = Globals.NavigateURL(this.TabId,"","memid=" + int.MaxValue.ToString()).Replace(int.MaxValue.ToString(),"{0}");
			string filter = txtSearchOP.Text;
			string filterType = rblFilterType.SelectedValue.ToLower();
			if(filterType == "c")
			{
				filter="%"+filter+"%";
				rblFilterType.SelectedValue="c";
			}
			else
				filter+="%";
            DataSet ds = DataProvider.ConvertDataReaderToDataSet(DataProvider.Instance().ListPeople(filter, "n", "a",false,false,true,false,true,26, true,false));
			dgResultList.DataSource = ds;
			dgResultList.DataBind();
		}
	}
}
