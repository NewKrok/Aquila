package aquila.game.data;

import aquila.game.BaseEnemy;
import hxd.Res;
import aquila.game.data.SpaceshipConfigs;

/**
 * ...
 * @author Krisztian Somoracz
 */
class EnemiesData
{
	public static var config(default, null):Array<EnemyConfig>;

	public static function init()
	{
		config = [
			{
				id: "asd",
				expReward: 5,
				scoreReward: 5,
				crystalReward: 1,
				spaceShipConfig: SpaceshipConfigs.getSpaceshipConfig("1535737624855")
			},
			{
				id: "qwe",
				expReward: 5,
				scoreReward: 4,
				crystalReward: 1,
				spaceShipConfig: SpaceshipConfigs.getSpaceshipConfig("1535737625655")
			}
		];
	}

	public static function getEnemy(enemyId:String):EnemyConfig
	{
		for (enemy in config)
		{
			if (enemy.spaceShipConfig.id == enemyId)
			{
				return enemy;
			}
		}

		return null;
	}
}

// TODO: remove it
typedef EnemyConfig = {
	var id:String;
	var expReward:UInt;
	var scoreReward:UInt;
	var crystalReward:UInt;
	var spaceShipConfig:SpaceshipConfig;
}