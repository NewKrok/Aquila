package aquila.menu.view;

import aquila.AppConfig;
import aquila.Fonts;
import com.greensock.TweenMax;
import h2d.Bitmap;
import h2d.Interactive;
import h2d.Layers;
import h2d.Text;
import aquila.menu.view.AnimatedArrows;
import hxd.Res;
import hxd.Stage;

/**
 * ...
 * @author Krisztian Somoracz
 */
class WelcomeButton extends Layers
{
	var onClick:Void->Void;

	var lineTop:Bitmap;
	var lineBottom:Bitmap;
	var light:Bitmap;

	var animatedArrowsLeft:AnimatedArrows;
	var animatedArrowsRight:AnimatedArrows;

	var interactive:Interactive;

	var tf:h2d.Text;

	public function new(parent:Layers, onClick:Void->Void = null)
	{
		super(parent);
		this.onClick = onClick;
	}

	function onMouseOver(_)
	{
		TweenMax.killTweensOf(light);
		TweenMax.to(light, .5, { alpha: .7 });
	}

	function onMouseOut(_)
	{
		TweenMax.killTweensOf(light);
		TweenMax.to(light, .5, { alpha: .2 });
		TweenMax.to(light, 2, { alpha: .5, repeat: -1, yoyo: true }).delay(.5);
	}

	public function onStageScale():Void
	{
		if ( AppConfig.shouldChangeLayoutSize() )
		{
			this.removeElements();
			this.resetLayout();
		}

		this.lineBottom.y = light.y + light.tile.height;
		this.light.x = lineTop.tile.width / 2 - light.tile.width / 2;
		this.tf.x = light.x + 2;
		this.tf.y = light.y + this.light.tile.height / 2 - this.tf.textHeight / 2 + 5;

		animatedArrowsLeft.x = light.x;
		animatedArrowsLeft.y = light.y;
		animatedArrowsRight.scaleX = -1;
		animatedArrowsRight.x = light.x + light.tile.width;
		animatedArrowsRight.y = light.y;
	}

	private function removeElements():Void
	{
		this.removeChild( this.tf );
		this.removeChild( this.light );
		this.removeChild( this.lineTop );
		this.removeChild( this.lineBottom );
		this.removeChild( this.interactive );
		this.removeChild( this.animatedArrowsLeft );
		this.removeChild( this.animatedArrowsRight );
	}

	private function resetLayout():Void
	{
		addChild(light = new Bitmap( AppConfig.isLayoutSmall() ? Res.image.ui.menu.button_background_small.toTile() : Res.image.ui.menu.button_background.toTile(), this));

		this.animatedArrowsLeft  = new AnimatedArrows(this);
		this.animatedArrowsRight = new AnimatedArrows(this);

		this.interactive = new Interactive( this.light.tile.width, this.light.tile.height, this.light);
		this.interactive.cursor = Button;
		this.interactive.onOver = onMouseOver;
		this.interactive.onOut = onMouseOut;
		this.interactive.onClick = function(_){ onClick(); };

		TweenMax.to(this.light, 2, { alpha: .5, repeat: -1, yoyo: true });

		this.tf = new Text( AppConfig.isLayoutSmall() ? Fonts.DEFAULT_S : Fonts.DEFAULT_M, this);
		this.tf.text = "ENTER FIGHTER DOCK";
		this.tf.maxWidth = this.light.tile.width;
		this.tf.textAlign = Align.Center;

		this.addChild(this.lineTop = new Bitmap( AppConfig.isLayoutSmall() ? Res.image.ui.menu.fade_line_small.toTile() : Res.image.ui.menu.fade_line.toTile(), this));
		this.addChild(this.lineBottom = new Bitmap( AppConfig.isLayoutSmall() ? Res.image.ui.menu.fade_line_small.toTile() : Res.image.ui.menu.fade_line.toTile(), this));
	}
}