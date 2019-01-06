package aquila.game;

import aquila.AppConfig;
import com.greensock.TweenMax;
import h2d.Layers;
import h2d.Tile;
import aquila.game.BaseBitmapHolder;
import hpp.heaps.HppG;

/**
 * ...
 * @author Krisztian Somoracz
 */
class BaseCrystal extends BaseBitmapHolder
{
	public var crystalConfig(default, null):CrystalConfig;

	var onRemoveRequest:BaseCrystal->Void;

	var tile:Tile;

	public function new(parent:Layers, onRemoveRequest:BaseCrystal->Void, crystalConfig:CrystalConfig)
	{
		super(parent);

		this.onRemoveRequest = onRemoveRequest;
		this.crystalConfig = crystalConfig;
	}

	public function init():Void
	{
		makeBitmap(crystalConfig.tile);

		TweenMax.to(this, .2 + Math.random() * .4, {
			x: Math.max(Math.min(x + Math.random() * 300 - 150, HppG.stage2d.width - 20), 20),
			y: y + Math.random() * 300 - 150,
			rotation: Math.random() * Math.PI * 2
		});
	}

	public function update(delta:Float):Void
	{
		y += crystalConfig.speed * delta;
		if (y > AppConfig.APP_HEIGHT) onRemoveRequest(this);
	}

	public function dispose():Void
	{
		TweenMax.killTweensOf(this);
	}
}

typedef CrystalConfig = {
	var value:UInt;
	var score:UInt;
	var speed:Float;
	var tile:Tile;
}