package aquila.menu.substate;

import aquila.menu.view.WelcomeButton;
import hpp.heaps.Base2dSubState;

/**
 * ...
 * @author Krisztian Somoracz
 */
class WelcomePage extends Base2dSubState
{
	var openFighterDock:Void->Void;
	var welcomeButton:WelcomeButton;

	public function new(openFighterDock:Void->Void)
	{
		this.openFighterDock = openFighterDock;

		super();
	}

	override function build()
	{
		welcomeButton = new WelcomeButton(container, openFighterDock);
		welcomeButton.onStageScale();
	}

	override public function onOpen()
	{
		rePosition();
	}

	function rePosition()
	{
		welcomeButton.onStageScale();

		welcomeButton.x = stage.width / 2 - welcomeButton.getSize().width / 2;
		welcomeButton.y = stage.height - welcomeButton.getSize().height - 50;
	}

	override public function onStageResize(width:Float, height:Float)
	{
		rePosition();
	}
}