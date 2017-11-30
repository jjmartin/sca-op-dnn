<%@ Import namespace="DotNetNuke.Common" %>
<%@ Import namespace="DotNetNuke.Entities.Modules" %>
<%@ Control Language="c#" AutoEventWireup="false" Inherits="JeffMartin.DNN.Modules.SCAOnlineOP.SCAOnlineOPMatchGame" targetSchema="http://schemas.microsoft.com/intellisense/ie5" Codebehind="SCAOnlineOPMatchGame.ascx.cs" %>
<div class="SCAOPGame">

<fieldset class="SCAOPGameSettings"><legend>Game Settings</legend>
	<div>Game Type:
		<asp:RadioButtonList ID="rblGameType" Runat="server" RepeatLayout="Flow" RepeatDirection="Horizontal">
			<asp:ListItem Value="Arms" Selected="True">Personal Arms</asp:ListItem>
			<asp:ListItem Value="Photo">Portrait Photographs</asp:ListItem>
		</asp:RadioButtonList>
	</div>
	<div>
		Difficulty:
		<asp:DropDownList Runat="server" ID="ddlDifficulty">
			<asp:ListItem Value="1">Easy - Reigning Royalty and Landed Nobility</asp:ListItem>
			<asp:ListItem Value="2">Easy - Recent Reigns and Landed Nobles</asp:ListItem>
			<asp:ListItem Value="3">Medium - Active Peers of the Realm</asp:ListItem>
			<asp:ListItem Value="4">Medium - Active Nobility</asp:ListItem>
			<asp:ListItem Value="5">Hard - Recently Active Gentry and Nobility</asp:ListItem>
			<asp:ListItem Value="6">Hard - Less Recently Active Gentry and Nobility</asp:ListItem>
			<asp:ListItem Value="7">Hard - All Royalty, Nobility, and Gentry</asp:ListItem>
		</asp:DropDownList><br />
		Each Difficulty adds a new group of people to the possible picks.
	</div>
	<div>Make it a bit trickier:
		<asp:CheckBox ID="chkShow10" Runat="server" Text="Show 10 names instead of 5" /></div>
	<div>
		<asp:Button Runat="server" ID="btnStartGame" Text="Start a New Game" /></div>
		<div class="normal">Questions about this game can be sent to the <a href="mailto:webmin@atenveldt.org">
		Web Ministers</a>.  If your picture appears on this game and you didn't authorize its use, please contact the
		web ministers.  If the wrong name appears for you, please contact the <a href="abacus@atenveldt.org">Abacus herald</a>.</div>
</fieldset>
<fieldset class="SCAOPGameInstructions"><legend>Instructions</legend>
	<p>Choose the the settings you want to test yourself on and click Start a New Game. 
		You will be presented with a list of 5 pictures and either 5 or 10 names 
		(depending on your game settings). Put the letter of one of the names in the 
		box next to each picture. When you have put all the letters in the boxes, click 
		the Submit button. The game will tell you how many you got right and track how 
		many guesses it takes you. Your goal, of course, is to get it in as few guesses 
		as possible. Once you get them all right, you will be able to click on the 
		names to find out more about those individuals (links will open a new window).
	</p>
	<p>
		This game doesn't keep any high scores, since its fairly easy to 
		look up the names in the OP. The point is to test your knowledge of the people 
		in the kingdom and learn about arms and people that you may not be familiar with.</p>
</fieldset>
<hr class="SCAOPGameClear">
<div class="SCAOPGamePictures">
	<asp:Repeater Runat="server" ID="rptPictures">
		<ItemTemplate>
			<div>
				<asp:Image Runat="server" ID="imgPicture"></asp:Image>
				<asp:TextBox ID="txtAnswer" Runat="server" />
				<asp:Label ID="lblCorrectAnswer" Visible="False" Runat="server" />
			</div>
		</ItemTemplate>
	</asp:Repeater>
</div>
<div class="SCAOPGameNames" runat="server" id="divNameList" visible="false">
	<asp:DataList Runat="server" ID="dlNames">
		<ItemTemplate>
			<asp:Label Runat="server" ID="lblLetter"></asp:Label>
			<asp:HyperLink ID="hlName" Runat="server"></asp:HyperLink>
		</ItemTemplate>
	</asp:DataList>
	<asp:Button ID="btnSubmitGuess" Runat="server" Text="Submit Answers"></asp:Button>
	<br>
	You have guessed
	<asp:Label ID="lblGuessCount" Runat="server">0</asp:Label>
	time(s).
	<asp:Label ID="lblResponse" CssClass="SCAOPGameResponse" Runat="server" Visible="False"></asp:Label>
</div>
</div>
