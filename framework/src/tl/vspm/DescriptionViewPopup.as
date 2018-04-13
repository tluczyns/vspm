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

	public class DescriptionViewPopup extends DescriptionView {
		
		public var objParamsWithValuesToShow: Object;
		
		public function DescriptionViewPopup(ind: String, nameClass: Class, content: ContentViewPopup, objParamsWithValuesToShow: Object, x: Number = 0, y: Number = 0, containerView: DisplayObjectContainer = null): void {
			this.objParamsWithValuesToShow = objParamsWithValuesToShow || {};
			super(ind, nameClass, content, x, y, containerView); 
		}
		
		override protected function getDictDescriptionViewInManager(): Dictionary { //DictionaryExt
			return ManagerPopup.dictDescriptionViewPopup;
		}
		
		private function isHideShowForParameters(parameters: Object): uint {
			var isHideShow: uint = 1;
			for (var param: String in this.objParamsWithValuesToShow) {
				var valueParam: * = this.objParamsWithValuesToShow[param];
				var classValueParam: Class;
				if (valueParam == undefined) valueParam = 0;
				if ((!isNaN(Number(valueParam))) && (valueParam != "")) classValueParam = Number;
				else classValueParam = String;
				var valueParamModel: * = parameters[param];
				if (valueParamModel == undefined) valueParamModel = 0;
				if (classValueParam(valueParamModel) != classValueParam(valueParam)) isHideShow = 0;
			}
			return isHideShow;
		}
		
		internal function checkAndHideShowView(oldParameters: Object): void {
			var isHideShowForOldParameters: uint = this.isHideShowForParameters(oldParameters);
			var isHideShow: uint = this.isHideShowForParameters(StateModel.parameters);
			if (isHideShow != isHideShowForOldParameters) {
				if (isHideShow == 0) { 
					if (this.view) this.view.hide();
				} else if (isHideShow == 1) this.createView();
			}
		}
		
		override protected function getDefaultContainerView(): DisplayObjectContainer {
			return ManagerPopup.dspObjContainerPopup;
		}
		
		override public function createView(): void {
			if (this.view == null) super.createView();
			if (this.view) {
				this.trackPageView();
				this.view.show();
			}
		}
		
		private function trackPageView(): void {
			if (!uint(this.content.isNotTrack))
				StateModel.trackPageview("popup_" + this.ind);
		}
		
	}

}