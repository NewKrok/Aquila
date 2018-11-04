package aquila.game.data;

/**
 * ...
 * @author Krisztian Somoracz
 */
class LevelData
{
	private static var config:Array<Array<Action>> = [
		untyped [{"type":{"_hx_index":2,"__enum__":"hle.ActionType"},"data":{"time":3}},{"type":{"_hx_index":3,"__enum__":"hle.ActionType"},"data":{"count":5,"enemyId":"1535737625655","attackLineId":"1512943091470","delay":1}},{"type":{"_hx_index":3,"__enum__":"hle.ActionType"},"data":{"count":5,"enemyId":"1535737625655","attackLineId":"1512943091471","delay":1}}]
	];

	public static function getLevelData(index:UInt):Array<Action>
	{
		return config[index];
	}
}

enum ActionType {
	START_GAME;
	END_GAME;
	WAIT;
	ADD_ENEMY;
	WAITING_FOR_ALL_ENEMIES_DIE;
}

typedef Action = {
	var type:ActionType;
	@:optional var data:Dynamic;
}

typedef ActionAddEnemyData = {
	var count:UInt;
	var enemyId:String;
	var attackLineId:String;
	var delay:Float;
}

typedef ActionWaitData = {
	var time:Float;
}