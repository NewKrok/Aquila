package aquila.menu.view;

import h2d.Bitmap;
import h2d.Layers;
import h2d.Particles;
import h2d.Tile;
import aquila.AppConfig;
import hpp.heaps.HppG;
import hxd.Res;

/**
 * ...
 * @author Krisztian Somoracz
 */
class Background
{
	var parent:Layers;

	var backBitmap:Bitmap;
	var tile:Tile;

	var particles:Particles;
	var particleGroup:ParticleGroup;

	public function new(parent:Layers)
	{
		this.parent = parent;

		particles = new Particles(parent);
		particleGroup = new ParticleGroup(particles);

		particleGroup.size = .1;
		particleGroup.life = 5;
		particleGroup.speed = .2;
		particleGroup.nparts = 300;
		particleGroup.emitDist = HppG.stage2d.width / 2;
		particleGroup.emitDistY = HppG.stage2d.height / 2;
		particleGroup.emitMode = PartEmitMode.Box;
		particleGroup.emitAngle = 0;
		particleGroup.fadeOut = .5;
		particleGroup.dx = cast HppG.stage2d.width / 2;
		particleGroup.dy = cast HppG.stage2d.height / 2;

		particles.addGroup(particleGroup);
	}
}