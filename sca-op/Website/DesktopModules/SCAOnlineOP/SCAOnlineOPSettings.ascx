<%@ Control AutoEventWireup="false" Inherits="JeffMartin.DNN.Modules.SCAOnlineOP.ScaOnlineOpSettings"
    Language="c#" Codebehind="ScaOnlineOpSettings.ascx.cs" %>
<%@ Register TagPrefix="dnn" TagName="Label" Src="~/controls/LabelControl.ascx" %>
<table>
    <tr>
        <td valign="top" class="SettingsLabelColumn">
            <dnn:label id="dlBasePortal" runat="server" controlname="ddlPortalList" />
           </td><td valign="top">
            <asp:DropDownList runat="server" ID="ddlPortalList">
            </asp:DropDownList>
        </td>
    </tr>
    <asp:PlaceHolder ID="phAwardRecsSettings" runat="server" >
    <tr >
        <td valign="top" class="SettingsLabelColumn">
            <dnn:Label ID="dlLinktoReccomendationForm" runat="server" ControlName="chkLinkToRec" />
        </td>
        <td valign="top">
            <asp:CheckBox ID="chkLinkToRec" runat="server" />
        </td>
    </tr>
    <tr>
        <td valign="top" class="SettingsLabelColumn">
            <dnn:Label ID="dlReccomendationForm" runat="server" ControlName="ddlDynamicForms" />
        </td>
        <td valign="top">
            <asp:DropDownList runat="server" ID="ddlDynamicForms">
            </asp:DropDownList>
        </td>
    </tr>
    </asp:PlaceHolder>
</table>

