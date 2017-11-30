using System;
using System.IO;
using iTextSharp.text;
using iTextSharp.text.pdf;

namespace JeffMartin.DNN.Modules.SCAOnlineOP
{
    /// <summary>
    /// Summary description for Class1
    /// </summary>
    public class MyPageEvents : PdfPageEventHelper
    {
        public MyPageEvents(string Subject, DateTime genDate)
        {
            GenDate = genDate;
            subject = Subject + " - Generated on " + GenDate.ToString("G");
        }

        // we will put the final number of pages in a template
        private PdfTemplate template;

        // This is the contentbyte object of the writer
        private PdfContentByte cb;

        // this is the BaseFont we are going to use for the header / footer
        private BaseFont bf = null;

        public DateTime GenDate;

        private string subject;

        // we override the onOpenDocument method
        public override void OnOpenDocument(PdfWriter writer, Document document)
        {
            try
            {
                bf = BaseFont.CreateFont(BaseFont.HELVETICA, BaseFont.CP1252, BaseFont.NOT_EMBEDDED);
                cb = writer.DirectContent;
                template = cb.CreateTemplate(50, 50);
            }
            catch (DocumentException )
            {
            }
            catch (IOException )
            {
            }
        }

        // we override the onEndPage method
        public override void OnEndPage(PdfWriter writer, Document document)
        {
            int pageN = writer.PageNumber - 1;
            String text = "Page " + pageN + " of ";

            float len = bf.GetWidthPoint(text, 6);
            float lenPageMax = bf.GetWidthPoint("888", 6);
            float rightMarginStart = writer.PageSize.Width - len - lenPageMax - 36; //right margin
            if (pageN > 0)
            {
                cb.BeginText();
                cb.SetFontAndSize(bf, 6);
                cb.SetTextMatrix(36, 30);
                cb.ShowText(subject);
                cb.EndText();

                cb.BeginText();
                cb.SetFontAndSize(bf, 6);
                cb.SetTextMatrix(rightMarginStart, 30);
                cb.ShowText(text);
                cb.EndText();
                cb.AddTemplate(template, rightMarginStart + len, 30);
            }
        }

        // we override the onCloseDocument method
        public override void OnCloseDocument(PdfWriter writer, Document document)
        {
            template.BeginText();
            template.SetFontAndSize(bf, 6);
            template.ShowText((writer.PageNumber - 2).ToString());
            template.EndText();
        }
    }
}