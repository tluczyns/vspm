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
	
	public class ViewSectionEmpty extends ViewSection {
		
		public function ViewSectionEmpty(description: DescriptionViewSection): void {
			super(description);
		}
		
		override public function init(): void {
			
		}
		
		override protected function hideShow(isHideShow: uint): void {
			if (isHideShow == 0) this.hideComplete();
			else if (isHideShow == 1) this.startAfterShow();
		}
		
		override protected function startAfterShow(): void {
			
			super.startAfterShow();
		}
			
		override protected function stopBeforeHide(): void {
			
		}
		
		override protected function hideComplete(): void {
			
			super.hideComplete();
		}
		
	}

}