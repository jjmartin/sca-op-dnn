using System;
using System.Data;
using DotNetNuke.Framework;

namespace JeffMartin.DNN.Modules.SCAOnlineOP.Data
{
    public abstract class DataProvider
    {
        #region Shared/Static Methods

        // singleton reference to the instantiated object 
        private static DataProvider objProvider;

        // constructor
        static DataProvider()
        {
            CreateProvider();
        }

        // dynamically create provider
        private static void CreateProvider()
        {
            objProvider =
                ((DataProvider)Reflection.CreateObject("data", "JeffMartin.DNN.Modules.SCAOnlineOP.Data", ""));
        }

        // return the provider
        public static DataProvider Instance()
        {
            return objProvider;
        }

        public static DataSet ConvertDataReaderToDataSet(IDataReader reader, bool LeaveReaderOpen)
        {
            DataSet ds = new DataSet();
            ds.Tables.Add(ConvertDataReaderToDataTable(reader, LeaveReaderOpen));
            return ds;
        }

        public static DataSet ConvertDataReaderToDataSet(IDataReader reader)
        {
            return ConvertDataReaderToDataSet(reader, false);
        }

        public static DataTable ConvertDataReaderToDataTable(IDataReader reader)
        {
            return ConvertDataReaderToDataTable(reader, false);
        }

        public static DataTable ConvertDataReaderToDataTable(IDataReader reader, bool LeaveReaderOpen)
        {
            // create datatable from datareader
            DataTable objDataTable = new DataTable();
            int intFieldCount = reader.FieldCount;
            for (int intCounter = 0; intCounter < intFieldCount; intCounter++)
            {
                objDataTable.Columns.Add(reader.GetName(intCounter), reader.GetFieldType(intCounter));
            }

            // populate datatable
            objDataTable.BeginLoadData();
            object[] objValues = new object[intFieldCount];
            while (reader.Read())
            {
                reader.GetValues(objValues);
                objDataTable.LoadDataRow(objValues, true);
            }
            if (!LeaveReaderOpen) reader.Close();
            objDataTable.EndLoadData();

            return objDataTable;
        }

        #endregion

        #region "Utility Abstract Methods"

        public abstract int GetFirstSCAOnlineOPTabId();

        #endregion

        #region "Alias Abstract Methods"

        public abstract IDataReader GetAlias(int aliasId);
        public abstract IDataReader ListAlias();
        public abstract IDataReader GetAliasByPeople(int peopleId);
        public abstract int AddAlias(int peopleId, string sCAName, bool registered, bool preferred);
        public abstract void UpdateAlias(int aliasId, int peopleId, string sCAName, bool registered, bool preferred);
        public abstract void DeleteAlias(int aliasId);

        #endregion

        #region "Awards Abstract Methods"

        public abstract IDataReader GetAwards(int awardId);
        public abstract IDataReader GetAwardYears();
        public abstract IDataReader GetAwardsSameName(int awardId, bool ShowAll);
        public abstract IDataReader ListAwards();

        /// <summary>
        /// Gets Awards with Grouped Awards Grouped
        /// </summary>
        /// <param name="groupsFilter"></param>
        /// <returns></returns>
        public abstract IDataReader GetAwardsByGroups(string groupsFilter);

        /// <summary>
        /// Gets awards with awardgroups seperated
        /// </summary>
        /// <param name="groupsFilter"></param>
        /// <returns></returns>
        public abstract IDataReader GetAwardListByGroups(int groupsFilter);

        public abstract int AddAwards(int groupId, string name, string charter, int precedence, int sortOrder,
                                      string badgeUrl, string badgeBlazon, bool closed, int awardedById,
                                      int awardGroupId, bool honorary);

        public abstract void UpdateAwards(int awardId, int groupId, string name, string charter, int precedence,
                                          int sortOrder, string badgeUrl, string badgeBlazon, bool closed,
                                          int awardedById, int awardGroupId, bool honorary);

        public abstract void DeleteAwards(int awardId);
        public abstract IDataReader GetAwardsByAwardGroups(int awardGroupId);
        public abstract IDataReader GetAwardsCountByCrowns(int crownId);
        public abstract IDataReader GetAwardsCountByTime(int groupId, DateTime StartTime, DateTime EndTime);

