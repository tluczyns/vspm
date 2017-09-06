package tl.loader {
	import tl.loader.progress.ILoaderProgress;
	import tl.types.ArrayUtils;
	import flash.events.Event;
	import flash.display.AVM1Movie;
	import flash.events.IOErrorEvent;
	import tl.loader.LoaderExt;
	import tl.loader.SoundExt;
	import tl.utils.FunctionCallback;
	
	public class QueueLoadContent extends Object {
		
		static public const FINISHED_PROGRESS: String = "finishedProgress";
		
		public static const IMAGE: uint = 0;
    	public static const SWF: uint = 1;
		public static const SOUND: uint = 2;
		public static const SERVER_DATA: uint = 3;
		
		private var _isLoading: Boolean;
		private var isStopLoading: Boolean;
		private var arrLoadContent: Array;
		private var numContentToLoad: int;
		private var onAllLoadCompleteHandler: Function;
		private var onAllLoadCompleteScope: Object;
		private var isClearAfterAllLoadComplete: Boolean; //należy ustawić na false, gdy planujemy doładywać na danej kolejce nowe rzeczy (po zakończeniu poprzedniego wczytywania)
		private var onElementLoadCompleteHandler: Function;
		private var onElementLoadCompleteScope: Object;
		public var loaderProgress: ILoaderProgress;
		
		//public var percentLoadingAsset: Number, percentLoadingTotal: Number; //for use for external preloaders
		
		public function QueueLoadContent(onAllLoadCompleteHandler: Function, onAllLoadCompleteScope: Object, loaderProgress: ILoaderProgress = null, onElementLoadCompleteHandler: Function = null, onElementLoadCompleteScope: Object = null, isClearAfterAllLoadComplete: Boolean = true): void {
			this._isLoading = false;
			this.arrLoadContent = [];
			this.numContentToLoad = -1;
			this.onAllLoadCompleteHandler = onAllLoadCompleteHandler;
			this.onAllLoadCompleteScope = onAllLoadCompleteScope;
			this.isClearAfterAllLoadComplete = isClearAfterAllLoadComplete;
			this.loaderProgress = loaderProgress;
			this.onElementLoadCompleteHandler = onElementLoadCompleteHandler;
			this.onElementLoadCompleteScope = onElementLoadCompleteScope;
		}
		
		public function addToLoadQueue(url: String, weight: Number = 1, isDataTextBinaryVariables: uint = 0, isStartLoading: Boolean = false, loaderProgress: ILoaderProgress = null): uint {
			url = url || "";
			loaderProgress = loaderProgress || this.loaderProgress;
			var newObjLoadContent: Object = {url: url, weight: weight, type: (isDataTextBinaryVariables == 1) ? QueueLoadContent.SERVER_DATA : this.getContentTypeFromUrl(url), isDataTextBinaryVariables: isDataTextBinaryVariables, isLoaded: false, loaderProgress: loaderProgress, content: null}
			this.arrLoadContent.push(newObjLoadContent);
			newObjLoadContent.indLoadContent = this.arrLoadContent.length - 1;
			if (loaderProgress) loaderProgress.addWeightContent(weight);
			if (isStartLoading) this.startLoading();
			return this.arrLoadContent.length - 1;
		}
		
		public function bringToFrontInLoadQueue(url: String): void {
			var indObjLoadContentInLoadQueue: int = ArrayUtils.getElementIndexByProperty(this.arrLoadContent, "url", url);
			if ((indObjLoadContentInLoadQueue != -1) && (indObjLoadContentInLoadQueue > this.numContentToLoad) && (this.numContentToLoad + 1 < this.arrLoadContent.length))
				this.arrLoadContent.splice(this.numContentToLoad + 1, 0, this.arrLoadContent.splice(indObjLoadContentInLoadQueue, 1)[0]);
		}
		
		public function startLoading(): void {
			this.isStopLoading = false;
			if (!this._isLoading) {
				this.loadNextElementFromQueue();
			}
		}
		
		private function onLoadComplete(event: Event): void {
			var objLoadContent: Object = this.arrLoadContent[this.numContentToLoad];
			objLoadContent = this.checkAndCorrectTypeFromLoadedContent(objLoadContent);
			if ((objLoadContent.type == QueueLoadContent.IMAGE) || ((objLoadContent.type == QueueLoadContent.SWF) /*&& (objLoadContent.content.contentLoaderInfo.actionScriptVersion == 3)*/)) {
				objLoadContent.width = objLoadContent.content.contentLoaderInfo.width;
				objLoadContent.height = objLoadContent.content.contentLoaderInfo.height;
				if (!(objLoadContent.content.content is AVM1Movie))
					objLoadContent.content = objLoadContent.content.content;
			}
			objLoadContent.isLoaded = true;
			if ((this.onElementLoadCompleteHandler != null) && (this.onElementLoadCompleteScope != null) && (!this.isStopLoading)) 
				this.onElementLoadCompleteHandler.apply(this.onElementLoadCompleteScope, [objLoadContent, this.numContentToLoad]);
			if (!this.isStopLoading) this.loadNextElementFromQueue();
		}
		
		private function onLoadError(errorEvent: IOErrorEvent): void {
			trace("onLoadError:", errorEvent)
            var objLoadContent: Object = this.arrLoadContent[this.numContentToLoad];
			objLoadContent.isLoaded = false;
			if ((this.onElementLoadCompleteHandler != null) && (this.onElementLoadCompleteScope != null)) 
				this.onElementLoadCompleteHandler.apply(this.onElementLoadCompleteScope, [objLoadContent, this.numContentToLoad]);
			if (!this.isStopLoading) this.loadNextElementFromQueue();
        }
		
		private function onAllLoadComplete(e: Object = null): void {
			if (this.onAllLoadCompleteHandler != null) this.onAllLoadCompleteHandler.apply(this.onAllLoadCompleteScope, [this.arrLoadContent]);
			if (this.isClearAfterAllLoadComplete) {
				if (this.loaderProgress) this.loaderProgress["removeEventListener"](QueueLoadContent.FINISHED_PROGRESS, this.onAllLoadComplete);
				for (var i: uint = 0; i < this.arrLoadContent.length; i++) this.arrLoadContent[i] = null;
				this.arrLoadContent = [];
			}
		}
		
        private function loadNextElementFromQueue(): void {
			if (this.numContentToLoad + 1 < this.arrLoadContent.length) {
				this.numContentToLoad++;
				this._isLoading = true;
				var objLoadContent: Object = this.arrLoadContent[this.numContentToLoad];
				var onLoadProgress: Function;
				if (objLoadContent.loaderProgress) onLoadProgress = objLoadContent.loaderProgress.onLoadProgress;
				if ((objLoadContent.type == QueueLoadContent.IMAGE) || (objLoadContent.type == QueueLoadContent.SWF)) {
					objLoadContent.content = new LoaderExt({url: objLoadContent.url, onLoadComplete: this.onLoadComplete, onLoadProgress: onLoadProgress, onLoadError: this.onLoadError});
				} else if (objLoadContent.type == QueueLoadContent.SOUND) {
					objLoadContent.content = new SoundExt({url: objLoadContent.url, isToPlay: false, onLoadComplete: this.onLoadComplete, onLoadProgress: onLoadProgress, onLoadError: this.onLoadError});
				} else if (objLoadContent.type == QueueLoadContent.SERVER_DATA) {
					var callback: FunctionCallback = new FunctionCallback(function(isLoaded: Boolean, data: *, ...args): void {
						var objLoadContent: Object = this.arrLoadContent[this.numContentToLoad];
						if (isLoaded) {
							objLoadContent.content = data;
							this.onLoadComplete(null);
						} else {
							this.onLoadError(null);
						}
					}, this);
					objLoadContent.urlLoaderExt = new URLLoaderExt({url: objLoadContent.url, isGetPost: 1, isTextBinaryVariables: objLoadContent.isDataTextBinaryVariables, timeTimeout: [60000, 10000000][uint(objLoadContent.isDataTextBinaryVariables == 1)], callback: callback, onLoadProgress: onLoadProgress});
				} else this.onLoadError(null);
				if (objLoadContent.loaderProgress) objLoadContent.loaderProgress.initNextLoad();
			} else {
				this._isLoading = false;
				if (this.loaderProgress) {
					this.loaderProgress.setLoadProgress(1);
					this.loaderProgress["addEventListener"](QueueLoadContent.FINISHED_PROGRESS, this.onAllLoadComplete);
				} else this.onAllLoadComplete();
			}
        }
		
		private function getContentTypeFromUrl(url: String): int {
			var arrExtensionImage: Array = ["png", "jpg", "jpeg", "gif"];
			var arrExtensionMovie: Array = ["swf", "ne"];
			var arrExtensionSound: Array = ["mp3", "wav"];
			var arrExtensionServerData: Array = ["xml", "php"];
			var isFoundType: Boolean = false;
			var type: uint = 0;
			while ((!isFoundType) && (type <= 3)) {
				var arrExtension: Array = [arrExtensionImage, arrExtensionMovie, arrExtensionSound, arrExtensionServerData][type];
				var i: uint = 0;
				url = url.toLowerCase();
				while (((url.indexOf("." + arrExtension[i]) == -1) 
					 || (url.indexOf("." + arrExtension[i]) != (url.length - arrExtension[i].length - 1))) 
					&& (i < arrExtension.length)) {
					i++;
				}
				if (i < arrExtension.length) {
					isFoundType = true;
				} else {
					type++;
				}
			}
			if (isFoundType) {
				return type;
			} else {
				return QueueLoadContent.SERVER_DATA;
			}
		}
		
		private function checkAndCorrectTypeFromLoadedContent(objLoadContent: Object): Object {
			if ((objLoadContent.type == QueueLoadContent.IMAGE) || (objLoadContent.type == QueueLoadContent.SWF)) {
				switch (objLoadContent.content.contentLoaderInfo.contentType) {
					case "application/x-shockwave-flash": objLoadContent.type = QueueLoadContent.SWF; break;
					case "image/jpeg": objLoadContent.type = QueueLoadContent.IMAGE; break;
					case "image/gif": objLoadContent.type = QueueLoadContent.IMAGE; break;
					case "image/png": objLoadContent.type = QueueLoadContent.IMAGE; break;
				}
			}
			return objLoadContent;
		}
		
		public function stopLoading(): void {
			this.isStopLoading = true;
			if (this.isLoading) {
				var objLoadContent: Object = this.arrLoadContent[this.numContentToLoad];
				if ((objLoadContent.type == QueueLoadContent.IMAGE) || (objLoadContent.type == QueueLoadContent.SWF)) {
					objLoadContent.content.destroy();
				} else if (objLoadContent.type == QueueLoadContent.SOUND) {
					objLoadContent.content.destroy();
				} else if (objLoadContent.type == QueueLoadContent.SERVER_DATA) {
					objLoadContent.urlLoaderExt.destroy();
				}
				this._isLoading = false;
			}
		}
		
		public function get isLoading(): Boolean {
			return _isLoading;
		}
		
	}
	
}