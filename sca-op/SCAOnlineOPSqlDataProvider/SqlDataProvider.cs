using System;
using System.Configuration;
using System.Data;
using DotNetNuke.Common.Utilities;
using DotNetNuke.Framework.Providers;
using Microsoft.ApplicationBlocks.Data;

namespace JeffMartin.DNN.Modules.SCAOnlineOP.Data
{
    public class SqlDataProvider : DataProvider
    {
        private const string providerType = "data";

        #region Private Members

        private readonly ProviderConfiguration _providerConfiguration =
            ProviderConfiguration.GetProviderConfiguration(providerType);

        private readonly string _connectionString;
        private readonly string _providerPath;
        private readonly string _objectQualifier;
        private readonly string _databaseOwner;

        #endregion

        #region Constructors

        public SqlDataProvider()
        {
            Provider objProvider = ((Provider)_providerConfiguration.Providers[_providerConfiguration.DefaultProvider]);
            if (objProvider.Attributes["connectionStringName"] != "" &&
                ConfigurationManager.AppSettings[objProvider.Attributes["connectionStringName"]] != "")
            {
                _connectionString = ConfigurationManager.AppSettings[objProvider.Attributes["connectionStringName"]];
            }
            else
            {
                _connectionString = objProvider.Attributes["connectionString"];
            }
            _providerPath = objProvider.Attributes["providerPath"];
            _objectQualifier = objProvider.Attributes["objectQualifier"];
            if (_objectQualifier != "" & _objectQualifier.EndsWith("_") == false)
            {
                _objectQualifier += "_";
            }
            _databaseOwner = objProvider.Attributes["databaseOwner"];
            if (_databaseOwner != "" & _databaseOwner.EndsWith(".") == false)
            {
                _databaseOwner += ".";
            }
        }

        #endregion

        #region Properties

        public string ConnectionString
        {
            get { return _connectionString; }
        }

        public string ProviderPath
        {
            get { return _providerPath; }
        }

        public string ObjectQualifier
        {
            get { return _objectQualifier; }
        }

        public string DatabaseOwner
        {
            get { return _databaseOwner; }
        }

        #endregion

        #region Private Methods

        private object GetNull(object Field)
        {
            return Null.GetNull(Field, DBNull.Value);
        }

        #endregion

        #region "Utility Abstract Methods"

        public override int GetFirstSCAOnlineOPTabId()
        {
            string sql =
                @"Select TabId from TabModules
join Modules on TabModules.ModuleID = Modules.ModuleID
join ModuleDefinitions on Modules.ModuleDefID = ModuleDefinitions.ModuleDefID
where ModuleDefinitions.FriendlyName = 'SCAOnlineOP'";
            return (int)SqlHelper.ExecuteScalar(ConnectionString, CommandType.Text, sql);
        }

        #endregion

        #region "Alias Methods"

        public override IDataReader GetAlias(int aliasId)
        {
            return
                SqlHelper.ExecuteReader(ConnectionString, DatabaseOwner + ObjectQualifier + "SCAAliasGet", aliasId);
        }

        public override IDataReader ListAlias()
        {
            return
                SqlHelper.ExecuteReader(ConnectionString, DatabaseOwner + ObjectQualifier + "SCAAliasList");
        }

        public override IDataReader GetAliasByPeople(int peopleId)
        {
            return
                SqlHelper.ExecuteReader(ConnectionString, DatabaseOwner + ObjectQualifier + "SCAAliasGetByPeople",
                                        peopleId);
        }

        public override int AddAlias(int peopleId, string sCAName, bool registered, bool preferred)
        {
            return
                int.Parse(
                    SqlHelper.ExecuteScalar(ConnectionString, DatabaseOwner + ObjectQualifier + "SCAAliasAdd", peopleId,
                                            sCAName, registered, preferred).ToString());
        }

        public override void UpdateAlias(int aliasId, int peopleId, string sCAName, bool registered, bool preferred)
        {
            SqlHelper.ExecuteNonQuery(ConnectionString, DatabaseOwner + ObjectQualifier + "SCAAliasUpdate", aliasId,
                                      peopleId, sCAName, registered, preferred);
        }

        public override void DeleteAlias(int aliasId)
        {
            SqlHelper.ExecuteNonQuery(ConnectionString, DatabaseOwner + ObjectQualifier + "SCAAliasDelete", aliasId);
        }

        #endregion

        #region "Awards Methods"

        public override IDataReader GetAwardYears()
        {
            return
                SqlHelper.ExecuteReader(ConnectionString, DatabaseOwner + ObjectQualifier + "SCAAwardYears");
        }

        public override IDataReader GetAwards(int awardId)
        {
            return
                SqlHelper.ExecuteReader(ConnectionString, DatabaseOwner + ObjectQualifier + "SCAAwardsGet", awardId);
        }

        public override IDataReader GetAwardsSameName(int awardId, bool ShowAll)
        {
            return
                SqlHelper.ExecuteReader(ConnectionString, DatabaseOwner + ObjectQualifier + "SCAAwardsGetSameName",
                                        awardId, ShowAll);
        }


        public override IDataReader ListAwards()
        {
            return
                SqlHelper.ExecuteReader(ConnectionString, DatabaseOwner + ObjectQualifier + "SCAAwardsList");
        }

        public override IDataReader ListAwardGroupFilters()
        {
            return
                SqlHelper.ExecuteReader(ConnectionString, DatabaseOwner + ObjectQualifier + "SCAGroupsListForAwards");
        }

