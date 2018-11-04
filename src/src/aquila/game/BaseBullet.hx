package aquila.game;

import aquila.AppConfig;
import h2d.Tile;
import aquila.game.BaseGraphicsHolder;
import aquila.game.data.TileConfig;
import hpp.util.GeomUtil.SimplePoint;

/**
 * ...
 * @author Krisztian Somoracz
 */
class BaseBullet extends BaseGraphicsHolder
{
	public static inline var hitAreaRadius:UInt = 15;

	public var currentDamage(get, null):Float;
	public var isSplitted(default, null):Bool;
	public var isCritical(default, null):Bool;
	public var config(default, null):BulletConfig;

	public var isOwnerIsPlayer:Bool;

	var tile:Tile;
	var onRemoveRequest:BaseBullet->Void;

	var life:Float;

	var angle:Float;
	var xSpeed:Float;
	var ySpeed:Float;

	public function new(onRemoveRequest:BaseBullet->Void, isOwnerIsPlayer:Bool, config:BulletConfig, angle:Float)
	{
		super();

		this.onRemoveRequest = onRemoveRequest;
		this.isOwnerIsPlayer = isOwnerIsPlayer;
		this.config = config;
		this.angle = angle;

		rotation = angle + Math.PI / 2;
		xSpeed = config.speed * Math.cos(angle);
		ySpeed = config.speed * Math.sin(angle);

		life = config.maxLife == null ? 1 : config.maxLife;
		config.criticalHitMultiplier = config.criticalHitMultiplier == null ? 1 : config.criticalHitMultiplier;

		makeGraphic(TileConfig.get(config.tile));
	}

	public function update(delta:Float)
	{
		x += xSpeed * delta;
		y += ySpeed * delta;

		if ( x < -40 || x > AppConfig.APP_WIDTH + 40 || y < -40 || y > AppConfig.APP_HEIGHT + 40 )
		{
			onRemoveRequest( this );
		}
	}

	public function hurt(damage:Float):Void
	{
		life -= damage;

		if (life <= 0)
		{
			life = 0;
			onRemoveRequest( this );
		}
	}

	function get_currentDamage():Float
	{
		if (config.chanceToSplit != null && Math.random() < config.chanceToSplit)
		{
			isSplitted = true;
		}
		if (config.criticalHitChance != null && Math.random() < config.criticalHitChance)
		{
			isCritical = true;
			return config.damage * config.criticalHitMultiplier;
		} else
		{
			return config.damage;
		}
	}
}

typedef BulletConfig = {
	var tile:String;
	var speed:Float;
	var damage:Float;
	var firePoints:Array<SimplePoint>;
	var maxLife:Float;
	@:optional var criticalHitChance:Float;
	@:optional var criticalHitMultiplier:Float;
	@:optional var chanceToSplit:Float;
}