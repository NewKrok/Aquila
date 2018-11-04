package aquila.data;

import h2d.Anim;
import h2d.Sprite;
import h2d.Tile;
import hpp.heaps.util.TileUtil;
import hxd.Res;

/**
 * ...
 * @author Krisztian Somoracz
 */
class AnimationConfig
{
	private static var config(default, null):Map<String, AnimationData>;

	public static function init()
	{
		config = [
			"fire_a" => { speed: 15, tiles: TileUtil.getHorizontalTile(Res.image.effects.fire_a.toTile(), 34, 24) }
		];
	}

	public static function getAnimation(id:String, ?parent:Sprite = null):Anim
	{
		var config:AnimationData = config.get(id);

		return new Anim(config.tiles, config.speed, parent);
	}
}

typedef AnimationData = {
	var tiles:Array<Tile>;
	var speed:UInt;
}