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
	
	public class ViewSection extends View {
		
		public var num: int;
		
		public function ViewSection(content: ContentViewSection, num: int): void {
			super(content);
			this.num = num;
		}
		
		override protected function startAfterShow(): void {
			ManagerSection.startSection();
		}
		
		override protected function hideComplete(): void {
			super.hideComplete();
			ManagerSection.finishStopSection(DescriptionViewSection(this.description));
		}
		
	}

}