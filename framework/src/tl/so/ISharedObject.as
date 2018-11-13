package tl.so {
	
	public interface ISharedObject {
		
		function setPropValue(propName: String, propValue: * ): Boolean;
		
		function getPropValue(propName: String, defaultValue: * = undefined): * ;
		
		function destroy(): void;
		
	}
	
}