        public override IDataReader ListCrownGroups()
        {
            return
                SqlHelper.ExecuteReader(ConnectionString, DatabaseOwner + ObjectQualifier + "SCAGroupsListForReigns");
        }

        public override IDataReader ListOfficeGroups()
        {
            return
                SqlHelper.ExecuteReader(ConnectionString, DatabaseOwner + ObjectQualifier + "SCAGroupsListForOffices");
        }

        public override IDataReader GetAwardsByGroups(string GroupsFilter)
        {
            return
                SqlHelper.ExecuteReader(ConnectionString, DatabaseOwner + ObjectQualifier + "SCAAwardsGetByGroups",
                                        GroupsFilter);
        }

        public override IDataReader GetAwardListByGroups(int GroupsFilter)
        {
            return
                SqlHelper.ExecuteReader(ConnectionString, DatabaseOwner + ObjectQualifier + "SCAAwardsListByGroup",
                                        GroupsFilter);
        }

        public override IDataReader GetAwardsByAwardGroups(int awardGroupId)
        {
            return
                SqlHelper.ExecuteReader(ConnectionString, DatabaseOwner + ObjectQualifier + "SCAAwardsGetByAwardGroups",
                                        awardGroupId);
        }

        public override int AddAwards(int groupId, string name, string charter, int precedence, int sortOrder,
                                      string badgeUrl, string badgeBlazon, bool closed, int awardedById,
                                      int awardGroupId, bool honorary)
        {
            return
                int.Parse(
                    SqlHelper.ExecuteScalar(ConnectionString, DatabaseOwner + ObjectQualifier + "SCAAwardsAdd", groupId,
                                            name, GetNull(charter), GetNull(precedence), GetNull(sortOrder),
                                            GetNull(badgeUrl), GetNull(badgeBlazon), closed, awardedById,
                                            GetNull(awardGroupId), honorary).ToString());
        }

        public override void UpdateAwards(int awardId, int groupId, string name, string charter, int precedence,
                                          int sortOrder, string badgeUrl, string badgeBlazon, bool closed,
                                          int awardedById, int awardGroupId, bool honorary)
        {
            SqlHelper.ExecuteNonQuery(ConnectionString, DatabaseOwner + ObjectQualifier + "SCAAwardsUpdate", awardId,
                                      groupId, name, GetNull(charter), GetNull(precedence), GetNull(sortOrder),
                                      GetNull(badgeUrl), GetNull(badgeBlazon), closed, awardedById,
                                      GetNull(awardGroupId), honorary);
        }

        public override void DeleteAwards(int awardId)
        {
            SqlHelper.ExecuteNonQuery(ConnectionString, DatabaseOwner + ObjectQualifier + "SCAAwardsDelete", awardId);
        }

        public override IDataReader GetAwardsCountByCrowns(int crownId)
        {
            return
                SqlHelper.ExecuteReader(ConnectionString, DatabaseOwner + ObjectQualifier + "SCAAwardsGetCountByCrowns",
                                        crownId);
        }

        public override IDataReader GetAwardsCountByTime(int groupId, DateTime StartTime, DateTime EndTime)
        {
            return
                SqlHelper.ExecuteReader(ConnectionString, DatabaseOwner + ObjectQualifier + "SCAAwardsGetCountBytime",
                                        GetNull(groupId), StartTime, EndTime);
        }

        #endregion

        #region "BranchStatus Methods"

        public override IDataReader GetBranchStatus(int branchStatusId)
        {
            return
                SqlHelper.ExecuteReader(ConnectionString, DatabaseOwner + ObjectQualifier + "SCABranchStatusGet",
                                        branchStatusId);
        }

        public override IDataReader ListBranchStatus()
        {
            return
                SqlHelper.ExecuteReader(ConnectionString, DatabaseOwner + ObjectQualifier + "SCABranchStatusList");
        }

        public override int AddBranchStatus(string name)
        {
            return
                int.Parse(
                    SqlHelper.ExecuteScalar(ConnectionString, DatabaseOwner + ObjectQualifier + "SCABranchStatusAdd",
                                            name).ToString());
        }

        public override void UpdateBranchStatus(int branchStatusId, string name)
        {
            SqlHelper.ExecuteNonQuery(ConnectionString, DatabaseOwner + ObjectQualifier + "SCABranchStatusUpdate",
                                      branchStatusId, name);
        }

        public override void DeleteBranchStatus(int branchStatusId)
        {
            SqlHelper.ExecuteNonQuery(ConnectionString, DatabaseOwner + ObjectQualifier + "SCABranchStatusDelete",
                                      branchStatusId);
        }

        #endregion

        #region "CrownLetters Methods"

        public override IDataReader GetCrownLetters(int crownLetterId)
        {
            return
                SqlHelper.ExecuteReader(ConnectionString, DatabaseOwner + ObjectQualifier + "SCACrownLettersGet",
                                        crownLetterId);
        }

        public override IDataReader ListCrownLetters()
        {
            return
                SqlHelper.ExecuteReader(ConnectionString, DatabaseOwner + ObjectQualifier + "SCACrownLettersList");
        }

        public override IDataReader GetCrownLettersByCrowns(int crownId)
        {
            return
                SqlHelper.ExecuteReader(ConnectionString, DatabaseOwner + ObjectQualifier + "SCACrownLettersGetByCrowns",
                                        crownId);
        }

        public override int AddCrownLetters(int crownId, string title, string letter)
        {
            return
                int.Parse(
                    SqlHelper.ExecuteScalar(ConnectionString, DatabaseOwner + ObjectQualifier + "SCACrownLettersAdd",
                                            crownId, title, GetNull(letter)).ToString());
        }

