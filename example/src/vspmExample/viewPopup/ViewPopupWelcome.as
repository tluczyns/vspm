package vspmExample.viewPopup {
	import tl.vspm.DescriptionViewPopup;
	import vspmExample.viewSection.TileColorAndLabel;
	
	public class ViewPopupWelcome extends ViewPopupFg {
		
		public function ViewPopupWelcome(description: DescriptionViewPopup): void {
			super(description);
		}
		
		override protected function createTileColorAndLabel(): void {
			super.createTileColorAndLabel();
			this.tileColorAndLabel.x = (this.stage.stageWidth - TileColorAndLabel.DIMENSION_TILE) / 2;
			this.tileColorAndLabel.y = (this.stage.stageHeight - TileColorAndLabel.DIMENSION_TILE) / 2;
		}

		
	}

}