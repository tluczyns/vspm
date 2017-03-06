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
	
	public interface IViewSection {
		
		function init(): void;
		function show(): void;
		function hide(): void;
			
		function get x(): Number;
		function set x(value: Number): void;
		function get y(): Number;
		function set y(value: Number): void;
	}
	
}