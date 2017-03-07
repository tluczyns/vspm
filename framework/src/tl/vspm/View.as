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
	import caurina.transitions.Tweener;
	import flash.display.Sprite;
	
	public class View extends Sprite implements IViewSection {
		
		public var content: ContentView;
		public var description: DescriptionView;
		
		protected var isHideShow: uint;
		
		public function View(content: ContentView): void {
			this.content = content;
		}
		
		public function init(): void {
			//abstract: initialization
			this.alpha = 0;
		}
		
		protected function hideShow(isHideShow: uint): void {
			Tweener.addTween(this, {alpha: isHideShow, time: 0.3, transition: "linear", onComplete: [this.hideComplete, this.startAfterShow][isHideShow]});
		}
		
		public function show(): void {
			this.isHideShow = 1;
			this.hideShow(1);
		}
		
		protected function startAfterShow(): void {
			//abstract: fe. additional animation, adding listeners and mouse events
		}
		
		protected function stopBeforeHide(): void {
			//abstract: fe. removing listeners and mouse events
		}
		
		public function hide(): void {
			this.stopBeforeHide();
			this.isHideShow = 0;
			this.hideShow(0);
		}
		
		protected function hideComplete(): void {
			//abstract
		}
		
	}

}