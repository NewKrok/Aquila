package aquila.game;

import aquila.AppConfig;
import aquila.data.AnimationConfig;
import h2d.Anim;
import h2d.Sprite;

/**
 * ...
 * @author Krisztian Somoracz
 */
class BaseAnimationHolder extends Sprite
{
	var anim:Anim;

	public function makeAnimation(animationId:String, posX:Float = 0, posY:Float = 0):Anim
	{
		anim = AnimationConfig.getAnimation(animationId, this);
		anim.setScale(AppConfig.GAME_BITMAP_SCALE);
		anim.x = posX;
		anim.y = posY;

		return anim;
	}

	public function dispose():Void
	{
		anim.remove();
		anim = null;
	}
}