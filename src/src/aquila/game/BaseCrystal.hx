package aquila.game;

import aquila.AppConfig;
import com.greensock.TweenMax;
import h2d.Layers;
import h2d.Tile;
import aquila.game.BaseGraphicsHolder;

/**
 * ...
 * @author Krisztian Somoracz
 */
class BaseCrystal extends BaseGraphicsHolder
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
		makeGraphic(crystalConfig.tile);

		TweenMax.to(this, .2 + Math.random() * .4, {
			x: x + Math.random() * 300 - 150,
			y: y + Math.random() * 300 - 150,
			rotation: Math.random() * Math.PI * 2
		});
	}

	public function update(delta:Float):Void
	{
		y += 2 * delta;
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