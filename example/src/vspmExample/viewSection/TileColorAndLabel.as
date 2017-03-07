package vspmExample.viewSection {
	import flash.display.Sprite;
	import flash.display.Shape;
	import flash.text.TextField;
	import tl.tf.TextFieldUtilsLite;
	import flash.text.TextFormat;
	import vspmExample.Config;
	import flash.text.TextFormatAlign;
	
	public class TileColorAndLabel extends Sprite {
		
		static public const DIMENSION_TILE: Number = 150;
		
		private var shpRectColor: Shape;
		private var tfLabel: TextField;
		
		public function TileColorAndLabel(colorRect: uint, strLabel: String): void {
			this.createShpRectColor(colorRect);
			this.createTfLabel(strLabel);
			this.useHandCursor = true;
		}
		
		private function createShpRectColor(colorRect: uint): void {
			this.shpRectColor = new Shape();
			this.shpRectColor.graphics.clear();
			this.shpRectColor.graphics.beginFill(colorRect, 1);
			this.shpRectColor.graphics.drawRect(0, 0, TileColorAndLabel.DIMENSION_TILE, TileColorAndLabel.DIMENSION_TILE)
			//this.shpRectColor.graphics.endFill();
			this.addChild(this.shpRectColor);
		}
		
		private function removeShpRectColor(): void {
			this.removeChild(this.shpRectColor);
			this.shpRectColor = null;
		}
		
		private function createTfLabel(strLabel: String): void {
			var offset:int = 10;
            this.tfLabel = TextFieldUtilsLite.createTextField(new TextFormat(Config.FONT, 16, 0x333333, null, null, null, null, null, TextFormatAlign.CENTER), 0, 1);
			this.tfLabel.width = TileColorAndLabel.DIMENSION_TILE - 2 * offset;
			this.tfLabel.height = TileColorAndLabel.DIMENSION_TILE - 2 * offset;
			this.tfLabel.text = strLabel;
			this.tfLabel.x = offset;
			this.tfLabel.y = (TileColorAndLabel.DIMENSION_TILE - this.tfLabel.height) / 2; 
            this.addChild(this.tfLabel);
		}
		
		private function removeTfLabel(): void {
			this.removeChild(this.tfLabel);
			this.tfLabel = null;
		}
		
		public function destroy(): void {
			this.removeTfLabel();
			this.removeShpRectColor();
		}
		
	}

}