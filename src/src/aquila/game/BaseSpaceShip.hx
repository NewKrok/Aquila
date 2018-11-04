package aquila.game;

import aquila.data.AnimationConfig;
import aquila.game.data.SpaceshipConfigs;
import h2d.Anim;
import h2d.Bitmap;
import h2d.Tile;
import aquila.game.BaseBullet.BulletConfig;
import aquila.game.BaseMissile.MissileConfig;
import aquila.game.data.FireModeDatas;
import aquila.game.data.SpaceshipConfigs.SpaceshipConfig;
import aquila.game.data.TileConfig;
import hpp.heaps.util.TileUtil;
import hxd.Res;

/**
 * ...
 * @author Krisztian Somoracz
 */
class BaseSpaceShip extends BaseGraphicsHolder
{
	public var currentSpeed(get, null):Float;
	public var currentFireRate(get, null):Float;
	public var currentMissileFireRate(get, null):Float;
	public var currentLife(default, null):Float;
	public var isInvulnerable(default, null):Bool;
	public var isRemoved(default, null):Bool;
	public var config(default, null):SpaceshipConfig;
	public var diedByEnemy(default, null):Bool = false;

	public var lastShootTime:Float;
	public var lastMissileLaunchTime:Float;

	var bonusSpeed:Float = 0;
	var bonusFireRate:Float = 0;
	var bonusRocketFireRate:Float = 0;

	var defaultFireMode:FireMode;

	var onRemoveRequest:BaseSpaceShip->Void;

	public function new(onRemoveRequest:BaseSpaceShip->Void, config:SpaceshipConfig)
	{
		super();

		this.onRemoveRequest = onRemoveRequest;
		this.config = config;

		config.fireRate = config.fireRate == null ? -1 : config.fireRate;
		config.missileFireRate = config.missileFireRate == null ? -1 : config.missileFireRate;

		if (config.fireModeConfig == null)
		{
			config.fireModeConfig = { fireMode: FireMode.NORMAL, fireModeDuration: -1 };
		}
		else if (config.fireModeConfig.fireModeDuration == null)
		{
			config.fireModeConfig.fireModeDuration = -1;
		}
		defaultFireMode = config.fireModeConfig.fireMode;

		currentLife = config.maxLife;
		lastShootTime = lastMissileLaunchTime = Date.now().getTime();

		makeGraphic(TileConfig.get(config.tile));
		makeDecoration();
	}

	function makeDecoration()
	{
		if (config.decoration != null)
		{
			for (decorationData in config.decoration)
			{
				var decoration:Anim = AnimationConfig.getAnimation(decorationData.animationId, this);
				decoration.setScale(AppConfig.GAME_BITMAP_SCALE);
				decoration.x = decorationData.dx;
				decoration.y = decorationData.dy;
			}
		}
	}

	public function hurt(damage:Float):Void
	{
		if (isInvulnerable)
		{
			return;
		}

		if (config.chanceToDodge == 0 || Math.random() > config.chanceToDodge)
		{
			currentLife -= damage;
			if (currentLife <= 0)
			{
				currentLife = 0;
				isRemoved = true;
				diedByEnemy = true;
				onRemoveRequest(this);
			}
		}
	}

	public function changeFireMode(fireMode:FireMode, duration:Float = -1):Void
	{
		config.fireModeConfig.fireMode = fireMode;
		config.fireModeConfig.fireModeStartTime = Date.now().getTime();
		config.fireModeConfig.fireModeDuration = duration;
	}

	public function update(delta:Float):Void
	{
		var now:Float = Date.now().getTime();

		if (config.fireModeConfig.fireModeDuration != -1 && config.fireModeConfig.fireModeStartTime + config.fireModeConfig.fireModeDuration < now)
		{
			changeFireMode(defaultFireMode);
		}
	}

	function get_currentSpeed():Float
	{
		return config.speed + bonusSpeed;
	}

	function get_currentFireRate():Float
	{
		return config.fireRate + bonusFireRate;
	}

	function get_currentMissileFireRate():Float
	{
		return config.missileFireRate + bonusRocketFireRate;
	}
}