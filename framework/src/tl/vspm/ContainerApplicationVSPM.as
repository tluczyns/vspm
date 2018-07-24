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
	import flash.display.Sprite;
	
	public class ContainerApplicationVSPM extends Sprite {
		
		protected var bg: Sprite;
		public var containerViewSection: Sprite;
		public var containerViewPopup: Sprite;
		public var fg: Sprite;
		
		public function ContainerApplicationVSPM(): void {
			this.createBg();
			this.createContainerViewSection();
			this.createContainerViewPopup();
			this.createFg();
		}
		
		protected function createBg(): void {
			this.bg = new classBg();
			this.addChild(this.bg);
		}
		
		protected function get classBg(): Class {
			return Sprite;
		}
		
		protected function deleteBg(): void {
			this.removeChild(this.bg);
			this.bg = null;
		}
		
		protected function get classContainerViewSection(): Class {
			return Sprite;
		}
		
		protected function createContainerViewSection(): void {
			this.containerViewSection = new classContainerViewSection();
			this.addChild(this.containerViewSection);
		}
		
		protected function get classContainerViewPopup(): Class {
			return Sprite;
		}
		
		protected function deleteContainerViewSection(): void {
			this.removeChild(this.containerViewSection);
			this.containerViewSection = null;
		}
		
		protected function createContainerViewPopup(): void {
			this.containerViewPopup = new classContainerViewPopup();
			this.addChild(this.containerViewPopup);
		}
		
		protected function get classFg(): Class {
			return Sprite;
		}
		
		protected function deleteContainerViewPopup(): void {
			this.removeChild(this.containerViewPopup);
			this.containerViewPopup = null;
		}
		
		protected function createFg(): void {
			this.fg = new classFg();
			this.addChild(this.fg);
		}
		
		protected function deleteFg(): void {
			this.removeChild(this.fg);
			this.fg = null;
		}
		
		public function destroy(): void {
			this.deleteFg();
			this.deleteContainerViewPopup();
			this.deleteContainerViewSection();
			this.deleteBg();
		}
		
	}

}