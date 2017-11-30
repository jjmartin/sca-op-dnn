using System;
using System.Collections;
using System.Data;
using System.Text.RegularExpressions;
using System.Web.UI;
using System.Web.UI.WebControls;
using DotNetNuke.Common;
using DotNetNuke.Common.Utilities;
using DotNetNuke.Entities.Modules;
using DotNetNuke.Entities.Portals;
using DotNetNuke.Security;
using JeffMartin.DNN.Modules.SCAOnlineOP.Data;
using JeffMartin.DNN.Modules.ScaOnlineOP.Utility;

namespace JeffMartin.DNN.Modules.SCAOnlineOP
{
    /// <summary>
    ///		Summary description for SCAOfficer.
    /// </summary>
    public partial class SCAOfficerList : PortalModuleBase
    {
        public string BasePortalHttpAddress;
        public PortalInfo BasePortalInfo;
        public PortalSettings BasePortalSettings;
        public PortalModuleBase MyModule;
        public int OPTabId;
        private DataTable regnumDataSource;
        private bool UseCrownLinkSetting;

        private void Page_Load(object sender, EventArgs e)
        {
            MyModule = this;
            SetupBasePortalInfo();
            UseCrownLinkSetting = Settings["UseCrownLink"] == null ? false : Convert.ToBoolean(Settings["UseCrownLink"]);
            int crownId = -1;
            if (Settings["CrownId"] != null && !string.IsNullOrEmpty(Settings["CrownId"].ToString()))
                crownId = Convert.ToInt32(Settings["CrownId"]);

            string OfficePositionsId = Settings["OfficePositionsId"] == null
                                           ? ""
                                           : ((string)Settings["OfficePositionsId"]).Replace(",", " ");

            DateTime DisplayDate;
            bool validDisplayDate = DateTime.TryParse(Settings["DisplayDate"] as String, out DisplayDate);

            if (!(Convert.ToBoolean(Settings["UseDisplayDate"]) && validDisplayDate))
                DisplayDate = DateTime.Now;


            regnumDataSource =
                DataProvider.ConvertDataReaderToDataTable(
                    DataProvider.Instance().GetRegnumforByOfficerPositionIds(OfficePositionsId,
                                                                             Convert.ToBoolean(Settings["ShowVacant"]),
                                                                             Convert.ToBoolean(Settings["ShowHistory"]),
                                                                             UseCrownLinkSetting, crownId, DisplayDate));

            if (Convert.ToBoolean(Settings["IncludeRulers"]))
            {
                DataTable rulers;
                if (UseCrownLinkSetting)
                    rulers = DataProvider.ConvertDataReaderToDataTable(
                        DataProvider.Instance().GetRegnumRulersOnly(Convert.ToInt32(Settings["GroupId"]), crownId, DisplayDate));
                else
                {
                    rulers = DataProvider.ConvertDataReaderToDataTable(
                        DataProvider.Instance().GetRegnumRulersOnly(Convert.ToInt32(Settings["GroupId"]), DisplayDate));
                }
                rulers.Merge(regnumDataSource);
                regnumDataSource = rulers;
            }
            if (Settings["ItemTemplate"] == null)
            {
                Settings["ItemTemplate"] = SCAOfficerListUtility.DefaultItemTemplate;
                ModuleController objModules = new ModuleController();
                objModules.UpdateModuleSetting(ModuleId, "ItemTemplate", SCAOfficerListUtility.DefaultItemTemplate);
            }
            BindRegnum();
        }

        public string DisplayAddress(object address1, object address2, object city, object state, object zip)
        {
            return Globals.FormatAddress(address1, address2, city, state, null, zip);
        }

        public string DisplayEmail(object emailAddress)
        {
            if (!emailAddress.Equals(string.Empty))
                return HtmlUtils.FormatEmail((string)emailAddress);
            else
                return string.Empty;
        }


        protected override void OnInit(EventArgs e)
        {
            //
            // CODEGEN: This call is required by the ASP.NET Web Form Designer.
            //
            InitializeComponent();
            base.OnInit(e);
            base.Actions.Add(GetNextActionID(), "Edit Officer List", string.Empty, string.Empty, string.Empty,
                             base.EditUrl(string.Empty, string.Empty, "Edit"), false,
                             SecurityAccessLevel.Edit, true, false);
        }

        /// <summary>
        ///		Required method for Designer support - do not modify
        ///		the contents of this method with the code editor.
        /// </summary>
        private void InitializeComponent()
        {
            Load += new EventHandler(Page_Load);
            rptRegnum.ItemDataBound += new RepeaterItemEventHandler(rptRegnum_ItemDataBound);
        }

