package tl.types {
	import flash.utils.Proxy;
	import flash.utils.Dictionary;
	import flash.utils.flash_proxy;
	
	public dynamic class DictionaryExt extends Proxy {
		
		private var funcSort: Function;
		public var dictionary: Dictionary;
		protected var _arrNameProp: Array;
		
		public function DictionaryExt(funcSort: Function = null): void {
			this.dictionary = new Dictionary();
			this._arrNameProp = new Array();
			this.funcSort = funcSort;
		}
		
		override flash_proxy function getProperty(name: *): * {
			return this.dictionary[name];
		}
		
		override flash_proxy function setProperty(name: *, value: *): void {
			if ((value) && (!this.dictionary[name])) this._arrNameProp.push(name);
			else if ((!value) && (this.dictionary[name])) this._arrNameProp.splice(this._arrNameProp.indexOf(name), 1);
			if (this.funcSort != null) this._arrNameProp.sort(this.funcSort)
			this.dictionary[name] = value;
		}
		
		override flash_proxy function callProperty(name:*, ...rest): * {
			return name.toString();
		}
		
		//klasa DictionaryExt (w przeciwieństwie do klasy Dictionary) w pętli for..in wyświetla elementy w kolejności takiej jakiej zostały dodane do słownika (a w klasie Dictionary jest losowa kolejność)
		override flash_proxy function nextNameIndex(index: int) : int {
			if (index < this._arrNameProp.length) return index + 1;
			else return 0;
		}
		
		override flash_proxy function nextName(index:int) : String {
			return this._arrNameProp[index - 1];
		}
		
		override flash_proxy function nextValue (index:int) : * {
			return this[this._arrNameProp[index - 1]];
		}
		
		public function get length(): uint {
			return this._arrNameProp.length;
		}
		
	}
	
}