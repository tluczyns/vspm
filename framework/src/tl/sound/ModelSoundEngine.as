package tl.sound {
	import tl.types.Singleton;
	import flash.events.EventDispatcher;

	public class ModelSoundEngine extends Singleton {
		
		static private var modelDispatcher: EventDispatcher = new EventDispatcher();
		
		static private var _levelVolume: Number	= 1;
		static private var _tweenLevelVolume: Number;
		static private var _isSoundOffOn: uint = 1;
		
		static public function addEventListener(type: String, func: Function, priority: int = 0): void {
			ModelSoundEngine.modelDispatcher.addEventListener(type, func, false, priority);
		}
	
		static public function removeEventListener(type: String, func: Function): void {
			ModelSoundEngine.modelDispatcher.removeEventListener(type, func);
		}
		
		static public function dispatchEvent(type: String): void {
			ModelSoundEngine.modelDispatcher.dispatchEvent(new EventSoundEngine(type));
		}
		
		static public function get levelVolume(): Number { 
			return ModelSoundEngine._levelVolume;
		}
		
		static public function set levelVolume(value: Number): void {
			ModelSoundEngine._levelVolume = value;
			ModelSoundEngine.dispatchEvent(EventSoundEngine.VOLUME_RATIO_CHANGED); 
		}

		static public function get tweenLevelVolume(): Number { 
			return ModelSoundEngine._tweenLevelVolume;
		}
		
		static public function set tweenLevelVolume(value: Number): void {
			ModelSoundEngine._tweenLevelVolume = value;
			ModelSoundEngine.dispatchEvent(EventSoundEngine.TWEEN_VOLUME_RATIO_CHANGED); 
		}
		
		static public function get isSoundOffOn(): uint {
			return ModelSoundEngine._isSoundOffOn;
		}
		
		static public function set isSoundOffOn(value: uint): void {
			ModelSoundEngine._isSoundOffOn = value;
			ModelSoundEngine.dispatchEvent(EventSoundEngine.SOUND_OFF_ON_STATE_CHANGED); 
		}
		
	}

}