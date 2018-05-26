package tl.types {
	import tl.types.Singleton;
	import flash.geom.Matrix;
	
	public class ObjectUtils extends Singleton {
		
		static public function cloneObj(objSrc: Object): Object {
			var objClone: Object = {};
			for (var prop: String in objSrc) {
				if (ObjectUtils.isObjClonable(objSrc[prop])) objClone[prop] = ObjectUtils.cloneObj(objSrc[prop]);
				else objClone[prop] = objSrc[prop];
			}
			return objClone;
		}
		
		static public function populateObj(objBase: Object, objPopulate: Object): Object {
			objBase = objBase || {};
			for (var prop: String in objPopulate) {
				if (ObjectUtils.isObjClonable(objPopulate[prop])) {
					if (objPopulate[prop] is Array) {
						if (!objBase[prop]) objBase[prop] = [];
						else if (!(objBase[prop] is Array)) objBase[prop] = [objBase[prop]];
						for (var i: int = objPopulate[prop].length - 1; i >= 0; i--) {
							if (objBase[prop].indexOf(objPopulate[prop][i]) == -1) objBase[prop].unshift(objPopulate[prop][i]);
						}
					} else objBase[prop] = ObjectUtils.populateObj(objBase[prop], objPopulate[prop]);
				} else objBase[prop] = objPopulate[prop];
				
			}
			return objBase;
		}
		
		static private function isObjClonable(obj: *): Boolean {
			return ((typeof(obj) == "object") && (!(obj is Class)) && (!(obj is Matrix)));
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