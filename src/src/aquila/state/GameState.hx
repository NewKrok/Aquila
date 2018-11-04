package aquila.state;

import aquila.AppConfig;
import aquila.game.data.FireModeDatas;
import com.greensock.TweenMax;
import h2d.Layers;
import h2d.col.Point;
import aquila.game.Background;
import aquila.game.BaseBullet;
import aquila.game.BaseCrystal;
import aquila.game.BaseEnemy;
import aquila.game.BaseMissile;
import aquila.game.BaseSpaceShip;
import aquila.game.EffectHandler;
import aquila.game.GameModel;
import aquila.game.PlayerSpaceShip;
import aquila.game.data.AttackLineConfig;
import aquila.game.data.EnemiesData;
import aquila.game.data.FireModeDatas.FireMode;
import aquila.game.data.LevelData;
import aquila.game.ui.GameUi;
import aquila.game.util.CrystalCalculator;
import hpp.heaps.Base2dState;
import hpp.heaps.util.SpriteUtil;

/**
 * ...
 * @author Krisztian Somoracz
 */
class GameState extends Base2dState
{
	var gameModel:GameModel;

	var gameContainer:Layers;
	var background:Background;
	var ui:GameUi;

	var effectHandler:EffectHandler;

	var spaceShip:PlayerSpaceShip;
	var spaceShipMoveTargetPoint:Point;

	var enemies:Array<BaseEnemy>;
	var bullets:Array<BaseBullet>;
	var missiles:Array<BaseMissile>;
	var crystals:Array<BaseCrystal>;

	var isPlayerAttackBlocked:Bool = false;
	var now:Float;

	var isPaused:Bool;

	override function build()
	{
		gameModel = new GameModel();

		bullets = [];
		missiles = [];
		enemies = [];
		crystals = [];

		background = new Background(stage);
		gameContainer = new Layers(stage);

		createSpaceShip();
		loadLevel();

		effectHandler = new EffectHandler(gameContainer);
		ui = new GameUi(spaceShip, resumeRequest, pauseRequest, stage);

		resizeGameContainer();
		changeFireMode();
		reset();
	}

	function changeFireMode():Void
	{
		var fireModes:Array<FireMode> = [FireMode.NORMAL, FireMode.DOUBLE, FireMode.TRIPLE, FireMode.CROSS, FireMode.BACKWARD];
		spaceShip.changeFireMode(fireModes[Math.floor(Math.random() * fireModes.length)], 5000);

		TweenMax.delayedCall(5, changeFireMode);
	}

	function createSpaceShip()
	{
		spaceShipMoveTargetPoint = new Point();

		gameContainer.addChild(spaceShip = new PlayerSpaceShip(removeSpaceShipRutin));
	}

	function loadLevel()
	{
		var actionList:Array<Action> = LevelData.getLevelData(0);
		var commonDelay:Float = 0;

		for (action in actionList)
		{
			switch action.type
			{
				case ActionType.WAIT:
					commonDelay += action.data.time;

				case ActionType.WAITING_FOR_ALL_ENEMIES_DIE:
					// TODO: don't forget to handle

				case ActionType.ADD_ENEMY:
					preloadEnemy(commonDelay, cast action.data);

				case _:
			}
		}
	}

	function preloadEnemy(delay:Float, data:ActionAddEnemyData)
	{
		var enemyConfig:EnemyConfig = EnemiesData.getEnemy(data.enemyId);

		for (i in 0...data.count)
		{
			TweenMax.delayedCall(delay + i * data.delay, createEnemy, [enemyConfig, AttackLineConfig.getAttackLine(data.attackLineId)]);
		}
	}

	function createEnemy(enemyConfig:EnemyConfig, attackLine:AttackLine)
	{
		var enemy:BaseEnemy = new BaseEnemy(removeSpaceShipRutin, enemyConfig, attackLine);

		enemies.push(enemy);
		gameContainer.addChild(enemy);
	}

	override public function update(delta:Float)
	{
		if (isPaused) return;

		now = Date.now().getTime();

		spaceShipMoveTargetPoint.set(
			stage.mouseX / gameContainer.scaleX - gameContainer.x / gameContainer.scaleX,
			stage.mouseY / gameContainer.scaleY - gameContainer.y / gameContainer.scaleX
		);

		updateBackground();
		updateSpaceShip(delta);
		updateBullets(delta);
		updateMissiles(delta);
		updateCrystals(delta);

		checkPlayerShoot();
		checkEnemyShoot();
		checkPlayerMissileLaunch();
		checkEnemyMissileLaunch();

		checkCollisionDamage();

		ui.update();
	}

