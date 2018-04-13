package tl.types {
	
	public class ArrayUtils extends Singleton {
		
		static public function fill(arr: *, value: *): void {
			for (var i: uint = 0; i < arr.length; i++)
				arr[i] = value;
		}
		
		static public function remove(arr: *, element: *): Boolean {
        	var isRemoved: Boolean = false;
        	var i: uint = 0;
        	while ((i < arr.length) && (!isRemoved)) {
        		if (arr[i] == element) {
        			arr.splice(i, 1);
        			isRemoved = true;
        		}
        		i++;
        	}
        	return isRemoved;
        }
		
		static public function removeByProperty(arr: *, propertyName: String, propertyValue: *): Boolean {
        	var isRemoved: Boolean = false;
        	var i: uint = 0;
        	while ((i < arr.length) && (!isRemoved)) {
        		if (arr[i][propertyName] == propertyValue) {
        			arr.splice(i, 1);
        			isRemoved = true;
        		}
        		i++;
        	}
        	return isRemoved;
        }
				
		static public function getElementIndexByProperty(arr: *, propertyName: String, propertyValue: *): int {
        	var elementIndex: int = -1;
        	var i: uint = 0;
			var arrPropertyName: Array = [];
			if (propertyName.length) arrPropertyName = propertyName.split(".");
        	while ((i < arr.length) && (elementIndex == -1)) {
				var propertyValueInArr: * = arr[i];
				for (var j: uint = 0; j < arrPropertyName.length; j++) propertyValueInArr = propertyValueInArr[arrPropertyName[j]];
        		if (propertyValueInArr == propertyValue) elementIndex = i;
        		i++;
        	}
        	return elementIndex;
        }
		
		static public function getElementArrIndexByProperty(arr: *, propertyName: String, propertyValue: *): Array {
        	var elementArrIndex: Array = [];
        	var i: uint = 0;
			var arrPropertyName: Array = [];
			if (propertyName.length) arrPropertyName = propertyName.split(".");
        	while (i < arr.length) {
				var propertyValueInArr: * = arr[i];
				for (var j: uint = 0; j < arrPropertyName.length; j++) propertyValueInArr = propertyValueInArr[arrPropertyName[j]];
        		if (propertyValueInArr == propertyValue) elementArrIndex.push(i);
        		i++;
        	}
        	return elementArrIndex;
        }
		
		static public function move(arr: *, indexFrom: uint, indexTo: uint): void {
			var elementMoved: * = arr.splice(indexFrom, 1);
			arr.splice(indexTo, 0, elementMoved);
		}
		
		static public function generateRandomIndexArray(length: uint, isForceMix: Boolean = true): Array {
			var arrRandomIndex: Array = new Array();
			for (var i: uint = 0; i < length; i++) {
				var index: uint;
				do {
					index = Math.floor(Math.random() * length);
				} while ((arrRandomIndex.indexOf(index) > -1) || (isForceMix && (arrRandomIndex.length < length - 1) && (index == arrRandomIndex.length)));
				arrRandomIndex.push(index);
			}
			return arrRandomIndex;
		}
		
		static public function generateRandomMixedArray(arrToMix: *, isForceMix: Boolean = true): Array {
			var arrInd: Array = ArrayUtils.generateRandomIndexArray(arrToMix.length);
			var arrMix: Array = new Array(arrToMix.length);
			for (var i: uint = 0; i < arrToMix.length; i++)
				arrMix[i] = arrToMix[arrInd[i]];
			return arrMix;
		}
		
		static public function concatUnique(arrToConcat1: *, arrToConcat2: *, isNewArray: Boolean = true): * {
			if (isNewArray) arrToConcat1 = arrToConcat1.concat();
			for (var i: uint = 0; i < arrToConcat2.length; i++) if (arrToConcat1.indexOf(arrToConcat2[i]) == -1) arrToConcat1.push(arrToConcat2[i]);
			return arrToConcat1;
		}
		
		static public function compareElements(arr: *, arrToCompare: *, isComparedMayBeLonger: Boolean = false): Boolean {
			if ((arrToCompare.length == arr.length) || ((isComparedMayBeLonger) && (arrToCompare.length > arr.length))) {
				var i: uint = 0;
				while ((i < arr.length) && (arr[i] == arrToCompare[i])) i++;
				return Boolean(i == arr.length);
			} else return false
		}
		
		static public function convertToArray(iterable: *): Array {
			var arr: Array = [];
			for each (var elem: * in iterable) arr.push(elem);
			return arr;
		}
		
	}

}