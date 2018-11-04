package aquila.game;

import aquila.AppConfig;
import h2d.Bitmap;
import h2d.Sprite;
import h2d.Tile;

/**
 * ...
 * @author Krisztian Somoracz
 */
class BaseGraphicsHolder extends Sprite
{
	var bitmap:Bitmap;

	function makeGraphic(tile:Tile)
	{
		bitmap = new Bitmap(tile, this);
		bitmap.scale(AppConfig.GAME_BITMAP_SCALE);
		bitmap.tile.dx = cast -bitmap.tile.width / 2;
		bitmap.tile.dy = cast -bitmap.tile.height / 2;
	}
}