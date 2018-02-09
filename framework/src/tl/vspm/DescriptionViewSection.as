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
	import flash.display.DisplayObjectContainer;
	import flash.utils.Dictionary;
	//import tl.types.DictionaryExt;

	public class DescriptionViewSection extends DescriptionView {
		
		public var indBase: String;
		public var num: uint;
		public var parent: DescriptionViewSection;
		public var isEngaged: Boolean = false;
		
		public function DescriptionViewSection(ind: String, nameClass: Class, content: ContentViewSection, num: int, parent: DescriptionViewSection = null, x: Number = 0, y: Number = 0, container: DisplayObjectContainer = null): void {
			super(ind + ((num == -1) ? "" : String(num)), nameClass, content, x, y, container);
			this.indBase = ind;
			this.num = (num == -1) ? 0 : num;
			this.parent = parent;
		}
		
		override protected function getDictDescriptionViewInManager(): Dictionary { //DictionaryExt
			return ManagerSection.dictDescriptionViewSection;
		}
		
		override protected function getDefaultContainerView(): DisplayObjectContainer {
			return ManagerSection.dspObjContainerSection;
		}
		
	}

}