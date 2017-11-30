<%@ Control Language="c#" AutoEventWireup="false" Inherits="JeffMartin.DNN.Modules.SCAOnlineOP.SCAOfficerListEdit"TargetSchema="http://schemas.microsoft.com/intellisense/ie5"CodeBehind="SCAOfficerListEdit.ascx.cs" %>
<fieldset>
    <legend>Options</legend><span>List Officers for which group:</span>
    <asp:DropDownList ID="ddlEditGroup" AutoPostBack="True" OnSelectedIndexChanged="ddlEditGroup_SelectedIndexChanged"
        Width="270px" CssClass="awardList" runat="server">
    </asp:DropDownList>
    <asp:Panel ID="pnlGroupOfficeList" runat="server" Visible="false">
        <fieldset>
            <legend>Reign Options</legend>
            <div>
                <asp:CheckBox runat="server" Text="Include the Rulers of this Group" ID="chkIncludeRulers" />
                <span class="InstructionNote">Displays the current reign for the group or the reign selected below in the options.</span>
            </div>
            <div>
                <asp:CheckBox runat="server" Text="Show Offices associated with the Reign Below"
                    ID="chkUseCrownLink" AutoPostBack="true" OnCheckedChanged="chkUseCrownLink_CheckedChanged" />
                <asp:DropDownList ID="ddlCrown" runat="server" DataTextField="ReignCrown" DataValueField="CrownId"
                    CssClass="awardList">
                </asp:DropDownList>
            </div>
        </fieldset>
        <fieldset>
            <legend>Display Options</legend>
            <div>
                <asp:CheckBox runat="server" Text="Show Vacant offices in display" ID="chkShowVacant" />
            </div>
            <div>
                <asp:CheckBox runat="server" Text="Show Office History" ID="chkShowHistory" /></div>
            <div>
                <asp:CheckBox runat="server" Text="Show Offices as they appeared on this date:" ID="chkUseDisplayDate" /> 
                <asp:TextBox runat="server" ID="txtDisplayDate"></asp:TextBox>
                <asp:HyperLink  ID="hlDisplayDateCalendar" runat="server" >Calendar</asp:HyperLink><br />
                <span class="InstructionNote">The people who were in these positions will appear in the results, however their titles and contact information will not necessarily reflect what they were at the time. Depending on the list, you may want to note this on the display page.</span>

            </div>
        </fieldset>
</fieldset>
<h2>
    Choose the Offices you wish to appear</h2>
<asp:CheckBoxList runat="server" ID="lstOffices">
</asp:CheckBoxList>
<asp:LinkButton ID="cmdUpdate" runat="server" BorderStyle="None" CssClass="CommandButton"
    resourcekey="cmdUpdate">Update</asp:LinkButton>
<asp:LinkButton ID="cmdCancel" runat="server" BorderStyle="None" CausesValidation="False"
    CssClass="CommandButton" resourcekey="cmdCancel">Cancel</asp:LinkButton>
</asp:Panel> 