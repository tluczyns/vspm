package tl.types {
	import tl.types.DictionaryExt;
	import flash.events.IEventDispatcher;
	import flash.utils.Dictionary;
	import com.adobe.crypto.MD5;
	import tl.other.Tricks;
	import flash.events.EventDispatcher;
	import flash.events.Event;
	import tl.vspm.EventModel;
	import flash.utils.flash_proxy;
	
	use namespace flash_proxy;
	
	public dynamic class DictEventDispatcher extends DictionaryExt implements IEventDispatcher {
		  
		private var _dictDescriptionEventListener: Dictionary;
		
		public function DictEventDispatcher(): void {
			super();
			this._dictDescriptionEventListener = new Dictionary();
		}
		
		public function addEventListener(type: String, func: Function, useCapture:Boolean=false, priority:int=0, useWeakReference:Boolean=false): void {
			this._dictDescriptionEventListener[MD5.hash(type + Tricks.getFunctionName2(func))] = new DescriptionEventListener(type, func, priority);
			for each (var dispatcher: EventDispatcher in this) {
				dispatcher.addEventListener(type, func, false, priority);
			}
		}
		
		public function removeEventListener(type: String, func: Function, useCapture:Boolean=false): void {
			delete this._dictDescriptionEventListener[MD5.hash(type + func.prototype.toString())];
			for each (var dispatcher: EventDispatcher in this) {
				dispatcher.removeEventListener(type, func);
			}
		}
		
		public function dispatchEvent(event: Event): Boolean {
			for each (var dispatcher: EventDispatcher in this)
				dispatcher.dispatchEvent(event);
			return true;
		}
		
		//if name == "" then dispatch on all dispatchers
		public function dispatchEventModel(type: String, data: * = null, name: * = null): void {
			if (name) {
				if  (this[name]) EventDispatcher(this[name]).dispatchEvent(new EventModel(type, data));
			} else {
				for each (var dispatcher: EventDispatcher in this)
					dispatcher.dispatchEvent(new EventModel(type, data));
			}
		}
		
		public function hasEventListener (type:String) : Boolean {
			//to do
			return false;
		}
		
		public function willTrigger (type:String) : Boolean {
			//to do
			return false;
		}
		
		override flash_proxy function deleteProperty (name: *): Boolean {//(name: String)
			var value: EventDispatcher = this[name];
			if (value) {
				for each (var descriptionEventListener: DescriptionEventListener in this._dictDescriptionEventListener)
					value.removeEventListener(descriptionEventListener.type, descriptionEventListener.func);
			}
			return super.deleteProperty(name);
		}
		
		override flash_proxy function setProperty(name: * , value: *): void {//(name: String , value: EventDispatcher): void {
			if (value == null) delete this[value];
			else {
				for each (var descriptionEventListener: DescriptionEventListener in this._dictDescriptionEventListener)
					value.addEventListener(descriptionEventListener.type, descriptionEventListener.func, false, descriptionEventListener.priority);
			}
			super.setProperty(name, value);
		}
		
		override flash_proxy function nextValue(index: int): * {
			return this.dictionary[this.nextName(index)];
		}
		
	}
	
}

class DescriptionEventListener extends Object {
	
	public var type: String;
	public var func: Function;
	public var priority: int;
	
	public function DescriptionEventListener(type: String, func: Function, priority: int): void {
		this.type = type;
		this.func = func;
		this.priority = priority;
	}
	
}