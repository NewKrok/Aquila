package aquila.game;

import aquila.game.data.SpaceshipConfigs;
import hxd.Res;

/**
 * ...
 * @author Krisztian Somoracz
 */
class PlayerSpaceShip extends BaseSpaceShip
{
	public var rageConfig(default, null):RageConfig;
	public var crystalMagnetConfig(default, null):CrystalMagnetConfig;
	public var currentRage(default, set):UInt = 0;

	public function new(onRemoveRequest:BaseSpaceShip->Void)
	{
		crystalMagnetConfig = {
			power: 5,
			range: 300
		};

		rageConfig = {
			maxRage: 100,
			ragePerSpaceShipKill: 4,
			ragePerMissileKill: 1,
			ragePerBulletDamage: 5,
			ragePerMissileDamage: 2,
			ragePerCollisionKill: 2
		};

		super(onRemoveRequest, SpaceshipConfigs.getSpaceshipConfig("1535737624855"));
	}

	function set_currentRage(value:UInt):UInt
	{
		value = cast Math.min(100, value);

		return currentRage = value;
	}
}

typedef RageConfig = {
	var maxRage:UInt;
	var ragePerSpaceShipKill:UInt;
	var ragePerMissileKill:UInt;
	var ragePerBulletDamage:UInt;
	var ragePerMissileDamage:UInt;
	var ragePerCollisionKill:UInt;
}

typedef CrystalMagnetConfig = {
	var power:Float;
	var range:Float;
}