package aquila.game;

import aquila.game.data.AttackLineConfig;
import aquila.game.data.EnemiesData;
import com.greensock.TweenMax;
import com.greensock.easing.Linear;
import aquila.game.data.AttackLineConfig.AttackLine;
import aquila.game.data.EnemiesData.EnemyConfig;
import hpp.util.GeomUtil.SimplePoint;

/**
 * ...
 * @author Krisztian Somoracz
 */
class BaseEnemy extends BaseSpaceShip
{
	public var enemyConfig(default, null):EnemyConfig;

	var lastPoint:SimplePoint;
	var isInited:Bool;
	var attackLine:AttackLine;

	public function new(onRemoveRequest:BaseSpaceShip->Void, enemyConfig:EnemyConfig, attackLine:AttackLine = null)
	{
		this.enemyConfig = enemyConfig;
		this.attackLine = attackLine;

		lastPoint = { x:0, y:0 };

		super(onRemoveRequest, enemyConfig.spaceShipConfig);

		if (attackLine != null)
		{
			init();
		}
	}

	public function init():Void
	{
		if (isInited) return;
		isInited = true;

		lastPoint = attackLine.line[0];

		setPosition(lastPoint.x, lastPoint.y);

		if (attackLine.line.length > 2)
		{
			TweenMax.to(
				this,
				attackLine.length / 1000 * config.speed,
				{
					bezier: {
						type: "soft",
						values: attackLine.line
					},
					ease: Linear.easeNone,
					onUpdate: updateRotation,
					onComplete: onAttackFinished
				}
			);
		}
		else
		{
			TweenMax.to(
				this,
				attackLine.length / 1000 * config.speed,
				{
					x: attackLine.line[1].x,
					y: attackLine.line[1].y,
					ease:Linear.easeNone,
					onUpdate: updateRotation,
					onComplete:onAttackFinished
				}
			);
		}
	}

	function updateRotation()
	{
		rotation = Math.atan2(y - lastPoint.y, x - lastPoint.x) + 90 * (Math.PI / 180);
		lastPoint.x = x;
		lastPoint.y = y;
	}

	function onAttackFinished()
	{
		diedByEnemy = false;
		onRemoveRequest(this);
	}
}