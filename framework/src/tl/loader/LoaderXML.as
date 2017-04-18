package tl.loader {
	import flash.events.EventDispatcher;
	import tl.utils.FunctionCallback;
	import com.hurlant.crypto.symmetric.ICipher;
	import com.hurlant.crypto.Crypto;
	import com.hurlant.util.Hex;
	import flash.filesystem.File; //
	import tl.types.StringUtils; //
	import flash.filesystem.FileMode; //
	import flash.filesystem.FileStream; //
	import flash.utils.ByteArray;

	public class LoaderXML extends EventDispatcher {
		
		private var pathXML: String;
		public var isLoading: Boolean;
		private var strKeyEncryption: String;
		public var isLoaded: Boolean;
		private var isAbort: Boolean;
		
		function LoaderXML(): void {}
		
		public function loadXML(pathXML: String, strKeyEncryption: String = ""): void {
			this.pathXML = pathXML;
			if (!this.isLoading) {
				this.strKeyEncryption = strKeyEncryption;
				this.isLoaded = false;
				this.isLoading = true;
				this.isAbort = false;
				var callbackEnd: FunctionCallback = new FunctionCallback(function(isLoaded: Boolean, strOrBANode: *, ...args): void {
					this.isLoading = false;
					if (!this.isAbort) {
						//trace("isLoaded:" + isLoaded)
						if (isLoaded) {
							this.isLoaded = true;
							if (this.strKeyEncryption != "") {
								var aes: ICipher = Crypto.getCipher("simple-aes-ecb", Hex.toArray(Hex.fromString(this.strKeyEncryption)), Crypto.getPad("pkcs5"));
								
								/*aes.encrypt(strOrBANode);
								var pathXMLAbsolute: String = File.applicationDirectory.nativePath + "\\" + StringUtils.replace(this.pathXML + "_aes", "/", "\\");
								var fileXML: File = new File(pathXMLAbsolute);
								var fileStreamXML: FileStream = new FileStream();
								fileStreamXML.open(fileXML, FileMode.WRITE);
								fileStreamXML.writeBytes(strOrBANode);
								fileStreamXML.close();*/
								
								aes.decrypt(strOrBANode);
								strOrBANode.position = 0;
								strOrBANode = ByteArray(strOrBANode).readMultiByte(ByteArray(strOrBANode).length, "utf-8");
							}
							
							var xmlNode: XML = new XML(strOrBANode)
							this.parseXML(xmlNode);
							this.dispatchEvent(new EventLoaderXML(EventLoaderXML.XML_LOADED, xmlNode));
						} else this.dispatchEvent(new EventLoaderXML(EventLoaderXML.XML_NOT_LOADED));
					}
				}, this);
				var urlLoaderExt: URLLoaderExt = new URLLoaderExt({url: pathXML, isGetPost: 0, callbackEnd: callbackEnd, isTextBinaryVariables: uint(this.strKeyEncryption != "")});
			}
		}
		
		public function parseXML(xmlNode: XML): void {}
		
		public function abort(): void {
			this.isAbort = true;
			this.isLoading = false; 
		}
		
	}
}