        public override void UpdateCrownLetters(int crownLetterId, int crownId, string title, string letter)
        {
            SqlHelper.ExecuteNonQuery(ConnectionString, DatabaseOwner + ObjectQualifier + "SCACrownLettersUpdate",
                                      crownLetterId, crownId, title, GetNull(letter));
        }

        public override void DeleteCrownLetters(int crownLetterId)
        {
            SqlHelper.ExecuteNonQuery(ConnectionString, DatabaseOwner + ObjectQualifier + "SCACrownLettersDelete",
                                      crownLetterId);
        }

        #endregion

        #region "Crowns Methods"

        public override IDataReader GetCrowns(int crownId)
        {
            return
                SqlHelper.ExecuteReader(ConnectionString, DatabaseOwner + ObjectQualifier + "SCACrownsGet", crownId);
        }

        public override IDataReader ListCrowns()
        {
            return
                SqlHelper.ExecuteReader(ConnectionString, DatabaseOwner + ObjectQualifier + "SCACrownsList");
        }

        public override DataTable GetCrownsByGroups(int groupId)
        {
            return
                ConvertDataReaderToDataTable(
                    SqlHelper.ExecuteReader(ConnectionString, DatabaseOwner + ObjectQualifier + "SCACrownsGetByGroups",
                                            groupId));
        }

        public override int AddCrowns(int groupId, int reign, int sovereignId, int consortId, string notes,
                                      DateTime startDate, DateTime endDate, string coronationLocation,
                                      DateTime crownTournamentDate, string crownTournamentLocation,
                                      string steppingDownLocation, string internalUrl, bool heir, string picture1Url,
                                      string picture2Url, string picture1Caption, string picture2Caption,
                                      string picture1Credit, string picture2Credit, string email, bool regent)
        {
            return
                int.Parse(
                    SqlHelper.ExecuteScalar(ConnectionString, DatabaseOwner + ObjectQualifier + "SCACrownsAdd", groupId,
                                            reign, sovereignId, GetNull(consortId), GetNull(notes), GetNull(startDate),
                                            GetNull(endDate), GetNull(coronationLocation), GetNull(crownTournamentDate),
                                            GetNull(crownTournamentLocation), GetNull(steppingDownLocation),
                                            GetNull(internalUrl), heir, GetNull(picture1Url), GetNull(picture2Url),
                                            GetNull(picture1Caption), GetNull(picture2Caption), GetNull(picture1Credit),
                                            GetNull(picture2Credit), GetNull(email), regent).ToString());
        }

        public override void UpdateCrowns(int crownId, int groupId, int reign, int sovereignId, int consortId,
                                          string notes, DateTime startDate, DateTime endDate, string coronationLocation,
                                          DateTime crownTournamentDate, string crownTournamentLocation,
                                          string steppingDownLocation, string internalUrl, bool heir, string picture1Url,
                                          string picture2Url, string picture1Caption, string picture2Caption,
                                          string picture1Credit, string picture2Credit, string email, bool regent)
        {
            SqlHelper.ExecuteNonQuery(ConnectionString, DatabaseOwner + ObjectQualifier + "SCACrownsUpdate", crownId,
                                      groupId, reign, sovereignId, GetNull(consortId), GetNull(notes),
                                      GetNull(startDate), GetNull(endDate), GetNull(coronationLocation),
                                      GetNull(crownTournamentDate), GetNull(crownTournamentLocation),
                                      GetNull(steppingDownLocation), GetNull(internalUrl), heir, GetNull(picture1Url),
                                      GetNull(picture2Url), GetNull(picture1Caption), GetNull(picture2Caption),
                                      GetNull(picture1Credit), GetNull(picture2Credit), GetNull(email), regent);
        }

        public override void DeleteCrowns(int crownId)
        {
            SqlHelper.ExecuteNonQuery(ConnectionString, DatabaseOwner + ObjectQualifier + "SCACrownsDelete", crownId);
        }

        #endregion

        #region "GroupAward Methods"

        public override IDataReader GetGroupAward(int groupAwardId)
        {
            return
                SqlHelper.ExecuteReader(ConnectionString, DatabaseOwner + ObjectQualifier + "SCAGroupAwardGet",
                                        groupAwardId);
        }

        public override IDataReader ListGroupAward()
        {
            return
                SqlHelper.ExecuteReader(ConnectionString, DatabaseOwner + ObjectQualifier + "SCAGroupAwardList");
        }

        public override IDataReader GetGroupAwardByGroups(int groupId)
        {
            return
                SqlHelper.ExecuteReader(ConnectionString, DatabaseOwner + ObjectQualifier + "SCAGroupAwardGetByGroups",
                                        groupId);
        }

        public override IDataReader GetGroupAwardByAwards(int awardId)
        {
            return
                SqlHelper.ExecuteReader(ConnectionString, DatabaseOwner + ObjectQualifier + "SCAGroupAwardGetByAwards",
                                        awardId);
        }

        public override IDataReader GetGroupAwardByCrowns(int crownId)
        {
            return
                SqlHelper.ExecuteReader(ConnectionString, DatabaseOwner + ObjectQualifier + "SCAGroupAwardGetByCrowns",
                                        crownId);
        }

        public override int AddGroupAward(int groupId, int awardId, int date, int crownId, string notes)
        {
            return
                int.Parse(
                    SqlHelper.ExecuteScalar(ConnectionString, DatabaseOwner + ObjectQualifier + "SCAGroupAwardAdd",
                                            groupId, awardId, date, crownId, GetNull(notes)).ToString());
        }

