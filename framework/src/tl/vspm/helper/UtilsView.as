package tl.vspm.helper {
	import mx.core.Singleton;
	import tl.vspm.DescriptionViewSection;
	import tl.vspm.ManagerSection;
	import tl.vspm.LoaderXMLContentView;
	
	public class UtilsView extends Singleton {
		
		static public function getTimeTMaxHideShowFromCurrentToTargetViewSection(targetIndSection: String): Number {
			var totalTime: Number = 0;
			var descriptionViewSection: DescriptionViewSection = ManagerSection.getCurrentDescriptionViewSection();
			while ((descriptionViewSection.ind != targetIndSection) && (descriptionViewSection.ind != "")) {
				if (descriptionViewSection.view) totalTime += descriptionViewSection.view.tMaxHideShow.totalTime();
				descriptionViewSection = DescriptionViewSection(LoaderXMLContentView.dictIndViewSectionToDescriptionParentViewSection[descriptionViewSection.ind]);
			}
			return totalTime;
		}
		
	}

}