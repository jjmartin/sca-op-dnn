using System;
using System.Collections.Generic;
using System.Data;
using System.IO;
using System.Web.UI.WebControls;
using DotNetNuke.Common.Utilities;
using DotNetNuke.Entities.Modules;
using iTextSharp.text;
using iTextSharp.text.pdf;
using JeffMartin.DNN.Modules.SCAOnlineOP.Data;
using ListItem=System.Web.UI.WebControls.ListItem;

namespace JeffMartin.DNN.Modules.SCAOnlineOP
{
    partial class SCAOPEverything : PortalModuleBase
    {
        private DataSet ds;

        private DateTime GenDate = DateTime.Now;

        #region Web Form Designer generated code

        protected override void OnInit(EventArgs e)
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
            this.lbGeneratePdf.Click += new System.EventHandler(this.lbGeneratePdf_Click);
            this.lbGeneratePdfNoDead.Click += new System.EventHandler(this.lbGeneratePdfNoDead_Click);
            this.lbGenerateCrownAwardReport.Click += new EventHandler(lbGenerateCrownAwardReport_Click);
            this.lbGenerateSouthwindReport.Click += new EventHandler(lbGenerateSouthwindReport_Click);

            this.Load += new System.EventHandler(this.Page_Load);
        }

        void lbGenerateSouthwindReport_Click(object sender, EventArgs e)
        {
            Server.ScriptTimeout = 600;
            GenerateSouthwindAwardPdfReport();

            Server.ScriptTimeout = 90;
            Response.Redirect(Request.Url.ToString());
        }

        private void lbGenerateCrownAwardReport_Click(object sender, EventArgs e)
        {
            Server.ScriptTimeout = 600;
            GenerateCrownAwardPdfReport();

            Server.ScriptTimeout = 90;
            Response.Redirect(Request.Url.ToString());
        }

        #endregion

        #region Page_Load

        private void Page_Load(object sender, EventArgs e)
        { 
            if (File.Exists(PortalSettings.HomeDirectoryMapPath + "\\OPReport.pdf"))
            {
                hlPdfReportLink.NavigateUrl = PortalSettings.HomeDirectory + "/OPReport.pdf";
            }
            if (File.Exists(PortalSettings.HomeDirectoryMapPath + "\\CrownReport.pdf"))
            {
                hlCrownAwardReport.NavigateUrl = PortalSettings.HomeDirectory + "/CrownReport.pdf";
            }
            if (File.Exists(PortalSettings.HomeDirectoryMapPath + "\\SouthwindReport.pdf"))
            {
                hlSouthwindAwardReport.NavigateUrl = PortalSettings.HomeDirectory + "/SouthwindReport.pdf";
            }
            BindGivenByDDL(ddlEdit_GivenBy);
            BindGroupDDL(ddlGroupList);
        }

        #endregion

        private void BindGivenByDDL(DropDownList ddl)
        {
            if (!IsPostBack)
            {
                DataTable dt = DataProvider.ConvertDataReaderToDataTable(DataProvider.Instance().ListCrowns());
                ddl.DataSource = dt;
                ddl.DataTextField = "GroupCrownReign";
                ddl.DataValueField = "CrownId";
                ddl.DataBind();
                ddl.Items.Insert(0,
                                 new ListItem("<none selected>", Null.NullInteger.ToString()));
            }
        }
        private void BindGroupDDL(DropDownList ddl)
        {
            if (!IsPostBack)
            {
                DataTable dt = DataProvider.ConvertDataReaderToDataTable(DataProvider.Instance().ListAwardGroupFilters());
                dt.DefaultView.RowFilter = "lvl1='Kingdom of Atenveldt'";
                ddl.DataSource = dt.DefaultView;
                ddl.DataTextField = "GroupName";
                ddl.DataValueField = "GroupId";
                ddl.DataBind();
                ddl.Items.Insert(0,
                                 new ListItem("<none selected>", Null.NullInteger.ToString()));
            }
        }
        private void lbGeneratePdf_Click(object sender, EventArgs e)
        {
            Server.ScriptTimeout = 600;
            GeneratePdfReport();

            Server.ScriptTimeout = 90;
            Response.Redirect(Request.Url.ToString());
        }

