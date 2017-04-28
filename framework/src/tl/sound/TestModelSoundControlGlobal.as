package tl.sound {
	import flash.display.Sprite;
	import tl.vspm.EventModel;
	
	public class TestModelSoundControlGlobal extends Sprite {
		
		private var modelSoundControlGlobal: ModelSoundControlGlobal;
		
		public function TestModelSoundControlGlobal(): void {
			this.modelSoundControlGlobal = new ModelSoundControlGlobal(new <String>["a", "b", "c"], "sharedobj");
			this.modelSoundControlGlobal.addEventListener(EventSoundControl.LEVEL_VOLUME_CHANGED, this.onLevelVolumeChanged)
			this.modelSoundControlGlobal.addEventListener(EventSoundControl.SOUND_OFF_ON_STATE_CHANGED, this.onSoundOffOnChanged)
			//this.modelSoundControlGlobal.levelVolume = 2;
			ModelSoundControlGlobal.getModel("a").levelVolume = 4;
			//this.modelSoundControlGlobal.isSoundOffOn = 0;
			trace("start:", this.modelSoundControlGlobal.levelVolume, ModelSoundControlGlobal.getModel("a").levelVolume, ModelSoundControlGlobal.getModel("b").levelVolume, ModelSoundControlGlobal.getModel("c").levelVolume);
		}
		
		public function onLevelVolumeChanged(e: EventModel): void {
			trace("onLevelVolumeChanged:", ModelSoundControl(e.target).levelVolume, this.modelSoundControlGlobal.levelVolume, ModelSoundControlGlobal.getModel("a").levelVolume, ModelSoundControlGlobal.getModel("b").levelVolume, ModelSoundControlGlobal.getModel("c").levelVolume);
		}
		
		public function onSoundOffOnChanged(e: EventModel): void {
			trace("onSoundOffOnChanged:", e.data);
		}
		
	}

}