        public override void UpdateGroupAward(int groupAwardId, int groupId, int awardId, int date, int crownId,
                                              string notes)
        {
            SqlHelper.ExecuteNonQuery(ConnectionString, DatabaseOwner + ObjectQualifier + "SCAGroupAwardUpdate",
                                      groupAwardId, groupId, awardId, date, crownId, GetNull(notes));
        }

        public override void DeleteGroupAward(int groupAwardId)
        {
            SqlHelper.ExecuteNonQuery(ConnectionString, DatabaseOwner + ObjectQualifier + "SCAGroupAwardDelete",
                                      groupAwardId);
        }

        #endregion

        #region "Groups Methods"

        public override IDataReader GetGroups(int groupId)
        {
            return
                SqlHelper.ExecuteReader(ConnectionString, DatabaseOwner + ObjectQualifier + "SCAGroupsGet", groupId);
        }

        public override IDataReader ListGroups()
        {
            return
                SqlHelper.ExecuteReader(ConnectionString, DatabaseOwner + ObjectQualifier + "SCAGroupsList");
        }

        public override IDataReader ListGroupGroups()
        {
            return
                SqlHelper.ExecuteReader(ConnectionString, DatabaseOwner + ObjectQualifier + "SCAGroupsListGroups");
        }

        public override IDataReader ListGroupsByGroupsGroup(string filter)
        {
            return
                SqlHelper.ExecuteReader(ConnectionString, DatabaseOwner + ObjectQualifier + "SCAGroupsListByGroupsGroup",
                                        filter);
        }


        public override IDataReader GetGroupsByBranchStatusId(int branchStatusId)
        {
            return
                SqlHelper.ExecuteReader(ConnectionString,
                                        DatabaseOwner + ObjectQualifier + "SCAGroupsGetByBranchStatusId", branchStatusId);
        }

        public override IDataReader GetGroupsByGroupDesignation(int GroupDesignationId)
        {
            return
                SqlHelper.ExecuteReader(ConnectionString,
                                        DatabaseOwner + ObjectQualifier + "SCAGroupsGetByGroupDesignation",
                                        GroupDesignationId, "");
        }

        public override IDataReader GetGroupsByGroupDesignation(string GroupDesignationName)
        {
            return
                SqlHelper.ExecuteReader(ConnectionString,
                                        DatabaseOwner + ObjectQualifier + "SCAGroupsGetByGroupDesignation", 0,
                                        GroupDesignationName);
        }

        public override int AddGroups(string name, string code, string location, int precedence, DateTime foundingDate,
                                      int groupDesignationId, bool hidden, string armsUrl, string armsBlazon,
                                      int branchStatusId, string notes, string sovereignMaleTitle,
                                      string sovereignFemaleTitle, string consortMaleTitle, string consortFemaleTitle,
                                      int parentGroupId, string sovereignArmsUrl, string sovereignBlazon,
                                      string consortArmsUrl, string webSiteUrl, string internalUrl, string consortBlazon,
                                      string reignType, string regentMaleTitle, string regentFemaleTitle,
                                      string regentType)
        {
            return
                int.Parse(
                    SqlHelper.ExecuteScalar(ConnectionString, DatabaseOwner + ObjectQualifier + "SCAGroupsAdd", name,
                                            GetNull(code), GetNull(location), GetNull(precedence), GetNull(foundingDate),
                                            GetNull(groupDesignationId), hidden, GetNull(armsUrl), GetNull(armsBlazon),
                                            branchStatusId, GetNull(notes), GetNull(sovereignMaleTitle),
                                            GetNull(sovereignFemaleTitle), GetNull(consortMaleTitle),
                                            GetNull(consortFemaleTitle), GetNull(parentGroupId),
                                            GetNull(sovereignArmsUrl), GetNull(sovereignBlazon), GetNull(consortArmsUrl),
                                            GetNull(webSiteUrl), GetNull(internalUrl), GetNull(consortBlazon),
                                            GetNull(reignType), GetNull(regentMaleTitle), GetNull(regentFemaleTitle),
                                            GetNull(regentType)).ToString());
        }

        public override void UpdateGroups(int groupId, string name, string code, string location, int precedence,
                                          DateTime foundingDate, int groupDesignationId, bool hidden, string armsUrl,
                                          string armsBlazon, int branchStatusId, string notes, string sovereignMaleTitle,
                                          string sovereignFemaleTitle, string consortMaleTitle,
                                          string consortFemaleTitle, int parentGroupId, string sovereignArmsUrl,
                                          string sovereignBlazon, string consortArmsUrl, string webSiteUrl,
                                          string internalUrl, string consortBlazon, string reignType,
                                          string regentMaleTitle, string regentFemaleTitle, string regentType)
        {
            SqlHelper.ExecuteNonQuery(ConnectionString, DatabaseOwner + ObjectQualifier + "SCAGroupsUpdate", groupId,
                                      name, GetNull(code), GetNull(location), GetNull(precedence), GetNull(foundingDate),
                                      GetNull(groupDesignationId), hidden, GetNull(armsUrl), GetNull(armsBlazon),
                                      branchStatusId, GetNull(notes), GetNull(sovereignMaleTitle),
                                      GetNull(sovereignFemaleTitle), GetNull(consortMaleTitle),
                                      GetNull(consortFemaleTitle), GetNull(parentGroupId), GetNull(sovereignArmsUrl),
                                      GetNull(sovereignBlazon), GetNull(consortArmsUrl), GetNull(webSiteUrl),
                                      GetNull(internalUrl), GetNull(consortBlazon), GetNull(reignType),
                                      GetNull(regentMaleTitle), GetNull(regentFemaleTitle), GetNull(regentType));
        }

