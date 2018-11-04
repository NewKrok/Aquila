package aquila.menu.view;

import aquila.AppConfig;
import aquila.Fonts;
import h2d.Bitmap;
import h2d.Flow;
import h2d.Layers;
import h2d.Text;
import hxd.Res;

/**
 * ...
 * @author Krisztian Somoracz
 */
class Logo extends Flow
{
	private var logoImage:Bitmap;

	public function new(parent:Layers)
	{
		super(parent);

		isVertical = true;
		verticalSpacing = 10;

		build();
	}

	function build()
	{
		//this.logoImage = new Bitmap(AppConfig.isLayoutSmall() ? Res.image.ui.logo_small.toTile() : Res.image.ui.logo.toTile(), this);
		//this.logoImage.smooth = false;


		var tf:Text = new Text( AppConfig.isLayoutSmall() ? Fonts.DEFAULT_ES : Fonts.DEFAULT_S, this);
		tf.text = "@2018-All rights reserved.";
		//tf.y = logoImage.y + logoImage.tile.height + 5;
	}
}