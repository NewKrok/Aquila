package aquila.game.ui;

import aquila.AppConfig;
import h2d.Layers;
import aquila.game.BaseSpaceShip;
import aquila.game.ui.LifeAndRageUi;
import hpp.heaps.ui.BaseButton;
import hxd.Res;

/**
 * ...
 * @author Krisztian Somoracz
 */
class GameUi
{
	var fireModeUi:FireModeUi;
	var lifeAndRageUi:LifeAndRageUi;

	var startButton:BaseButton;

	var target:BaseSpaceShip;

	var resumeRequest:Void->Void;
	var pauseRequest:Void->Void;
	var parent:Layers;

	public function new(target:BaseSpaceShip, resumeRequest:Void->Void, pauseRequest:Void->Void, parent:Layers)
	{
		this.target = target;
		this.resumeRequest = resumeRequest;
		this.pauseRequest = pauseRequest;
		this.parent = parent;

		parent.addChild(fireModeUi = new FireModeUi(target.config.fireModeConfig));
		fireModeUi.x = 5;
		fireModeUi.y = AppConfig._engineHeight - fireModeUi.getSize().height - 5;

		parent.addChild(lifeAndRageUi = new LifeAndRageUi(cast target));
		lifeAndRageUi.x = fireModeUi.x + fireModeUi.getSize().width + 5;
		lifeAndRageUi.y = fireModeUi.y;

		createStartButton();

		onResize();
	}

	function createStartButton():Void
	{
		startButton = new BaseButton(
			parent,
			{
				onClick: onResumeRequest,
				baseGraphic: Res.image.ui.ingame_start_button.toTile(),
				overAlpha: .9
			}
		);
	}

	function onResumeRequest(_)
	{
		startButton.visible = false;
		resumeRequest();
	}

	public function update():Void
	{
		fireModeUi.update();
		lifeAndRageUi.update();
	}

	public function onResize():Void
	{
		startButton.x = AppConfig._engineWidth / 2 - startButton.getSize().width / 2;
		startButton.y = AppConfig._engineHeight / 2 - startButton.getSize().height / 2;

		fireModeUi.y = AppConfig._engineHeight - fireModeUi.getSize().height - 5;
		lifeAndRageUi.y = fireModeUi.y;
	}
}