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
import hpp.ui.HAlign;
import hpp.ui.VAlign;
import hxd.Res;
import tink.state.State;

/**
 * ...
 * @author Krisztian Somoracz
 */
class BaseSpaceShip extends BaseBitmapHolder
{
	public var currentSpeed(get, null):Float;
	public var currentFireRate(get, null):Float;
	public var currentMissileFireRate(get, null):Float;
	public var currentLife(default, null):State<Float> = new State<Float>(0);
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

		currentLife.set(config.maxLife);
		lastShootTime = lastMissileLaunchTime = Date.now().getTime();

		makeBitmap(TileConfig.get(config.tile), HAlign.CENTER, VAlign.MIDDLE);
		makeDecoration();
	}

	function makeDecoration()
	{
		if (config.decorations != null)
		{
			for (decorationData in config.decorations)
			{
				var decoration:Anim = AnimationConfig.getAnimation(decorationData.id, this);
				decoration.setScale(AppConfig.GAME_BITMAP_SCALE);
				decoration.x = decorationData.point.x;
				decoration.y = decorationData.point.y;
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
			currentLife.set(currentLife.value - damage);
			if (currentLife.value <= 0)
			{
				currentLife.set(0);
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