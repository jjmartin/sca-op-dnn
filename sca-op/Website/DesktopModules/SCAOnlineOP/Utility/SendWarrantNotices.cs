using System;

using DotNetNuke.Services.Exceptions;
using DotNetNuke.Services.Scheduling;

namespace ScaOnlineOP.Utility
{
    public class SendWarrantNotices : SchedulerClient
    {
        public SendWarrantNotices(ScheduleHistoryItem historyItem)
        {
            ScheduleHistoryItem = historyItem;
        }

        public override void DoWork()
        {
            try
            {
                Progressing();



                ScheduleHistoryItem.Succeeded = true;
                ScheduleHistoryItem.AddLogNote("Sent warrant expiration notifications successfully");
            }
            catch(Exception ex)
            {
                ScheduleHistoryItem.Succeeded = false;
                ScheduleHistoryItem.AddLogNote("EXCEPTION: " + ex);
                Errored(ref ex);
                Exceptions.LogException(ex);


            }
        }
    }
}