package aquila.menu.view;

import aquila.AppConfig;
import h2d.Bitmap;
import h2d.Flow;
import h2d.Layers;
import hxd.Res;

/**
 * ...
 * @author Krisztian Somoracz
 */
class ArrowFlow extends Flow
{
	public function new(?parent:Layers)
	{
		super(parent);
		isVertical = false;
		horizontalSpacing = AppConfig.isLayoutSmall() ? -12 : -15;

		var arrow1:Bitmap = new Bitmap( AppConfig.isLayoutSmall() ? Res.image.ui.menu.arrow_1_small.toTile() : Res.image.ui.menu.arrow_1.toTile());
		var arrow2:Bitmap = new Bitmap( AppConfig.isLayoutSmall() ? Res.image.ui.menu.arrow_1_small.toTile() : Res.image.ui.menu.arrow_1.toTile());

		addChild(arrow1);
		addChild(arrow2);
	}
}