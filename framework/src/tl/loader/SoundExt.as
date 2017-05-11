package tl.loader {
	import flash.media.Sound;
	import flash.media.SoundChannel;
	import tl.sound.ModelSoundControl;
	import tl.sound.ModelSoundControlGlobal;
	import flash.events.Event;
	import flash.events.ProgressEvent;
	import flash.events.IOErrorEvent;
	import flash.net.URLRequest;
	import tl.sound.EventSoundControl;
	import flash.media.SoundTransform;
	import caurina.transitions.Tweener;
	import flash.errors.IOError;
	
	import zajKompKlasa1.ConfigAll; //usunąć po projekcie
	
	public dynamic class SoundExt extends Sound {
		public var channel: SoundChannel;
		public var modelSoundControl: ModelSoundControl;
		public var isLoop: Boolean;
		public var initVolume: Number;
		private var origVolume: Number;
		private var onLoadComplete: Function;
		private var onLoadProgress: Function;
		private var onLoadError: Function;
		private var isPlayFirstTime: Boolean;
		private var onSoundComplete: Function;
		public var positionPause: int = 0;
		
		public function SoundExt(objSoundExt: Object = null) {
			objSoundExt = objSoundExt || {};
			this.modelSoundControl = objSoundExt.modelSoundControl || ModelSoundControlGlobal.getModel(ConfigAll.NAME_MODEL_SOUND_CONTROL_CONTAINER) || ModelSoundControlGlobal.getModel(); //usunąć po projekcie ModelSoundControlGlobal.getModel(ConfigAll.NAME_MODEL_SOUND_CONTROL_CONTAINER)
			this.isLoop = Boolean(objSoundExt.isLoop);
			this.initVolume = this.origVolume = (objSoundExt.initVolume != undefined) ? objSoundExt.initVolume : 1;
			this.onLoadComplete = objSoundExt.onLoadComplete || this.onLoadCompleteDefault;
			this.onLoadProgress = objSoundExt.onLoadProgress || this.onLoadProgressDefault;
			this.onLoadError = objSoundExt.onLoadError || this.onLoadErrorDefault;
			this.addEventListener(Event.COMPLETE, this.onLoadComplete);
			this.addEventListener(ProgressEvent.PROGRESS, this.onLoadProgress);
			this.addEventListener(IOErrorEvent.IO_ERROR, this.onLoadError);
			var urlRequest: URLRequest;
			if (objSoundExt.url != null) urlRequest = new URLRequest(objSoundExt.url);
			this.isPlayFirstTime = true;
			super(urlRequest);
		}
		
		//loading and init
		
		private function onLoadCompleteDefault(event:Event): void {
			this.removeLoadListeners();
		}
		
		private function removeLoadListeners(): void {
			this.removeEventListener(Event.COMPLETE, this.onLoadComplete);
			this.removeEventListener(ProgressEvent.PROGRESS, this.onLoadProgress);
			this.removeEventListener(IOErrorEvent.IO_ERROR, this.onLoadError);
		}
		
		private function onLoadProgressDefault(event:ProgressEvent): void {
			var ratioLoaded:Number = event.bytesLoaded / event.bytesTotal;
			var percentLoaded: uint = Math.round(ratioLoaded * 100);
		}
		
		private function onLoadErrorDefault(errorEvent:IOErrorEvent): void {}		
		
		//play and stop
		
		public function playExt(onSoundComplete: Function = null, startTime: Number = 0, loops: int = 0, sndTransform: SoundTransform = null): SoundChannel {
			if (this.isPlayFirstTime) {
				this.isPlayFirstTime = false;
				this.modelSoundControl.addEventListener(EventSoundControl.LEVEL_VOLUME_CHANGED, this.setVolumeGlobal);
				this.setVolumeGlobal();
			}
			this.onSoundComplete = onSoundComplete || this.onSoundCompleteDefault;
			this.stop();
			this.channel = this.play(startTime, loops, sndTransform);
			this.channel.addEventListener(Event.SOUND_COMPLETE, this.onSoundComplete);
			this.setVolumeSelf();
			return this.channel;
		}
		
		public function stop(): void {
			if (this.channel) {
				this.positionPause = this.channel.position; 
				this.channel.removeEventListener(Event.SOUND_COMPLETE, this.onSoundComplete);
				this.channel.stop();
				this.channel = null;
			}
		}
		
		private function onSoundCompleteDefault(event:Event): void {
			if (this.isLoop) this.playExt();
			else this.stop();
		}
		
		//set volume
		
		private function setVolumeGlobal(e: EventSoundControl = null): void { 
			this.setVolume(this.modelSoundControl.levelVolume, true);
		}

		private function setVolumeSelf(): void { 
			this.setVolume(this.initVolume, false);
		}
		
		public function setVolume(volume: Number, isGlobal: Boolean = false): void {
			if (!isGlobal) {
				this.initVolume = volume;
				volume *= this.modelSoundControl.levelVolume;
			} else {
				volume *= this.initVolume;
			}
			//trace("volume:" + volume + ", isGlobal:" + isGlobal)
			if (this.channel != null) {
				var soundTransform: SoundTransform = new SoundTransform();
				soundTransform.volume = volume;	
				this.channel.soundTransform = soundTransform;
			}
		}
		
		public function setSoundOffOnFade(isSoundOffOn: Number, stepChangeVolume: Number = 0.1, onComplete: Function = null, onCompleteParams: Array = null): void {
			var destVolume: Number;
			if (isSoundOffOn == 0) {
				this.origVolume = this.initVolume;
				destVolume = 0;
			} else if (isSoundOffOn == 1) {
				destVolume = this.origVolume;
			}
			this.tweenVolume(destVolume, stepChangeVolume, onComplete, onCompleteParams)
		}
		
		public function tweenVolume(destVolume: Number, stepChangeVolume: Number = 0.1, onComplete: Function = null, onCompleteParams: Array = null, ease: * = null): uint {
			var currVolume: Number = ((this.channel) && (this.channel.soundTransform)) ? this.channel.soundTransform.volume : this.initVolume;
			var numFramesChangeVolume: uint = Math.abs(Math.round(Math.abs(destVolume - currVolume) / stepChangeVolume));
			ease = ease || "linear";
			Tweener.removeTweens(this);
			Tweener.addTween(this, {initVolume: destVolume, time: numFramesChangeVolume, useFrames: true, transition: ease, onUpdate: this.setVolumeSelf, onComplete: onComplete, onCompleteParams: onCompleteParams});
			return numFramesChangeVolume;
		}
		
		//destroy
		
		public function destroy(): void {
			try { 
				this.close();
				this.removeLoadListeners();
			}
			catch (error:IOError) {}
			this.modelSoundControl.removeEventListener(EventSoundControl.LEVEL_VOLUME_CHANGED, this.setVolumeGlobal);
			this.stop();
			Tweener.removeTweens(this);
		}
		
	}

}