package aquila.game;

import aquila.AppConfig;
import h2d.Bitmap;
import h2d.Sprite;
import h2d.Tile;
import hpp.ui.HAlign;
import hpp.ui.VAlign;

/**
 * ...
 * @author Krisztian Somoracz
 */
class BaseBitmapHolder extends Sprite
{
	function makeBitmap(tile:Tile, hAlign:HAlign = null, vAlign:VAlign = null):Bitmap
	{
		hAlign = hAlign == null ? HAlign.RIGHT : hAlign;
		vAlign = vAlign == null ? VAlign.TOP : vAlign;

		var bitmap:Bitmap = new Bitmap(tile, this);
		bitmap.scale(AppConfig.GAME_BITMAP_SCALE);

		bitmap.x = hAlign == HAlign.LEFT ? 0 : hAlign == HAlign.RIGHT ? -bitmap.tile.width : -bitmap.tile.width / 2;
		bitmap.y = vAlign == VAlign.TOP ? 0 : vAlign == VAlign.BOTTOM ? -bitmap.tile.height : -bitmap.tile.height / 2;

		return bitmap;
	}
}