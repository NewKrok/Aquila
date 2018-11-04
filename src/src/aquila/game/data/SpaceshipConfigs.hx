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
		config = [{"decorations":[{"id":"fire_a","point":{"x":-24,"y":35}},{"id":"fire_a","point":{"x":-9,"y":34}}],"id":"1535737624855","name":"Player","isBoss":false,"tile":"img/gamecontent/spaceship/spaceship_a.png","destroyRange":0,"hitAreaRadius":30,"maxLife":1,"speed":5,"fireRate":1000,"missileFireRate":1000,"chanceToDodge":0,"bulletConfig":{"firePoints":[{"x":0,"y":-15}],"tile":"img/gamecontent/bullet/bullet_a.png","speed":400,"damage":10,"maxLife":0},"missileConfig":{"firePoints":[{"x":30,"y":0},{"x":-30,"y":-3}],"tile":"img/gamecontent/missle/missle_a.png","speed":100,"rotationSpeed":0,"maxDamage":0,"reducedDamage":0,"areaToReducedDamage":0,"maxLife":0}},{"decorations":[],"id":"1535737625655","name":"Enemy1","isBoss":false,"tile":"img/gamecontent/spaceship/enemy_a.png","destroyRange":0,"hitAreaRadius":30,"maxLife":1,"speed":10,"fireRate":1000,"missileFireRate":1000,"chanceToDodge":0,"bulletConfig":{"firePoints":[{"x":0,"y":0}],"tile":"img/gamecontent/bullet/bullet_b.png","speed":2,"damage":10,"maxLife":1},"missileConfig":{"firePoints":[{"x":0,"y":0}],"tile":"img/gamecontent/missle/missle_a.png","speed":10,"rotationSpeed":0,"maxDamage":0,"reducedDamage":0,"areaToReducedDamage":0,"maxLife":0}},{"id":"1541371592350","name":"unnamed","isBoss":false,"tile":"img/gamecontent/spaceship/spaceship_a.png","destroyRange":0,"hitAreaRadius":30,"maxLife":1,"speed":10,"fireRate":1000,"missileFireRate":1000,"chanceToDodge":0,"bulletConfig":{"firePoints":[{"x":0,"y":0}],"tile":"img/gamecontent/bullet/bullet_a.png","speed":10,"damage":0,"maxLife":0},"missileConfig":{"firePoints":[{"x":0,"y":0}],"tile":"img/gamecontent/missle/missle_a.png","speed":10,"rotationSpeed":0,"maxDamage":0,"reducedDamage":0,"areaToReducedDamage":0,"maxLife":0},"decorations":[]},{"id":"1541371592985","name":"unnamed","isBoss":false,"tile":"img/gamecontent/spaceship/spaceship_a.png","destroyRange":0,"hitAreaRadius":30,"maxLife":1,"speed":10,"fireRate":1000,"missileFireRate":1000,"chanceToDodge":0,"bulletConfig":{"firePoints":[{"x":0,"y":0}],"tile":"img/gamecontent/bullet/bullet_a.png","speed":10,"damage":0,"maxLife":0},"missileConfig":{"firePoints":[{"x":0,"y":0}],"tile":"img/gamecontent/missle/missle_a.png","speed":10,"rotationSpeed":0,"maxDamage":0,"reducedDamage":0,"areaToReducedDamage":0,"maxLife":0},"decorations":[]}];
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
	var decorations:Array<DecorationConfig>;
	@:optional var fireModeConfig:FireModeConfig;
}

typedef DecorationConfig = {
	var id:String;
	var point:SimplePoint;
}

typedef FireModeConfig = {
	var fireMode:FireMode;
	@:optional var fireModeStartTime:Float;
	@:optional var fireModeDuration:Float;
}