        private void rptRegnum_ItemDataBound(object sender, RepeaterItemEventArgs e)
        {
            if (e.Item.ItemType == ListItemType.Header && Settings["HeaderTemplate"] != null)
            {
                e.Item.Controls.Clear();
                Literal HeaderLit = new Literal();
                HeaderLit.Text = Settings["HeaderTemplate"].ToString();
                e.Item.Controls.Add(HeaderLit);
            }
            if (e.Item.ItemType == ListItemType.Footer && Settings["FooterTemplate"] != null)
            {
                e.Item.Controls.Clear();
                Literal FooterLit = new Literal();
                FooterLit.Text = Settings["FooterTemplate"].ToString();
                e.Item.Controls.Add(FooterLit);
            }
            if ((e.Item.ItemType == ListItemType.Item || e.Item.ItemType == ListItemType.AlternatingItem) &&
                Settings["ItemTemplate"] != null)
            {
                e.Item.Controls.Clear();
                Literal ItemLit = new Literal();
                string LiteralText = ProcessItemTemplate(Settings["ItemTemplate"].ToString(),
                                                         (DataRowView)e.Item.DataItem);
                ItemLit.Text = LiteralText;
                e.Item.Controls.Add(ItemLit);
            }
        }

        private string ProcessItemTemplate(string s, DataRowView dataItem)
        {
            string result = s;

            bool OfficeIsCurrent = false;
            if ((!(dataItem["StartDate"] is DBNull) && !(dataItem["EndDate"] is DBNull) &&
                 DateTime.Today >= Convert.ToDateTime(dataItem["StartDate"]) &&
                 DateTime.Today <= Convert.ToDateTime(dataItem["EndDate"])) || // Between start and end
                (!(dataItem["StartDate"] is DBNull) && (dataItem["EndDate"] is DBNull) &&
                 DateTime.Today >= Convert.ToDateTime(dataItem["StartDate"]))
                // its now after start date, no end date
                )
                OfficeIsCurrent = true;

            string officeEmail = "";
            bool isCrown = Convert.ToInt32(dataItem["OfficerPositionId"]) == -1;

            if (OfficeIsCurrent)
            {
                switch (dataItem["EmailToUse"].ToString())
                {
                    case "OfficePosition":
                        officeEmail = dataItem["OfficeEmail"].ToString();
                        break;
                    case "Override":
                        officeEmail = dataItem["EmailOverride"].ToString();
                        break;
                    default:
                        officeEmail = dataItem["EmailAddress"].ToString();
                        break;
                }
                if (isCrown && !(dataItem["OfficeEmail"] is DBNull)) //crown
                {
                    officeEmail = dataItem["OfficeEmail"].ToString();
                }
            }
            else
                officeEmail = string.Empty;

            string BadgeImage =
                string.Format(@"<img height=""{0}"" width=""{1}"" src=""{2}"" />", dataItem["BadgeURLHeight"],
                              dataItem["BadgeURLWidth"],
                              BasePortalHttpAddress + BasePortalInfo.HomeDirectory + dataItem["BadgeUrl"]);
            if (dataItem["BadgeUrl"].ToString().Trim().Equals(string.Empty) ||
                dataItem["BadgeUrl"].ToString().ToLower().StartsWith("fileid="))
                BadgeImage = string.Empty;
            result = result.Replace("[OfficeBadge]", BadgeImage);

            string PhotoImage =
                string.Format(@"<img height=""{0}"" width=""{1}"" src=""{2}"" />", dataItem["PhotoURLHeight"],
                              dataItem["PhotoURLWidth"],
                              BasePortalHttpAddress + BasePortalInfo.HomeDirectory + dataItem["PhotoUrl"]);
            if (dataItem["PhotoUrl"].ToString().Trim().Equals(string.Empty) ||
                dataItem["PhotoUrl"].ToString().ToLower().StartsWith("fileid="))
                PhotoImage = string.Empty;
            result = result.Replace("[Photo]", PhotoImage);

            string ArmsImage =
                string.Format(@"<img height=""{0}"" width=""{1}"" src=""{2}"" />", dataItem["ArmsURLHeight"],
                              dataItem["ArmsURLWidth"],
                              BasePortalHttpAddress + BasePortalInfo.HomeDirectory + dataItem["ArmsUrl"]);
            if (dataItem["ArmsUrl"].ToString().Trim().Equals(string.Empty) ||
                dataItem["ArmsUrl"].ToString().ToLower().StartsWith("fileid="))
                ArmsImage = string.Empty;
            result = result.Replace("[PersonalArms]", ArmsImage);

            string OfficerTitle = Convert.ToBoolean(dataItem["Acting"]) ? "ACTING " : string.Empty;
            OfficerTitle += dataItem["Title"];
            if (!(dataItem["LinkedToCrown"] is DBNull) && Convert.ToBoolean(dataItem["LinkedToCrown"]) &&
                (!UseCrownLinkSetting))
                OfficerTitle += " for <a href=\"" +
                                Globals.NavigateURL(TabId, "", "cid=" + dataItem["LinkedCrownId"]) +
                                "\">" + dataItem["LinkedCrownDisplay"].ToString() + "</a>";
            result = result.Replace("[OfficeTitle]", OfficerTitle);


            string OfficeSubTitle = dataItem["PositionSubTitle"].ToString();
            result = result.Replace("[OfficeSubTitle]", OfficeSubTitle);

            string OfficeTermStart = dataItem["StartDate"] is DBNull
                                         ? "N/A"
                                         : ((DateTime)dataItem["StartDate"]).ToShortDateString();
            result = result.Replace("[OfficeTermStart]", OfficeTermStart);

            string OfficeTermEnd = dataItem["EndDate"] is DBNull
                                       ? "N/A"
                                       : ((DateTime)dataItem["EndDate"]).ToShortDateString();
            result = result.Replace("[OfficeTermEnd]", OfficeTermEnd);

            string PersonalTitle = dataItem["TitlePrefix"].ToString().Trim();
            result = result.Replace("[PersonalTitle]", PersonalTitle);

            string SCAName = dataItem["SCAName"].ToString();
            result = result.Replace("[SCAName]", SCAName);

            string OPLink =
                Globals.NavigateURL(OPTabId, BasePortalSettings, "",
                                    "memid=" + dataItem["PeopleId"].ToString());
            result = result.Replace("[OPLink]", OPLink);

            string HonorsSuffix = dataItem["HonorsSuffix"].ToString();
            result = result.Replace("[HonorsSuffix]", HonorsSuffix);

            string ModernName = dataItem["MundaneName"].ToString();
            result = result.Replace("[ModernName]", ModernName);

            string FullAddress =
                DisplayAddress(DataBinder.Eval(dataItem, "Address1"), DataBinder.Eval(dataItem, "Address2"),
                               DataBinder.Eval(dataItem, "City"), DataBinder.Eval(dataItem, "State"),
                               DataBinder.Eval(dataItem, "Zip"));
            result = result.Replace("[1LineAddress]", FullAddress);

            string Address1 = dataItem["Address1"].ToString();
            result = result.Replace("[Address1]", Address1);

            string Address2 = dataItem["Address2"].ToString();
            result = result.Replace("[Address2]", Address2);

            string City = dataItem["City"].ToString();
            result = result.Replace("[City]", City);

            string State = dataItem["State"].ToString();
            result = result.Replace("[State]", State);

            string Zip = dataItem["Zip"].ToString();
            result = result.Replace("[Zip]", Zip);

            string Phone1 = dataItem["Phone1"].ToString();
            result = result.Replace("[Phone1]", Phone1);

            string Phone2 = dataItem["Phone2"].ToString();
            result = result.Replace("[Phone2]", Phone2);

            string EmailLink = DisplayEmail(officeEmail);
            result = result.Replace("[EmailLink]", EmailLink);

            result = result.Replace("[EmailAddress]", officeEmail);

            string Notes = dataItem["OfficerNotes"].ToString();
            Notes += (!string.IsNullOrEmpty(dataItem["PositionNotes"].ToString()) &&
                      !string.IsNullOrEmpty(dataItem["OfficerNotes"].ToString()))
                         ? "<br />"
                         : "";
            Notes += dataItem["PositionNotes"];
            result = result.Replace("[Notes]", Notes);

            string HomeBranch = dataItem["HomeBranch"].ToString();
            result = result.Replace("[HomeBranch]", HomeBranch);

            string HomeKingdom = dataItem["HomeKingdom"].ToString();
            result = result.Replace("[HomeKingdom]", HomeKingdom);

            string HomeBranchKingdom = HomeBranch == HomeKingdom
                                           ? HomeKingdom
                                           : string.Format("{0} ({1})", HomeBranch, HomeKingdom);
            result = result.Replace("[HomeBranchKingdom]", HomeBranchKingdom);

            string OfficeHistoryLink =
                (isCrown ?
                Globals.NavigateURL(OPTabId, BasePortalSettings, "", "list=crown", "f=" + Settings["GroupId"].ToString()) :
                Globals.NavigateURL(OPTabId, BasePortalSettings, "", "list=oh", "f=" + dataItem["OfficerPositionId"].ToString()))
                                    + "#results";
            result = result.Replace("[OfficeHistoryLink]", OfficeHistoryLink);

            string FullNameOrVacantLink = string.Empty;
            if (SCAName == "VACANT")
                FullNameOrVacantLink = "<b>VACANT</b>";
            else
                FullNameOrVacantLink = string.Format("<a href=\"{0}\" />{1}{2}{3}</a>", OPLink,
                                                     string.IsNullOrEmpty(PersonalTitle)
                                                         ? string.Empty
                                                         : (PersonalTitle + " "), SCAName,
                                                     string.IsNullOrEmpty(HonorsSuffix)
                                                         ? string.Empty
                                                         : (", " + HonorsSuffix));

            result = result.Replace("[FullNameOrVacantLink]", FullNameOrVacantLink);

            result = ReplaceIfText(result, dataItem);

            result = ReplaceIfNotVacantToken(result, SCAName == "VACANT");

            return result;
        }