        public override void DeleteGroups(int groupId)
        {
            SqlHelper.ExecuteNonQuery(ConnectionString, DatabaseOwner + ObjectQualifier + "SCAGroupsDelete", groupId);
        }

        #endregion

        #region "OfficerPosition Methods"

        public override IDataReader GetOfficerPosition(int officerPosistionId)
        {
            return
                SqlHelper.ExecuteReader(ConnectionString, DatabaseOwner + ObjectQualifier + "SCAOfficerPositionGet",
                                        officerPosistionId);
        }

        public override DataTable ListOfficerPosition()
        {
            return
                ConvertDataReaderToDataTable(
                    SqlHelper.ExecuteReader(ConnectionString, DatabaseOwner + ObjectQualifier + "SCAOfficerPositionList"));
        }

        public override DataTable ListOfficerPositionByGroup(int groupId)
        {
            return
                ConvertDataReaderToDataTable(
                    SqlHelper.ExecuteReader(ConnectionString,
                                            DatabaseOwner + ObjectQualifier + "SCAOfficerPositionListByGroup", groupId));
        }

        public override int AddOfficerPosition(string title, int groupId, int listOrder, string badgeUrl,
                                               string officeEmail, bool linkedToCrown)
        {
            return
                int.Parse(
                    SqlHelper.ExecuteScalar(ConnectionString, DatabaseOwner + ObjectQualifier + "SCAOfficerPositionAdd",
                                            title, GetNull(groupId), listOrder, badgeUrl, officeEmail, linkedToCrown).
                        ToString());
        }

        public override void UpdateOfficerPosition(int officerPositionId, string title, int groupId, int listOrder,
                                                   string badgeUrl, string officeEmail, bool linkedToCrown)
        {
            SqlHelper.ExecuteNonQuery(ConnectionString, DatabaseOwner + ObjectQualifier + "SCAOfficerPositionUpdate",
                                      officerPositionId, title, GetNull(groupId), listOrder, badgeUrl, officeEmail,
                                      linkedToCrown);
        }

        public override void DeleteOfficerPosition(int officerPositionId)
        {
            SqlHelper.ExecuteNonQuery(ConnectionString, DatabaseOwner + ObjectQualifier + "SCAOfficerPositionDelete",
                                      officerPositionId);
        }

        #endregion

        #region "People Methods"

        public override IDataReader GetPeople(int peopleId)
        {
            return
                SqlHelper.ExecuteReader(ConnectionString, DatabaseOwner + ObjectQualifier + "SCAPeopleGet", peopleId);
        }

        public override IDataReader ListPeople()
        {
            return
                SqlHelper.ExecuteReader(ConnectionString, DatabaseOwner + ObjectQualifier + "SCAPeopleList");
        }

        public override IDataReader ListPeople(string Filter, string SearchField, string OrderBy, bool OnlyPhotos,
                                               bool OnlyDevices, bool IncludeAliases, bool LimitDeceased,
                                               bool LimitLiving, int BaseKingdomId, bool LimitResident,
                                               bool LimitNonResident)
        {
            //System.Data.SqlClient.SqlConnection connection = new SqlConnection();
            //connection.ConnectionString = ConnectionString;
            //connection.Open();
            //SqlCommand command =  connection.CreateCommand();
            //command.CommandTimeout = 120;
            //SqlHelper.
            IDataReader reader = SqlHelper.ExecuteReader(ConnectionString,
                                                         DatabaseOwner + ObjectQualifier + "SCAPeopleListFilter",
                                                         Filter, SearchField, OrderBy, OnlyPhotos, OnlyDevices,
                                                         IncludeAliases, LimitDeceased, LimitLiving, BaseKingdomId,
                                                         LimitResident, LimitNonResident);
            return reader;
        }

        public override IDataReader ListPeopleAlphaCount()
        {
            return
                SqlHelper.ExecuteReader(ConnectionString, DatabaseOwner + ObjectQualifier + "SCAPeopleListAlphaCount");
        }

        public override IDataReader ListPeopleByOP()
        {
            return
                SqlHelper.ExecuteReader(ConnectionString, DatabaseOwner + ObjectQualifier + "SCAPeopleListOP");
        }

        public override IDataReader ListPeopleForGame(int Difficulty, string GameType)
        {
            return
                SqlHelper.ExecuteReader(ConnectionString, DatabaseOwner + ObjectQualifier + "SCAPeopleListGame",
                                        Difficulty, GameType);
        }


        public override void UpdateAllOPNum()
        {
            SqlHelper.ExecuteNonQuery(ConnectionString, DatabaseOwner + ObjectQualifier + "SCAPeopleUpdatePrecedence");
        }

        public override string GetRegisteredName(int peopleId)
        {
            return
                (string)
                SqlHelper.ExecuteScalar(ConnectionString, DatabaseOwner + ObjectQualifier + "SCAPeopleGetRegisteredName",
                                        peopleId);
        }

