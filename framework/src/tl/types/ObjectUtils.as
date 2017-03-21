package tl.types {
	import tl.types.Singleton;
	
	public class ObjectUtils extends Singleton{
		
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
		
		static public function compare(obj1: Object, obj2: Object): Boolean {
			var count: uint = 0;
			for (var s: String in obj1) {
				count++;
				if (obj2[s] == undefined) return false;
				if (!ObjectUtils.compare(obj1[s], obj2[s])) return false;
			}
			if ((count == 0) && (obj1 != obj2)) return false;
			return true;
		}
		
	}
	
}