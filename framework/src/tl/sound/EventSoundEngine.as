package tl.sound {
	import flash.events.Event;

	public class EventSoundEngine extends Event {
		
		//events to sound engine
		static public const SOUND_OFF_ON_STATE_CHANGED: String = "soundOffOnStateChanged";
		//events from sound engine
		static public const LEVEL_VOLUME_CHANGED: String = "levelVolumeChanged";
		static public const TWEEN_LEVEL_VOLUME_CHANGED: String = "tweenLevelVolumeChanged";
		
		public function EventSoundEngine(type: String, bubbles: Boolean = false) {
			super(type, bubbles);
		}
		
	}

}