        public override int AddPeople(string sCAName, string mundaneName, string address1, string address2, string city,
                                      string state, string zip, string phone1, string phone2, string emailAddress,
                                      string photoURL, string armsURL, string armsBlazon, bool showPicPermission,
                                      bool showEmailPermission, string adminNotes, string officerNotes, string Gender,
                                      string TitlePrefix, string HonorsSuffix, bool Deceased, int DeceasedWhen,
                                      int BranchResidenceId)
        {
            return
                int.Parse(
                    SqlHelper.ExecuteScalar(ConnectionString, DatabaseOwner + ObjectQualifier + "SCAPeopleAdd", sCAName,
                                            GetNull(mundaneName), GetNull(address1), GetNull(address2), GetNull(city),
                                            GetNull(state), GetNull(zip), GetNull(phone1), GetNull(phone2),
                                            GetNull(emailAddress), GetNull(photoURL), GetNull(armsURL),
                                            GetNull(armsBlazon), showPicPermission, showEmailPermission,
                                            GetNull(adminNotes), GetNull(officerNotes), GetNull(Gender),
                                            GetNull(TitlePrefix), GetNull(HonorsSuffix), Deceased,
                                            GetNull(DeceasedWhen), GetNull(BranchResidenceId)).ToString());
        }

        public override void UpdatePeople(int peopleId, string sCAName, string mundaneName, string address1,
                                          string address2, string city, string state, string zip, string phone1,
                                          string phone2, string emailAddress, string photoURL, string armsURL,
                                          string armsBlazon, bool showPicPermission, bool showEmailPermission,
                                          string adminNotes, string officerNotes, string Gender, string TitlePrefix,
                                          string HonorsSuffix, bool Deceased, int DeceasedWhen, int BranchResidenceId)
        {
            SqlHelper.ExecuteNonQuery(ConnectionString, DatabaseOwner + ObjectQualifier + "SCAPeopleUpdate", peopleId,
                                      sCAName, GetNull(mundaneName), GetNull(address1), GetNull(address2), GetNull(city),
                                      GetNull(state), GetNull(zip), GetNull(phone1), GetNull(phone2),
                                      GetNull(emailAddress),
                                      GetNull(photoURL), GetNull(armsURL), GetNull(armsBlazon), showPicPermission,
                                      showEmailPermission, GetNull(adminNotes), GetNull(officerNotes), GetNull(Gender),
                                      GetNull(TitlePrefix), GetNull(HonorsSuffix), Deceased, GetNull(DeceasedWhen),
                                      GetNull(BranchResidenceId));
        }

        public override void DeletePeople(int peopleId)
        {
            SqlHelper.ExecuteNonQuery(ConnectionString, DatabaseOwner + ObjectQualifier + "SCAPeopleDelete", peopleId);
        }

        public override IDataReader GetRegnumforByOfficerPositionIds(string officerPositionIds, bool showVacant, bool showHistory,
                                                                     bool useCrownLink, int crownId, DateTime displayDate)
        {
            return
                SqlHelper.ExecuteReader(ConnectionString,
                                        DatabaseOwner + ObjectQualifier + "SCAPeopleOfficerListByOfficerPositionIDs",
                                        officerPositionIds, showVacant, showHistory, useCrownLink, crownId, displayDate);
        }

        public override IDataReader GetRegnumRulersOnly(int GroupId, DateTime displayDate)
        {
            return GetRegnumRulersOnly(GroupId, -1, displayDate);
        }

        public override IDataReader GetRegnumRulersOnly(int GroupId, int CrownId, DateTime displayDate)
        {
            return
                SqlHelper.ExecuteReader(ConnectionString,
                                        DatabaseOwner + ObjectQualifier + "SCAPeopleOfficerListGroupRulers", GroupId, CrownId, displayDate);
        }

        public override IDataReader GetRegnumforGroup(int GroupId)
        {
            return
                SqlHelper.ExecuteReader(ConnectionString,
                                        DatabaseOwner + ObjectQualifier + "SCAPeopleOfficerListGroupRegnum", GroupId);
        }

        public override IDataReader GetWholeEnchiladaReport()
        {
            return
                SqlHelper.ExecuteReader(ConnectionString,
                                        DatabaseOwner + ObjectQualifier + "SCAPeopleWholeEnchiladaReport");
        }

        public override IDataReader GetSingleGroupEnchiladaReport(int GroupId)
        {
            return
                SqlHelper.ExecuteReader(ConnectionString,
                                        DatabaseOwner + ObjectQualifier + "SCAPeopleSingleGroupEnchiladaReport", GroupId);
        }

        #endregion

        #region "AwardGroups Methods"

        public override IDataReader GetAwardGroups(int awardGroupId)
        {
            return
                SqlHelper.ExecuteReader(ConnectionString, DatabaseOwner + ObjectQualifier + "SCAAwardGroupsGet",
                                        awardGroupId);
        }

        public override IDataReader GetAwardGroupsSameName(int awardGroupId, bool ShowAll)
        {
            return
                SqlHelper.ExecuteReader(ConnectionString, DatabaseOwner + ObjectQualifier + "SCAAwardGroupsGetSameName",
                                        awardGroupId, ShowAll);
        }

        public override IDataReader ListAwardGroups()
        {
            return
                SqlHelper.ExecuteReader(ConnectionString, DatabaseOwner + ObjectQualifier + "SCAAwardGroupsList");
        }

        public override IDataReader GetAwardGroupsByGroups(int groupId)
        {
            return
                SqlHelper.ExecuteReader(ConnectionString, DatabaseOwner + ObjectQualifier + "SCAAwardGroupsGetByGroups",
                                        groupId);
        }

        public override int AddAwardGroups(string awardGroupName, int precedence, int sortOrder, int groupId)
        {
            return
                int.Parse(
                    SqlHelper.ExecuteScalar(ConnectionString, DatabaseOwner + ObjectQualifier + "SCAAwardGroupsAdd",
                                            awardGroupName, precedence, GetNull(sortOrder), groupId).ToString());
        }

