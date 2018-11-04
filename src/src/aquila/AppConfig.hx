package aquila;

/**
 * ...
 * @author Krisztian Somoracz
 */
class AppConfig
{
	public static inline var APP_WIDTH:Int = 1136;
	public static inline var APP_HEIGHT:Int = 640;

	public static inline var APP_HALF_WIDTH:Int = cast APP_WIDTH / 2;
	public static inline var APP_HALF_HEIGHT:Int = cast APP_HEIGHT / 2;

	public static inline var GAME_BITMAP_SCALE:Float = 1;

	public static inline var BACKGROUND_ORIGIN_WIDTH:Int  = 3072;
	public static inline var BACKGROUND_ORIGIN_HEIGTH:Int = 1920;

	// Below this width in px considered the application as small.
	private static inline var APP_SMALL_DESIGN_FROM_WIDTH:Int = 1800;

	private static var _actualLayoutSmall:Bool = false;
	private static var _changeLayoutSize:Bool  = true;

	public static var _engineWidth:Float;
	public static var _engineHeight:Float;

	public static var _backgroundWidth:Int;
	public static var _backgroundHeight:Int;

	private static var _backgroundResizeMarkers = [1024,1160,1280,1366,1600,1920,2200,2400,2560];

	// First initialization run.
	private static var init:Bool = true;

	/*
	 * changeLayoutSize  - Whenever needs to change the layout from small to large or large to small.
	 * actualLayoutSmall - Is the actual size is small or not.
	 */
	public static function setLayoutSize( engineWidth:Float, engineHeight:Float )
	{
		_engineWidth  = engineWidth;
		_engineHeight = engineHeight;

		if ( engineWidth < APP_SMALL_DESIGN_FROM_WIDTH )
		{
			_changeLayoutSize 	= _actualLayoutSmall != true || init ? true : false;
			_actualLayoutSmall  = true;
		}
		else
		{
			_changeLayoutSize 	= _actualLayoutSmall != false || init ? true : false;
			_actualLayoutSmall  = false;
		}

		init = true;

		shouldBackgroundResize();
	}

	private static function shouldBackgroundResize()
	{
		for ( forcedWidth in _backgroundResizeMarkers )
		{
			if ( _engineWidth <= forcedWidth )
			{
				calcluateBackgroundSize( forcedWidth );
				break;
			}
		}
	}

	private static function calcluateBackgroundSize( forcedWidth:Int )
	{
		_backgroundWidth  = forcedWidth;
		_backgroundHeight = Math.round( ( BACKGROUND_ORIGIN_HEIGTH / BACKGROUND_ORIGIN_WIDTH ) * forcedWidth );
	}

	public static function shouldChangeLayoutSize():Bool
	{
		return _changeLayoutSize;
	}

	public static function isLayoutSmall():Bool
	{
		return _actualLayoutSmall;
	}
}