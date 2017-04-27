package tl.sound {
	import tl.types.DictEventDispatcher;
	import tl.sharedObjects.SharedObjectInstance;
	import tl.vspm.EventModel;
	import caurina.transitions.Tweener;
	
	public class DictModelSoundControl extends DictEventDispatcher implements IModelSoundControl {
		
		static private var _instance: DictModelSoundControl;

		private var _levelVolume: Number;
		private var _tweenLevelVolume: Number;
		private var _isSoundOffOn: uint = 1;
		
		private var vecModelSoundControl: Vector.<ModelSoundControl>;
		private var so: SharedObjectInstance;
		private var stepChangeLevelVolume: Number;
		
		public static function getInstance(): DictModelSoundControl {
			return DictModelSoundControl._instance; 
		}
		
		public function DictModelSoundControl(vecNameModelSoundControl: Vector.<String>, soName: String = "", stepChangeLevelVolume: Number = 0.05): void {
			if (!DictModelSoundControl._instance) {
				super();
				this.vecModelSoundControl = new Vector.<ModelSoundControl>(vecNameModelSoundControl.length);
				if (soName != "") this.so = new SharedObjectInstance(soName);
				this.stepChangeLevelVolume = stepChangeLevelVolume;
				var nameModelSoundControl: String;
				var levelVolumeModelSoundControl: Number;
				var maxLevelVolumeModelSoundControl: Number = 0;
				for (var i: uint = 0; i < vecNameModelSoundControl.length; i++) {
					nameModelSoundControl = vecNameModelSoundControl[i];
					levelVolumeModelSoundControl = this.so ? this.so.getPropValue("levelVolume" + nameModelSoundControl, 1) : 1;
					maxLevelVolumeModelSoundControl = Math.max(maxLevelVolumeModelSoundControl, levelVolumeModelSoundControl)
					this[nameModelSoundControl] = new ModelSoundControl(nameModelSoundControl, levelVolumeModelSoundControl);
				}
				this.addEventListener(EventSoundControl.LEVEL_VOLUME_CHANGED, this.onLevelVolumeChanged);
				this.addEventListener(EventSoundControl.SOUND_OFF_ON_STATE_CHANGED, this.setSoundOffOnFade);
				this.addEventListener(EventSoundControl.TWEEN_LEVEL_VOLUME_CHANGED, this.onTweenLevelVolumeChanged);
				this.isSoundOffOn = uint(maxLevelVolumeModelSoundControl > 0);
				DictModelSoundControl._instance = this;
			} else throw new Error("DictModelSoundControl is a singleten class!")
		}
		
		public function get levelVolume(): Number { 
			return this._levelVolume;
		}
		
		public function set levelVolume(value: Number): void {
			this._levelVolume = value;
			for each (var modelSoundControl: ModelSoundControl in this) 
				modelSoundControl.levelVolume = value;
		}

		public function get tweenLevelVolume(): Number { 
			return this._tweenLevelVolume;
		}
		
		public function set tweenLevelVolume(value: Number): void {
			this._tweenLevelVolume = value;
			for each (var modelSoundControl: ModelSoundControl in this) 
				modelSoundControl.tweenLevelVolume = value;
		}
		
		public function get isSoundOffOn(): uint {
			return this._isSoundOffOn;
		}
		
		public function set isSoundOffOn(value: uint): void {
			this._isSoundOffOn = value;
			for each (var modelSoundControl: ModelSoundControl in this) 
				modelSoundControl.isSoundOffOn = value;
		}
		
		private function onLevelVolumeChanged(e: EventModel): void {
			var modelSoundControl: ModelSoundControl = ModelSoundControl(e.target);
			if (this.so) this.so.setPropValue("levelVolume" + modelSoundControl.name, modelSoundControl.levelVolume);
		}
		
		private function setSoundOffOnFade(e: EventModel): void {
			var modelSoundControl: ModelSoundControl = ModelSoundControl(e.target);
			if (modelSoundControl.isSoundOffOn == 0) modelSoundControl.origLevelVolume = Math.max(0.5, modelSoundControl.levelVolume);
			modelSoundControl.tweenLevelVolume = [0, modelSoundControl.origLevelVolume][modelSoundControl.isSoundOffOn];
		}
		
		private function onTweenLevelVolumeChanged(e: EventModel): void {
			var modelSoundControl: ModelSoundControl = ModelSoundControl(e.target);
			if (modelSoundControl.origLevelVolume != modelSoundControl.tweenLevelVolume)
				modelSoundControl.origLevelVolume = Math.max(0.5, modelSoundControl.levelVolume);
			var numFramesChangeLevelVolume: Number = Math.round(Math.abs(modelSoundControl.levelVolume - modelSoundControl.tweenLevelVolume) / this.stepChangeLevelVolume);
			Tweener.addTween(modelSoundControl, {levelVolume: modelSoundControl.tweenLevelVolume, time: numFramesChangeLevelVolume, useFrames: true, transition: "linear"});
			if (this.so) this.so.setPropValue("levelVolume" + modelSoundControl.name, String(modelSoundControl.tweenLevelVolume));
		}
		
	}
	
}