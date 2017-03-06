package tl.flashUtils {
	import tl.types.Singleton;
	import tl.types.ArrayExt;
	import flash.utils.*;
	
	public class FlashUtils extends Singleton {
		
		//timeout
		
		private static var arrArgumentsTimeout: ArrayExt = new ArrayExt();
		private static const TIMER_DELAY: uint = 50;
		
		public static function setTimeout(onComplete: Function, /*onCompleteScope: Object, */delay: Number, ... params): uint {
			var idTimeout: uint = flash.utils.setTimeout(FlashUtils.onCompleteCall, delay, FlashUtils.arrArgumentsTimeout.length);
			var timerTimeout: Timer = FlashUtils.createTimerForDelay(delay);
			FlashUtils.arrArgumentsTimeout.push(new ArgumentsTimeoutInterval(idTimeout, timerTimeout, onComplete, null /*onCompleteScope*/, params[0]));
			timerTimeout.start();
			return FlashUtils.arrArgumentsTimeout.length - 1;
		}
		
		public static function pauseTimeout(numArguments: uint): void {
			if ((numArguments < FlashUtils.arrArgumentsTimeout.length) && (FlashUtils.arrArgumentsTimeout[numArguments] != null)) {
				var argumentsTimeout: ArgumentsTimeoutInterval = ArgumentsTimeoutInterval(FlashUtils.arrArgumentsTimeout[numArguments]);
				var timerTimeout: Timer = argumentsTimeout.timer;
				if (timerTimeout.running) {
					flash.utils.clearTimeout(argumentsTimeout.id);
					timerTimeout.stop();
				}
			}
		}
		
		public static function continueTimeout(numArguments: uint): void {
			if ((numArguments < FlashUtils.arrArgumentsTimeout.length) && (FlashUtils.arrArgumentsTimeout[numArguments] != null)) {
				var argumentsTimeout: ArgumentsTimeoutInterval = ArgumentsTimeoutInterval(FlashUtils.arrArgumentsTimeout[numArguments]);
				var timerTimeout: Timer = argumentsTimeout.timer;
				if (!timerTimeout.running) {
					argumentsTimeout.id = flash.utils.setTimeout(FlashUtils.onCompleteCall, FlashUtils.TIMER_DELAY * (timerTimeout.repeatCount - timerTimeout.currentCount), numArguments);
					timerTimeout.start();
				}
			}
		}
		
		public static function clearTimeout(numArguments: uint): void {
			FlashUtils.pauseTimeout(numArguments);
			if ((numArguments < FlashUtils.arrArgumentsTimeout.length) && (FlashUtils.arrArgumentsTimeout[numArguments] != null)) FlashUtils.deleteTimeout(numArguments);
		}
		
		private static function createTimerForDelay(delay: Number): Timer {
			var timerTimeout: Timer = new Timer(FlashUtils.TIMER_DELAY, delay / FlashUtils.TIMER_DELAY);
			return timerTimeout;
		}

		private static function onCompleteCall(numArguments: uint): void {
			var argumentsTimeout: ArgumentsTimeoutInterval = ArgumentsTimeoutInterval(FlashUtils.arrArgumentsTimeout[numArguments]);
			argumentsTimeout.onComplete.apply(null /*argumentsTimeout.onCompleteScope*/, argumentsTimeout.params);
			FlashUtils.deleteTimeout(numArguments);
		}
		
		private static function deleteTimeout(numArguments: uint): void {
			FlashUtils.arrArgumentsTimeout[numArguments] = null
		}
		
		//TODO: intervals
		
		
		//class names
		
		static public function isSuperclass(classCheck: Class, classSuper: Class): Boolean {
			var result: Boolean;
			result = Boolean(classCheck == classSuper) 
			if (!result) {
				var nameClassCheck: String;
				do {
					nameClassCheck = getQualifiedSuperclassName(classCheck);
					if (nameClassCheck != null) classCheck = Class(getDefinitionByName(nameClassCheck));
				} while ((classCheck != classSuper) && (nameClassCheck != null));
				result = Boolean(classCheck == classSuper);
			}
			return result;
		}
		
		static private const VEC_NAME_TYPE_FIELD: Vector.<String> = new <String>["constant", "variable", "accessor", "method", ];
		
		static public function mixin(target: Object, ... rest):void {
			var classTarget: Class = getDefinitionByName(getQualifiedClassName(target)) as Class;
			for each (var objSrc: * in rest) {
				var classSrc: Class;
				if (objSrc is Class) {
					classSrc = objSrc;
					objSrc = new classSrc();
				} else classSrc = Class(getDefinitionByName(getQualifiedClassName(objSrc)))
				var classSuperToSrc: Class = classSrc as Class;
				var XMLObjSrc: XML = describeType(objSrc); //XMLClassSrc: XML = describeType(classSrc);
				var XMLClassSrc: XML;
				var nameField: String;
				while (!FlashUtils.isSuperclass(classTarget, classSuperToSrc)) {
					for (var numNameTypeField: uint = 2 * (1 - uint(classSuperToSrc == classSrc)); numNameTypeField < FlashUtils.VEC_NAME_TYPE_FIELD.length; numNameTypeField++)
						for each (nameField in XMLObjSrc[FlashUtils.VEC_NAME_TYPE_FIELD[numNameTypeField]].(numNameTypeField <= 1 || @declaredBy==getQualifiedClassName(classSuperToSrc)).@name) //XMLClassSrc.factory
							target[nameField] = objSrc[nameField];
					XMLClassSrc = describeType(classSuperToSrc);
					for (numNameTypeField = 0; numNameTypeField < 2; numNameTypeField++) {
						for each (nameField in XMLClassSrc[FlashUtils.VEC_NAME_TYPE_FIELD[numNameTypeField]].(@type=='Function').@name)
							target[nameField] = classSuperToSrc[nameField];
					}
					classSuperToSrc = getDefinitionByName(getQualifiedSuperclassName(classSuperToSrc)) as Class;
				}
			}
		}
		
	}

}