	function updateBackground()
	{
		var middle:Float = AppConfig._engineWidth;
		background.xPercentOffset = (middle - spaceShip.x) / middle;
	}

	function updateSpaceShip(delta:Float)
	{
		spaceShip.x += (spaceShipMoveTargetPoint.x - spaceShip.x) / spaceShip.currentSpeed * delta;
		spaceShip.y += (spaceShipMoveTargetPoint.y - spaceShip.y) / spaceShip.currentSpeed * delta;

		spaceShip.x = Math.min(spaceShip.x, AppConfig.APP_WIDTH);
		spaceShip.y = Math.min(spaceShip.y, AppConfig.APP_HEIGHT);
		spaceShip.x = Math.max(spaceShip.x, 0);
		spaceShip.y = Math.max(spaceShip.y, 0);

		spaceShip.update(delta);
	}

	function updateBullets(delta:Float)
	{
		for (bullet in bullets)
		{
			bullet.update(delta);

			if (bullet.isOwnerIsPlayer)
			{
				for (enemy in enemies)
				{
					// TODO: check this magic numbers, maybe we should calculate it more deeply
					if (SpriteUtil.getDistance(enemy, bullet) <= enemy.config.hitAreaRadius)
					{
						// TODO: handle area damage
						/*tmpDamage = bullet.damage * ( _rageIsActivated ? _spaceShip.damageMultiplierInRage : 1 );
						if ( _spaceShip.bulletAreaDamageMultiplier > 0 )
							areaDamage ( true, bullet.damage * ( _rageIsActivated ? _spaceShip.damageMultiplierInRage : 1 ) * _spaceShip.bulletAreaDamageMultiplier, _spaceShip.bulletAreaDamageRadius, _enemys[j] );*/

						// TODO: handle multiple damage problem on the same enemy (if the bullet has more life)
						enemy.hurt(bullet.currentDamage);
						effectHandler.addBulletExplosion(bullet.x, bullet.y, .7);

						// TODO: handle bullet split
						/*if ( bullet.isSplitted ) {
							_bullets.push ( _container.addChildAt ( new BulletC ( removeBulletRutin, true, 135, _spaceShip.damage ), 1 ) as BaseBullet );
							_bullets[_bullets.length - 1].x = bullet.x - 10;
							_bullets[_bullets.length - 1].y = bullet.y;
							_bullets.push ( _container.addChildAt ( new BulletC ( removeBulletRutin, true, -135, _spaceShip.damage ), 1 ) as BaseBullet );
							_bullets[_bullets.length - 1].x = bullet.x + 10;
							_bullets[_bullets.length - 1].y = bullet.y;
						}*/

						bullet.hurt(1);
						break;
					}
				}

				for (missile in missiles)
				{
					if (!missile.isOwnerIsPlayer && SpriteUtil.getDistance(missile, bullet) <= BaseBullet.hitAreaRadius)
					{
						missile.hurt(bullet.currentDamage);
						bullet.hurt(1);
						spaceShip.currentRage += spaceShip.rageConfig.ragePerMissileKill;

						break;
					}
				}
			}
			else if (SpriteUtil.getDistance(spaceShip, bullet) <= spaceShip.config.hitAreaRadius)
			{
				spaceShip.hurt(bullet.currentDamage);
				spaceShip.currentRage += spaceShip.rageConfig.ragePerBulletDamage;

				effectHandler.addBulletExplosion(bullet.x, bullet.y, .7);
				bullet.hurt(1);
			}
		}
	}

	function updateMissiles(delta:Float)
	{
		for (missile in missiles)
		{
			missile.update(delta);

			if (missile.isOwnerIsPlayer)
			{
				for (enemy in enemies)
				{
					if (SpriteUtil.getDistance(missile, enemy) <= enemy.config.hitAreaRadius)
					{
						enemy.hurt(missile.config.maxDamage);

						if (missile.config.reducedDamage > 0)
						{
							areaDamage(missile.x, missile.y, missile.isOwnerIsPlayer, missile.config.reducedDamage, missile.config.areaToReducedDamage, enemy);
						}

						missile.hurt(1);
						break;
					}
				}
			}
			else if (SpriteUtil.getDistance(spaceShip, missile) <= spaceShip.config.hitAreaRadius)
			{
				spaceShip.hurt(missile.config.maxDamage);
				spaceShip.currentRage += spaceShip.rageConfig.ragePerMissileDamage;

				missile.hurt(1);
			}
		}
	}

