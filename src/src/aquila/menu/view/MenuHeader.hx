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

		createMenuBackground();
	}

	function addEntry(callBackMenuContent:Void->Void, labelText:String)
	{
		var button:BaseButton = new BaseButton(
			flow,
			{
				onClick: function(_) { callBackMenuContent(); },
				labelText: labelText,
				font: AppConfig.isLayoutSmall() ? Fonts.DEFAULT_S : Fonts.DEFAULT_M,
				baseGraphic: Tile.fromColor(0xFFFFFF, 200, 40, .5),
				overGraphic: Tile.fromColor(0xFFFFFF, 200, 40, .4),
				selectedGraphic: Tile.fromColor(0xFFFFFF, 200, 40, .2),
				overAlpha: .3,
				selectedAlpha: .6,
				isSelectable: true,
				isSelected: activeMenuLabel == "" || activeMenuLabel == labelText ? true : false,
				textOffset: { x: 0, y: 3 }
			}
		);
		button.onSelected = disableMenuButtons;
		buttons.push(button);
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
		removeChild(flow);
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

	public function onStageResize()
	{
		if (AppConfig.shouldChangeLayoutSize())
		{
			buttons = [];

			clearLayout();
			createFlow();

			createMenuBackground();
			createMenuButtons();
		}
	}
}