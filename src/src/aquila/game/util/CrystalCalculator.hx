package aquila.game.util;

import h2d.Layers;
import aquila.game.BaseCrystal;
import aquila.game.data.CrystalDatas;

/**
 * ...
 * @author Krisztian Somoracz
 */
class CrystalCalculator
{
	public static function getCrystalsFromValue(crystalTotalValue:UInt, parent:Layers, onRemoveRequest:BaseCrystal->Void):Array<BaseCrystal>
	{
		var result:Array<BaseCrystal> = [];

		var index:Int = CrystalDatas.datas.length - 1;
		for (i in 0...index + 1)
		{
			var count:UInt = Math.floor(crystalTotalValue / CrystalDatas.datas[index].value);
			for (i in 0...count) result.push(new BaseCrystal(parent, onRemoveRequest, CrystalDatas.datas[index]));

			crystalTotalValue -= count * CrystalDatas.datas[index].value;
			index--;
		}

		return result;
	}
}