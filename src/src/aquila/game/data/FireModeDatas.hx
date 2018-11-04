package aquila.game.data;

import h2d.Tile;
import hxd.Res;

/**
 * ...
 * @author Krisztian Somoracz
 */
class FireModeDatas
{
	private static var config:Array<FireModeData>;

	public static function init()
	{
		config = [
			{
				mode: FireMode.NORMAL,
				iconTile: Res.image.ui.fire_mode_normal.toTile()
			},
			{
				mode: FireMode.DOUBLE,
				iconTile: Res.image.ui.fire_mode_double.toTile()
			},
			{
				mode: FireMode.TRIPLE,
				iconTile: Res.image.ui.fire_mode_triple.toTile()
			},
			{
				mode: FireMode.CROSS,
				iconTile: Res.image.ui.fire_mode_cross.toTile()
			},
			{
				mode: FireMode.BACKWARD,
				iconTile: Res.image.ui.fire_mode_backward.toTile()
			}
		];
	}

	public static function getFireModeData(mode:FireMode):FireModeData
	{
		for (entry in config)
		{
			if (entry.mode == mode) return entry;
		}

		return null;
	}
}

typedef FireModeData = {
	var mode:FireMode;
	var iconTile:Tile;
}

enum FireMode {
	NORMAL;
	DOUBLE;
	TRIPLE;
	CROSS;
	BACKWARD;
}