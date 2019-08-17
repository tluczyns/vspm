package tl.loader {
	import flash.display.Loader;
	import flash.events.ProgressEvent;
	import flash.events.Event;
	import flash.events.IOErrorEvent;	
	import flash.system.ApplicationDomain;
	import flash.system.LoaderContext;
	import flash.system.SecurityDomain;
	import flash.filesystem.File;
	import flash.utils.ByteArray;
	import flash.filesystem.FileStream;
	import flash.filesystem.FileMode;
	import flash.net.URLRequest;
	/*import tl.service.ExternalInterfaceExt;
	import flash.net.URLVariables;*/
	
	public class LoaderExt extends Loader {
		
		private var onLoadProgress: Function;
		private var onLoadComplete: Function;
		private var onLoadError: Function;
		
		public function LoaderExt(objLoaderExt: Object): void {
			super();
			this.onLoadProgress = objLoaderExt.onLoadProgress || this.onLoadProgressDefault;
			this.onLoadComplete = objLoaderExt.onLoadComplete || this.onLoadCompleteDefault;
			this.onLoadError = objLoaderExt.onLoadError || this.onLoadErrorDefault;
			this.contentLoaderInfo.addEventListener(ProgressEvent.PROGRESS, this.onLoadProgress);
			if (objLoaderExt.isLoadByByteArray) this.contentLoaderInfo.addEventListener(Event.INIT, this.onLoadComplete);
			else this.contentLoaderInfo.addEventListener(Event.COMPLETE, this.onLoadComplete);
            this.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR, this.onLoadError);
			var checkPolicyFile: Boolean = Boolean(objLoaderExt.checkPolicyFile);
			var applicationDomain: ApplicationDomain;
			if (uint(objLoaderExt.isApplicationDomainCurrentNew) == 1) applicationDomain = new ApplicationDomain();
			else applicationDomain = ApplicationDomain.currentDomain; //SecurityDomain.currentDomain
			var context: LoaderContext = new LoaderContext(checkPolicyFile, applicationDomain);
			var url: String = String(objLoaderExt.url);
			if (objLoaderExt.isLoadByByteArray) {
				try {
					var file: File = new File(url);
					var ba: ByteArray = new ByteArray();  
					var loadStream: FileStream = new FileStream();  
					loadStream.open(file, FileMode.READ);
					loadStream.readBytes(ba);  
					loadStream.close();  
					context.allowLoadBytesCodeExecution = true;  
					this.loadBytes(ba, context);
					ba.clear();
					ba = null;
				} catch(e: Error) {
					this.onLoadError(new IOErrorEvent(IOErrorEvent.IO_ERROR));
				}
			} else {
				var request: URLRequest = new URLRequest(url);
				/*if (ExternalInterfaceExt.isBrowser) {
					var variables:URLVariables = new URLVariables();  
					variables.nocache = new Date().getTime(); 
					request.data = variables;
				}*/
				this.load(request, context);
			}
		}
		
		private function onLoadProgressDefault(event:ProgressEvent): void {
			var ratioLoaded:Number = event.bytesLoaded / event.bytesTotal;
			var percentLoaded: uint = Math.round(ratioLoaded * 100);
			//trace("The img / movie has loaded in " + percentLoaded + " %");
		}
		
		private function onLoadCompleteDefault(event:Event): void {
			trace("The img / movie has finished loading.");
		}
		
		private function onLoadErrorDefault(errorEvent:IOErrorEvent): void {
            trace("The img / movie could not be loaded: " + errorEvent.text);
        }
		
		public function destroy(): void {
			if (this.contentLoaderInfo.hasEventListener(Event.COMPLETE)) this.contentLoaderInfo.removeEventListener(Event.COMPLETE, this.onLoadComplete);
			else if (this.contentLoaderInfo.hasEventListener(Event.INIT)) this.contentLoaderInfo.removeEventListener(Event.INIT, this.onLoadComplete);
			this.contentLoaderInfo.removeEventListener(ProgressEvent.PROGRESS, this.onLoadProgress);
            this.contentLoaderInfo.removeEventListener(IOErrorEvent.IO_ERROR, this.onLoadError);
			try {
				if (this.content) this.unloadAndStop();
				else this.close();
			} catch (e: Error) {}
		}
		
	}
	
}