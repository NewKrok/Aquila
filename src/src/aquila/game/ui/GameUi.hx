package aquila.game.ui;

import aquila.AppConfig;
import aquila.game.PlayerSpaceShip;
import aquila.game.ui.ProgressUi;
import com.greensock.TweenMax;
import com.greensock.easing.Back;
import h2d.Bitmap;
import h2d.Flow;
import h2d.Layers;
import h2d.Sprite;
import hpp.heaps.HppG;
import hpp.heaps.ui.BaseButton;
import hxd.Res;

/**
 * ...
 * @author Krisztian Somoracz
 */
class GameUi
{
	var container:Sprite;
	var uiPanel:Flow;

	//var fireModeUi:FireModeUi;

	var lifeUi:ProgressUi;
	var shieldUi:ProgressUi;
	var rageUi:ProgressUi;
	var enemyLifeUi:ProgressUi;

	var startButton:BaseButton;

	var target:PlayerSpaceShip;

	var resumeRequest:Void->Void;
	var pauseRequest:Void->Void;
	var parent:Layers;

	public function new(target:PlayerSpaceShip, resumeRequest:Void->Void, pauseRequest:Void->Void, parent:Layers)
	{
		this.target = target;
		this.resumeRequest = resumeRequest;
		this.pauseRequest = pauseRequest;
		this.parent = parent;

		/*parent.addChild(fireModeUi = new FireModeUi(target.config.fireModeConfig));
		fireModeUi.x = 5;
		fireModeUi.y = AppConfig._engineHeight - fireModeUi.getSize().height - 5;*/

		container = new Sprite(parent);

		createStartButton();
		createUiPanels(target);
		createFrame();

		onResize();
	}

	function createStartButton():Void
	{
		startButton = new BaseButton(
			parent,
			{
				onClick: onResumeRequest,
				baseGraphic: Res.image.ui.game.ingame_start_button.toTile(),
				overAlpha: .2
			}
		);
	}

	function onResumeRequest(_)
	{
		startButton.visible = false;
		resumeRequest();
	}

	function createUiPanels(target)
	{
		uiPanel = new Flow(container);
		uiPanel.isVertical = false;
		uiPanel.horizontalSpacing = 20;

		lifeUi = new ProgressUi(
			uiPanel,
			target.currentLife,
			target.config.maxLife,
			0xFF2626,
			Res.image.icon.health.toTile()
		);
		lifeUi.show(.9);

		shieldUi = new ProgressUi(
			uiPanel,
			target.currentLife,
			target.config.maxLife,
			0x006DD9,
			Res.image.icon.shield.toTile()
		);
		shieldUi.show(1.3);

		rageUi = new ProgressUi(
			uiPanel,
			target.currentLife,
			target.config.maxLife,
			0xFFD827,
			Res.image.icon.rage.toTile()
		);
		rageUi.show(1.7);

		uiPanel.x = HppG.stage2d.width / 2 - uiPanel.getSize().width / 2;
		uiPanel.y = HppG.stage2d.height - uiPanel.getSize().height;

		enemyLifeUi = new ProgressUi(
			container,
			target.currentLife,
			target.config.maxLife,
			0x85B200,
			Res.image.icon.enemy_health.toTile(),
			620,
			true
		);
		enemyLifeUi.rotation = Math.PI;
		enemyLifeUi.x = HppG.stage2d.width / 2 + enemyLifeUi.getSize().width / 2;
		enemyLifeUi.y = enemyLifeUi.getSize().height;
	}

	function createFrame()
	{
		var margin = 20;

		var frameTL = new Bitmap(Res.image.ui.game.frame_element.toTile(), container);
		var frameTR = new Bitmap(Res.image.ui.game.frame_element.toTile(), container);
		var frameBL = new Bitmap(Res.image.ui.game.frame_element.toTile(), container);
		var frameBR = new Bitmap(Res.image.ui.game.frame_element.toTile(), container);

		var width = frameTL.tile.width;
		var height = frameTL.tile.height;

		frameTL.x = height + -margin;
		frameTL.y = -width + -margin;
		frameTL.rotation = Math.PI / 2;

		frameTR.x = HppG.stage2d.width + width + margin;
		frameTR.y = height + -margin;
		frameTR.rotation = Math.PI;

		frameBL.x = -width + -margin;
		frameBL.y = HppG.stage2d.height - height + margin;

		frameBR.x = HppG.stage2d.width - height + margin;
		frameBR.y = HppG.stage2d.height + width + margin;
		frameBR.rotation = Math.PI * 1.5;

		TweenMax.to(frameTL, .6, {
			y: frameTL.y + width,
			ease: Back.easeOut,
			delay: Math.random() * .5,
			onUpdate: function () {frameTL.x = frameTL.x;}
		});

		TweenMax.to(frameTR, .6, {
			x: frameTR.x - width,
			ease: Back.easeOut,
			delay: Math.random() * .5,
			onUpdate: function () {frameTR.x = frameTR.x;}
		});

		TweenMax.to(frameBL, .6, {
			x: frameBL.x + width,
			ease: Back.easeOut,
			delay: Math.random() * .5,
			onUpdate: function () {frameBL.x = frameBL.x;}
		});

		TweenMax.to(frameBR, .6, {
			y: frameBR.y - width,
			ease: Back.easeOut,
			delay: Math.random() * .5,
			onUpdate: function () {frameBR.x = frameBR.x;}
		});
	}

	public function update():Void
	{
		//fireModeUi.update();
	}

	public function onResize():Void
	{
		startButton.x = AppConfig._engineWidth / 2 - startButton.getSize().width / 2;
		startButton.y = AppConfig._engineHeight / 2 - startButton.getSize().height / 2;

		//fireModeUi.y = AppConfig._engineHeight - fireModeUi.getSize().height - 5;
	}
}