        private string ReplaceIfText(string result, DataRowView dataItem)
        {
            Regex IfTextTokenRegex = new Regex(@"\[IfText:(?<Field>\w+)\](?<Contents>[^\[]*)\[/IfText\]");
            Match IfTextMatch = IfTextTokenRegex.Match(result);
            while (IfTextMatch.Success)
            {
                if (IfTextMatch.Groups["Field"].Success)
                {
                    string FieldName = IfTextMatch.Groups["Field"].Value;
                    //FieldName Tokens vs DB name differences
                    FieldName =
                        FieldName.Replace("ModernName", "MundaneName").Replace("PersonalTitle", "TitlePrefix").Replace(
                            "Notes", "OfficerNotes").Replace("OfficeSubTitle", "PositionSubTitle").Replace(
                            "OfficeTermEnd", "EndDate").Replace("OfficeTermStart", "StartDate");

                    if (dataItem.Row.Table.Columns.Contains(FieldName))
                    {
                        string Contents = IfTextMatch.Groups["Contents"].Value;
                        if (dataItem[FieldName].ToString().Trim().Equals(string.Empty) ||
                            (FieldName == "OfficerNotes" &&
                             (dataItem[FieldName].ToString().Trim().Equals(string.Empty) &&
                              dataItem["PositionNotes"].ToString().Trim().Equals(string.Empty))))
                            Contents = string.Empty;
                        result = result.Replace(IfTextMatch.Groups[0].Value, Contents);
                    }
                }

                IfTextMatch = IfTextMatch.NextMatch();
            }
            return result;
        }

