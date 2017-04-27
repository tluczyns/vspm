package tl.sound {
	import flash.events.IEventDispatcher;
	
	public interface IModelSoundControl extends IEventDispatcher {
		
		function get levelVolume(): Number;
		function set levelVolume(value: Number): void;	
		function get tweenLevelVolume(): Number;
		function set tweenLevelVolume(value: Number): void;
		function get isSoundOffOn(): uint;
		function set isSoundOffOn(value: uint): void;
		
	}

}