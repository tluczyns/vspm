package tl.sound {
	import flash.display.Sprite;
	import tl.vspm.EventModel;
	
	public class TestDictModelSoundControl extends Sprite {
		
		private var dictModelSoundControl: DictModelSoundControl;
		
		public function TestDictModelSoundControl(): void {
			this.dictModelSoundControl = new DictModelSoundControl(new <String>["a", "b", "c"], "sharedobj");
			this.dictModelSoundControl.addEventListener(EventSoundControl.LEVEL_VOLUME_CHANGED, this.onLevelVolumeChanged)
			this.dictModelSoundControl.addEventListener(EventSoundControl.SOUND_OFF_ON_STATE_CHANGED, this.onSoundOffOnChanged)
			//this.dictModelSoundControl.levelVolume = 2;
			//this.dictModelSoundControl["a"].levelVolume = 4;
			//this.dictModelSoundControl.isSoundOffOn = 0;
			trace("start:", this.dictModelSoundControl.levelVolume, this.dictModelSoundControl["a"].levelVolume, this.dictModelSoundControl["b"].levelVolume, this.dictModelSoundControl["c"].levelVolume)
		}
		
		
		public function onLevelVolumeChanged(e: EventModel): void {
			trace("onLevelVolumeChanged:", ModelSoundControl(e.target).levelVolume, this.dictModelSoundControl.levelVolume, this.dictModelSoundControl["a"].levelVolume, this.dictModelSoundControl["b"].levelVolume, this.dictModelSoundControl["c"].levelVolume);
		}
		
		public function onSoundOffOnChanged(e: EventModel): void {
			trace("onSoundOffOnChanged:", e.data);
		}
		
	}

}