package aquila.menu.view;

import aquila.Fonts;
import h2d.Bitmap;
import h2d.Flow;
import h2d.Graphics;
import h2d.Layers;
import h2d.Tile;
import aquila.AppConfig;
import hpp.heaps.ui.BaseButton;
import hxd.Res;

class MenuHeader extends Layers
{
	var flow:Flow;
	var lineTop:Bitmap;
	var lineBottom:Bitmap;
	var menuStarter:Bitmap;
	var blackBackground:h2d.Graphics;
	var buttons:Array<BaseButton> = [];
	var submenus:Array<Dynamic> = [];
	var activeMenuLabel:String="";

	public function new(parent:Layers, startGame:Void->Void, openFighterDockPage:Void->Void, openSettingsPage:Void->Void, openPilotRankPage:Void->Void, openCampaignPage:Void->Void)
	{
		super(parent);

		build();

		submenus.push([ openFighterDockPage, "FIGHTER DOCK" ]);
		submenus.push([ openSettingsPage, "SETTINGS" ]);
		submenus.push([ openPilotRankPage, "PILOT RANK" ]);
		submenus.push([ openCampaignPage, "CAMPAIGN" ]);
		submenus.push([ startGame, "START GAME" ]);
	}

	function build()
	{
		blackBackground = new Graphics(this);
		createFlow();

		createMenuStarterDesign();
		flow.addChild(menuStarter);

		flow.addChild(new ArrowFlow());

		createMenuBackground();
		addEffectLines();
	}

	function addLine(yPos:Float):Bitmap
	{
		var line:Bitmap = new Bitmap(AppConfig.isLayoutSmall() ? Res.image.ui.menu.fade_line_small.toTile() : Res.image.ui.menu.fade_line.toTile());
		line.x = 0;
		line.y = yPos;
		return line;
	}

	function addEntry(callBackMenuContent:Void->Void, labelText:String)
	{
		var buttonTile:Tile = AppConfig.isLayoutSmall() ? Res.image.ui.menu.selected_menu_bg_small.toTile() : Res.image.ui.menu.selected_menu_bg.toTile();

		var button:BaseButton = new BaseButton(
			flow,
			{
				onClick: function(_) { callBackMenuContent(); },
				labelText: labelText,
				font: AppConfig.isLayoutSmall() ? Fonts.DEFAULT_S : Fonts.DEFAULT_M,
				baseGraphic: Tile.fromColor(0xFFFFFF, buttonTile.width, buttonTile.height, 0),
				overGraphic: buttonTile,
				selectedGraphic: buttonTile,
				overAlpha: .3,
				selectedAlpha: .6,
				isSelectable: true,
				isSelected: activeMenuLabel == "" || activeMenuLabel == labelText ? true : false,
				textOffset: { x: 0, y: 3 }
			}
		);
		button.onSelected = disableMenuButtons;
		buttons.push(button);

		var arrowFlowLong:ArrowFlowLong = new ArrowFlowLong();
		flow.addChild(arrowFlowLong);
	}

	function disableMenuButtons(target:BaseButton)
	{
		for (button in buttons)
		{
			if (button != target)
			{
				button.isSelected = false;
			}
		}

		activeMenuLabel = target.labelText;
	}

	function createMenuButtons():Void
	{
		for (menu in submenus)
		{
			addEntry(menu[ 0 ], menu[ 1 ]);
		}
	}

	function clearLayout():Void
	{
		blackBackground.clear();
		removeChild(lineTop);
		removeChild(lineBottom);
		removeChild(flow);
		removeChild(menuStarter);
	}

	function createFlow():Void
	{
		flow = new Flow(this);
		flow.isVertical = false;
		flow.horizontalSpacing = AppConfig.isLayoutSmall() ? -12 : -15;
		flow.verticalAlign = FlowAlign.Middle;
	}

	function createMenuBackground():Void
	{
		blackBackground.beginFill(0, .5);
		blackBackground.drawRect(0, 0, AppConfig._engineWidth, flow.outerHeight);
		blackBackground.endFill();
	}

	function addEffectLines():Void
	{
		lineTop = addLine(0);
		addChildAt(lineTop, 0);

		lineBottom = addLine(flow.y + flow.outerHeight);
		addChildAt(lineBottom, 0);

		lineTop.x = (AppConfig._engineWidth / 2) - (lineTop.getSize().width / 2);
		lineBottom.x = (AppConfig._engineWidth / 2) - (lineTop.getSize().width / 2);
	}

	function createMenuStarterDesign():Void
	{
		menuStarter = new Bitmap(AppConfig.isLayoutSmall() ? Res.image.ui.menu.menu_start_line_blue_small.toTile() : Res.image.ui.menu.menu_start_line_blue.toTile());
		menuStarter.smooth = true;
	}

	public function onStageResize()
	{
		if (AppConfig.shouldChangeLayoutSize())
		{
			buttons = [];

			clearLayout();
			createFlow();
			createMenuStarterDesign();

			flow.addChild(menuStarter);
			flow.addChild(new ArrowFlow());

			createMenuBackground();
			addEffectLines();
			createMenuButtons();
		}
	}
}