        private void lbGeneratePdfNoDead_Click(object sender, EventArgs e)
        {
            Server.ScriptTimeout = 600;
            GeneratePdfReport(true);

            Server.ScriptTimeout = 90;
            Response.Redirect(Request.Url.ToString());
        }

        private void GeneratePdfReport()
        {
            GeneratePdfReport(false);
        }

        private void GeneratePdfReport(bool removeDeadAndNonResidents)
        {
            //TODO: validate size and margins
            Document doc = new Document(PageSize.LETTER, 36, 36, 36, 36);
            try
            {
                string ReportPath = PortalSettings.HomeDirectoryMapPath + "\\OPReport.pdf";
                PdfWriter writer = PdfWriter.GetInstance(doc, new FileStream(ReportPath, FileMode.Create));
                // create add the event handler
            
                MyPageEvents events = new MyPageEvents("Kingdom of Atenveldt Order of Precedence", GenDate);
                writer.PageEvent = events;

                doc.AddSubject("Kingdom of Atenveldt Order of Precedence");
                doc.Open();
                AddOPReportHeader(doc);

                ds = DataProvider.ConvertDataReaderToDataSet(DataProvider.Instance().ListPeopleByOP());
                ds.Tables.Add(
                    DataProvider.ConvertDataReaderToDataTable(DataProvider.Instance().GetWholeEnchiladaReport()));
                ds.Relations.Add("Awards", ds.Tables[0].Columns["PeopleId"], ds.Tables[1].Columns["PeopleId"]);
                ds.Tables[0].DefaultView.Sort = "SCAName";
                if (removeDeadAndNonResidents)
                    ds.Tables[0].DefaultView.RowFilter = "ParentKingdom = 26 AND Deceased=0";
                foreach (DataRowView drv in ds.Tables[0].DefaultView)
                {
                    AddOPEntry(doc, drv);
                }
            }
            finally
            {
                doc.Close();
            }
        }

        private void GenerateSouthwindAwardPdfReport()
        {
            //TODO: validate size and margins
            Document doc = new Document(PageSize.LETTER, 36, 36, 36, 36);
            try
            {
                string ReportPath = PortalSettings.HomeDirectoryMapPath + "\\SouthwindReport.pdf";
                PdfWriter writer = PdfWriter.GetInstance(doc, new FileStream(ReportPath, FileMode.Create));


                //Data Stuff...
                IDataReader dr =
                    DataProvider.Instance().GetPeopleAwardByTime(int.Parse(ddlGroupList.SelectedValue), DateTime.Today.AddDays(- int.Parse(txtDays.Text)),DateTime.Today );
                ds = DataProvider.ConvertDataReaderToDataSet(dr, true);

                dr = DataProvider.Instance().GetAwardsCountByTime(int.Parse(ddlGroupList.SelectedValue), DateTime.Today.AddDays(-int.Parse(txtDays.Text)), DateTime.Today);
                ds.Tables.Add(DataProvider.ConvertDataReaderToDataTable(dr));


                if (ds.Tables[0].Rows.Count > 0)
                {
                    string subject = string.Format("Awards given between {0:d} and {1:d} in {2}",
                                                   DateTime.Today.AddDays(-int.Parse(txtDays.Text)),
                                                   DateTime.Today,
                                                   ddlGroupList.SelectedValue == "-1"
                                                       ? "All Groups"
                                                       : ddlGroupList.SelectedItem.Text);
                        ;
                    // create add the event handler
                    MyPageEvents events = new MyPageEvents(subject, GenDate);
                    writer.PageEvent = events;

                    doc.AddSubject(subject);
                    doc.Open();
                    AddCrownAwardReportHeader(doc, subject, "", "Summary Award Counts for " + 
                        DateTime.Today.AddDays(-int.Parse(txtDays.Text)).ToShortDateString() + "-" + DateTime.Today.ToShortDateString(),
                        ds.Tables[1].DefaultView);

                    AddCrownAwardEntries(doc, ds.Tables[0].DefaultView);

                    
                }
                else
                {

                    Paragraph Message =
                            new Paragraph(
                                "No Awards were found for the Time Span Requested - " +  DateTime.Today.AddDays(- int.Parse(txtDays.Text)).ToShortDateString() + "-" + DateTime.Today.ToShortDateString(),
                                FontFactory.GetFont(FontFactory.HELVETICA, 12, Font.BOLD));
                    Message.Alignment = Element.ALIGN_CENTER;
                    doc.Open();
                    doc.Add(Message);
                }
            }
            finally
            {
                if (doc.IsOpen()) doc.Close();
            }
        }

