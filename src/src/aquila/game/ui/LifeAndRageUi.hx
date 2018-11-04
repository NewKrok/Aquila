package aquila.game.ui;

import com.greensock.TweenMax;
import h2d.Bitmap;
import h2d.Graphics;
import h2d.Mask;
import h2d.Sprite;
import h2d.col.Point;
import aquila.game.PlayerSpaceShip;
import aquila.game.data.FireModeDatas;
import hxd.Res;

/**
 * ...
 * @author Krisztian Somoracz
 */
class LifeAndRageUi extends Sprite
{
	var background:Bitmap;
	var spaceShip:PlayerSpaceShip;

	var lifeLine:Bitmap;
	var lifeLineMask:Mask;

	var rageLine:Bitmap;
	var rageLineMask:Mask;

	var lastSavedLifePercent:Float;
	var lastSavedRagePercent:Float;

	public function new(spaceShip:PlayerSpaceShip)
	{
		super();

		this.spaceShip = spaceShip;

		build();
	}

	function build()
	{
		background = new Bitmap(Res.image.ui.life_and_rage_ui.toTile(), this);

		var middlePoint:Point = new Point(
			Math.round(background.getBounds().width / 2),
			Math.round(background.getBounds().height / 2)
		);

		lifeLine = new Bitmap(Res.image.ui.life_line.toTile());
		lifeLineMask = new Mask(cast lifeLine.getSize().width, cast lifeLine.getSize().height, this);
		lifeLineMask.x = Math.round(middlePoint.x - lifeLine.getBounds().width / 2);
		lifeLineMask.y = 15;
		lifeLineMask.addChild(lifeLine);

		rageLine = new Bitmap(Res.image.ui.rage_line.toTile());
		rageLineMask = new Mask(cast rageLine.getSize().width, cast rageLine.getSize().height, this);
		rageLineMask.x = lifeLineMask.x;
		rageLineMask.y = lifeLineMask.y + lifeLineMask.getSize().height + 7;
		rageLineMask.width = 0;
		rageLineMask.addChild(rageLine);
	}

	public function update():Void
	{
		var currentLifePercent:Float = spaceShip.currentLife / spaceShip.config.maxLife;
		var currentRagePercent:Float = spaceShip.currentRage / spaceShip.rageConfig.maxRage;

		if (lastSavedLifePercent != currentLifePercent)
		{
			lastSavedLifePercent = currentLifePercent;
			TweenMax.to(lifeLineMask, .4, {width: lifeLine.getSize().width * lastSavedLifePercent, onUpdate: updateHack});
		}

		if (lastSavedRagePercent != currentRagePercent)
		{
			lastSavedRagePercent = currentRagePercent;
			TweenMax.to(rageLineMask, .4, {width: rageLine.getSize().width * lastSavedRagePercent, onUpdate: updateHack});
		}
	}

	function updateHack()
	{
		lifeLineMask.x = lifeLineMask.x;
		rageLineMask.x = rageLineMask.x;
	}
}