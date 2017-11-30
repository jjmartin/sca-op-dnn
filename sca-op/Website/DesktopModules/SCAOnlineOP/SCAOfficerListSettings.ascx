<%@ Control AutoEventWireup="false" Inherits="JeffMartin.DNN.Modules.SCAOnlineOP.OfficerListSettings"
    Language="c#" Codebehind="SCAOfficerListSettings.ascx.cs" %>
<%@ Register TagPrefix="dnn" TagName="Label" Src="~/controls/LabelControl.ascx" %>
<table>
    <tr>
        <td valign="top" class="SettingsLabelColumn">
            <dnn:label id="dlBasePortal" runat="server" controlname="ddlPortalList" />
        </td>
        <td valign="top">
            <asp:DropDownList runat="server" ID="ddlPortalList">
            </asp:DropDownList>
        </td>
    </tr>
    <tr>
        <td valign="top">
            <label>
                Header Template</label></td>
        <td>
            <asp:TextBox ID="txtHeaderTemplate" runat="server" Height="300"
                    TextMode="MultiLine" Width="400"></asp:TextBox>
        </td>
    </tr>
    <tr>
        <td valign="top">
            <label>
                Item Template</label><br /><asp:LinkButton ID="btnReset" runat="server" CssClass="Normal"
                    OnClick="btnReset_Click" Text="Reset">
                </asp:LinkButton></td>
        <td>
            <asp:TextBox ID="txtItemTemplate" runat="server" Height="300"
                    TextMode="MultiLine" Width="400"></asp:TextBox>
        </td>
    </tr>
    <tr>
        <td valign="top">
            <label>
                Footer Template</label></td>
        <td>
            <asp:TextBox ID="txtFooterTemplate" runat="server" Height="300"
                    Width="400" TextMode="MultiLine"></asp:TextBox><br />
        </td>
    </tr>
</table>
<div style="float: right;">
    <p>
        <strong>Available Tokens</strong></p>
    <ul>
        <li>[OfficeBadge]*</li>
        <li>[Photo]*</li>
        <li>[PersonalArms]*</li>
        <li>[OfficeTitle]</li>
        <li>[OfficeSubTitle]</li>
        <li>[OfficeTermStart]</li>
        <li>[OfficeTermEnd]</li>
        <li>[PersonalTitle]</li>
        <li>[SCAName]</li>
        <li>[FullNameOrVacantLink]*</li>
        <li>[OPLink]*</li>
        <li>[HonorsSuffix]</li>
        <li>[ModernName]</li>
        <li>[1LineAddress]*</li>
        <li>[Address1]</li>
        <li>[Address2]</li>
        <li>[City]</li>
        <li>[State]</li>
        <li>[Zip]</li>
        <li>[Phone1]</li>
        <li>[Phone2]</li>
        <li>[EmailLink]*</li>
        <li>[EmailAddress]</li>
        <li>[Notes]</li>
        <li>[HomeBranch]</li>
        <li>[HomeKingdom]</li>
        <li>[HomeBranchKingdom]*</li>
        <li>[OfficeHistoryLink]*</li>
        <li>[IfNotVacant]</li>
        <li>[IfText:field]text/html[/IfText]</li>
    </ul>
    <p>
        Notes:<br />
        The [IfText:field] token works such that if the named field is not empty, then any
        additional text or HTML within the blocks will be included. If the field is empty,
        then that text html will not display. For instance, if the person has data in Address2
        they you may want to prefix address2 with a &lt;br /&gt; tag. This line would look
        like this:<br />
        [IfText:Address2]&lt;br /&gt;[/IfText][Address2]<br />
        [IfNotVacant]Text[/IfNotVacant] works the same way but will only show text if the officer record is not VACANT.<br />
        Email addresses are always scrambled against bot gleaning.<br />
        The Html entered here is not scrubbed or tested for validity... if you screw up
        the HTML, it has the potential to mess up the rest of the page.<br />
        Tokens are only available in the Item Template.<br />
       
        * Fields marked with * cannot be used in the IfText token<br />
    </p>
</div>
