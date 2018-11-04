package aquila.menu.view;

import aquila.AppConfig;
import com.greensock.TweenMax;
import com.greensock.easing.Linear;
import h2d.Bitmap;
import h2d.Flow;
import h2d.Layers;
import hxd.Res;

/**
 * ...
 * @author Krisztian Somoracz
 */
class AnimatedArrows extends Flow
{
	var arrowA:Bitmap;
	var arrowB:Bitmap;
	var arrowC:Bitmap;

	public function new(parent:Layers)
	{
		super(parent);

		isVertical = false;
		horizontalSpacing = AppConfig.isLayoutSmall() ? -12 : -15;

		addChild(arrowA = new Bitmap( AppConfig.isLayoutSmall() ? Res.image.ui.menu.arrow_1_small.toTile() : Res.image.ui.menu.arrow_1.toTile(), parent));
		arrowA.smooth = true;
		addChild(arrowB = new Bitmap(AppConfig.isLayoutSmall() ? Res.image.ui.menu.arrow_2_small.toTile() : Res.image.ui.menu.arrow_2.toTile(), parent));
		arrowB.smooth = true;
		addChild(arrowC = new Bitmap(AppConfig.isLayoutSmall() ? Res.image.ui.menu.arrow_3_small.toTile() : Res.image.ui.menu.arrow_3.toTile(), parent));
		arrowC.smooth = true;

		animateHide();
	}

	function animateHide()
	{
		var animSpeed:Float = .7;

		TweenMax.to(arrowA, animSpeed, { alpha: .2, delay: 0, ease: Linear.easeNone });
		TweenMax.to(arrowB, animSpeed, { alpha: .2, delay: .3, ease: Linear.easeNone });
		TweenMax.to(arrowC, animSpeed, { alpha: .2, delay: .6, ease: Linear.easeNone });
		TweenMax.delayedCall(animSpeed + .3, animateShow);
	}

	function animateShow()
	{
		var animSpeed:Float = .7;

		TweenMax.to(arrowA, animSpeed, { alpha: 1, delay: 0, ease: Linear.easeNone });
		TweenMax.to(arrowB, animSpeed, { alpha: 1, delay: .3, ease: Linear.easeNone });
		TweenMax.to(arrowC, animSpeed, { alpha: 1, delay: .6, ease: Linear.easeNone });
		TweenMax.delayedCall(animSpeed + .3, animateHide);
	}
}