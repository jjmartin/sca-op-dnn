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
    partial class SCAOPBaronialAwardsReport : PortalModuleBase
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
            this.lbGenerateBaronialAwardReport.Click += new System.EventHandler(this.hlBaronialAwardReport_Click);
            

            this.Load += new System.EventHandler(this.Page_Load);
        }

        #endregion

        #region Page_Load

        private void Page_Load(object sender, EventArgs e)
        { 
            if (File.Exists(PortalSettings.HomeDirectoryMapPath + "\\BaronialAwardReport.pdf"))
            {
                hlBaronialAwardReport.NavigateUrl = PortalSettings.HomeDirectory + "/BaronialAwardReport.pdf";
            }
            BindGivenByDDL(ddlBarony);
        }

        #endregion

        private void BindGivenByDDL(DropDownList ddl)
        {
            if (!IsPostBack)
            {
                DataTable dt = DataProvider.ConvertDataReaderToDataTable(DataProvider.Instance().GetGroupsByGroupDesignation("Barony"));
                ddl.DataSource = dt;
                ddl.DataTextField = "GroupName";
                ddl.DataValueField = "GroupId";
                ddl.DataBind();
                ddl.Items.Insert(0,
                                 new ListItem("<none selected>", Null.NullInteger.ToString()));
            }
        }

        private void hlBaronialAwardReport_Click(object sender, EventArgs e)
        {
            Server.ScriptTimeout = 600;
            GenerateBarionalReport();

            Server.ScriptTimeout = 90;
            Response.Redirect(Request.Url.ToString());
        }

        private void GenerateBarionalReport()
        {
            //TODO: validate size and margins
            Document doc = new Document(PageSize.LETTER, 36, 36, 36, 36);
            try
            {
                string ReportPath = PortalSettings.HomeDirectoryMapPath + "\\BaronialAwardReport.pdf";
                PdfWriter writer = PdfWriter.GetInstance(doc, new FileStream(ReportPath, FileMode.Create));
                // create add the event handler

                MyPageEvents events = new MyPageEvents(ddlBarony.SelectedItem.Text + " Order of Precedence", GenDate);
                writer.PageEvent = events;
                string subject = ddlBarony.SelectedItem.Text + " Order of Precedence";
                doc.AddSubject(subject);
                doc.Open();
                AddOPReportHeader(doc, subject, "");

                ds = DataProvider.ConvertDataReaderToDataSet(DataProvider.Instance().ListPeopleByOP());
                ds.Tables.Add(
                    DataProvider.ConvertDataReaderToDataTable(DataProvider.Instance().GetSingleGroupEnchiladaReport(int.Parse(ddlBarony.SelectedValue))));
                ds.Relations.Add("Awards", ds.Tables[0].Columns["PeopleId"], ds.Tables[1].Columns["PeopleId"]);
                ds.Tables[0].DefaultView.Sort = "SCAName";
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

     

        

        private void AddOPReportHeader(Document doc, string subject, string subtitle)
        {
            Paragraph title =
                new Paragraph(subject,
                              FontFactory.GetFont(FontFactory.HELVETICA, 24, Font.BOLD));
            title.Alignment = Element.ALIGN_CENTER;
            doc.Add(title);
            if(subtitle!=string.Empty)
            {
                Paragraph pSubtitle =
                    new Paragraph(subtitle,
                                  FontFactory.GetFont(FontFactory.HELVETICA, 12, Font.BOLD));
                pSubtitle.Alignment = Element.ALIGN_CENTER;
                doc.Add(pSubtitle);
            }
            Paragraph generated =
                new Paragraph("Generated on " + GenDate.ToString("G"),
                              FontFactory.GetFont(FontFactory.HELVETICA, 12, Font.BOLD));
            generated.Alignment = Element.ALIGN_CENTER;
            doc.Add(generated);

            //Add Footer Page Numbers


            doc.NewPage();
        }

        private void AddOPEntry(Document doc, DataRowView row)
        {
            if(row.CreateChildView("Awards").Count>0)
            {
                PdfPTable mainTable = new PdfPTable(1);
                mainTable.WidthPercentage = 100f;
                mainTable.DefaultCell.GrayFill = 0.9f;
                mainTable.AddCell(AddOPRecordHeader(row));
                mainTable.DefaultCell.GrayFill = 1f;
                mainTable.AddCell(AddAwardRecords(row));
                mainTable.SpacingAfter = 10f;
                mainTable.KeepTogether = true;
                doc.Add(mainTable);
            }
        }

       


        private PdfPTable AddOPRecordHeader(DataRowView row)
        {
            PdfPTable headerTable = new PdfPTable(new float[] {90f, 10f});

            headerTable.DefaultCell.BorderWidth = 0;
            headerTable.ExtendLastRow = false;

            PdfPCell nameCell = new PdfPCell();
            nameCell.BorderWidth = 0;
            nameCell.AddElement(new Phrase("SCA Name:", FontFactory.GetFont(FontFactory.HELVETICA, 9, Font.BOLD)));
            nameCell.AddElement(new Phrase(row.Row["SCAName"].ToString(), FontFactory.GetFont(FontFactory.HELVETICA, 9)));
            headerTable.AddCell(nameCell);

            PdfPCell rankCell = new PdfPCell();
            rankCell.BorderWidth = 0;
            rankCell.AddElement(new Phrase("Kingdom OP Rank:", FontFactory.GetFont(FontFactory.HELVETICA, 6, Font.BOLD)));
            rankCell.AddElement(new Phrase(row.Row["OPNum"].ToString(), FontFactory.GetFont(FontFactory.HELVETICA, 6)));
            headerTable.AddCell(rankCell);

            PdfPCell highAwardCell = new PdfPCell();
            highAwardCell.BorderWidth = 0;
            highAwardCell.AddElement(
                new Phrase("Highest Award or Status:" + row.Row["HighestAwardName"].ToString(), FontFactory.GetFont(FontFactory.HELVETICA, 6, Font.BOLD)));
            headerTable.AddCell(highAwardCell);

            headerTable.AddCell("");

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

            return recordsTable;
        }
    }

    
}