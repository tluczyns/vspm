package vspmExample {
	import tl.vspm.ContainerApplicationVSPM;
	import vspmExample.viewPopup.*;
	import vspmExample.viewSection.*;
	
	public class ContainerApplication extends ContainerApplicationVSPM {
		
		public function ContainerApplication(): void {
			ViewPopupHeader; ViewPopupWelcome;
			ViewSectionMain; ViewSectionSubpage;
			super();
		}
		
		/*override protected function createBg(): void {
			this.bg = new Bg();
			this.addChild(this.bg);
		}
		
		override protected function createFg(): void {
			this.fg = new Fg();
			this.addChild(this.fg);
		}*/
		

		
	}

}