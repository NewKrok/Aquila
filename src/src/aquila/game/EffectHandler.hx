package aquila.game;

import com.greensock.TweenMax;
import h2d.Anim;
import h2d.Bitmap;
import h2d.Layers;
import h2d.Particles;
import h2d.Sprite;
import h2d.Tile;
import haxe.Timer;
import hxd.Res;

/**
 * ...
 * @author Krisztian Somoracz
 */
class EffectHandler
{
	static public inline var BULLET_EXPLOSION_DURATION:UInt = 500;
	static public inline var EXPLOSION_A_ANIMATION_DURATION:UInt = 700;

	static public inline var EXPLOSION_PART_DURATION:UInt = 1000;
	static public inline var EXPLOSION_SPARK_DURATION:UInt = 1000;
	static public inline var EXPLOSION_LIGHT_DURATION:UInt = 500;

	static public inline var CRYSTAL_COLLECT_DURATION:UInt = 600;

	var parent:Layers;
	var particles:Particles;
	var missleEffectDatas:Array<MissleEffectData>;

	public function new(s2d:Layers)
	{
		this.parent = s2d;

		particles = new Particles(s2d);
		missleEffectDatas = [];
	}

	public function addBulletExplosion(x:Float, y:Float, scale:Float = 1)
	{
		var g = new ParticleGroup(particles);

		g.size = scale;
		g.sizeRand = .2;
		g.gravity = 1;
		g.life = BULLET_EXPLOSION_DURATION / 3 / 1000;
		g.speed = 60 * scale;
		g.nparts = 5;
		g.emitDirectionAsAngle = true;
		g.emitMode = PartEmitMode.Point;
		g.emitDist = 10 * scale;
		g.emitLoop = false;
		g.speedRand = 3;
		g.fadeIn = 0;
		g.fadeOut = 0;
		g.texture = Res.image.effect.explosion_spark.toTexture();
		g.dx = cast x;
		g.dy = cast y;

		particles.addGroup(g);

		Timer.delay(function(){ removeEffect(g); }, BULLET_EXPLOSION_DURATION);
	}

	public function addExplosion(x:Float, y:Float, scale:Float = 1)
	{
		addExplosionLight(x, y, scale);
		addExplosionAAnimation(x, y);
		addExplosionSpark(x, y, scale);
		addExplosionPart(x, y, scale);
	}

	public function addExplosionPart(x:Float, y:Float, scale:Float = 1)
	{
		var g = new ParticleGroup(particles);

		g.size = .8 * scale;
		g.sizeRand = .4;
		g.gravity = 1;
		g.life = EXPLOSION_PART_DURATION / 2 / 1000;
		g.speed = 70 * scale;
		g.nparts = 10;
		g.emitMode = PartEmitMode.Point;
		g.emitDist = 10 * scale;
		g.emitLoop = false;
		g.speedRand = 3;
		g.fadeIn = 0;
		g.fadeOut = 0;
		g.rotSpeed = Math.PI / 5;
		g.rotSpeedRand = Math.PI / 5;
		g.texture = Res.image.effect.explosion_part.toTexture();
		g.dx = cast x;
		g.dy = cast y;

		particles.addGroup(g);

		Timer.delay(function(){ removeEffect(g); }, EXPLOSION_PART_DURATION);
	}

	public function addExplosionSpark(x:Float, y:Float, scale:Float = 1)
	{
		var g = new ParticleGroup(particles);

		g.size = scale;
		g.sizeRand = .2;
		g.gravity = 1;
		g.life = EXPLOSION_SPARK_DURATION / 3 / 1000;
		g.speed = 60 * scale;
		g.nparts = 15;
		g.emitDirectionAsAngle = true;
		g.emitMode = PartEmitMode.Point;
		g.emitDist = 10 * scale;
		g.emitLoop = false;
		g.speedRand = 3;
		g.fadeIn = 0;
		g.fadeOut = 0;
		g.texture = Res.image.effect.explosion_spark.toTexture();
		g.dx = cast x;
		g.dy = cast y;

		particles.addGroup(g);

		Timer.delay(function(){ removeEffect(g); }, EXPLOSION_SPARK_DURATION);
	}

	public function addExplosionLight(x:Float, y:Float, scale:Float = 1)
	{
		var image:Bitmap = new Bitmap(Res.image.effect.explosion_light.toTile(), parent);
		image.x = x;
		image.y = y;
		image.scaleX = image.scaleY = .3 * scale;

		var tile:Tile = image.tile;
		tile.dx = cast -tile.width / 2;
		tile.dy = cast -tile.height / 2;

		TweenMax.to(image, EXPLOSION_LIGHT_DURATION / 1000, { scaleX: 3 * scale, scaleY: 3 * scale, alpha: 0, onComplete: removeExplosionLight, onCompleteParams: [image], onUpdate: updateHack, onUpdateParams: [image] });
	}

	public function addExplosionAAnimation(x:Float, y:Float)
	{
		var holder = new BaseAnimationHolder();
		parent.addChild(holder);

		var anim:Anim = holder.makeAnimation("explosion_a");
		anim.x -= anim.getSize().width / 2;
		anim.y -= anim.getSize().height / 2;

		holder.scale(1 + Math.random() * .2);
		holder.rotation = Math.random() * Math.PI * 2;
		holder.x = x;
		holder.y = y;

		TweenMax.delayedCall(EXPLOSION_A_ANIMATION_DURATION / 1000, function(){
			holder.dispose();
			holder.remove();
			holder = null;
		});
	}

	function updateHack(img:Bitmap)
	{
		img.x = img.x;
	}

	function removeExplosionLight(img:Bitmap)
	{
		img.remove();
	}

	public function addCrystalCollectedEffect(x:Float, y:Float):Void
	{
		var g = new ParticleGroup(particles);

		g.size = .4;
		g.sizeRand = .4;
		g.gravity = 2;
		g.life = (CRYSTAL_COLLECT_DURATION - 200) / 1000;
		g.speed = 20;
		g.nparts = 10;
		g.emitDirectionAsAngle = true;
		g.emitMode = PartEmitMode.Point;
		g.emitDist = 40;
		g.emitLoop = false;
		g.speedRand = 1.5;
		g.fadeIn = 0;
		g.fadeOut = 0;
		g.texture = Res.image.effect.star.toTexture();
		g.dx = cast x;
		g.dy = cast y;

		particles.addGroup(g);

		Timer.delay(function(){ removeEffect(g); }, CRYSTAL_COLLECT_DURATION);
	}

	function removeEffect(g:ParticleGroup)
	{
		particles.removeGroup(g);
	}
}

typedef MissleEffectData = {
	var target:Sprite;
	var g:ParticleGroup;
}