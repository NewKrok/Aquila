package aquila.game;

import aquila.AppConfig;
import h2d.Tile;
import aquila.game.BaseGraphicsHolder;
import aquila.game.BaseSpaceShip;
import aquila.game.data.TileConfig;
import hpp.heaps.util.SpriteUtil;
import hpp.util.GeomUtil.SimplePoint;

/**
 * ...
 * @author Krisztian Somoracz
 */
class BaseMissile extends BaseGraphicsHolder
{
	public var config(default, null):MissileConfig;
	public var diedByEnemy(default, null):Bool = false;

	public var isOwnerIsPlayer:Bool;

	var tile:Tile;
	var onRemoveRequest:BaseMissile->Void;

	var life:Float;

	var enemies:Array<BaseSpaceShip>;
	var target:BaseSpaceShip;

	public function new(onRemoveRequest:BaseMissile->Void, enemies:Array<BaseSpaceShip>, isOwnerIsPlayer:Bool, config:MissileConfig, angle:Float)
	{
		super();

		this.onRemoveRequest = onRemoveRequest;
		this.enemies = enemies;
		this.isOwnerIsPlayer = isOwnerIsPlayer;
		this.config = config;

		rotation = angle + Math.PI / 2;

		life = config.maxLife == null ? 1 : config.maxLife;

		config.reducedDamage = config.reducedDamage == null ? 0 : config.reducedDamage;
		config.areaToReducedDamage = config.areaToReducedDamage == null ? 0 : config.areaToReducedDamage;

		makeGraphic(TileConfig.get(config.tile));
	}

	public function update(delta:Float):Void
	{
		if (y < -100 || y > AppConfig.APP_HEIGHT + 100)
		{
			onRemoveRequest(this);
			return;
		}

		calculateTarget();

		if (target == null)
		{
			x += config.speed * Math.cos(rotation - Math.PI / 2) * delta;
			y += config.speed * Math.sin(rotation - Math.PI / 2) * delta;
		}
		else
		{
			var tmpAngle:Float = rotation - Math.PI / 2;
			var rotationOffset:Float = config.rotationSpeed;
			var angle:Float = Math.floor(Math.atan2(target.y - y, target.x - x));

			if (tmpAngle > angle)
			{
				rotationOffset = -config.rotationSpeed;
			}
			else
			{
				rotationOffset = config.rotationSpeed;
			}

			if ((tmpAngle > 0 && angle < 0 || tmpAngle < 0 && angle > 0) && Math.abs(tmpAngle) + Math.abs(angle) > Math.PI)
			{
				rotationOffset *= -1;
			}

			if (Math.abs(Math.floor(tmpAngle) - angle) < rotationOffset)
			{
				tmpAngle = angle;
			}
			else if (angle != Math.floor(tmpAngle))
			{
				tmpAngle += rotationOffset;
			}

			rotation = tmpAngle + Math.PI / 2;
			x += config.speed * Math.cos(tmpAngle) * delta;
			y += config.speed * Math.sin(tmpAngle) * delta;
		}
	}

	function calculateTarget():Void
	{
		var distance:Float = 999999;
		var index:UInt = 0;
		for (i in 0...enemies.length)
		{
			var tmpDistance:Float = SpriteUtil.getDistance(this, enemies[i]);
			if (tmpDistance < distance)
			{
				distance = tmpDistance;
				index = i;
			}
		}

		target = enemies[index];
	}

	public function hurt(damage:Float):Void
	{
		life -= damage;
		if (life <= 0)
		{
			life = 0;
			diedByEnemy = true;
			onRemoveRequest(this);
		}
	}
}

typedef MissileConfig = {
	var tile:String;
	var speed:Float;
	var maxDamage:Float;
	var rotationSpeed:Float;
	var reducedDamage:Float;
	var areaToReducedDamage:Float;
	var maxLife:Float;
	var firePoints:Array<SimplePoint>;
}