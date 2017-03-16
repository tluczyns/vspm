package tl.loader.progress {
	import flash.display.Sprite;
	import flash.display.Shape;
	import flash.text.TextField;
	
	public class LoaderProgressBar extends LoaderProgress {
		
		private var bg: Sprite;
		private var bar: Sprite;
		private var maskBar: Shape;
		private var isVerticalHorizontal: uint;
		
		public function LoaderProgressBar(bg: Sprite, bar: Sprite, isVerticalHorizontal: uint, tfPercent: TextField = null, isTLOrCenterAnchorPointWhenCenterOnStage: uint = 0, timeFramesTweenPercent: Number = 0.5): void {
			this.bg = bg;
			this.bar = bar;
			this.isVerticalHorizontal = isVerticalHorizontal;
			this.createElements();
			super(tfPercent, isTLOrCenterAnchorPointWhenCenterOnStage, timeFramesTweenPercent);
			this.repositionBgAndBar();
		}
		
		private function createElements(): void {
			this.addChild(this.bg);
			this.maskBar = new Shape();
			this.maskBar.graphics.beginFill(0, 1);
			this.maskBar.graphics.drawRect(0, 0, this.bg.width, this.bg.height);
			this.maskBar.graphics.endFill();
			this.addChild(this.maskBar);
			this.bar.mask = this.maskBar;
			this.addChild(this.bar);
			this.maskBar[["width", "height"][this.isVerticalHorizontal]] = 0;
		}
		
		private function changeDimensionBar(): void {
			this.maskBar[["width", "height"][this.isVerticalHorizontal]] = this.ratioProgress * this.bg[["width", "height"][this.isVerticalHorizontal]];
		}
		
		override protected function update(): void {
			this.changeDimensionBar();
			super.update();
		}
		
		protected function repositionBgAndBar(newPosX: Number = 0, newPosY: Number = 0): void {
			this.maskBar.x = this.bg.x = this.bar.x = newPosX;
			this.maskBar.y = this.bg.y = this.bar.y = newPosY;
			if (this.tfPercent) {
				this.basePosXTfPercent = bg.width / 2;
				this.tfPercent.y = Math.round(bg.height + this.tfPercent.height * 0.3);
			}
		}
		
		override public function destroy(): void {
			this.bar.mask = null;
			this.removeChild(this.bar);
			this.maskBar.graphics.clear();
			this.removeChild(this.maskBar);
			this.maskBar = null;
			this.removeChild(this.bg)
			super.destroy();
		}
		
	}
	
}