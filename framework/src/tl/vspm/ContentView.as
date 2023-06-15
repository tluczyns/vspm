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
	import tl.loader.URLLoaderExt;

	public dynamic class ContentView extends Object {
		
		public function ContentView(xmlContent: XML): void {
			if (xmlContent) {
				var objContent: Object = URLLoaderExt.parseXMLToObject(xmlContent);
				for (var i: String in objContent) {
					this[i] = objContent[i];
				}
			}
		}
		
		public function set title(value: *): void {
			if (!(value is String)) value = value.text;
			this.label = value;
		}
		
		public function get title(): * {
			return this.name || this.label || "";
		}
		
	}

}