package aquila.menu.substate;

import h2d.Bitmap;
import hpp.heaps.Base2dSubState;
import hpp.heaps.HppG;
import hpp.heaps.ui.BaseButton;
import hpp.util.Language;
import hxd.Res;

/**
 * ...
 * @author Krisztian Somoracz
 */
class WelcomePage extends Base2dSubState
{
	var openFighterDock:Void->Void;
	var logo:Bitmap;
	var button:BaseButton;

	public function new(openFighterDock:Void->Void)
	{
		this.openFighterDock = openFighterDock;

		super();
	}

	override function build()
	{
		logo = new Bitmap(Res.image.common.logo.toTile());
		container.addChild(logo);
		logo.x = HppG.stage2d.width / 2 - logo.tile.width / 2;
		logo.y = 100;

		var button = new BaseButton(container, {
			onClick: function(_){ openFighterDock(); },
			baseGraphic: Res.image.ui.menu.enter_dock_button.toTile(),
			overGraphic: Res.image.ui.menu.enter_dock_button_over.toTile(),
			font: Fonts.DEFAULT_M,
			textOffset: { x: 0, y: 5.5 }
		});
		Language.registerTextHolder(cast button.label, "welcome_button");

		button.x = HppG.stage2d.width / 2 - button.getSize().width / 2;
		button.y = HppG.stage2d.height - button.getSize().height - 100;
	}
}