        private void GenerateCrownAwardPdfReport()
        {
            //TODO: validate size and margins
            Document doc = new Document(PageSize.LETTER, 36, 36, 36, 36);
            try
            {
                string ReportPath = PortalSettings.HomeDirectoryMapPath + "\\CrownReport.pdf";
                PdfWriter writer = PdfWriter.GetInstance(doc, new FileStream(ReportPath, FileMode.Create));
               

                //Data Stuff...
                IDataReader dr =
                    DataProvider.Instance().GetPeopleAwardByCrowns(int.Parse(ddlEdit_GivenBy.SelectedValue));
                ds =DataProvider.ConvertDataReaderToDataSet(dr, true);
                dr.NextResult();
                ds.Tables.Add(DataProvider.ConvertDataReaderToDataTable(dr));

                dr = DataProvider.Instance().GetAwardsCountByCrowns(int.Parse(ddlEdit_GivenBy.SelectedValue));
                ds.Tables.Add(DataProvider.ConvertDataReaderToDataTable(dr));
               
               
                if (ds.Tables[0].Rows.Count > 0)
                {
                    string subject = "Awards Given by " + ds.Tables[0].Rows[0]["AwardedBy"];
                    string subtitle = string.Format("Given during Reign {0} of {1} between {2:d} and {3:d}",
                                                    ds.Tables[0].Rows[0]["Reign"],
                                                    ds.Tables[0].Rows[0]["GroupName"],
                                                    ds.Tables[0].Rows[0]["CrownStartDate"],
                                                    ds.Tables[0].Rows[0]["CrownEndDate"])
                        ;
                    // create add the event handler
                    MyPageEvents events = new MyPageEvents(subject, GenDate);
                    writer.PageEvent = events;
                    
                    doc.AddSubject(subject);
                    doc.Open();
                    AddCrownAwardReportHeader(doc, subject, subtitle, "Summary Award Counts for the Reign", ds.Tables[2].DefaultView);

                    AddCrownAwardEntries(doc, ds.Tables[0].DefaultView);

                    if (ds.Tables.Count > 1 && ds.Tables[1].Rows.Count > 0)
                    {
                        doc.NewPage();
                        Paragraph Additional =
                            new Paragraph(
                                "Additional Awards Given out during the reign but not assigned a \"Given By\"",
                                FontFactory.GetFont(FontFactory.HELVETICA, 12, Font.BOLD));
                        Additional.Alignment = Element.ALIGN_CENTER;
                        doc.Add(Additional);
                        AddCrownAwardEntries(doc, ds.Tables[1].DefaultView);
                    }
                }
                else
                {
                   
                    Paragraph Message =
                            new Paragraph(
                                "No Awards were found for the Reign Requested - " + ddlEdit_GivenBy.SelectedItem.Text,
                                FontFactory.GetFont(FontFactory.HELVETICA, 12, Font.BOLD));
                    Message.Alignment = Element.ALIGN_CENTER;
                    doc.Open();
                    doc.Add(Message);
                }
            }
            finally
            {
                if(doc.IsOpen()) doc.Close();
            }
        }

        private void AddOPReportHeader(Document doc)
        {
            Paragraph title =
                new Paragraph("Kingdom of Atenveldt Order of Precedence",
                              FontFactory.GetFont(FontFactory.HELVETICA, 24, Font.BOLD));
            title.Alignment = Element.ALIGN_MIDDLE;
            doc.Add(title);
            Paragraph generated =
                new Paragraph("Generated on " + GenDate.ToString("G"),
                              FontFactory.GetFont(FontFactory.HELVETICA, 12, Font.BOLD));
            generated.Alignment = Element.ALIGN_CENTER;
            doc.Add(generated);

            //Add Footer Page Numbers


            doc.NewPage();
        }

