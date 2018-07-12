package tl.loader {
	import flash.events.EventDispatcher;
	import tl.utils.FunctionCallback;
	import com.hurlant.crypto.symmetric.ICipher;
	import com.hurlant.crypto.Crypto;
	import com.hurlant.util.Hex;
	/*import flash.filesystem.File;
	import tl.types.StringUtils;
	import flash.filesystem.FileMode;
	import flash.filesystem.FileStream;*/
	import flash.utils.ByteArray;

	public class LoaderXML extends EventDispatcher {
		
		private var pathXML: String;
		private var strKeyEncryption: String;
		private var urlLoaderExt: URLLoaderExt;
		
		function LoaderXML(): void {}
		
		public function loadXML(pathXML: String, strKeyEncryption: String = "", isReturnXMLOrString: uint = 0): void {
			this.pathXML = pathXML;
			if (!this.urlLoaderExt) {
				this.strKeyEncryption = strKeyEncryption;
				var callback: FunctionCallback = new FunctionCallback(function(isLoaded: Boolean, strOrBANode: *, ...args): void {
					//trace("isLoaded:" + isLoaded)
					if (isLoaded) {
						if (this.strKeyEncryption != "") {
							var aes: ICipher = Crypto.getCipher("simple-aes-ecb", Hex.toArray(Hex.fromString(this.strKeyEncryption)), Crypto.getPad("pkcs5"));
							
							//uncomment when encrypt normal file, comment in encrypted mode
							
							/*aes.encrypt(strOrBANode);
							var pathXMLAbsolute: String = File.applicationDirectory.nativePath + "\\" + StringUtils.replace(this.pathXML + "_aes", "/", "\\");
							var fileXML: File = new File(pathXMLAbsolute);
							var fileStreamXML: FileStream = new FileStream();
							fileStreamXML.open(fileXML, FileMode.WRITE);
							fileStreamXML.writeBytes(strOrBANode);
							fileStreamXML.close();*/
							
							//end comment
							
							aes.decrypt(strOrBANode);
							strOrBANode.position = 0;
							strOrBANode = ByteArray(strOrBANode).readMultiByte(ByteArray(strOrBANode).length, "utf-8");
						}
						var result: Object;
						if (!isReturnXMLOrString) {
							var xmlNode: XML = new XML(strOrBANode);
							this.parseXML(xmlNode);
							result = xmlNode;
						} else result = strOrBANode;
						this.dispatchEvent(new EventLoaderXML(EventLoaderXML.XML_LOADED, result));
					} else this.dispatchEvent(new EventLoaderXML(EventLoaderXML.XML_NOT_LOADED));
					this.removeLoaderXML();
				}, this);
				this.urlLoaderExt = new URLLoaderExt({url: pathXML, isGetPost: 0, callback: callback, isTextBinaryVariables: uint(this.strKeyEncryption != "")});
			}
		}
		
		private function removeLoaderXML(): void {
			if (this.urlLoaderExt) {
				this.urlLoaderExt.destroy();
				this.urlLoaderExt = null;
			}
		}
		
		public function parseXML(xmlNode: XML): void {}
		
		public function abort(): void {
			this.removeLoaderXML(); 
		}
		
	}
}