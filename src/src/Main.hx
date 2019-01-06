package;

import aquila.AppConfig;
import aquila.Fonts;
import aquila.data.AnimationConfig;
import aquila.game.data.CrystalDatas;
import aquila.game.data.EnemiesData;
import aquila.game.data.FireModeDatas;
import aquila.game.data.SpaceshipConfigs;
import aquila.game.data.TileConfig;
import aquila.state.GameState;
import aquila.state.MenuState;
import haxe.Json;
import hpp.heaps.Base2dApp;
import hpp.heaps.Base2dStage.StageScaleMode;
import hpp.util.Language;
import hxd.Res;

class Main extends Base2dApp
{
	override function init()
	{
		super.init();

		/*switch (SaveUtil.data.applicationInfo.lang)
		{
			case "en": Language.setLang(Json.parse(Res.lang.lang_en.entry.getText()));
			case "hu": Language.setLang(Json.parse(Res.lang.lang_hu.entry.getText()));
			case _: Language.setLang(Json.parse(Res.lang.lang_en.entry.getText()));
		}*/
		Language.setLang(Json.parse(Res.lang.lang_en.entry.getText()));

		setDefaultAppSize(AppConfig.APP_WIDTH, AppConfig.APP_HEIGHT);
		stage.stageScaleMode = StageScaleMode.NO_SCALE;

		AnimationConfig.init();
		TileConfig.init();
		SpaceshipConfigs.init();
		EnemiesData.init();
		CrystalDatas.init();
		FireModeDatas.init();
		Fonts.init();

		changeState(GameState);
		//changeState(MenuState);
	}

	static function main()
	{
		Res.initEmbed();
		new Main();
	}

	override function onResize()
	{
		AppConfig.setLayoutSize(engine.width, engine.height);

		super.onResize();
	}
}