        private void AddCrownAwardReportHeader(Document doc, string subject, string subtitle, string summaryText, DataView dv)
        {
            Paragraph title =
                new Paragraph(subject,
                              FontFactory.GetFont(FontFactory.HELVETICA, 24, Font.BOLD));
            title.Alignment = Element.ALIGN_CENTER;
            doc.Add(title);
            Paragraph generated =
                new Paragraph(subtitle,
                              FontFactory.GetFont(FontFactory.HELVETICA, 12, Font.BOLD));
            generated.Alignment = Element.ALIGN_CENTER;
            doc.Add(generated);
            generated =
                new Paragraph("Generated on " + GenDate.ToString("G"),
                              FontFactory.GetFont(FontFactory.HELVETICA, 12, Font.BOLD));
            generated.Alignment = Element.ALIGN_CENTER;
            doc.Add(generated);

            AddCrownAwardCounts(doc, dv, summaryText);

            //Add Footer Page Numbers


            doc.NewPage();
        }

        private void AddOPEntry(Document doc, DataRowView row)
        {
            PdfPTable mainTable = new PdfPTable(1);
            mainTable.WidthPercentage = 100f;
            mainTable.DefaultCell.GrayFill = 0.9f;
            mainTable.AddCell(AddOPRecordHeader(row));
            mainTable.DefaultCell.GrayFill = 1f;
            mainTable.AddCell(AddAwardRecords(row));
            mainTable.SpacingAfter = 5f;
            mainTable.KeepTogether = true;
            doc.Add(mainTable);
        }

        private void AddCrownAwardCounts(Document doc, DataView dv, string SummaryText)
        {
            Paragraph AwardCounts =
               new Paragraph(SummaryText,
                             FontFactory.GetFont(FontFactory.HELVETICA, 12, Font.BOLD));
            AwardCounts.Alignment = Element.ALIGN_CENTER;
            AwardCounts.SpacingBefore = 100f;
            AwardCounts.SpacingAfter = 10f;
            doc.Add(AwardCounts);

            PdfPTable mainTable = new PdfPTable(2);
            mainTable.WidthPercentage = 50f;

            bool ToggleGrey = false;

            Font HeaderFont = FontFactory.GetFont(FontFactory.HELVETICA, 6, Font.BOLD);
            Font TextFont = FontFactory.GetFont(FontFactory.HELVETICA, 6);
            //RecordsTable Headers

            mainTable.AddCell(new Phrase("Award", HeaderFont));
            mainTable.AddCell(new Phrase("Count", HeaderFont));

            int TotalCount = 0;
            foreach (DataRowView AwardRecord in dv)
            {
                if (ToggleGrey)
                {
                    mainTable.DefaultCell.GrayFill = .9f;
                }
                else
                {
                    mainTable.DefaultCell.GrayFill = 1f;
                }
                mainTable.AddCell(
                    new Phrase(AwardRecord.Row["Name"].ToString(), TextFont));
                mainTable.AddCell(
                    new Phrase(Convert.ToInt32(AwardRecord.Row["AwardCount"]).ToString(), TextFont));

                TotalCount += Convert.ToInt32(AwardRecord.Row["AwardCount"]);
                ToggleGrey = !ToggleGrey;
            }
            if (ToggleGrey)
            {
                mainTable.DefaultCell.GrayFill = .9f;
            }
            else
            {
                mainTable.DefaultCell.GrayFill = 1f;
            }
            mainTable.AddCell(
                   new Phrase("Total Awards", HeaderFont));
            mainTable.AddCell(
                new Phrase(TotalCount.ToString(), HeaderFont));
            doc.Add(mainTable);
        }
        private void AddCrownAwardEntries(Document doc, DataView dv)
        {
            PdfPTable mainTable = new PdfPTable(5);

            bool ToggleGrey = false;

            Font HeaderFont = FontFactory.GetFont(FontFactory.HELVETICA, 6, Font.BOLD);
            Font TextFont = FontFactory.GetFont(FontFactory.HELVETICA, 6);
            //RecordsTable Headers
           
            mainTable.AddCell(new Phrase("SCA Name", HeaderFont));
            mainTable.AddCell(new Phrase("Date", HeaderFont));
            mainTable.AddCell(new Phrase("Award", HeaderFont));
            mainTable.AddCell(new Phrase("Awarded By", HeaderFont));
            mainTable.AddCell(new Phrase("Notes", HeaderFont));

            foreach (DataRowView AwardRecord in dv)
            {
                if (ToggleGrey)
                {
                    mainTable.DefaultCell.GrayFill = .9f;
                }
                else
                {
                    mainTable.DefaultCell.GrayFill = 1f;
                }
                mainTable.AddCell(
                    new Phrase(AwardRecord.Row["SCAName"].ToString(), TextFont));
                mainTable.AddCell(
                    new Phrase(Convert.ToDateTime(AwardRecord.Row["Date"]).ToShortDateString(), TextFont));
                mainTable.AddCell(
                    new Phrase(
                        AwardRecord.Row["AwardName"] +
                        (Convert.ToBoolean(AwardRecord.Row["Retired"]) ? "(Retired)" : ""), TextFont));
                mainTable.AddCell(new Phrase(AwardRecord.Row["AwardedBy"].ToString(), TextFont));
                mainTable.AddCell(new Phrase(AwardRecord.Row["Notes"].ToString(), TextFont));

                ToggleGrey = !ToggleGrey;
            }
            doc.Add(mainTable);
        }


