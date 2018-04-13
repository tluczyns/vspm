/**
 * View Section and Popup Manager (VSPM)  <https://github.com/tluczyns/vspm>
 * Frontend multilevel subpage manager developed according to MVC pattern.
 * VSPM is (c) 2009-2017 Tomasz Luczynski
 * Licensed under MIT License
 *
 * @author		Tomasz Luczynski <tluczyns@gmail.com> <http://www.programuje.pl>
 * @version		1.3
 */
package tl.vspm {
	
	public class ViewSectionWithLoading extends ViewSection {
		
		private var _isNoneLoadingHidepreloaderLoaded: uint = 0;
		private var isHideShowAfterHidePreloader: uint;
		
		public function ViewSectionWithLoading(description: DescriptionViewSection): void {
			super(description);
		}
		
		override public function show(): void {
			//trace("this.isLoading:" + this.isLoading, "this.isLoaded:" + this.isLoaded);
			if (this.isNoneLoadingHidepreloaderLoaded == 0) {
				if (this.startLoading()) {
					this.isNoneLoadingHidepreloaderLoaded = 1;
				} else {
					this.isNoneLoadingHidepreloaderLoaded = 3;
					this.initAfterLoading();
					this.showAfterLoading();
				}
			} else if (this.isNoneLoadingHidepreloaderLoaded == 1)
				super.startAfterShow(); //gdy w czasie ładowania chcemy przejść sekcję głębiej
			else if (this.isNoneLoadingHidepreloaderLoaded == 2)
				this.isHideShowAfterHidePreloader = 1;
			else if (this.isNoneLoadingHidepreloaderLoaded == 3)
				this.showAfterLoading();
		}
		
		protected function startLoading(): Boolean {
			trace("startLoading: override this");
			return true;
		}
		
		private function get isNoneLoadingHidepreloaderLoaded(): uint {
			return this._isNoneLoadingHidepreloaderLoaded;
		}
		
		private function set isNoneLoadingHidepreloaderLoaded(value: uint): void {
			if (value != this._isNoneLoadingHidepreloaderLoaded) {
				if ((this._isNoneLoadingHidepreloaderLoaded == 0) && (value == 1)) this.addRemovePreloader(1);
				else if ((this._isNoneLoadingHidepreloaderLoaded == 1) && (value == 2)) this.addRemovePreloader(0);
				this._isNoneLoadingHidepreloaderLoaded = value;
			}
		}
		
		protected function addRemovePreloader(isRemoveAdd: uint): void {
			trace("addRemovePreloader: override this");
			//odpalana gdy nie ma preloadera
			if (isRemoveAdd == 0) this.finishRemovePreloader();
		}
		
		protected function finishRemovePreloader(): void {
			if (this.isHideShowAfterHidePreloader == 0) super.hideComplete();
			else if (this.isHideShowAfterHidePreloader == 1) {
				this.isNoneLoadingHidepreloaderLoaded = 3;
				this.initAfterLoading();
				this.showAfterLoading();
			}
		}
		
		protected function abortLoading(): void {
			trace("abortLoading: override this");
		}
		
		protected function initAfterLoading(): void {
			trace("initAfterLoading: override this");
		}
		
		private function showAfterLoading(): void {
			this.hideShow(1);
		}
		
		protected function finishLoading(): void {
			this.isHideShowAfterHidePreloader = 1;
			this.isNoneLoadingHidepreloaderLoaded = 2;
		}
		
		private function hideAfterLoading(): void {
			this.hideShow(0);
		}
		
		override public function hide(): void {
			this.stopBeforeHide();
			if ((this.isNoneLoadingHidepreloaderLoaded == 1) || (this.isNoneLoadingHidepreloaderLoaded == 2)) {
				this.isHideShowAfterHidePreloader = 0;
				if (this.isNoneLoadingHidepreloaderLoaded == 1) {
					this.abortLoading();
					this.isNoneLoadingHidepreloaderLoaded = 2;
				}
			} else if (this.isNoneLoadingHidepreloaderLoaded == 3) {
				this.hideAfterLoading();
			}
		}
		
	}
	
}