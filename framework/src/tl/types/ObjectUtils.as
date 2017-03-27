package tl.types {
	import tl.types.Singleton;
	
	public class ObjectUtils extends Singleton {
		
		static public function cloneObj(objSrc: Object): Object {
			var objClone: Object = {};
			for (var prop: String in objSrc) {
				if (typeof(objSrc[prop]) == "object") objClone[prop] = ObjectUtils.cloneObj(objSrc[prop]);
				else objClone[prop] = objSrc[prop];
			}
			return objClone;
		}
		
		static public function populateObj(objSrc: Object, objPopulate: Object): Object {
			for (var prop: String in objSrc) {
				if (typeof(objSrc[prop]) == "object") {
					if (objSrc[prop] is Array) {
						if (!objPopulate[prop]) objPopulate[prop] = [];
						else if (!(objPopulate[prop] is Array)) objPopulate[prop] = [objPopulate[prop]];
						for (var i: uint = 0; i < objSrc[prop].length; i++) {
							if (objPopulate[prop].indexOf(objSrc[prop][i]) == -1) objPopulate[prop].push(objSrc[prop][i]);
						}
					} else objPopulate[prop] = ObjectUtils.populateObj(objSrc[prop], objPopulate[prop] || {});
				} else objPopulate[prop] = objSrc[prop];
				
			}
			return objPopulate;
		}
		
		static public function equals(obj1: Object, obj2: Object): Boolean {
			var prop: String;
			var isEquals: Boolean;
			for (prop in obj1)
				isEquals = isEquals && (!((obj1[prop] == undefined) || (!ObjectUtils.equals(obj1[prop], obj2[prop]))));
			for (prop in obj2)
				isEquals = isEquals && (!((obj2[prop] == undefined) || (!ObjectUtils.equals(obj1[prop], obj2[prop]))));
			return isEquals;
		}
		
		static public function toString(obj: Object): String {
			var str: String = "{";
			for (var prop: String in obj) {
				str += (prop + ": " + obj[prop] + ",");
			}
			if (str.length > 1) str = str.substr(0, str.length - 1);
			str += "}";
			return str
		}
		
	}
	
}