        #endregion

        #region "BranchStatusId Abstract Methods"

        public abstract IDataReader GetBranchStatus(int branchStatusId);
        public abstract IDataReader ListBranchStatus();
        public abstract int AddBranchStatus(string name);
        public abstract void UpdateBranchStatus(int branchStatusId, string name);
        public abstract void DeleteBranchStatus(int branchStatusId);

        #endregion

        #region "CrownLetters Abstract Methods"

        public abstract IDataReader GetCrownLetters(int crownLetterId);
        public abstract IDataReader ListCrownLetters();
        public abstract IDataReader GetCrownLettersByCrowns(int crownId);
        public abstract int AddCrownLetters(int crownId, string title, string letter);
        public abstract void UpdateCrownLetters(int crownLetterId, int crownId, string title, string letter);
        public abstract void DeleteCrownLetters(int crownLetterId);

        #endregion

        #region "Crowns Abstract Methods"

        public abstract IDataReader GetCrowns(int crownId);
        public abstract IDataReader ListCrowns();
        public abstract DataTable GetCrownsByGroups(int groupId);

        public abstract int AddCrowns(int groupId, int reign, int sovereignId, int consortId, string notes,
                                      DateTime startDate, DateTime endDate, string coronationLocation,
                                      DateTime crownTournamentDate, string crownTournamentLocation,
                                      string steppingDownLocation, string internalUrl, bool heir, string picture1Url,
                                      string picture2Url, string picture1Caption, string picture2Caption,
                                      string picture1Credit, string picture2Credit, string email, bool Regent);

        public abstract void UpdateCrowns(int crownId, int groupId, int reign, int sovereignId, int consortId,
                                          string notes, DateTime startDate, DateTime endDate, string coronationLocation,
                                          DateTime crownTournamentDate, string crownTournamentLocation,
                                          string steppingDownLocation, string internalUrl, bool heir, string picture1Url,
                                          string picture2Url, string picture1Caption, string picture2Caption,
                                          string picture1Credit, string picture2Credit, string email, bool Regent);

        public abstract void DeleteCrowns(int crownId);

        #endregion

        #region "GroupAward Abstract Methods"

        public abstract IDataReader GetGroupAward(int groupAwardId);
        public abstract IDataReader ListGroupAward();
        public abstract IDataReader GetGroupAwardByGroups(int groupId);
        public abstract IDataReader GetGroupAwardByAwards(int awardId);
        public abstract IDataReader GetGroupAwardByCrowns(int crownId);
        public abstract int AddGroupAward(int groupId, int awardId, int date, int crownId, string notes);

        public abstract void UpdateGroupAward(int groupAwardId, int groupId, int awardId, int date, int crownId,
                                              string notes);

        public abstract void DeleteGroupAward(int groupAwardId);

        #endregion

        #region "Groups Abstract Methods"

        public abstract IDataReader GetGroups(int groupId);
        public abstract IDataReader ListGroups();
        public abstract IDataReader ListGroupGroups();
        public abstract IDataReader ListGroupsByGroupsGroup(string filter);
        public abstract IDataReader ListAwardGroupFilters();
        public abstract IDataReader ListCrownGroups();
        public abstract IDataReader ListOfficeGroups();
        public abstract IDataReader GetGroupsByBranchStatusId(int branchStatusId);
        public abstract IDataReader GetGroupsByGroupDesignation(int GroupDesignationId);
        public abstract IDataReader GetGroupsByGroupDesignation(string GroupDesignationName);

        public abstract int AddGroups(string name, string code, string location, int precedence, DateTime foundingDate,
                                      int groupDesignationId, bool hidden, string armsUrl, string armsBlazon,
                                      int branchStatusId, string notes, string sovereignMaleTitle,
                                      string sovereignFemaleTitle, string consortMaleTitle, string consortFemaleTitle,
                                      int parentGroupId, string sovereignArmsUrl, string sovereignBlazon,
                                      string consortArmsUrl, string webSiteUrl, string internalUrl, string consortBlazon,
                                      string reignType, string regentMaleTitle, string regentFemaleTitle,
                                      string regentType);

