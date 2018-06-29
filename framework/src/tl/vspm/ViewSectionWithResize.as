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
	import flash.events.Event;
	
	public class ViewSectionWithResize extends ViewSection {
		
		public function ViewSectionWithResize(description: DescriptionViewSection): void {
			super(description);
		}
		
		override public function init(): void {
			super.init();
			this.stage.addEventListener(Event.RESIZE, this.onStageResize);
			this.onStageResize(null);
		}
		
		protected function onStageResize(e: Event): void {
			throw new Error("onStageResize must be implemented");
		}
		
		override protected function hideComplete(): void {
			this.stage.removeEventListener(Event.RESIZE, this.onStageResize);			
			super.hideComplete();
		}
		
	}

}