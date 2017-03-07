package vspmExample {
	import flash.text.Font;
	import tl.vspm.ApplicationVSPM;
	import tl.loader.Library;
	//import tl.vspm.ManagerSection;
	
	public class Application extends ApplicationVSPM {
		
		public function Application(): void {
			ContainerApplication;
			super();
		}
		
		override protected function registerFonts(): void {
			Font.registerFont(Library.getClassDefinition("vspmExample.font.Verdana"));
		}
		
		override protected function initViews(startIndSection: String = ""): void {
			//ManagerSection.isEngagingParallelViewSections = true;
			super.initViews(Config.NAME_SECTION_SUBPAGE + "0" + "?" + Config.NAME_PARAMETER_WELCOME + "=" + String(1)); 
		}
		
	}
	
}