        public override void UpdateAwardGroups(int awardGroupId, string awardGroupName, int precedence, int sortOrder,
                                               int groupId)
        {
            SqlHelper.ExecuteNonQuery(ConnectionString, DatabaseOwner + ObjectQualifier + "SCAAwardGroupsUpdate",
                                      awardGroupId, awardGroupName, precedence, GetNull(sortOrder), groupId);
        }

        public override void DeleteAwardGroups(int awardGroupId)
        {
            SqlHelper.ExecuteNonQuery(ConnectionString, DatabaseOwner + ObjectQualifier + "SCAAwardGroupsDelete",
                                      awardGroupId);
        }

        #endregion

        #region "PeopleAward Methods"

        public override IDataReader GetPeopleAward(int peopleAwardId)
        {
            return
                SqlHelper.ExecuteReader(ConnectionString, DatabaseOwner + ObjectQualifier + "SCAPeopleAwardGet",
                                        peopleAwardId);
        }

        public override IDataReader ListPeopleAward()
        {
            return
                SqlHelper.ExecuteReader(ConnectionString, DatabaseOwner + ObjectQualifier + "SCAPeopleAwardList");
        }

        public override IDataReader GetPeopleAwardByAwards(int awardId, bool SameName)
        {
            return
                SqlHelper.ExecuteReader(ConnectionString, DatabaseOwner + ObjectQualifier + "SCAPeopleAwardGetByAwards",
                                        awardId, SameName);
        }

        public override IDataReader GetPeopleAwardByAwardGroup(int AwardGroupId, bool ShowAll)
        {
            return
                SqlHelper.ExecuteReader(ConnectionString,
                                        DatabaseOwner + ObjectQualifier + "SCAPeopleAwardGetByAwardGroup", AwardGroupId,
                                        ShowAll);
        }

        public override IDataReader GetPeopleAwardByPeople(int peopleId)
        {
            return
                SqlHelper.ExecuteReader(ConnectionString, DatabaseOwner + ObjectQualifier + "SCAPeopleAwardGetByPeople",
                                        peopleId);
        }

        public override IDataReader GetPeopleAwardByAlias(int aliasId)
        {
            return
                SqlHelper.ExecuteReader(ConnectionString, DatabaseOwner + ObjectQualifier + "SCAPeopleAwardGetByAlias",
                                        aliasId);
        }

        public override IDataReader GetPeopleAwardByTime(int groupid, DateTime TimeStart, DateTime TimeEnd)
        {
            return
                SqlHelper.ExecuteReader(ConnectionString, DatabaseOwner + ObjectQualifier + "SCAPeopleAwardGetByTime",
                                        GetNull(groupid), TimeStart, TimeEnd);
        }

        public override IDataReader GetPeopleAwardByCrowns(int crownId)
        {
            return
                SqlHelper.ExecuteReader(ConnectionString, DatabaseOwner + ObjectQualifier + "SCAPeopleAwardGetByCrowns",
                                        crownId);
        }

        public override int AddPeopleAward(int awardId, int peopleId, DateTime date, int crownId, string notes,
                                           int aliasId, bool retired)
        {
            return
                int.Parse(
                    SqlHelper.ExecuteScalar(ConnectionString, DatabaseOwner + ObjectQualifier + "SCAPeopleAwardAdd",
                                            awardId, peopleId, date, GetNull(crownId), GetNull(notes), GetNull(aliasId),
                                            retired).ToString());
        }

        public override void UpdatePeopleAward(int peopleAwardId, int awardId, int peopleId, DateTime date, int crownId,
                                               string notes, int aliasId, bool retired)
        {
            SqlHelper.ExecuteNonQuery(ConnectionString, DatabaseOwner + ObjectQualifier + "SCAPeopleAwardUpdate",
                                      peopleAwardId, awardId, peopleId, date, GetNull(crownId), GetNull(notes),
                                      GetNull(aliasId), retired);
        }

        public override void DeletePeopleAward(int peopleAwardId)
        {
            SqlHelper.ExecuteNonQuery(ConnectionString, DatabaseOwner + ObjectQualifier + "SCAPeopleAwardDelete",
                                      peopleAwardId);
        }

        #endregion

        #region "PeopleOfficer Methods"

        public override IDataReader GetPeopleCombinedOfficesByPeople(int peopleId)
        {
            return
                SqlHelper.ExecuteReader(ConnectionString,
                                        DatabaseOwner + ObjectQualifier + "SCAPeopleCombinedOfficesGet", peopleId);
        }

        public override IDataReader GetPeopleOfficer(int peopleOfficerId)
        {
            return
                SqlHelper.ExecuteReader(ConnectionString, DatabaseOwner + ObjectQualifier + "SCAPeopleOfficerGet",
                                        peopleOfficerId);
        }

        public override IDataReader ListPeopleOfficer()
        {
            return
                SqlHelper.ExecuteReader(ConnectionString, DatabaseOwner + ObjectQualifier + "SCAPeopleOfficerList");
        }

        public override IDataReader GetPeopleOfficerByOfficerPosition(int officerPosistionId)
        {
            return
                SqlHelper.ExecuteReader(ConnectionString,
                                        DatabaseOwner + ObjectQualifier + "SCAPeopleOfficerGetByOfficerPosition",
                                        officerPosistionId);
        }

