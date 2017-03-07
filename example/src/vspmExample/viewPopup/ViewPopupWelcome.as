package vspmExample.viewPopup {
	import tl.vspm.ContentViewPopup;
	import vspmExample.viewSection.TileColorAndLabel;
	
	public class ViewPopupWelcome extends ViewPopupFg {
		
		public function ViewPopupWelcome(content: ContentViewPopup): void {
			super(content);
		}
		
		override protected function createTileColorAndLabel(): void {
			super.createTileColorAndLabel();
			this.tileColorAndLabel.x = (this.stage.stageWidth - TileColorAndLabel.DIMENSION_TILE) / 2;
			this.tileColorAndLabel.y = (this.stage.stageHeight - TileColorAndLabel.DIMENSION_TILE) / 2;
		}

		
	}

}