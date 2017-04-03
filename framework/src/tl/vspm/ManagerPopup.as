/**
 * View Section and Popup Manager (VSPM)  <https://github.com/tluczyns/vspm>
 * Frontend multilevel subpage manager developed according to MVC pattern.
 * VSPM is (c) 2009-2017 Tomasz Luczynski
 * Licensed under MIT License
 *
 * @author		Tomasz Luczynski <tluczyns@gmail.com> <http://www.programuje.pl>
 * @version		1.2
 */
package tl.vspm {
	import tl.types.Singleton;
	import flash.utils.Dictionary;
	//import tl.types.DictionaryExt;
	import flash.display.DisplayObjectContainer;

	public class ManagerPopup extends Singleton {
		
		//static private var _dictDescriptionViewPopup: DictionaryExt = new DictionaryExt();
		static private var _dictDescriptionViewPopup: Dictionary = new Dictionary();
		static public var dspObjContainerPopup: DisplayObjectContainer;
		
		static public function init(dspObjContainerPopup: DisplayObjectContainer): void {
			ManagerPopup.dspObjContainerPopup = dspObjContainerPopup;
			StateModel.addEventListener(EventStateModel.CHANGE_PARAMETERS, ManagerPopup.checkAndHideOrShowPopupsOnParametersChange);
		}
		
		static private function checkAndHideOrShowPopupsOnParametersChange(e: EventStateModel):void {
			for (var ind: String in ManagerPopup._dictDescriptionViewPopup) {
				var descriptionViewPopup: DescriptionViewPopup = ManagerPopup._dictDescriptionViewPopup[ind];
				descriptionViewPopup.checkAndHideShowView(e.data.oldParameters);
			}
		}
		
		static public function get dictDescriptionViewPopup(): Dictionary { //DictionaryExt
			return ManagerPopup._dictDescriptionViewPopup;
		}
		
	}
	
}