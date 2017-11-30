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

namespace JeffMartin.DNN.Modules.SCAOnlineOP
{
	partial class SCAOnlineDisplayCrown:UserControl
	{
		
		private bool _isEditable;
        #region Public Controls
        public System.Web.UI.WebControls.HyperLink EditCrown { get { return hlEditCrown; } }
        public System.Web.UI.WebControls.Literal CrownOrdinal { get { return litCrownOrdinal; } }
        public System.Web.UI.WebControls.Literal ReignType { get { return litReignType; } }
        public System.Web.UI.WebControls.HyperLink Group { get { return hlGroup; } }
        public System.Web.UI.WebControls.HyperLink Email { get { return hlEmail; } }
        public System.Web.UI.WebControls.Image CrownPhoto1 { get { return imgCrownPhoto1; } }
        public System.Web.UI.WebControls.Image CrownPhoto2 { get { return imgCrownPhoto2; } }
        public System.Web.UI.WebControls.Literal Caption1 { get { return litCaption1; } }
        public System.Web.UI.WebControls.Literal Caption2 { get { return litCaption2; } }
        public System.Web.UI.WebControls.Literal Credit1 { get { return litCredit1; } }
        public System.Web.UI.WebControls.Literal Credit2 { get { return litCredit2; } }
        public System.Web.UI.WebControls.Image SovereignArms { get { return imgSovereignArms; } }
        public System.Web.UI.WebControls.HyperLink SovereignName { get { return hlSovereignName; } }
        public System.Web.UI.WebControls.Image SovereignPersonalArms { get { return imgSovereignPersonalArms; } }
        public System.Web.UI.WebControls.Image ConsortArms { get { return imgConsortArms; } }
        public System.Web.UI.WebControls.HyperLink ConsortName { get { return hlConsortName; } }
        public System.Web.UI.WebControls.Image ConsortPersonalArms { get { return imgConsortPersonalArms; } }
        public System.Web.UI.WebControls.Panel Default { get { return pnlDefault; } }
        public System.Web.UI.HtmlControls.HtmlGenericControl CrownName { get { return H1CrownName; } }
        public System.Web.UI.HtmlControls.HtmlTableRow Crown { get { return trCrown; } }
        public System.Web.UI.HtmlControls.HtmlTableCell CrownInfo { get { return tdCrownInfo; } }
        public System.Web.UI.HtmlControls.HtmlTableRow Coronation { get { return trCoronation; } }
        public System.Web.UI.HtmlControls.HtmlTableCell CoronationInfo { get { return tdCoronationInfo; } }
        public System.Web.UI.HtmlControls.HtmlTableRow StepDown { get { return trStepDown; } }
        public System.Web.UI.HtmlControls.HtmlTableCell StepDownInfo { get { return tdStepDownInfo; } }
        public System.Web.UI.HtmlControls.HtmlTableCell Notes { get { return tdNotes; } }
        public System.Web.UI.HtmlControls.HtmlGenericControl SovereignBlazon { get { return divSovereignBlazon; } }
        public System.Web.UI.HtmlControls.HtmlGenericControl ConsortBlazon { get { return divConsortBlazon; } }
        public System.Web.UI.HtmlControls.HtmlGenericControl HeirsNotify { get { return divHeirsNotify; } }
        #endregion
        private int _crownId;

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
			this.Load += new System.EventHandler(this.Page_Load);
			this.PreRender += new EventHandler(SCAOnlineDisplayCrown_PreRender);

		}
		#endregion

		#region Page_Load

		private void Page_Load(object sender, System.EventArgs e)
		{
			try 
			{
			 
			} 
			catch (Exception exc) 
			{
				Exceptions.ProcessModuleLoadException(this, exc);
			}
		}

		#endregion

		public PortalModuleBase MyModule;
		
		public bool IsEditable
		{
			get{ return _isEditable;}
			set{_isEditable=value;
			hlEditCrown.Visible=_isEditable;}
		}


		public int CrownId
		{
			get{ return _crownId;}
			set{_crownId=value;
			 hlEditCrown.NavigateUrl = MyModule.EditUrl("cid", CrownId.ToString(), "crown");
			
			}
		}

		private void SCAOnlineDisplayCrown_PreRender(object sender, EventArgs e)
		{
			if(imgCrownPhoto1.ImageUrl.Equals(string.Empty))
			{
				imgCrownPhoto1.Visible=false;
			}
			if(imgCrownPhoto2.ImageUrl.Equals(string.Empty))
			{
				imgCrownPhoto2.Visible=false;
			}
			if(imgConsortArms.ImageUrl.Equals(string.Empty))
			{
				imgConsortArms.Visible=false;
			}
			if(imgConsortPersonalArms.ImageUrl.Equals(string.Empty))
			{
				imgConsortPersonalArms.Visible=false;
			}
			if(imgSovereignArms.ImageUrl.Equals(string.Empty))
			{
				imgSovereignArms.Visible=false;
			}
			if(imgSovereignPersonalArms.ImageUrl.Equals(string.Empty))
			{
				imgSovereignPersonalArms.Visible=false;
			}
			if(tdCoronationInfo.InnerText.Equals(string.Empty))
			{
				trCoronation.Visible=false;
			}
			if(tdCrownInfo.InnerText.Equals(string.Empty))
			{
				trCrown.Visible=false;
			}
			if(tdStepDownInfo.InnerText.Equals(string.Empty))
			{
				trStepDown.Visible=false;
			}
		}
	}
}

