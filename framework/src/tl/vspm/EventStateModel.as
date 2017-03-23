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

	public class EventStateModel extends EventModel {

		public static const START_CHANGE_SECTION: String = "startChangeSection";
		public static const CHANGE_SECTION: String = "changeSection";
		public static const CHANGE_CURR_SECTION: String = "changeCurrSection";
		public static const CHANGE_PARAMETERS: String = "changeParameters";
		
		public function EventStateModel(type: String, data: * = null): void {
			super(type, data);
		}
		
	}

}