<%@ WebHandler Language="C#" Class="SCAOPNamesJSON" %>

using System;
using System.Data;
using System.Web;
using JeffMartin.DNN.Modules.SCAOnlineOP.Data;

public class SCAOPNamesJSON : IHttpHandler {
    
    public void ProcessRequest (HttpContext context) {
        context.Response.ContentType = "text/plain";
        string filter = context.Request.QueryString["q"];
        filter += "%";
        string limit = context.Request.QueryString["limit"];
        int limitResult = -1;
        if (!string.IsNullOrEmpty(limit))
            limitResult = int.Parse(limit);
        
        IDataReader dr = DataProvider.Instance().ListPeople(filter, "n", "a", false,
                                                                       false, true, false,
                                                                       false, 26, false,
                                                                       false);
        int count = 0;
        while(dr.Read() && ((limitResult>0 && count<=limitResult) || limitResult==-1))
        {
            context.Response.Write(dr["SCAName"] + Environment.NewLine);
        }
        
        
        
    }
 
    public bool IsReusable {
        get {
            return false;
        }
    }

}