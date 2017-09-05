package tl.loader.progress {
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.text.TextField;
	import flash.events.ProgressEvent;
	import caurina.transitions.Tweener;
	import tl.loader.QueueLoadContent;

	public class LoaderProgress extends Sprite implements ILoaderProgress {
		
		private var weightForCurrentElement: Number;
		private var weightLoaded: Number;
		private var weightTotal: Number;
		private var arrWeightContentToLoad: Array;
		private var numContentToLoad: int;
		
		protected var containerElements: Sprite;
		protected var tfPercent: TextField;
		private var timeFramesTweenPercent: Number;
		private var isTLOrCenterAnchorPointWhenCenterOnStage: uint;
		public var ratioProgress: Number;
		private var prevRatioLoadedElement: Number;
		private var _basePosXTfPercent: Number;
		
		
		public function LoaderProgress(tfPercent: TextField = null, isTLOrCenterAnchorPointWhenCenterOnStage: uint = 0, timeFramesTweenPercent: Number = 0.5): void {
			this.timeFramesTweenPercent = timeFramesTweenPercent;
			this.isTLOrCenterAnchorPointWhenCenterOnStage = isTLOrCenterAnchorPointWhenCenterOnStage;
			this.createContainerElements();
			this.initTfPercent(tfPercent);
			this.ratioProgress = this.prevRatioLoadedElement = 0;
			this.arrWeightContentToLoad = [];
			this.numContentToLoad = -1;
			this.addEventListener(Event.ADDED_TO_STAGE, this.onAddedToStage);
			this.addEventListener(Event.REMOVED_FROM_STAGE, this.onRemovedFromStage);
		}
		
		private function onAddedToStage(e: Event): void {
			this.containerElements.x = [0, - this.containerElements.width / 2][isTLOrCenterAnchorPointWhenCenterOnStage];
			this.setLoadProgress(0);
			this.stage.addEventListener(Event.RESIZE, this.onStageResize);
			this.stage.dispatchEvent(new Event(Event.RESIZE));
		}
		
		private function onRemovedFromStage(e: Event): void {
			this.stage.removeEventListener(Event.RESIZE, this.onStageResize);
		}
		
		public function onStageResize(e: Event): void {
			this.x = (this.stage.stageWidth - [this.width, 0][this.isTLOrCenterAnchorPointWhenCenterOnStage]) / 2;
			this.y = (this.stage.stageHeight - [this.height, 0][this.isTLOrCenterAnchorPointWhenCenterOnStage]) / 2;
		}
		
		//container elements
		
		private function createContainerElements(): void {
			this.containerElements = new Sprite();
			this.addChild(this.containerElements);
		}
		
		private function removeContainerElements(): void {
			this.removeChild(this.containerElements);
			this.containerElements = null;
		}
		
		//textfield percent
		
		protected function initTfPercent(tfPercent: TextField = null): void {
			if (this.tfPercent == null) this.tfPercent = tfPercent;
			if (this.tfPercent != null) {
				tfPercent.x = Math.round(tfPercent.x);
				tfPercent.y = Math.round(tfPercent.y);
				this.tfPercent.text = "0 %";
				this.containerElements.addChild(this.tfPercent);
				this.basePosXTfPercent = this.tfPercent.x + this.tfPercent.width / 2;
			}
		}
		
		private function removeTfPercent(): void {
			if (this.tfPercent) {
				this.containerElements.removeChild(this.tfPercent);
				this.tfPercent = null;
			}
		}
		
		protected function get basePosXTfPercent(): Number {
			return this._basePosXTfPercent;
		}
		
		protected function set basePosXTfPercent(value: Number): void {
			this._basePosXTfPercent = value;
			this.tfPercent.x =  value - this.tfPercent.width / 2;
		}
		
		//load progress
		
		public function addWeightContent(weight: Number): void {
			this.arrWeightContentToLoad.push(weight);
			this.weightTotal = 0;
			for (var i: uint = 0; i < this.arrWeightContentToLoad.length; i++)
				this.weightTotal += this.arrWeightContentToLoad[i];
		}

		public function initNextLoad(): void {
			this.numContentToLoad++;
			this.weightForCurrentElement = this.arrWeightContentToLoad[this.numContentToLoad];
			this.weightLoaded = 0;
			for (var i: uint = 0; i < this.numContentToLoad; i++)
				this.weightLoaded += this.arrWeightContentToLoad[i];
			this.setLoadProgress(this.weightLoaded / this.weightTotal);
		}
		
		public function onLoadProgress(event: ProgressEvent): void {
			var ratioLoadedElement: Number = event.bytesLoaded / event.bytesTotal;
			if (isNaN(ratioLoadedElement)) ratioLoadedElement = this.prevRatioLoadedElement;
			ratioLoadedElement = Math.max(0, Math.min(1, ratioLoadedElement));
			this.prevRatioLoadedElement = ratioLoadedElement;
			var ratioLoaded: Number = (this.weightLoaded + ratioLoadedElement * this.weightForCurrentElement) / this.weightTotal;
			this.setLoadProgress(ratioLoaded);
		}
		
		public function setLoadProgress(ratioLoaded: Number): void {
			this.updateAndCheckIsFinished();
			Tweener.removeTweens(this);
			Tweener.addTween(this, {ratioProgress: ratioLoaded, time: this.timeFramesTweenPercent, transition: "easeOutCubic", onUpdate: this.updateAndCheckIsFinished});
		}
		
		private function updateAndCheckIsFinished(): void {
			this.update();
			if (this.ratioProgress == 1) this.dispatchEvent(new Event(QueueLoadContent.FINISHED_PROGRESS));
		}
		
		protected function update(): void {
			if (this.tfPercent) {
				this.tfPercent.text = String(Math.round(this.ratioProgress * 100)) + "%";
				this.tfPercent.x = this.basePosXTfPercent - this.tfPercent.width / 2;
			}
			//trace("this.ratioProgress:" + this.ratioProgress);
		}
		
		//destroy
		
		public function destroy(): void {
			if (this.stage != null) this.stage.removeEventListener(Event.RESIZE, this.onStageResize);
			this.removeEventListener(Event.ADDED_TO_STAGE, this.onAddedToStage);
			this.removeEventListener(Event.REMOVED_FROM_STAGE, this.onRemovedFromStage);
			Tweener.removeTweens(this);
			this.removeTfPercent();
			this.removeContainerElements();
		}
		
	}

}