        private PdfPTable AddOPRecordHeader(DataRowView row)
        {
            PdfPTable headerTable = new PdfPTable(new float[] {90f, 10f});

            headerTable.DefaultCell.BorderWidth = 0;
            headerTable.ExtendLastRow = false;

            PdfPCell nameCell = new PdfPCell();
            nameCell.BorderWidth = 0;
            nameCell.AddElement(new Phrase(row.Row["SCAName"].ToString(), FontFactory.GetFont(FontFactory.HELVETICA, 8, Font.BOLD)));
            
            headerTable.AddCell(nameCell);

            PdfPCell rankCell = new PdfPCell();
            rankCell.BorderWidth = 0;
            
            Phrase OpNum = new Phrase("Rank: ", FontFactory.GetFont(FontFactory.HELVETICA, 6, Font.BOLD));
            Chunk OpNumChunk = new Chunk(row.Row["OPNum"].ToString(), FontFactory.GetFont(FontFactory.HELVETICA, 6));
            OpNum.Add(OpNumChunk);
            rankCell.AddElement(OpNum);
            headerTable.AddCell(rankCell);

            PdfPCell highAwardCell = new PdfPCell();
            highAwardCell.BorderWidth = 0;
            Phrase Award = new Phrase("Highest Award or Status: ", FontFactory.GetFont(FontFactory.HELVETICA, 6, Font.BOLD));
            Chunk AwardChunk = new Chunk( row.Row["HighestAwardName"].ToString(), FontFactory.GetFont(FontFactory.HELVETICA, 6));
            Award.Add(AwardChunk);
            highAwardCell.AddElement(Award);

            Phrase Residence = new Phrase("Last Known Residence: ", FontFactory.GetFont(FontFactory.HELVETICA, 6, Font.BOLD));
            Chunk ResidenceChunk = new Chunk(row.Row["BranchResidence"].ToString(), FontFactory.GetFont(FontFactory.HELVETICA, 6));
            Residence.Add(ResidenceChunk);
            highAwardCell.AddElement(Residence);
            headerTable.AddCell(highAwardCell);

            PdfPCell infoCell = new PdfPCell();
            infoCell.BorderWidth = 0;
            if (Convert.ToInt32(row.Row["Deceased"]) != 0)
            {
                infoCell.AddElement(new Phrase("(Deceased)", FontFactory.GetFont(FontFactory.HELVETICA, 5, Font.ITALIC)));
            }
            Phrase Photo = new Phrase("Photo: ", FontFactory.GetFont(FontFactory.HELVETICA, 6, Font.BOLD));
            Chunk PhotoChunk = new Chunk(row.Row["PhotoURL"] == DBNull.Value ? "No" : "Yes", FontFactory.GetFont(FontFactory.HELVETICA, 6));
            Photo.Add(PhotoChunk);
            infoCell.AddElement(Photo);
            Phrase Arms = new Phrase("Arms: ", FontFactory.GetFont(FontFactory.HELVETICA, 6, Font.BOLD));
            Chunk ArmsChunk = new Chunk(row.Row["ArmsURL"] == DBNull.Value ? "No" : "Yes", FontFactory.GetFont(FontFactory.HELVETICA, 6));
            Arms.Add(ArmsChunk);
            infoCell.AddElement(Arms);
            headerTable.AddCell(infoCell);

            return headerTable;
        }

