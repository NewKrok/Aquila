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
			"fire_a" => { speed: 15, tile: TileUtil.getVerticalTile(Res.image.effect.fire_a.toTile(), 34, 24) },
			"explosion_a" => { speed: 15, tile: TileUtil.getHorizontalTile(Res.image.effect.explosion_a.toTile(), 108, 84), loop: false },
			"bullet_a" => { speed: 10, tile: TileUtil.getHorizontalTile(Res.image.bullet.bullet_a.toTile(), 15, 8) },
			"missle_a" => { speed: 10, tile: TileUtil.getHorizontalTile(Res.image.missile.missile_a.toTile(), 35, 14) }
		];
	}

	public static function getAnimation(id:String, ?parent:Sprite = null):Anim
	{
		var config:AnimationData = config.get(id);

		var anim = new Anim(config.tile, config.speed, parent);
		if (config.loop != null) anim.loop = config.loop;

		return anim;
	}
}

typedef AnimationData = {
	var tile:Array<Tile>;
	var speed:UInt;
	@:optional var loop:Bool;
}