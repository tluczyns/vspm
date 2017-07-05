package tl.utils {

	public class FunctionCallback extends Object {
		
		public var func: Function;
		public var scope: Object;
		public var params: Array;
		
		public function FunctionCallback(func: Function, scope: Object, params: Array = null) {
			this.func = func;
			this.scope = scope;
			this.params = params;
		}
		
		public function call(params: Array = null): void {
			this.func.apply(this.scope, params || this.params);
		}
		
	}

}