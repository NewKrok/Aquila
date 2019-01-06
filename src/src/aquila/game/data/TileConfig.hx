package aquila.game.data;

import h2d.Tile;
import hxd.Res;

/**
 * ...
 * @author Krisztian Somoracz
 */
class TileConfig
{
	private static var config(default, null):Map<String, Tile>;

	public static function init()
	{
		config = [
			// Spaceships
			"img/gamecontent/spaceship/spaceship_a.png" => Res.image.spaceship.spaceship_a.toTile(),
			"img/gamecontent/spaceship/enemy_a.png" => Res.image.spaceship.enemy_a.toTile(),
			"img/gamecontent/spaceship/enemy_b.png" => Res.image.spaceship.enemy_b.toTile(),
			"img/gamecontent/spaceship/enemy_c.png" => Res.image.spaceship.enemy_c.toTile(),
		];
	}

	public static function get(id:String):Tile
	{
		return config.get(id);
	}
}