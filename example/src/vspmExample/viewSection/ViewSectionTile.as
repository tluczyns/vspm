package vspmExample.viewSection {
	import tl.vspm.ViewSection;
	import tl.vspm.DescriptionViewSection;
	import tl.vspm.ContentViewSection;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	import tl.vspm.SWFAddress;
	
	public class ViewSectionTile extends ViewSection {
		
		static internal const MARGIN_BETWEEN_TILES: Number = 20;
		
		private var tileColorAndLabel: TileColorAndLabel;
		
		public function ViewSectionTile(description: DescriptionViewSection): void {
			super(description);
		}
			
		override public function init(): void {
			this.createTileColorAndLabel();
			super.init();
		}
		
		private function createTileColorAndLabel(): void {
			this.tileColorAndLabel = new TileColorAndLabel(this.content.color, this.content.label);
			this.tileColorAndLabel.x = ContentViewSection(this.content).order * (TileColorAndLabel.DIMENSION_TILE + ViewSectionTile.MARGIN_BETWEEN_TILES);
			this.tileColorAndLabel.y = (ContentViewSection(this.content).depth + 1) * (TileColorAndLabel.DIMENSION_TILE + ViewSectionTile.MARGIN_BETWEEN_TILES);
			this.tileColorAndLabel.addEventListener(MouseEvent.CLICK, this.onClick);
			this.addChild(this.tileColorAndLabel);
		}
		
		private function onClick(e: MouseEvent):void {
			SWFAddress.setValue(this.content.indSectionTarget);
		}
		
		private function removeTileColorAndLabel(): void {
			this.removeChild(this.tileColorAndLabel);
			this.tileColorAndLabel.removeEventListener(MouseEvent.CLICK, this.onClick);
			this.tileColorAndLabel.destroy();
			this.tileColorAndLabel = null;
		}
		
		override protected function hideComplete(): void {
			this.removeTileColorAndLabel();
			super.hideComplete();
		}
		
	}

}