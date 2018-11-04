package aquila.game.ui;

import aquila.game.BaseSpaceShip;
import aquila.game.data.SpaceshipConfigs.FireModeConfig;
import h2d.Bitmap;
import h2d.Graphics;
import h2d.Sprite;
import h2d.col.Point;
import aquila.game.data.FireModeDatas;
import hxd.Res;

/**
 * ...
 * @author Krisztian Somoracz
 */
class FireModeUi extends Sprite
{
	var background:Bitmap;
	var fireModeIcon:Bitmap;
	var timeBase:Bitmap;
	var timeMask:Bitmap;
	var timeMaskOuter:Bitmap;
	var timeGraphic:Graphics;

	var middlePoint:Point;
	var fireModeConfig:FireModeConfig;
	var activeFireMode:FireMode;

	public function new(fireModeConfig:FireModeConfig)
	{
		super();

		this.fireModeConfig = fireModeConfig;

		build();
		setFireMode(FireMode.NORMAL);
	}

	function build()
	{
		background = new Bitmap(Res.image.ui.fire_mode_ui.toTile(), this);

		middlePoint = new Point(
			Math.round(background.tile.width / 2),
			Math.round(background.tile.height / 2)
		);

		timeBase = new Bitmap(Res.image.ui.fire_mode_time_base.toTile(), this);
		timeBase.x = Math.round(middlePoint.x - timeBase.tile.width / 2);
		timeBase.y = Math.round(middlePoint.y - timeBase.tile.height / 2);

		timeGraphic = new Graphics(this);

		timeMask = new Bitmap(Res.image.ui.fire_mode_time_mask.toTile(), this);
		timeMask.x = Math.round(middlePoint.x - timeMask.tile.width / 2);
		timeMask.y = Math.round(middlePoint.y - timeMask.tile.height / 2);

		timeMaskOuter = new Bitmap(Res.image.ui.fire_mode_time_mask_outer.toTile(), this);
		timeMaskOuter.x = Math.round(middlePoint.x - timeMaskOuter.tile.width / 2);
		timeMaskOuter.y = Math.round(middlePoint.y - timeMaskOuter.tile.height / 2);
	}

	function setFireMode(fireMode:FireMode)
	{
		activeFireMode = fireMode;

		if (fireModeIcon != null)
		{
			fireModeIcon.remove();
			fireModeIcon = null;
		}

		fireModeIcon = new Bitmap(FireModeDatas.getFireModeData(fireMode).iconTile, this);
		fireModeIcon.x = Math.round(middlePoint.x - fireModeIcon.tile.width / 2);
		fireModeIcon.y = Math.round(middlePoint.y - fireModeIcon.tile.height / 2);

		if (fireModeConfig.fireModeDuration == -1)
		{
			timeBase.visible = false;
			timeGraphic.visible = false;
			timeMask.visible = false;
			timeMaskOuter.visible = false;
		}
		else
		{
			timeBase.visible = true;
			timeGraphic.visible = true;
			timeMask.visible = true;
			timeMaskOuter.visible = true;
		}
	}

	public function setRemainingTimePercent(percent:Float):Void
	{
		timeGraphic.clear();
		timeGraphic.beginFill(0xFFFF00, 1);
		timeGraphic.drawPie(middlePoint.x, middlePoint.y, timeBase.tile.width / 2 + 2, -Math.PI / 2, -Math.PI * 2 * percent);
		timeGraphic.endFill();
	}

	public function update():Void
	{
		if (fireModeConfig.fireModeDuration != -1)
		{
			var now:Float = Date.now().getTime();
			var endTime:Float = fireModeConfig.fireModeStartTime + fireModeConfig.fireModeDuration;

			setRemainingTimePercent(Math.max((endTime - now) / fireModeConfig.fireModeDuration, 0));
		}

		if (activeFireMode != fireModeConfig.fireMode)
		{
			setFireMode(fireModeConfig.fireMode);
		}
	}
}