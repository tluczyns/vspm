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
	import tl.types.DictionaryExt;
	import tl.types.ObjectUtils;
	
	public class DescriptionView extends Object {
		
		public var ind: String;
		public var classView: Class;
		public var content: ContentView;
		public var x: Number;
		public var y: Number;
		public var containerView: DisplayObjectContainer;
		public var view: View;
		
		public function DescriptionView(ind: String, classView: Class, content: ContentView, x: Number = 0, y: Number = 0, containerView: DisplayObjectContainer = null): void {
			this.ind = ind;
			this.classView = classView;
			this.content = content;
			this.x = x;
			this.y = y;
			this.containerView = containerView;
			this.view = null;
			this.addToDictInManager();
		}
		
		protected function getDictDescriptionViewInManager(): Dictionary { //DictionaryExt
			throw new Error("getDictDescriptionViewFromManager must be implemented");
		}
		
		private function addToDictInManager(): void {
			var dictDescriptionViewInManager: Dictionary = this.getDictDescriptionViewInManager();  //DictionaryExt
			if (dictDescriptionViewInManager[this.ind]) DescriptionView(dictDescriptionViewInManager[this.ind]).addAdditionalContent(this);
			else dictDescriptionViewInManager[this.ind] = this;
		}
		
		internal function addAdditionalContent(descriptionView: DescriptionView): void {
			if (!this.classView) this.classView = descriptionView.classView;
			this.content = ContentView(ObjectUtils.populateObj(this.content, descriptionView.content));
		}
		
		protected function getDefaultContainerView(): DisplayObjectContainer {
			throw new Error("getDefaultContainerView must be implemented");
		}
		
		public function getContainerView(): DisplayObjectContainer {
			return (this.containerView != null) ? this.containerView : this.getDefaultContainerView();
		}
		
		public function createView(): void {
			var containerView: DisplayObjectContainer = this.getContainerView();
			if ((this.view == null) && (this.classView)) {
				this.view = new this.classView(this);
				this.view.x = this.x;
				this.view.y = this.y;
				containerView.addChild(this.view);
				containerView.setChildIndex(this.view, containerView.numChildren - 1);
				this.view.init();
			}
		}
		
		public function removeView(): void {
			var containerView: DisplayObjectContainer = this.getContainerView();
			if (this.view != null) {
				containerView.removeChild(this.view);
				this.view = null;
			}
		}
		
	}

}