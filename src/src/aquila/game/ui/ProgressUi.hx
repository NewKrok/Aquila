package aquila.game.ui;

import com.greensock.TweenMax;
import com.greensock.easing.Back;
import h2d.Bitmap;
import h2d.Mask;
import h2d.Sprite;
import h2d.Tile;
import h2d.col.Bounds;
import hxd.Res;
import tink.state.Observable;

/**
 * ...
 * @author Krisztian Somoracz
 */
class ProgressUi extends Sprite
{
	var frameA:Bitmap;
	var frameB:Bitmap;
	var iconBack:Bitmap;
	var content:Sprite;
	var mask:Mask;

	var progressLine:Bitmap;
	var progressLineBack:Bitmap;

	var lastSavedLifePercent:Float;
	var bounds:Bounds = new Bounds();

	public function new(parent, value:Observable<Float>, maxValue:Float, color:UInt, icon:Tile, width:Float = 270, isRotated:Bool = false)
	{
		super(parent);

		bounds.x = 0;
		bounds.y = 0;
		bounds.width = width;
		bounds.height = 45;

		build(color, icon, width, isRotated);

		value.bind(function(v) {
			TweenMax.killTweensOf(progressLine);
			TweenMax.to(progressLine, .4, {scaleX: v / maxValue, onUpdate: function () {progressLine.scaleX = progressLine.scaleX;}});
		});
	}

	override public function getSize(?out:h2d.col.Bounds):Bounds return bounds;

	function build(color:UInt, icon:Tile, width:Float, isRotated:Bool)
	{
		mask = new Mask(cast bounds.width - 80, cast bounds.height - 15, this);
		mask.y = mask.height + 15;
		mask.width = 10;
		mask.x = bounds.width / 2 - mask.width * mask.scaleX / 2;

		content = new Sprite(mask);
		var back = new Bitmap(Tile.fromColor(0x6B6B6B, cast bounds.width + 100, cast bounds.height - 15), content);
		back.x = -50;

		iconBack = new Bitmap(Res.image.ui.game.ui_panel_icon_back.toTile(), content);
		iconBack.x = 15;
		iconBack.y = 0;

		var iconContainer = new Bitmap(icon, content);
		iconContainer.x = iconBack.x + iconBack.tile.width / 2 - icon.width / 2;
		iconContainer.y = iconBack.y + iconBack.tile.height / 2 - icon.height / 2;

		progressLineBack = new Bitmap(Tile.fromColor(0x2C2C2C, cast bounds.width - 150 + 4, cast mask.height / 2 + 4), content);

		progressLine = new Bitmap(Tile.fromColor(color, cast bounds.width - 150, cast mask.height / 2), content);
		progressLine.x = bounds.width - progressLine.tile.width - 100;
		progressLine.y = 8;
		progressLineBack.x = progressLine.x - 2;
		progressLineBack.y = progressLine.y - 2;

		if (isRotated)
		{
			content.rotation = -Math.PI;
			content.x = bounds.width - 80;
			content.y = content.getSize().height;
		}

		frameA = new Bitmap(Res.image.ui.game.life_frame_element.toTile(), this);
		frameA.x = width / 2 - frameA.tile.width;
		frameA.y = frameA.tile.height + 2;

		frameB = new Bitmap(Res.image.ui.game.life_frame_element.toTile(), this);
		frameB.tile.flipX();
		frameB.tile.dx = 0;
		frameB.x = width / 2;
		frameB.y = frameB.tile.height + 2;
	}

	public function show(delay:Float = 0)
	{
		var margin = 10;

		TweenMax.to(frameA, .5, {
			y: margin,
			delay: delay,
			ease: Back.easeOut,
			onUpdate: function () {frameA.x = frameA.x;}
		});

		TweenMax.to(frameB, .5, {
			y: margin,
			delay: delay,
			ease: Back.easeOut,
			onUpdate: function () {frameB.x = frameB.x;}
		});

		TweenMax.to(mask, .5, {
			y: 15,
			delay: delay,
			ease: Back.easeOut,
			onUpdate: function () {mask.x = mask.x;}
		});

		TweenMax.to(frameA, 1, {
			x: 0,
			delay: delay + .5,
			ease: Back.easeOut,
			onUpdate: function () {frameA.x = frameA.x;}
		});

		TweenMax.to(frameB, 1, {
			x: bounds.width - frameB.tile.width,
			delay: delay + .5,
			ease: Back.easeOut,
			onUpdate: function () {frameB.x = frameB.x;}
		});

		TweenMax.to(mask, 1, {
			width: bounds.width - 80,
			delay: delay + .5,
			ease: Back.easeOut,
			onUpdate: function () {mask.x = bounds.width / 2 - mask.width / 2;}
		});
	}
}