	function updateCrystals(delta:Float)
	{
		for (crystal in crystals)
		{
			var distance:Float = SpriteUtil.getDistance(crystal, spaceShip);

			if (spaceShip.crystalMagnetConfig.power > 0 && distance <= spaceShip.crystalMagnetConfig.range)
			{
				var angle:Float = Math.atan2(spaceShip.y - crystal.y, spaceShip.x - crystal.x);
				crystal.x += spaceShip.crystalMagnetConfig.power * Math.cos(angle);
				crystal.y += spaceShip.crystalMagnetConfig.power * Math.sin(angle);
			}

			if (distance < spaceShip.config.hitAreaRadius)
			{
				gameModel.collectedCrystal += crystal.crystalConfig.value;
				gameModel.score += crystal.crystalConfig.score;
				removeCrystalRutin(crystal);
				effectHandler.addCrystalCollectedEffect(crystal.x, crystal.y);
			}

			crystal.update(delta);
		}
	}

	function areaDamage(x:Float, y:Float, ownerIsPlayer:Bool, damage:Float, area:Float, exceptedEnemy:BaseSpaceShip)
	{
		if (ownerIsPlayer)
		{
			for (enemy in enemies)
			{
				if (enemy != exceptedEnemy && Math.sqrt(Math.pow(enemy.x - x, 2) + Math.pow(enemy.y - y, 2)) <= area)
				{
					enemy.hurt(damage);
				}
			}

			for (missile in missiles)
			{
				if (Math.sqrt(Math.pow(missile.x - x, 2) + Math.pow(missile.y - y, 2)) <= area)
				{
					missile.hurt(damage);
				}
			}
		}
	}

	function checkPlayerShoot()
	{
		if (!isPlayerAttackBlocked && now - spaceShip.lastShootTime >= spaceShip.currentFireRate)
		{
			spaceShip.lastShootTime = now;

			shootRequest(spaceShip, true, -Math.PI + Math.PI / 2);
		}
	}

	function checkEnemyShoot()
	{
		for (i in 0...enemies.length)
		{
			var enemy:BaseEnemy = enemies[i];

			if (enemy.currentFireRate != -1 && now - enemy.lastShootTime >= enemy.currentFireRate/* * ( _rageIsActivated ? _spaceShip.slowEnemysFireRate : 1 )*/)
			{
				enemy.lastShootTime = now;

				shootRequest(enemy, false, enemy.rotation - Math.PI / 2);
			}
		}
	}

	function shootRequest(owner:BaseSpaceShip, isOwnerIsPlayer:Bool, angle:Float)
	{
		switch (owner.config.fireModeConfig.fireMode)
		{
			case FireMode.NORMAL:
				shoot(owner.x, owner.y, isOwnerIsPlayer, owner.config.bulletConfig, angle);

			case FireMode.DOUBLE:
				shoot(owner.x - 10, owner.y, isOwnerIsPlayer, owner.config.bulletConfig, angle);
				shoot(owner.x + 10, owner.y, isOwnerIsPlayer, owner.config.bulletConfig, angle);

			case FireMode.TRIPLE:
				shoot(owner.x, owner.y, isOwnerIsPlayer, owner.config.bulletConfig, angle);
				shoot(owner.x - 5, owner.y, isOwnerIsPlayer, owner.config.bulletConfig, angle - Math.PI / 6);
				shoot(owner.x + 5, owner.y, isOwnerIsPlayer, owner.config.bulletConfig, angle + Math.PI / 6);

			case FireMode.CROSS:
				shoot(owner.x, owner.y, isOwnerIsPlayer, owner.config.bulletConfig, angle);
				shoot(owner.x, owner.y, isOwnerIsPlayer, owner.config.bulletConfig, angle + Math.PI / 2);
				shoot(owner.x, owner.y, isOwnerIsPlayer, owner.config.bulletConfig, angle - Math.PI / 2);

			case FireMode.BACKWARD:
				shoot(owner.x, owner.y, isOwnerIsPlayer, owner.config.bulletConfig, angle);
				shoot(owner.x - 5, owner.y, isOwnerIsPlayer, owner.config.bulletConfig, angle + Math.PI - Math.PI / 6);
				shoot(owner.x + 5, owner.y, isOwnerIsPlayer, owner.config.bulletConfig, angle + Math.PI + Math.PI / 6);
		}
	}

	function shoot(x:Float, y:Float, isOwnerIsPlayer:Bool, config:BulletConfig, angle:Float)
	{
		var bullet:BaseBullet = new BaseBullet(removeBulletRutin, isOwnerIsPlayer, config, angle);
		gameContainer.addChild( bullet );
		bullet.x = x;
		bullet.y = y;
		bullets.push(bullet);
	}

	function checkPlayerMissileLaunch()
	{
		if (!isPlayerAttackBlocked && spaceShip.currentMissileFireRate != 0 && now - spaceShip.lastMissileLaunchTime >= spaceShip.currentMissileFireRate)
		{
			spaceShip.lastMissileLaunchTime = now;

			launchMissile(spaceShip.x, spaceShip.y, cast enemies, true, spaceShip.config.missileConfig, -Math.PI + Math.PI / 2);
		}
	}

