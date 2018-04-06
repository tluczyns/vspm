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
	import tl.types.Singleton;
	import flash.events.EventDispatcher;
	//import com.google.analytics.GATracker;
	//import tl.omniture.OmnitureTracker;
	import tl.types.ObjectUtils;

	public class StateModel extends Singleton {
		
		private static var dispatcher: EventDispatcher = new EventDispatcher();
		
		private static var _parameters: Object = {}
		
		public static function init(): void {
			if (!SWFAddress.hasEventListener(SWFAddressEvent.CHANGE))
				SWFAddress.addEventListener(SWFAddressEvent.CHANGE, StateModel.handleSWFAddress);
		}
		
		public static function addEventListener(type: String, func: Function, priority: int = 0): void {
			StateModel.dispatcher.addEventListener(type, func, false, priority);
		}
		
		public static function removeEventListener(type: String, func: Function): void {
			StateModel.dispatcher.removeEventListener(type, func);
		}
		
		public static function dispatchEvent(type: String, data: * = null): void {
			StateModel.dispatcher.dispatchEvent(new EventStateModel(type, data));
		}
		
		public static function get parameters(): Object { 
			return StateModel._parameters;
		}
		
		static public function trackPageview(indView: String, isForward: Boolean = true): void {
			for (var i: uint = 0; i < Metrics.vecMetrics.length; i++)
				Metrics.vecMetrics[i].trackView(indView, uint(isForward));
		}
		
		private static function handleSWFAddress(e: SWFAddressEvent): void {
			/*var currentSwfAddressValue: String = SWFAddress.getValue();
			if ((currentSwfAddressValue != StateModel.currentSwfAddressValue) || (ManagerSection.isForceReload)) {*/
			var oldParameters: Object = StateModel._parameters;
			StateModel._parameters = SWFAddress.getParametersObject();
			var currentSwfAddressPath: String = SWFAddress.getPath();
			var indSectionAlias: String = ManagerSection.joinIndSectionFromArrElement(ManagerSection.splitIndSectionFromStr(currentSwfAddressPath));
			var indSection: String;
			if ((LoaderXMLContentView.dictAliasIndToIndSection) && (LoaderXMLContentView.dictAliasIndToIndSection[indSectionAlias])) indSection = LoaderXMLContentView.dictAliasIndToIndSection[indSectionAlias];
			else indSection = indSectionAlias;
			
			if ((indSection != "") && (indSection != ManagerSection.currIndSection)) {
				var descriptionViewSection: DescriptionViewSection = ManagerSection.dictDescriptionViewSection[indSection];
				if (descriptionViewSection) {
					var contentViewSection: ContentViewSection = ContentViewSection(descriptionViewSection.content);
					var isForward: Boolean = !ManagerSection.isEqualsElementsIndSection(indSection, ManagerSection.currIndSection);
					if (!contentViewSection || (!uint(contentViewSection.isNotTrack) && (!uint(contentViewSection.isOnlyForwardTrack) || isForward)))
						StateModel.trackPageview(indSectionAlias, isForward);
				}
			}
			if ((indSection == "") && (ManagerSection.startIndSection != "")) SWFAddress.setValue(ManagerSection.startIndSection);
			else {
				//trace("oldIndSection:", ManagerSection.currIndSection, ", indSection:", indSection);
				//trace("oldParameters:", ObjectUtils.toString(oldParameters), ", StateModel._parameters:", ObjectUtils.toString(StateModel._parameters), !ObjectUtils.equals(oldParameters, StateModel._parameters))
				if (!ObjectUtils.equals(oldParameters, StateModel._parameters))
					StateModel.dispatchEvent(EventStateModel.CHANGE_PARAMETERS, {oldParameters: oldParameters, newParameters: StateModel._parameters, oldIndSection: ManagerSection.currIndSection, newIndSection: indSection});
				var newIndSection: String = ManagerSection.newIndSection ? ManagerSection.newIndSection : ManagerSection.currIndSection;
				if (newIndSection != indSection) {
					StateModel.dispatchEvent(EventStateModel.START_CHANGE_SECTION, {oldIndSection: ManagerSection.currIndSection, newIndSection: indSection});
				}
			}
		}
		
	}

}