        public abstract void UpdateGroups(int groupId, string name, string code, string location, int precedence,
                                          DateTime foundingDate, int groupDesignationId, bool hidden, string armsUrl,
                                          string armsBlazon, int branchStatusId, string notes, string sovereignMaleTitle,
                                          string sovereignFemaleTitle, string consortMaleTitle,
                                          string consortFemaleTitle, int parentGroupId, string sovereignArmsUrl,
                                          string sovereignBlazon, string consortArmsUrl, string webSiteUrl,
                                          string internalUrl, string consortBlazon, string reignType,
                                          string regentMaleTitle, string regentFemaleTitle, string regentType);

        public abstract void DeleteGroups(int groupId);

        #endregion

        #region "OfficerPosition Abstract Methods"

        public abstract IDataReader GetOfficerPosition(int officerPosistionId);
        public abstract DataTable ListOfficerPosition();
        public abstract DataTable ListOfficerPositionByGroup(int groupId);

        public abstract int AddOfficerPosition(string title, int groupId, int listOrder, string badgeUrl,
                                               string officeEmail, bool linkedToCrown);

        public abstract void UpdateOfficerPosition(int officerPositionId, string title, int groupId, int listOrder,
                                                   string badgeUrl, string officeEmail, bool linkedToCrown);

        public abstract void DeleteOfficerPosition(int officerPositionId);

        #endregion

        #region "AwardGroups Abstract Methods"

        public abstract IDataReader GetAwardGroups(int awardGroupId);
        public abstract IDataReader GetAwardGroupsSameName(int awardGroupId, bool ShowAll);
        public abstract IDataReader ListAwardGroups();
        public abstract IDataReader GetAwardGroupsByGroups(int groupId);
        public abstract int AddAwardGroups(string awardGroupName, int precedence, int sortOrder, int groupId);

        public abstract void UpdateAwardGroups(int awardGroupId, string awardGroupName, int precedence, int sortOrder,
                                               int groupId);

        public abstract void DeleteAwardGroups(int awardGroupId);

        #endregion

        #region "People Abstract Methods"

        public abstract IDataReader GetPeople(int peopleId);
        public abstract IDataReader ListPeople();

        public abstract IDataReader ListPeople(string Filter, string SearchField, string OrderBy, bool OnlyPhotos,
                                               bool OnlyDevices, bool IncludeAliases, bool LimitDeceased,
                                               bool LimitLiving, int BaseKingdomId, bool LimitResident,
                                               bool LimitNonResident);

        public abstract IDataReader ListPeopleByOP();
        public abstract IDataReader ListPeopleForGame(int Difficulty, string GameType);
        public abstract IDataReader ListPeopleAlphaCount();
        public abstract string GetRegisteredName(int peopleId);
        public abstract void UpdateAllOPNum();

        public abstract int AddPeople(string SCAName, string mundaneName, string address1, string address2, string city,
                                      string state, string zip, string phone1, string phone2, string emailAddress,
                                      string photoURL, string armsURL, string armsBlazon, bool showPicPermission,
                                      bool showEmailPermission, string adminNotes, string officerNotes, string Gender,
                                      string TitlePrefix, string HonorsSuffix, bool Deceased, int DeceasedWhen,
                                      int BranchResidenceId);

        public abstract void UpdatePeople(int peopleId, string sCAName, string mundaneName, string address1,
                                          string address2, string city, string state, string zip, string phone1,
                                          string phone2, string emailAddress, string photoURL, string armsURL,
                                          string armsBlazon, bool showPicPermission, bool showEmailPermission,
                                          string adminNotes, string officerNotes, string Gender, string TitlePrefix,
                                          string HonorsSuffix, bool Deceased, int DeceasedWhen, int BranchResidenceId);

        public abstract void DeletePeople(int peopleId);
        public abstract IDataReader GetRegnumforGroup(int GroupId);

        public abstract IDataReader GetRegnumforByOfficerPositionIds(string OfficerPositionIds, bool ShowVacant, bool showHistory,
                                                                     bool UseCrownLink, int CrownId, DateTime DisplayDate);