        public override IDataReader GetPeopleOfficerByPeople(int peopleId)
        {
            return
                SqlHelper.ExecuteReader(ConnectionString,
                                        DatabaseOwner + ObjectQualifier + "SCAPeopleOfficerGetByPeople", peopleId);
        }

        public override int AddPeopleOfficer(int peopleId, int officerPositionId, DateTime startDate, DateTime endDate,
                                             bool currentlyHeld, bool acting, bool verified, string positionSubTitle,
                                             string positionNotes, string emailToUse, string emailOverride,
                                             string verifiedNotes, int linkedCrownId)
        {
            return
                int.Parse(
                    SqlHelper.ExecuteScalar(ConnectionString, DatabaseOwner + ObjectQualifier + "SCAPeopleOfficerAdd",
                                            peopleId, officerPositionId, startDate, GetNull(endDate), currentlyHeld,
                                            acting, verified, positionSubTitle, positionNotes, emailToUse, emailOverride,
                                            verifiedNotes, GetNull(linkedCrownId)).ToString());
        }

        public override void UpdatePeopleOfficer(int peopleOfficerId, int peopleId, int officerPositionId,
                                                 DateTime startDate, DateTime endDate, bool currentlyHeld, bool acting,
                                                 bool verified, string positionSubTitle, string positionNotes,
                                                 string emailToUse, string emailOverride, string verifiedNotes,
                                                 int linkedCrownId)
        {
            SqlHelper.ExecuteNonQuery(ConnectionString, DatabaseOwner + ObjectQualifier + "SCAPeopleOfficerUpdate",
                                      peopleOfficerId, peopleId, officerPositionId, startDate, GetNull(endDate),
                                      currentlyHeld, acting, verified, positionSubTitle, positionNotes, emailToUse,
                                      emailOverride, verifiedNotes, GetNull(linkedCrownId));
        }

        public override void DeletePeopleOfficer(int peopleOfficerId)
        {
            SqlHelper.ExecuteNonQuery(ConnectionString, DatabaseOwner + ObjectQualifier + "SCAPeopleOfficerDelete",
                                      peopleOfficerId);
        }

        #endregion

        #region "GroupDesignation Methods"

        public override IDataReader GetGroupDesignation(int groupDesignationId)
        {
            return
                SqlHelper.ExecuteReader(ConnectionString, DatabaseOwner + ObjectQualifier + "SCAGroupDesignationGet",
                                        groupDesignationId);
        }

        public override IDataReader ListGroupDesignation()
        {
            return
                SqlHelper.ExecuteReader(ConnectionString, DatabaseOwner + ObjectQualifier + "SCAGroupDesignationList");
        }

        public override int AddGroupDesignation(string name, bool ceremonialHead)
        {
            return
                int.Parse(
                    SqlHelper.ExecuteScalar(ConnectionString, DatabaseOwner + ObjectQualifier + "SCAGroupDesignationAdd",
                                            name, ceremonialHead).ToString());
        }

        public override void UpdateGroupDesignation(int groupDesignationId, string name, bool ceremonialHead)
        {
            SqlHelper.ExecuteNonQuery(ConnectionString, DatabaseOwner + ObjectQualifier + "SCAGroupDesignationUpdate",
                                      groupDesignationId, name, ceremonialHead);
        }

        public override void DeleteGroupDesignation(int groupDesignationId)
        {
            SqlHelper.ExecuteNonQuery(ConnectionString, DatabaseOwner + ObjectQualifier + "SCAGroupDesignationDelete",
                                      groupDesignationId);
        }

        #endregion

        #region "GroupHistory Methods"

        public override IDataReader GetGroupHistory(int groupHistoryId)
        {
            return
                SqlHelper.ExecuteReader(ConnectionString, DatabaseOwner + ObjectQualifier + "SCAGroupHistoryGet",
                                        groupHistoryId);
        }

        public override IDataReader ListGroupHistory()
        {
            return
                SqlHelper.ExecuteReader(ConnectionString, DatabaseOwner + ObjectQualifier + "SCAGroupHistoryList");
        }

        public override IDataReader GetGroupHistoryByToGroup(int groupId)
        {
            return
                SqlHelper.ExecuteReader(ConnectionString,
                                        DatabaseOwner + ObjectQualifier + "SCAGroupHistoryGetByToGroup", groupId);
        }

        public override IDataReader GetGroupHistoryByFromGroup(int groupId)
        {
            return
                SqlHelper.ExecuteReader(ConnectionString,
                                        DatabaseOwner + ObjectQualifier + "SCAGroupHistoryGetByFromGroup", groupId);
        }

        public override int AddGroupHistory(DateTime date, int fromGroupId, int toGroupId, string note)
        {
            return
                int.Parse(
                    SqlHelper.ExecuteScalar(ConnectionString, DatabaseOwner + ObjectQualifier + "SCAGroupHistoryAdd",
                                            date, GetNull(fromGroupId), GetNull(toGroupId), GetNull(note)).ToString());
        }

        public override void UpdateGroupHistory(int groupHistoryId, DateTime date, int fromGroupId, int toGroupId,
                                                string note)
        {
            SqlHelper.ExecuteNonQuery(ConnectionString, DatabaseOwner + ObjectQualifier + "SCAGroupHistoryUpdate",
                                      groupHistoryId, date, GetNull(fromGroupId), GetNull(toGroupId), GetNull(note));
        }

        public override void DeleteGroupHistory(int groupHistoryId)
        {
            SqlHelper.ExecuteNonQuery(ConnectionString, DatabaseOwner + ObjectQualifier + "SCAGroupHistoryDelete",
                                      groupHistoryId);
        }

        #endregion
    }
}