        private PdfPTable AddAwardRecords(DataRowView PersonRow)
        {
            PdfPTable recordsTable = new PdfPTable(6);

            DataView awardsDv = PersonRow.CreateChildView("Awards");
            awardsDv.Sort = "Precedence,Date,SortOrder";
            bool ToggleGrey = false;

            Font HeaderFont = FontFactory.GetFont(FontFactory.HELVETICA, 6, Font.BOLD);
            Font TextFont = FontFactory.GetFont(FontFactory.HELVETICA, 6);
            //RecordsTable Headers
            if (awardsDv.Count > 0)
            {
                recordsTable.AddCell(new Phrase("Date", HeaderFont));
                recordsTable.AddCell(new Phrase("Award", HeaderFont));
                recordsTable.AddCell(new Phrase("Group", HeaderFont));
                recordsTable.AddCell(new Phrase("Awarded By", HeaderFont));
                recordsTable.AddCell(new Phrase("Name on Scroll", HeaderFont));
                recordsTable.AddCell(new Phrase("Notes", HeaderFont));

                foreach (DataRowView AwardRecord in awardsDv)
                {
                    if (ToggleGrey)
                    {
                        recordsTable.DefaultCell.GrayFill = .9f;
                    }
                    else
                    {
                        recordsTable.DefaultCell.GrayFill = 1f;
                    }
                    recordsTable.AddCell(
                        new Phrase(Convert.ToDateTime(AwardRecord.Row["Date"]).ToShortDateString(), TextFont));
                    recordsTable.AddCell(
                        new Phrase(
                            AwardRecord.Row["AwardName"] +
                            (Convert.ToBoolean(AwardRecord.Row["Retired"]) ? "(Retired)" : ""), TextFont));
                    recordsTable.AddCell(new Phrase(AwardRecord.Row["AwardGroup"].ToString(), TextFont));
                    recordsTable.AddCell(new Phrase(AwardRecord.Row["AwardedBy"].ToString(), TextFont));
                    recordsTable.AddCell(new Phrase(AwardRecord.Row["NameOnScroll"].ToString(), TextFont));
                    recordsTable.AddCell(new Phrase(AwardRecord.Row["Notes"].ToString(), TextFont));

                    ToggleGrey = !ToggleGrey;
                }
            }
            return recordsTable;
        }

        protected void lbRename_Click(object sender, EventArgs e)
        {
            MassRename("PersonalArmsImages", "arms_");
            MassRename("OPImages", "photo_");
        }

        private void MassRename(string DestPath, string prefix)
        {
            string strSourcePath = FileSystemUtils.AddTrailingSlash(PortalSettings.HomeDirectoryMapPath + DestPath);
            string[] fileNames = Directory.GetFiles(strSourcePath);
            List<string> changedFiles = new List<string>();
            foreach (string fileName in fileNames)
            {
                if (fileName.StartsWith(strSourcePath + prefix))
                {
                    FileSystemUtils.MoveFile(fileName, fileName.Replace(strSourcePath + prefix, strSourcePath),
                                             PortalSettings);
                    changedFiles.Add(fileName.Replace(strSourcePath + prefix, string.Empty));
                }
            }
            foreach (string fileName in changedFiles)
            {
                lblResults.Text += fileName + "<br />";
            }
        }

        protected void LinkButton1_Click(object sender, EventArgs e)
        {
            try
            {
                lblResults.Text = "don't do that... ";
            }
            catch(Exception ex)
            {
                DotNetNuke.Services.Exceptions.Exceptions.ProcessModuleLoadException(this, ex);
            }
        }
    }


}