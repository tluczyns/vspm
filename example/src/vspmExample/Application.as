package vspmExample {
	import tl.vspm.ApplicationVSPM;
	import flash.text.Font;
	import tl.loader.Library;
	//import tl.vspm.ManagerSection;
	import tl.vspm.Metrics;
	import flash.system.Capabilities;
	
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
		
		override protected function createMetrics(): void {
			super.createMetrics();
			this.setDataForMetrics();
		}
		
		private function setDataForMetrics(): void {
			if (Metrics.vecMetrics) {
				for (var i: uint = 0; i < Metrics.vecMetrics.length; i++) {
					var metrics: Metrics = Metrics.vecMetrics[i];
					if ((metrics.type == Metrics.GA) || (metrics.type == Metrics.PIWIK)) {
						metrics.tracker.set(metrics.baseClassTracker["APP_VERSION"], "1.0.0.RC1");
						metrics.tracker.set(metrics.baseClassTracker["USER_AGENT_OVERRIDE"], Capabilities.os)
						metrics.tracker.set(metrics.baseClassTracker["DATA_SOURCE"], "appInDevelopmentMode");
					}
				}
			}
		}
		
	}
	
}