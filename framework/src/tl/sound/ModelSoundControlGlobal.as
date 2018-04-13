package tl.sound {
	import flash.utils.Dictionary;
	import tl.so.SharedObjectInstance;
	
	public class ModelSoundControlGlobal extends ModelSoundControl {
		
		static private var _instance: ModelSoundControlGlobal;

		private var dictModelSoundControl: Dictionary;
		
		public function ModelSoundControlGlobal(vecNameModelSoundControl: Vector.<String>, soName: String = "", stepChangeLevelVolume: Number = 0.05): void {
			if (!ModelSoundControlGlobal._instance) {
				this.dictModelSoundControl = new Dictionary();
				var so: SharedObjectInstance;
				if (soName != "") so = new SharedObjectInstance(soName);
				super("", so, stepChangeLevelVolume, 1);
				var nameModelSoundControl: String;
				var maxLevelVolumeModelSoundControl: Number = [1, 0][uint(vecNameModelSoundControl.length > 0)];
				for (var i: uint = 0; i < vecNameModelSoundControl.length; i++) {
					nameModelSoundControl = vecNameModelSoundControl[i];
					this.dictModelSoundControl[nameModelSoundControl] = new ModelSoundControl(nameModelSoundControl, so, stepChangeLevelVolume, this.levelVolume);
					maxLevelVolumeModelSoundControl = Math.max(maxLevelVolumeModelSoundControl, this.dictModelSoundControl[nameModelSoundControl].levelVolume)
				}
				this.isSoundOffOn = uint(maxLevelVolumeModelSoundControl > 0);
				ModelSoundControlGlobal._instance = this;
			} //else throw new Error("ModelSoundControlGlobal is a singleten class!");
		}
		
		override public function set levelVolume(value: Number): void {
			for each (var modelSoundControl: ModelSoundControl in this.dictModelSoundControl) 
				modelSoundControl.levelVolume = value;
			super.levelVolume = value;
		}
		
		override public function set tweenLevelVolume(value: Number): void {
			for each (var modelSoundControl: ModelSoundControl in this.dictModelSoundControl)
				modelSoundControl.tweenLevelVolume = value;
			super.tweenLevelVolume = value;
		}
		
		//static access to global model
		
		static public function get levelVolume(): Number { 
			return ModelSoundControlGlobal._instance.levelVolume;
		}
		
		static public function set levelVolume(value: Number): void {
			ModelSoundControlGlobal._instance.levelVolume = value;
		}

		static public function get tweenLevelVolume(): Number { 
			return ModelSoundControlGlobal._instance.tweenLevelVolume;
		}
		
		static public function set tweenLevelVolume(value: Number): void {
			ModelSoundControlGlobal._instance.tweenLevelVolume = value;
		}
		
		static public function get isSoundOffOn(): uint {
			return ModelSoundControlGlobal._instance.isSoundOffOn;
		}
		
		static public function set isSoundOffOn(value: uint): void {
			ModelSoundControlGlobal._instance.isSoundOffOn = value;
		}
		
		static public function addEventListener(type: String, listener: Function): void {
			ModelSoundControlGlobal._instance.addEventListener(type, listener);
		}
		
		static public function removeEventListener(type: String, listener: Function): void {
			ModelSoundControlGlobal._instance.removeEventListener(type, listener);
		}
		
		//
		
		static public function getModel(name: String = ""): ModelSoundControl {
			var model: ModelSoundControl;
			if (!ModelSoundControlGlobal._instance) new ModelSoundControlGlobal(new Vector.<String>());
			if (name == "") model = ModelSoundControlGlobal._instance;
			else if (ModelSoundControlGlobal._instance) model = ModelSoundControlGlobal._instance.dictModelSoundControl[name];
			return model;
		}
		
	}
	
}