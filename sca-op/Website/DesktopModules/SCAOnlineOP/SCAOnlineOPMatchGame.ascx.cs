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
using JeffMartin.DNN.Modules.SCAOnlineOP.Data;

namespace JeffMartin.DNN.Modules.SCAOnlineOP
{
	partial class SCAOnlineOPMatchGame:PortalModuleBase
	{
		
		private Hashtable answerKey = new Hashtable();
		const string LETTERS = "ABCDEFGHIJ";
		private ModuleInfo OPModuleInfo;
		
		
		#region Web Form Designer generated code
		override protected void OnInit(EventArgs e)
		{
			//
			// CODEGEN: This call is required by the ASP.NET Web Form Designer.
			//
			InitializeComponent();
			base.OnInit(e);
		}
		
		/// <summary>
		///		Required method for Designer support - do not modify
		///		the contents of this method with the code editor.
		/// </summary>
		private void InitializeComponent()
		{
			this.btnStartGame.Click += new System.EventHandler(this.btnStartGame_Click);
			this.rptPictures.ItemDataBound += new System.Web.UI.WebControls.RepeaterItemEventHandler(this.rptPictures_ItemDataBound);
			this.dlNames.ItemDataBound += new System.Web.UI.WebControls.DataListItemEventHandler(this.dlNames_ItemDataBound);
			this.btnSubmitGuess.Click += new System.EventHandler(this.btnSubmitGuess_Click);
			this.Load += new System.EventHandler(this.Page_Load);

		}
		#endregion

		#region Page_Load

		private void Page_Load(object sender, System.EventArgs e)
		{
			try 
			{
				
				OPModuleInfo = (ModuleInfo)DataCache.GetCache("OPModule");
				if(OPModuleInfo==null)
				{
					ModuleController mControl = new ModuleController();
					OPModuleInfo = mControl.GetModuleByDefinition(this.PortalId, "SCAOnlineOP");
					DataCache.SetCache("OPTab", OPModuleInfo);
				}
			} 
			catch (Exception exc) 
			{
				Exceptions.ProcessModuleLoadException(this, exc);
			}
		}

		#endregion

		private void btnStartGame_Click(object sender, System.EventArgs e)
		{
			lblResponse.Visible = false;
			lblGuessCount.Text = "0";
			divNameList.Visible = true;
			btnSubmitGuess.Visible =true;
			DataTable gameData = DataProvider.ConvertDataReaderToDataTable( 
				DataProvider.Instance().ListPeopleForGame(
				int.Parse(ddlDifficulty.SelectedValue), rblGameType.SelectedValue));

			if(!chkShow10.Checked)
			{
				while(gameData.Rows.Count>5)
					gameData.Rows.RemoveAt(gameData.Rows.Count-1);
			}
			ArrayList rows = new ArrayList( gameData.Select("","random"));
			while(rows.Count>5) //Always show just 5 pictures
				rows.RemoveAt(rows.Count-1);		
			rptPictures.DataSource = rows;
			

			DataView sortedNames = gameData.DefaultView;
			sortedNames.Sort = "SCAName asc";
			
			for(int i=0;i<sortedNames.Count;i++)
			{
				answerKey.Add(Convert.ToInt32(sortedNames[i]["PeopleId"]), LETTERS[i]);
			}
			
			dlNames.DataSource = sortedNames;
			dlNames.DataKeyField = "PeopleId";
			rptPictures.DataBind();
			dlNames.DataBind();
			


		}

		private void rptPictures_ItemDataBound(object sender, RepeaterItemEventArgs e)
		{
			Image imgPicture = (Image)e.Item.FindControl("imgPicture");
			Label lblCorrectAnswer = (Label)e.Item.FindControl("lblCorrectAnswer");
			DataRow row = (DataRow)e.Item.DataItem;
			lblCorrectAnswer.Text = answerKey[row["PeopleId"]].ToString();

			string imageType = rblGameType.SelectedValue + "Url";
			imgPicture.ImageUrl = row[imageType].ToString();
			if(imgPicture.ImageUrl.IndexOf("://")== -1 )
				imgPicture.ImageUrl = PortalSettings.HomeDirectory + imgPicture.ImageUrl;
			imgPicture.Height = ((int)row[imageType + "Height"]==0?Unit.Empty:(int)row[imageType + "Height"]);
			imgPicture.Width = ((int)row[imageType + "Width"]==0?Unit.Empty:(int)row[imageType + "Width"]);
			imgPicture.AlternateText="Guess who this is.";

		}
	
		private void dlNames_ItemDataBound(object sender, DataListItemEventArgs e)
		{
			Label lblLetter = (Label)e.Item.FindControl("lblLetter");
			HyperLink hlName = (HyperLink)e.Item.FindControl("hlName");
			
			DataRowView row  = (DataRowView)e.Item.DataItem;
			lblLetter.Text = answerKey[row["PeopleId"]].ToString() + ".";
			hlName.Text = row["SCAName"].ToString();
			hlName.Target = "_blank";
			hlName.NavigateUrl = Globals.NavigateURL(OPModuleInfo.TabID,"", "memid=" +row["PeopleId"].ToString());
			hlName.Enabled = false;
		}

		private void btnSubmitGuess_Click(object sender, System.EventArgs e)
		{
			int GuessCount = int.Parse(lblGuessCount.Text);
			GuessCount++;
			lblGuessCount.Text = GuessCount.ToString();
			int CorrectAnswers = 0;
			foreach(RepeaterItem item in  rptPictures.Items)
			{
				TextBox txtAnswer = (TextBox)item.FindControl("txtAnswer");
				Label lblCorrectAnswer = (Label)item.FindControl("lblCorrectAnswer");
				if(txtAnswer.Text.ToLower() == lblCorrectAnswer.Text.ToLower())
					CorrectAnswers++;
			}
			lblResponse.Visible = true;
			if(CorrectAnswers==5)
			{
				lblResponse.Text =string.Empty;
				switch(rblGameType.SelectedValue)
				{
					case "Arms":
						if(GuessCount==1)
							lblResponse.Text = "<br/>You know your field heraldry well!";
							lblResponse.Text+= "<br/>All answers were correct.";
						break;
					default://photos
						if(GuessCount==1)
							lblResponse.Text = "<br/>You know your fellow SCAdians well!";
							lblResponse.Text+= "<br/>All answers were correct.";
						
						break;
				}
			    lblResponse.Text +=
			        "<br/><span style=\"font-size:12px;font-wieght:normal;\">The names above now link to those individual records if you wish to learn more about these individuals.</span>";
				btnSubmitGuess.Visible =false;
				//Enable the links...
				foreach(DataListItem item in dlNames.Items)
				{
					HyperLink hlName = (HyperLink)item.FindControl("hlName");
					hlName.Enabled = true;
				}
			}
			else
			{
				lblResponse.Text = "<br/>You identified " + CorrectAnswers.ToString() + " out of 5 correctly.  Change your answers and try again.";
			}	
		}
	}
}

