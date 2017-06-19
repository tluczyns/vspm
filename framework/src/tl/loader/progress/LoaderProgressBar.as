package tl.loader.progress {
	import flash.display.Sprite;
	import flash.display.Shape;
	import flash.text.TextField;
	
	public class LoaderProgressBar extends LoaderProgress {
		
		private var bg: Sprite;
		private var bar: Sprite;
		private var maskBar: Shape;
		private var isVerticalHorizontal: uint;
		
		public function LoaderProgressBar(bg: Sprite, bar: Sprite, isVerticalHorizontal: uint, isTFPercentBelowAboveBar: uint = 0, tfPercent: TextField = null, isTLOrCenterAnchorPointWhenCenterOnStage: uint = 0, timeFramesTweenPercent: Number = 0.5): void {
			this.bg = bg;
			this.bar = bar;
			this.isVerticalHorizontal = isVerticalHorizontal;
			super(tfPercent, isTLOrCenterAnchorPointWhenCenterOnStage, timeFramesTweenPercent);
			this.createElements();
			this.repositionTFPercent(isTFPercentBelowAboveBar);
		}
		
		private function createElements(): void {
			this.containerElements.addChild(this.bg);
			this.maskBar = new Shape();
			this.maskBar.graphics.beginFill(0, 1);
			this.maskBar.graphics.drawRect(0, 0, this.bg.width, this.bg.height);
			this.maskBar.graphics.endFill();
			this.containerElements.addChild(this.maskBar);
			this.bar.mask = this.maskBar;
			this.containerElements.addChild(this.bar);
			this.maskBar[["width", "height"][this.isVerticalHorizontal]] = 0;
		}
		
		private function repositionTFPercent(isTFPercentBelowAboveBar: uint = 0): void {
			if (this.tfPercent) {
				this.basePosXTfPercent = this.bg.width / 2;
				var marginYTFPercent: Number = this.tfPercent.height * 0.3;
				this.tfPercent.y = Math.round([this.bg.height + marginYTFPercent, - this.tfPercent.height - marginYTFPercent * 0.8][isTFPercentBelowAboveBar]);
			}
		}
		
		override protected function update(): void {
			this.maskBar[["width", "height"][this.isVerticalHorizontal]] = this.ratioProgress * this.bg[["width", "height"][this.isVerticalHorizontal]];
			super.update();
		}
		
		override public function destroy(): void {
			this.bar.mask = null;
			this.containerElements.removeChild(this.bar);
			this.bar = null;
			this.maskBar.graphics.clear();
			this.containerElements.removeChild(this.maskBar);
			this.maskBar = null;
			this.containerElements.removeChild(this.bg);
			this.bg = null;
			super.destroy();
		}
		
	}
	
}