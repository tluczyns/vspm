package tl.sound {
	import tl.vspm.EventModel;

	public class EventSoundControl extends EventModel {
		
		//events to sound engine
		static public const SOUND_OFF_ON_STATE_CHANGED: String = "soundOffOnStateChanged";
		//events from sound engine
		static public const LEVEL_VOLUME_CHANGED: String = "levelVolumeChanged";
		static public const TWEEN_LEVEL_VOLUME_CHANGED: String = "tweenLevelVolumeChanged";
		
		public function EventSoundControl(type: String, data: * = null): void {
			super(type, data);
		}
		
	}

}