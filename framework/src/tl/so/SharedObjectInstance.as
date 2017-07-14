package tl.so {
	import flash.net.SharedObject;
	
	public class SharedObjectInstance extends Object {
		
		protected var so: SharedObject;
		
		public function SharedObjectInstance(soName: String): void {
			if (soName) this.so = SharedObject.getLocal(soName, "/");
		}
			
		public function setPropValue(propName: String, propValue: *): Boolean {
			if (this.so != null) {
				this.so.data[propName] = propValue;
				this.so.flush();
				return true;
			} return false;
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