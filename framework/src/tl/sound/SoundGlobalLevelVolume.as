package tl.sound {
	import base.sharedObjects.SharedObjectInstance;
	import caurina.transitions.Tweener;
	
	public class SoundGlobalLevelVolume extends Object {

		private var so: SharedObjectInstance;
		private var stepChangeLevelVolume: Number;
		private var origLevelVolume: Number;
		
		function SoundGlobalLevelVolume(soName: String = "", stepChangeLevelVolume: Number = 0.05): void {
			ModelSoundEngine.addEventListener(EventSoundEngine.LEVEL_VOLUME_CHANGED, this.onLevelVolumeChanged);
			ModelSoundEngine.addEventListener(EventSoundEngine.SOUND_OFF_ON_STATE_CHANGED, this.setSoundOffOnFade);
			ModelSoundEngine.addEventListener(EventSoundEngine.TWEEN_LEVEL_VOLUME_CHANGED, this.onTweenLevelVolumeChanged);
			if (soName != "") this.so = new SharedObjectInstance(soName);
			this.stepChangeLevelVolume = stepChangeLevelVolume;
			ModelSoundEngine.levelVolume = this.so ? this.so.getPropValue("levelVolume", 1) : 1;
			ModelSoundEngine.isSoundOffOn = uint(ModelSoundEngine.levelVolume > 0);
			ModelSoundEngine.levelVolume = ModelSoundEngine.isSoundOffOn;
		}
		
		private function onLevelVolumeChanged(e: EventSoundEngine): void {
			
			if (this.so) this.so.setPropValue("levelVolume", ModelSoundEngine.levelVolume);
		}
		
		private function setSoundOffOnFade(e: EventSoundEngine): void {
			if (ModelSoundEngine.isSoundOffOn) this.origLevelVolume = Math.max(0.5, ModelSoundEngine.levelVolume);
			
			ModelSoundEngine.tweenLevelVolume = [0, this.origLevelVolume][ModelSoundEngine.isSoundOffOn];
		}
		
		private function onTweenLevelVolumeChanged(e: EventSoundEngine): void {
			if (this.origLevelVolume != ModelSoundEngine.tweenLevelVolume)
				this.origLevelVolume = Math.max(0.5, ModelSoundEngine.levelVolume);
			var numFramesChangeLevelVolume: Number = Math.round(Math.abs(ModelSoundEngine.levelVolume - ModelSoundEngine.tweenLevelVolume) / this.stepChangeLevelVolume);
			Tweener.addTween(ModelSoundEngine, {levelVolume: ModelSoundEngine.tweenLevelVolume, time: numFramesChangeLevelVolume, useFrames: true, transition: "linear"});
			if (this.so) this.so.setPropValue("levelVolume", String(ModelSoundEngine.tweenLevelVolume));
		}
		
	}
}