	function checkEnemyMissileLaunch()
	{
		for (i in 0...enemies.length)
		{
			var enemy:BaseEnemy = enemies[i];

			if (enemy.currentMissileFireRate != 0 && now - enemy.lastMissileLaunchTime >= enemy.currentMissileFireRate)
			{
				enemy.lastMissileLaunchTime = now;

				launchMissile(enemy.x, enemy.y, [spaceShip], false, enemy.config.missileConfig, enemy.rotation - Math.PI / 2);
			}
		}
	}

	function launchMissile(x:Float, y:Float, enemies:Array<BaseSpaceShip>, isOwnerIsPlayer:Bool, config:MissileConfig, angle:Float)
	{
		var missile:BaseMissile = new BaseMissile(removeMissileRutin, enemies, isOwnerIsPlayer, config, angle);
		gameContainer.addChild(missile);
		missile.x = x;
		missile.y = y;
		missiles.push(missile);
	}

	function checkCollisionDamage()
	{
		if (!spaceShip.isRemoved && !spaceShip.isInvulnerable)
		{
			for (enemy in enemies)
			{
				if (SpriteUtil.getDistance(enemy, spaceShip) < enemy.config.destroyRange)
				{
					spaceShip.hurt(enemy.config.maxLife);
					spaceShip.currentRage += spaceShip.rageConfig.ragePerCollisionKill;
					enemy.hurt(spaceShip.config.maxLife);
				}
			}
		}
	}

	function removeSpaceShipRutin(target:BaseSpaceShip)
	{
		if (target == spaceShip)
		{
			createSpaceShip();
		}
		else
		{
			enemies.remove(cast target);
		}

		if (target.diedByEnemy)
		{
			effectHandler.addExplosion(target.x, target.y);

			if (target != spaceShip)
			{
				spaceShip.currentRage += spaceShip.rageConfig.ragePerSpaceShipKill;
				addCrystals(target.x, target.y, cast(target, BaseEnemy).enemyConfig.crystalReward);
			}
		}

		target.remove();
		target = null;
	}

	function addCrystals(x:Float, y:Float, value:UInt)
	{
		var newCrystals:Array<BaseCrystal> = CrystalCalculator.getCrystalsFromValue(value, gameContainer, removeCrystalRutin);
		for (crystal in newCrystals)
		{
			crystal.x = x;
			crystal.y = y;
			crystal.init();
			crystals.push(crystal);
		}
	}

	function removeCrystalRutin(target:BaseCrystal):Void
	{
		for (crystal in crystals)
		{
			if (crystal == target)
			{
				crystal.dispose();
				crystal.remove();
				crystals.remove(crystal);
				crystal = null;
				return;
			}
		}
	}

	function removeBulletRutin(target:BaseBullet)
	{
		bullets.remove(target);

		target.remove();
		target = null;
	}

	function removeMissileRutin(target:BaseMissile)
	{
		missiles.remove(target);

		if (target.diedByEnemy)
			effectHandler.addExplosion(target.x, target.y, .7);

		target.remove();
		target = null;
	}

	function reset()
	{
		pauseRequest();

		spaceShip.x = AppConfig.APP_HALF_WIDTH;
		spaceShip.y = AppConfig.APP_HALF_HEIGHT;
	}

	function updateHack()
	{
		spaceShip.x = spaceShip.x;
	}

	override public function onStageResize(width:UInt, height:UInt)
	{
		super.onStageResize(width, height);

		resizeGameContainer();
		background.onResize();
		ui.onResize();
	}

	function resizeGameContainer()
	{
		var ratio:Float = stage.width / AppConfig.APP_WIDTH;
		if (stage.height < AppConfig.APP_HEIGHT * ratio)
			ratio = stage.height / AppConfig.APP_HEIGHT;

		gameContainer.scaleX = gameContainer.scaleY = ratio;
		gameContainer.x = stage.width / 2 - AppConfig.APP_HALF_WIDTH * ratio;
		gameContainer.y = stage.height / 2 - AppConfig.APP_HALF_HEIGHT * ratio;
	}

	function resumeRequest()
	{
		isPaused = false;
		TweenMax.resumeAll(true, true, true);
	}

	function pauseRequest()
	{
		isPaused = true;
		TweenMax.pauseAll(true, true, true);
	}

	override public function onFocus()
	{
		resumeRequest();
	}

	override public function onFocusLost()
	{
		pauseRequest();
	}

	override public function dispose()
	{

	}
}