package aquila.game.data;
import aquila.game.BaseBullet;
import aquila.game.BaseMissile;

import aquila.game.BaseBullet.BulletConfig;
import aquila.game.BaseMissile.MissileConfig;
import aquila.game.data.FireModeDatas.FireMode;
import hpp.util.GeomUtil.SimplePoint;

/**
 * ...
 * @author Krisztian Somoracz
 */
class SpaceshipConfigs
{
	public static var config(default, null):Array<SpaceshipConfig>;

	public static function init()
	{
		config = [{"id":"1535737624855","name":"Player","isBoss":false,"tile":"img/gamecontent/spaceship/spaceship_a.png","destroyRange":0,"hitAreaRadius":30,"maxLife":100,"speed":10,"fireRate":1000,"missileFireRate":3000,"chanceToDodge":0,"bulletConfig":{"firePoints":[{"x":0,"y":0}],"tile":"img/gamecontent/bullet/bullet_a.png","speed":3,"damage":5,"maxLife":1},"missileConfig":{"firePoints":[{"x":0,"y":0}],"tile":"img/gamecontent/missle/missle_a.png","speed":10,"rotationSpeed":0,"maxDamage":0,"reducedDamage":0,"areaToReducedDamage":0,"maxLife":0}},{"id":"1535737625655","name":"Enemy1","isBoss":false,"tile":"img/gamecontent/spaceship/enemy_a.png","destroyRange":0,"hitAreaRadius":30,"maxLife":15,"speed":10,"fireRate":2000,"missileFireRate":0,"chanceToDodge":0,"bulletConfig":{"firePoints":[{"x":0,"y":0}],"tile":"img/gamecontent/bullet/bullet_b.png","speed":1.5,"damage":10,"maxLife":1},"missileConfig":{"firePoints":[{"x":0,"y":0}],"tile":"img/gamecontent/missle/missle_a.png","speed":10,"rotationSpeed":0,"maxDamage":0,"reducedDamage":0,"areaToReducedDamage":0,"maxLife":0}}];
	}

	public static function getSpaceshipConfig(id:String):SpaceshipConfig
	{
		for (entry in config)
		{
			if (entry.id == id)
			{
				return entry;
			}
		}

		return null;
	}
}

typedef SpaceshipConfig = {
	var id:String;
	var name:String;
	var isBoss:Bool;
	var tile:String;
	var destroyRange:Float;
	var hitAreaRadius:UInt;
	var maxLife:Float;
	var speed:Float;
	var chanceToDodge:Float;
	var missileFireRate:Float;
	var fireRate:Float;
	var bulletConfig:BulletConfig;
	var missileConfig:MissileConfig;
	@:optional var fireModeConfig:FireModeConfig;
	@:optional var decoration:Array<DecorationConfig>;
}

typedef DecorationConfig = {
	var animationId:String;
	var dx:Float;
	var dy:Float;
}

typedef FireModeConfig = {
	var fireMode:FireMode;
	@:optional var fireModeStartTime:Float;
	@:optional var fireModeDuration:Float;
}