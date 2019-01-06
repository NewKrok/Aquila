package aquila.state;

import aquila.AppConfig;
import com.greensock.TweenMax;
import h2d.Flow;
import h2d.Graphics;
import h3d.mat.BlendMode;
import aquila.menu.substate.CampaignPage;
import aquila.menu.substate.FighterDockPage;
import aquila.menu.substate.PilotRankPage;
import aquila.menu.substate.SettingsPage;
import aquila.menu.substate.WelcomePage;
import aquila.menu.view.Background;
import aquila.menu.view.MenuHeader;
import hpp.heaps.Base2dState;
import hpp.heaps.Base2dSubState;
import hpp.heaps.HppG;
import hxd.Res;
import hxd.res.Sound;

class MenuState extends Base2dState
{
	var welcomePage:WelcomePage;
	var fighterDockPage:FighterDockPage;
	var settingsPage:SettingsPage;
	var pilotRankPage:PilotRankPage;
	var campaignPage:CampaignPage;

	var menuHeader:MenuHeader;
	var light:Graphics;
	var background:Background;

	var backgroundLoopMusic:Sound;
	var subStateChangeSound:Sound;

	override function build()
	{
		background = new Background(stage);

		backgroundLoopMusic = if (Sound.supportedFormat(Mp3)) Res.sound.Eerie_Cyber_World_Looping else null;
		subStateChangeSound = if (Sound.supportedFormat(Mp3)) Res.sound.UI_Quirky20 else null;

		if (backgroundLoopMusic != null) backgroundLoopMusic.play(true, .3);

		menuHeader = new MenuHeader(stage, startGame, openFighterDockPage, openSettingsPage, openPilotRankPage, openCampaignPage);

		welcomePage = new WelcomePage(openFighterDockPage);
		fighterDockPage = new FighterDockPage();
		settingsPage = new SettingsPage();
		pilotRankPage = new PilotRankPage();
		campaignPage = new CampaignPage();

		openSubState(welcomePage);
		onStageResize(0, 0);
	}

	function startGame()
	{
		playSubStateChangeSound();

		HppG.changeState(GameState);
	}

	function openWelcomePage()
	{
		playSubStateChangeSound();
		openSubState(welcomePage);
	}

	function openFighterDockPage()
	{
		playSubStateChangeSound();
		openSubState(fighterDockPage);
	}

	function openSettingsPage()
	{
		playSubStateChangeSound();
		openSubState(settingsPage);
	}

	function openPilotRankPage()
	{
		playSubStateChangeSound();
		openSubState(pilotRankPage);
	}

	function openCampaignPage()
	{
		playSubStateChangeSound();
		openSubState(campaignPage);
	}

	override function onSubStateChanged(activeSubState:Base2dSubState):Void
	{
		menuHeader.visible = activeSubState != welcomePage;
	}

	override public function onStageResize(width:UInt, height:UInt)
	{
		super.onStageResize(width, height);

		menuHeader.onStageResize();

		menuHeader.y = AppConfig.isLayoutSmall() ? 150 : 200;
	}

	function playSubStateChangeSound():Void
	{
		if (subStateChangeSound != null) subStateChangeSound.play();
	}

	override public function onFocus()
	{
		TweenMax.resumeAll(true, true, true);
	}

	override public function onFocusLost()
	{
		TweenMax.pauseAll(true, true, true);
	}

	override public function dispose()
	{
		backgroundLoopMusic.stop();
		backgroundLoopMusic.dispose();
		subStateChangeSound.stop();
		subStateChangeSound.dispose();

		super.dispose();
	}
}