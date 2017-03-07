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

	public class EventModel extends Event implements IEventModel {

		private var _data: *;
		
		public function EventModel(type: String, data: * = null, bubbles: Boolean = false): void {
			super(type, bubbles);
			this._data = data;
		}
		
		public function get data(): Object {
			return this._data;
		}
		
		public override function clone(): Event { 
			return new EventModel(type, this._data, bubbles);
		}
		
		public override function toString():String { 
			return formatToString("EventLoaderContent", "_data", "type", "bubbles", "cancelable", "eventPhase"); 
		}
		
	}

}