package aquila.game;

import aquila.AppConfig;
import h2d.Graphics;
import h2d.Layers;
import h2d.Particles.PartEmitMode;
import h2d.Particles.ParticleGroup;
import h2d.Particles.Particles;
import h2d.Tile;
import hpp.heaps.HppG;

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

	var back:Graphics;
	var tile:Tile;

	var particles:Particles;
	var particleGroup:ParticleGroup;

	public function new(parent:Layers)
	{
		this.parent = parent;

		back = new Graphics(parent);
		back.beginFill(0x000000);
		back.drawRect(0, 0, HppG.stage2d.width, HppG.stage2d.height);
		back.endFill();

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
	}

	function set_xPercentOffset(value:Float):Float
	{
		xPercentOffset = value;

		particles.x = xPercentOffset * PARTICLE_MAX_OFFSET;

		return xPercentOffset;
	}
}