        private string ReplaceIfNotVacantToken(string result, bool Vacant)
        {
            Regex IfNotVacantTokenRegex = new Regex(@"\[IfNotVacant\](?<Contents>[^\[]*)\[/IfNotVacant\]");
            Match IfNotVacantMatch = IfNotVacantTokenRegex.Match(result);
            while (IfNotVacantMatch.Success)
            {
                string Contents = IfNotVacantMatch.Groups["Contents"].Value;
                if (Vacant) Contents = string.Empty;
                result = result.Replace(IfNotVacantMatch.Groups[0].Value, Contents);
                IfNotVacantMatch = IfNotVacantMatch.NextMatch();
            }
            return result;
        }

        public void BindRegnum()
        {
            rptRegnum.DataSource = regnumDataSource;
            rptRegnum.DataBind();
        }

        private void SetupBasePortalInfo()
        {
            PortalController pc = new PortalController();

            int basePortalId = Convert.ToInt32(Settings["BasePortal"]);
            if (basePortalId < 0) basePortalId = 0;
            BasePortalInfo = pc.GetPortal(basePortalId);
            if (!BasePortalInfo.HomeDirectory.EndsWith("/"))
                BasePortalInfo.HomeDirectory += "/";
            PortalAliasController pac = new PortalAliasController();
            ArrayList aliases = pac.GetPortalAliasArrayByPortalID(basePortalId);
            PortalAliasInfo pai = (PortalAliasInfo)aliases[0];
            OPTabId = DataProvider.Instance().GetFirstSCAOnlineOPTabId();
            BasePortalSettings = new PortalSettings(OPTabId, pai);
            BasePortalHttpAddress = Globals.AddHTTP(pai.HTTPAlias);
            if (!BasePortalHttpAddress.EndsWith("/"))
                BasePortalHttpAddress += "/";
        }
    }
}