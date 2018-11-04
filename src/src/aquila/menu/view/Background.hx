package aquila.menu.view;

import h2d.Bitmap;
import h2d.Layers;
import h2d.Particles;
import h2d.Tile;
import aquila.AppConfig;
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

		backBitmap = new Bitmap(Res.image.ui.menu.menu_background_original.toTile(), parent);

		particles = new Particles(parent);
		particleGroup = new ParticleGroup(particles);

		particleGroup.size = .1;
		particleGroup.life = 3;
		particleGroup.speed = .2;
		particleGroup.nparts = 500;
		//particleGroup.emitMode = PartEmitMode.;
		particleGroup.emitDist = AppConfig._backgroundWidth;
		particleGroup.emitDistY = AppConfig._backgroundHeight;
		particleGroup.fadeOut = .5;
		particleGroup.dx = AppConfig._backgroundWidth;
		particleGroup.dy = AppConfig._backgroundHeight;

		particles.addGroup(particleGroup);
	}

	public function resizeAndScale()
	{
		if ( backBitmap.tile.width != AppConfig._backgroundWidth )
		{
			backBitmap.x = 0;
			backBitmap.y = 0;

			backBitmap.tile.scaleToSize( AppConfig._backgroundWidth, AppConfig._backgroundHeight );
			backBitmap.x -= ( backBitmap.tile.width - AppConfig._engineWidth ) / 2;
			backBitmap.y -= ( backBitmap.tile.height - AppConfig._engineHeight ) / 2;
		}
	}
}