package tl.sound {
	import flash.events.EventDispatcher;
	import tl.so.SharedObjectInstance;
	import tl.vspm.EventModel;
	import caurina.transitions.Tweener;

	public class ModelSoundControl extends EventDispatcher {
		
		private var _levelVolume: Number = 1;
		private var _tweenLevelVolume: Number;
		private var _isSoundOffOn: uint = 1;
		
		private var name: String;
		private var so: SharedObjectInstance;
		private var stepChangeLevelVolume: Number;
		private var origLevelVolume: Number;
		
		public function ModelSoundControl(name: String, so: SharedObjectInstance = null, stepChangeLevelVolume: Number = 0.05, startLevelVolume: Number = 1): void {
			this.name = name;
			this.so = so;
			this.stepChangeLevelVolume = stepChangeLevelVolume;
			var levelVolume: Number = so ? so.getPropValue("levelVolume", 1) : startLevelVolume;
			this.origLevelVolume = levelVolume;
			this.levelVolume = levelVolume;
			this.isSoundOffOn = uint(this.levelVolume > 0);
			this.addEventListener(EventSoundControl.LEVEL_VOLUME_CHANGED, this.onLevelVolumeChanged);
			this.addEventListener(EventSoundControl.TWEEN_LEVEL_VOLUME_CHANGED, this.onTweenLevelVolumeChanged);			
			this.addEventListener(EventSoundControl.SOUND_OFF_ON_STATE_CHANGED, this.setSoundOffOnFade);
		}
		
		public function get levelVolume(): Number { 
			return this._levelVolume;
		}
		
		public function set levelVolume(value: Number): void {
			if (value != this._levelVolume) {
				this._levelVolume = value;
				this.dispatchEvent(new EventSoundControl(EventSoundControl.LEVEL_VOLUME_CHANGED, value));
			}
		}

		public function get tweenLevelVolume(): Number { 
			return this._tweenLevelVolume;
		}
		
		public function set tweenLevelVolume(value: Number): void {
			if (value != this._tweenLevelVolume) {
				this._tweenLevelVolume = value;
				this.dispatchEvent(new EventSoundControl(EventSoundControl.TWEEN_LEVEL_VOLUME_CHANGED, value));
			}
		}
		
		public function get isSoundOffOn(): uint {
			return this._isSoundOffOn;
		}
		
		public function set isSoundOffOn(value: uint): void {
			if (value != this._isSoundOffOn) {
				this._isSoundOffOn = value;
				this.dispatchEvent(new EventSoundControl(EventSoundControl.SOUND_OFF_ON_STATE_CHANGED, value));
			}
		}
		
		private function onLevelVolumeChanged(e: EventModel): void {
			if (this.so) this.so.setPropValue("levelVolume" + this.name, this.levelVolume);
		}
		
		private function onTweenLevelVolumeChanged(e: EventModel): void {
			//if (this.origLevelVolume != this.tweenLevelVolume) this.origLevelVolume = Math.max(0.5, this.levelVolume);
			var numFramesChangeLevelVolume: Number = Math.round(Math.abs(this.levelVolume - this.tweenLevelVolume) / this.stepChangeLevelVolume);
			Tweener.removeTweens(this, "levelVolume");
			Tweener.addTween(this, {levelVolume: this.tweenLevelVolume, time: numFramesChangeLevelVolume, useFrames: true, transition: "linear"});
			if (this.so) this.so.setPropValue("levelVolume" + this.name, String(this.tweenLevelVolume));
		}
		
		private function setSoundOffOnFade(e: EventModel): void {
			/*if (this.isSoundOffOn == 0) this.origLevelVolume = Math.max(0.5, this.levelVolume);
			this.tweenLevelVolume = [0, this.origLevelVolume][this.isSoundOffOn];*/
			this.tweenLevelVolume = this.isSoundOffOn;
		}
		
	}

}