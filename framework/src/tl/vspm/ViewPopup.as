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
	
	public class ViewPopup extends View {
		
		public function ViewPopup(description: DescriptionView): void {
			super(description);
		}
		
		override protected function hideComplete(): void {
			super.hideComplete();
			this.description.removeView();
		}
		
	}

}