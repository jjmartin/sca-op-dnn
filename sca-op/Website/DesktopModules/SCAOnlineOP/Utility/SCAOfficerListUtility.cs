namespace JeffMartin.DNN.Modules.ScaOnlineOP.Utility
{
    /// <summary>
    /// Summary description for SCAOfficerListUtility
    /// </summary>
    public static class SCAOfficerListUtility
    {
        public static readonly string DefaultItemTemplate =
            @" <tr>
            <td>
                [OfficeBadge]</td>
            <td valign=""top"">
                [Photo]</td>
            <td valign=""top"">
                <table>
                    <tr>
                        <td class=""OfficerPosition"">
                            [OfficeTitle]
                            [IfText:OfficeSubTitle]<br />[/IfText][OfficeSubTitle]
                        </td>
                    </tr>
                    <tr>
                        <td class=""Normal"">
                        [FullNameOrVacantLink] [IfText:ModernName] ([/IfText][ModernName][IfText:ModernName])[/IfText]
                        </td>
                    </tr>
                    <tr >
                        <td class=""Normal"">
                            [1LineAddress]
                        </td>
                    </tr>
                    <tr>
                        <td class=""Normal"">
                            [Phone1][IfText:Phone1]<br />[/IfText]
                            [Phone2]
                        </td>
                    </tr>
                    <tr>
                         <td class=""Normal"">
                            [EmailLink]
                        </td>
                    </tr>
                    <tr>
                        <td class=""Normal"">
                            [Notes]
                        </td>
                    </tr>
                    <tr>
                        <td class=""Normal"">
                            [IfNotVacant]Office Warrant Ends: [OfficeTermEnd][/IfNotVacant]
                        </td>
                    </tr>   
                    <tr>
                        <td class=""Normal"">
                            <a href=""[OfficeHistoryLink]"">Office History</a>
                        </td>
                    </tr>
                </table>
            </td>
        </tr>";
    }
}