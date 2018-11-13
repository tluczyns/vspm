package tl.so {
	import flash.net.SharedObject;
	
	public class SharedObjectInstance implements ISharedObject {
		
		protected var so: SharedObject;
		
		public function SharedObjectInstance(nameSO: String): void {
			if (nameSO) this.so = SharedObject.getLocal(nameSO, "/");
		}
			
		public function setPropValue(propName: String, propValue: *): Boolean {
			var result: Boolean;
			if (this.so != null) {
				this.so.data[propName] = propValue;
				this.so.flush();
				result = true;
			} result = false;
			return result;
		}
		
		public function getPropValue(propName: String, defaultValue: * = undefined): * {
			return ((this.so != null) && (this.so.data[propName] != undefined)) ? this.so.data[propName] : defaultValue;
		}
		
		public function destroy(): void {
			this.so.flush();
			this.so.close();
			this.so = null;
		}
		
	}

}