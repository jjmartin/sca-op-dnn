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
using DotNetNuke.Entities.Portals;
using DotNetNuke.Services.Localization;
using DotNetNuke.Services.Exceptions;

namespace JeffMartin.DNN.Modules.SCAOnlineOP
{
	partial class SCAOnlineDisplayGroup:UserControl
	{
        public PortalInfo BasePortalInfo;
        public string BasePortalHttpAddress;

		private DataTable regnumDataSource;
		
		private string _armsUrl;
		private int _parentGroupId = Null.NullInteger;
		private string _parentGroupName;
		private bool _showPartOf;
		private bool _showAwardsList;
        private bool _showCrownsList;
		private bool _isEditable;
		
		private int _groupId;

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
			this.PreRender += new System.EventHandler(this.SCAOnlineDisplayGroup_PreRender);

		}
		#endregion

		#region Event Handlers

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

		public string ArmsUrl
		{
			get{ return _armsUrl;}
			set{_armsUrl=value;
				if(_armsUrl.IndexOf("://")== -1 )
					if(!_armsUrl.Trim().Equals(string.Empty))
						imgArms.ImageUrl=MyModule.PortalSettings.HomeDirectory+ _armsUrl;
					else
						imgArms.Visible = false;
				else
					imgArms.ImageUrl=_armsUrl;}
		}
		public double ArmsHeight
		{
			get{ return imgArms.Height.Value;}
			set{if(value!=0.0)
				imgArms.Height=new Unit(value, UnitType.Pixel);}
		}
		public double ArmsWidth
		{
			get{ return imgArms.Width.Value;}
			set{if(value!=0.0)
					imgArms.Width=new Unit(value, UnitType.Pixel);}
		}
		public string GroupName
		{
			get{ return H1GroupName.InnerText;}
			set{H1GroupName.InnerText=value;}
		}
		public string GroupLocation
		{
			get{ return divLocation.InnerText;}
			set{divLocation.InnerText=value;}
		}
        public string GroupStatus
        {
            get { return divStatus.InnerText; }
            set { divStatus.InnerText = value; }
        }

		public string WebsiteUrl
		{
			get{ return hlWebSiteUrl.NavigateUrl;}
			set{hlWebSiteUrl.NavigateUrl=value;
				hlWebSiteUrl.Text=value;}
		}

	

		public string NotesHtml
		{
			get{ return divNotes.InnerHtml;}
			set{divNotes.InnerHtml=value;}
		}
		
		public DataTable RegnumDataSource
		{
			get{ return (DataTable)rptRegnum.DataSource;}
			set{rptRegnum.DataSource = value;
			regnumDataSource = value;}
		}

		public void BindRegnum()
		{
			if(regnumDataSource.Rows.Count>=1)
			{
				rptRegnum.DataBind();
				
			}
			else
			{
				trRegnumHeader.Visible=false;
				rptRegnum.Visible=false;
				
			}
		}
		public string DisplayAddress(object Address1, object Address2, object City, object State, object Zip)
		{
			return Globals.FormatAddress(Address1,Address2,City,State,null,Zip);
		}
		public string DisplayEmail(object EmailToUse, object PersonalEmailAddress, object OfficeEmail, object OfficeEmailOverride)
		{
		    string emailLink = string.Empty;
            if (OfficeEmail is DBNull)
                OfficeEmail = "";
            switch (EmailToUse.ToString())
            {
                case "OfficePosition":
                    emailLink =
                        HtmlUtils.FormatEmail((string)OfficeEmail);
                    break;
                case "Override":
                    emailLink =
                        HtmlUtils.FormatEmail((string)OfficeEmailOverride);
                    break;
                default:
                    if(!(PersonalEmailAddress is DBNull))
                        emailLink = HtmlUtils.FormatEmail((string)PersonalEmailAddress);
                    break;
            }

		    return emailLink;

		}

		public int ParentGroupId
		{
			get{ return _parentGroupId;}
			set{_parentGroupId=value;}
		}


		public string ParentGroupName
		{
			get{ return _parentGroupName;}
			set{_parentGroupName=value;}
		}


		public bool ShowPartOf
		{
			get{ return _showPartOf;}
			set{_showPartOf=value;}
		}

		private void SCAOnlineDisplayGroup_PreRender(object sender, EventArgs e)
		{
			if(ShowPartOf)
			{
				if(Null.IsNull(ParentGroupId))
				{
					Label parentGroupLabel = new Label();
					parentGroupLabel.Text = ParentGroupName;
					divPartOf.Controls.Add(parentGroupLabel);
				}
				else
				{
					HyperLink parentGroupLink = new HyperLink();
					parentGroupLink.Text = ParentGroupName;
					parentGroupLink.NavigateUrl = Globals.NavigateURL(MyModule.TabId, string.Empty, "gid=" + ParentGroupId.ToString());
					divPartOf.Controls.Add(parentGroupLink);
				}
			}
			else
			{
				divPartOf.Visible=false;
			}
			if(ShowAwardsList)
			{
				hlAwardList.NavigateUrl = Globals.NavigateURL(MyModule.TabId, "", "list=charters","f=" + GroupId.ToString());
				trAwardsHeader.Visible = true;
			}
            if (ShowCrownsList)
            {
                hlCrownList.NavigateUrl = Globals.NavigateURL(MyModule.TabId, "", "list=crown", "f=" + GroupId.ToString());
                trCrownsHeader.Visible = true;
            }
		}

		public bool IsEditable
		{
			get{ return _isEditable;}
			set{_isEditable=value;
			hlEditGroup.Visible=_isEditable;}
		}


		public int GroupId
		{
			get{ return _groupId;}
			set{_groupId=value;
			 hlEditGroup.NavigateUrl = MyModule.EditUrl("gid", GroupId.ToString(), "group");
			
			}
		}


		public bool ShowAwardsList
		{
			get{ return _showAwardsList;}
			set{_showAwardsList=value;}
		}
        public bool ShowCrownsList
        {
            get { return _showCrownsList; }
            set { _showCrownsList = value; }
        }
	}
}

