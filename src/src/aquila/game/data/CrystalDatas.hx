package aquila.game.data;
import aquila.game.BaseCrystal;

import aquila.game.BaseCrystal.CrystalConfig;
import hxd.Res;

/**
 * ...
 * @author Krisztian Somoracz
 */
class CrystalDatas
{
	public static var datas(default, null):Array<CrystalConfig>;

	// TODO: add uniqe graphic for all crystal
	public static function init():Void
	{
		datas = [
			{
				speed: 200,
				value: 1,
				score: 10,
				tile: Res.image.common.crystal_a.toTile()
			},
			{
				speed: 200,
				value: 5,
				score: 50,
				tile: Res.image.common.crystal_b.toTile()
			},
			{
				speed: 200,
				value: 25,
				score: 250,
				tile: Res.image.common.crystal_c.toTile()
			},
			{
				speed: 200,
				value: 100,
				score: 1000,
				tile: Res.image.common.crystal_c.toTile()
			},
			{
				speed: 200,
				value: 500,
				score: 5000,
				tile: Res.image.common.crystal_c.toTile()
			},
			{
				speed: 200,
				value: 2500,
				score: 25000,
				tile: Res.image.common.crystal_c.toTile()
			}
		];
	}
}