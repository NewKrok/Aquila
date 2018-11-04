package aquila.game;

import aquila.AppConfig;
import h2d.Bitmap;
import h2d.Layers;
import h2d.Particles.PartEmitMode;
import h2d.Particles.ParticleGroup;
import h2d.Particles.Particles;
import h2d.Tile;
import hxd.Res;

/**
 * ...
 * @author Krisztian Somoracz
 */
class Background
{
	static private inline var TILE_MAX_OFFSET:Float = 15;
	static private inline var PARTICLE_MAX_OFFSET:Float = 30;

	public var xPercentOffset(default, set):Float = 0;

	var parent:Layers;

	var backBitmap:Bitmap;
	var tile:Tile;

	var particles:Particles;
	var particleGroup:ParticleGroup;

	public function new(parent:Layers)
	{
		this.parent = parent;

		backBitmap = new Bitmap(Res.image.game.background.bg_world_a.toTile(), parent);

		tile = backBitmap.tile;

		particles = new Particles(parent);
		particleGroup = new ParticleGroup(particles);

		particleGroup.size = .1;
		particleGroup.gravity = 1;
		particleGroup.life = 5;
		particleGroup.speed = 100;
		particleGroup.nparts = 200;
		particleGroup.emitMode = PartEmitMode.Direction;
		particleGroup.speedRand = 3;
		particleGroup.emitDist = AppConfig._engineWidth;
		particleGroup.emitAngle = Math.PI / 2;
		particleGroup.fadeOut = .5;

		particles.addGroup(particleGroup);

		onResize();
	}

	function set_xPercentOffset(value:Float):Float
	{
		xPercentOffset = value;

		backBitmap.x = AppConfig.APP_HALF_WIDTH + xPercentOffset * TILE_MAX_OFFSET;
		particles.x = xPercentOffset * PARTICLE_MAX_OFFSET;

		return xPercentOffset;
	}

	public function onResize():Void
	{
		backBitmap.scaleX = backBitmap.scaleY = AppConfig._engineWidth / AppConfig.APP_WIDTH - .5;
		backBitmap.x = AppConfig._engineWidth / 2;
		backBitmap.y = AppConfig._engineHeight / 2;

		tile.dx = cast -tile.width / 2;
		tile.dy = cast -tile.height / 2;
	}
}