        public abstract IDataReader GetRegnumRulersOnly(int GroupId, DateTime displayDate);
        public abstract IDataReader GetRegnumRulersOnly(int GroupId, int CrownId, DateTime displayDate);
        public abstract IDataReader GetWholeEnchiladaReport();
        public abstract IDataReader GetSingleGroupEnchiladaReport(int GroupId);

        #endregion

        #region "PeopleAward Abstract Methods"

        public abstract IDataReader GetPeopleAward(int peopleAwardId);
        public abstract IDataReader ListPeopleAward();

        public IDataReader GetPeopleAwardByAwards(int awardId)
        {
            return GetPeopleAwardByAwards(awardId, false);
        }

        public abstract IDataReader GetPeopleAwardByAwards(int awardId, bool SameName);

        public IDataReader GetPeopleAwardByAwardGroup(int awardGroupId)
        {
            return GetPeopleAwardByAwardGroup(awardGroupId, false);
        }

        public abstract IDataReader GetPeopleAwardByAwardGroup(int awardGroupId, bool ShowAll);
        public abstract IDataReader GetPeopleAwardByPeople(int peopleId);
        public abstract IDataReader GetPeopleAwardByAlias(int aliasId);
        public abstract IDataReader GetPeopleAwardByCrowns(int crownId);
        public abstract IDataReader GetPeopleAwardByTime(int groupid, DateTime TimeStart, DateTime TimeEnd);

        public abstract int AddPeopleAward(int awardId, int peopleId, DateTime date, int crownId, string notes,
                                           int aliasId, bool retired);

        public abstract void UpdatePeopleAward(int peopleAwardId, int awardId, int peopleId, DateTime date, int crownId,
                                               string notes, int aliasId, bool retired);

        public abstract void DeletePeopleAward(int peopleAwardId);

        #endregion

        #region "PeopleOfficer Abstract Methods"

        public abstract IDataReader GetPeopleCombinedOfficesByPeople(int peopleId);

        public abstract IDataReader GetPeopleOfficer(int peopleOfficerId);
        public abstract IDataReader ListPeopleOfficer();
        public abstract IDataReader GetPeopleOfficerByOfficerPosition(int officerPosistionId);
        public abstract IDataReader GetPeopleOfficerByPeople(int peopleId);

        public abstract int AddPeopleOfficer(int peopleId, int officerPositionId, DateTime startDate, DateTime endDate,
                                             bool currentlyHeld, bool acting, bool verified, string positionSubTitle,
                                             string positionNotes, string emailToUse, string emailOverride,
                                             string verifiedNotes, int linkedCrownId);

        public abstract void UpdatePeopleOfficer(int peopleOfficerId, int peopleId, int officerPositionId,
                                                 DateTime startDate, DateTime endDate, bool currentlyHeld, bool acting,
                                                 bool verified, string positionSubTitle, string positionNotes,
                                                 string emailToUse, string emailOverride, string verifiedNotes,
                                                 int linkedCrownId);

        public abstract void DeletePeopleOfficer(int peopleOfficerId);

        #endregion

        #region "GroupDesignation Abstract Methods"

        public abstract IDataReader GetGroupDesignation(int groupDesignationId);
        public abstract IDataReader ListGroupDesignation();
        public abstract int AddGroupDesignation(string name, bool ceremonialHead);
        public abstract void UpdateGroupDesignation(int groupDesignationId, string name, bool ceremonialHead);
        public abstract void DeleteGroupDesignation(int groupDesignationId);

        #endregion

        #region "GroupHistory Abstract Methods"

        public abstract IDataReader GetGroupHistory(int groupHistoryId);
        public abstract IDataReader ListGroupHistory();
        public abstract IDataReader GetGroupHistoryByFromGroup(int groupId);
        public abstract IDataReader GetGroupHistoryByToGroup(int groupId);
        public abstract int AddGroupHistory(DateTime date, int fromGroupId, int toGroupId, string note);

        public abstract void UpdateGroupHistory(int groupHistoryId, DateTime date, int fromGroupId, int toGroupId,
                                                string note);

        public abstract void DeleteGroupHistory(int groupHistoryId);

        #endregion
    }
}