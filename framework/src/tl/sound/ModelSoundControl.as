package tl.sound {
	import flash.events.EventDispatcher;
	import tl.vspm.EventModel;

	public class ModelSoundControl extends EventDispatcher implements IModelSoundControl {
		
		private var _levelVolume: Number = 1;
		private var _tweenLevelVolume: Number;
		private var _isSoundOffOn: uint = 1;

		public var name: String;
		internal var origLevelVolume: Number;
		
		public function ModelSoundControl(name: String, levelVolume: Number): void {
			this.name = name;
			this.origLevelVolume = levelVolume;
			this.levelVolume = levelVolume;
		}
		
		public function get levelVolume(): Number { 
			return this._levelVolume;
		}
		
		public function set levelVolume(value: Number): void {
			this._levelVolume = value;
			this.dispatchEvent(new EventModel(EventSoundControl.LEVEL_VOLUME_CHANGED, value));
		}

		public function get tweenLevelVolume(): Number { 
			return this._tweenLevelVolume;
		}
		
		public function set tweenLevelVolume(value: Number): void {
			this._tweenLevelVolume = value;
			this.dispatchEvent(new EventModel(EventSoundControl.TWEEN_LEVEL_VOLUME_CHANGED, value));
		}
		
		public function get isSoundOffOn(): uint {
			return this._isSoundOffOn;
		}
		
		public function set isSoundOffOn(value: uint): void {
			this._isSoundOffOn = value;
			this.dispatchEvent(new EventModel(EventSoundControl.SOUND_OFF_ON_STATE_CHANGED, value));
		}
		
	}

}