package vspmExample {
	import tl.types.Singleton;
	
	public class Config extends Singleton {
		
		static public var HOST: String;
		static public const ADD_TO_PATH_SWF: String = ""; //"swf/"
		
		static public const NAME_SECTION_MAIN: String = "main";
		static public const NAME_SECTION_SUBPAGE: String = NAME_SECTION_MAIN + "/subpage";
		static public const NAME_SECTION_TILE: String = NAME_SECTION_SUBPAGE + "/tile";
		static public const NAME_PARAMETER_WELCOME: String = "ivw";
		
		static public const TIME_HIDE_SHOW: Number = 0.6;
		
		static public var WIDTH: Number;
		static public var HEIGHT: Number;
		
		static public const FONT: String = "Verdana";
		
	}
}