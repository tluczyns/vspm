package tl.loader {
	import tl.types.Singleton;
	import flash.display.DisplayObject;
	import flash.display.MovieClip;
	import flash.media.Sound;
	import flash.display.BitmapData;
	import flash.system.ApplicationDomain;
	import flash.display.Bitmap;
	
	public class Library extends Singleton {
		
		private static var arrSwf: Array = [];
		
		public function Library(): void {}
		
		public static function addSwf(swf: DisplayObject): void {
			Library.arrSwf.push(swf);
		}
		
		public static function getClassDefinition(nameClass: String): Class {
			var i: uint = 0;
			var classDef: Class;
			while ((i < Library.arrSwf.length) && (classDef == null)) {
				try {
					classDef = Class(DisplayObject(Library.arrSwf[i]).loaderInfo.applicationDomain.getDefinition(nameClass));
				} catch (e:Error) { }
				i++;
			}
			return classDef;
		}
		
		public static function getMovieClip(nameClass: String, ... params): * {
			var classDef: Class = Library.getClassDefinition(nameClass);
			var mc: *;
			if (classDef) {
				try {
					if (params.length) mc = new classDef(params);
					else mc = new classDef();
					if (!((mc is MovieClip) || (mc is Sound)))
						mc = null;
				} catch (e: Error) {
					trace("Element |",nameClass,"| is not a movieclip.")
				}
			} else trace("Element |", nameClass, "| not exists in library.")
			return mc;
		}
		
		public static function getBitmapData(nameClass: String): BitmapData {
			var classDef: Class = Library.getClassDefinition(nameClass);
			var bmpData: BitmapData;
			if (classDef) {
				try {
					bmpData = new classDef(0, 0);
				} catch (e: Error) {
					trace("Element |",nameClass,"| is not a BitmapData.")
				}
			} else trace("Element |",nameClass,"| not exists in library.")
			return bmpData;
		}
		
		public static function getBitmap(nameClass: String): Bitmap {
			var bmpData: BitmapData = Library.getBitmapData(nameClass);
			if (bmpData) return new Bitmap(bmpData, "auto", true);
			else return null;
		}
		
		public static function getDisplayObject(nameClass: String): DisplayObject {
			var dspObj: DisplayObject = Library.getMovieClip(nameClass);
			if (!dspObj) dspObj = Library.getBitmap(nameClass);
			return dspObj;
		}
		
	}
}