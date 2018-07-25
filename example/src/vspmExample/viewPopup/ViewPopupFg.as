package vspmExample.viewPopup {
	import tl.vspm.ViewPopup;
	import vspmExample.viewSection.TileColorAndLabel;
	import tl.vspm.DescriptionViewPopup;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	import tl.vspm.SWFAddress;
	
	public class ViewPopupFg extends ViewPopup {
		
		static internal const MARGIN_BETWEEN_TILES: Number = 20;
		
		protected var tileColorAndLabel: TileColorAndLabel;
		
		public function ViewPopupFg(description: DescriptionViewPopup): void {
			if (!description.content.dataClick) description.content.dataClick = "";
			super(description);
		}
		
		override public function init(): void {
			this.createTileColorAndLabel();
			super.init();
		}
		
		protected function createTileColorAndLabel(): void {
			this.tileColorAndLabel = new TileColorAndLabel(this.content.color, this.content.label);
			this.tileColorAndLabel.addEventListener(MouseEvent.CLICK, this.onClick);
			this.addChild(this.tileColorAndLabel);
		}
		
		private function onClick(e: MouseEvent):void {
			//SWFAddress.setPathWithParameters(this.content.indSectionTarget, JSON.parse(this.dataClick2), false);
			//SWFAddress.setValue(this.content.indSectionTarget);
			SWFAddress.setCurrentValueWithParameters(JSON.parse(this.content.dataClick), false);
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