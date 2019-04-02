/**
 * View Section and Popup Manager (VSPM)  <https://github.com/tluczyns/vspm>
 * Frontend multilevel subpage manager developed according to MVC pattern.
 * VSPM is (c) 2009-2017 Tomasz Luczynski
 * Licensed under MIT License
 *
 * @author		Tomasz Luczynski <tluczyns@gmail.com> <http://www.programuje.pl>
 * @version		1.2
 */
package tl.vspm {
	import flash.display.Sprite;
	//import caurina.transitions.Tweener;
	/*
	 * Important: 
	 * Greensock library is NOT a part of this framework.
	 * It is used here only to represent base hide/show animation of the view.
	 * It can be easily replaced by Tweener (just comment/uncomment proper lines in this file) or any other animation library.
	 */
	import com.greensock.core.Animation;
	import com.greensock.TweenMax;
	import com.greensock.easing.Linear;

	public class View extends Sprite implements IViewSection {
		
		public var description: DescriptionView;
		
		protected var isHideShow: uint;
		protected var animationHideShow: Animation;
		
		public function View(description: DescriptionView): void {
			this.description = description;
		}
		
		public function get content(): ContentView {
			return this.description.content;
		}
		
		public function init(): void {
			//override it: add elements
			this.createAnimationHideShow();
			if (!this.animationHideShow) this.alpha = 0;
		}
		
		protected function createAnimationHideShow(): void {
			if (!this.animationHideShow) this.animationHideShow = this.getAnimationHideShow();
		}
		
		protected function getAnimationHideShow(): Animation {
			return null;
			//override it: create animation hideShow
		}
		
		private function deleteAnimationHideShow(): void {
			if (this.animationHideShow) {
				this.animationHideShow.kill();
				this.animationHideShow = null;
			}
		}
		
		protected function hideShowByAnimation(isHideShow: uint): void {
			if (isHideShow == 0) {
				this.animationHideShow.reverse();
				if (this.animationHideShow.totalProgress() == 0) this.hideComplete();
			} else if (isHideShow == 1) {
				this.animationHideShow.play();
				if (this.animationHideShow.totalProgress() == 1) this.startAfterShow();
			}
		}
		
		protected function hideShowEmpty(isHideShow: uint, timeDelayStartAfterShow: Number): void {
			TweenMax.killDelayedCallsTo(this.startAfterShow);
			if (isHideShow == 0) this.hideComplete();
			else if (isHideShow == 1) TweenMax.delayedCall(timeDelayStartAfterShow, this.startAfterShow);
		}
		
		protected function hideShow(isHideShow: uint): void {
			//Tweener.addTween(this, {alpha: isHideShow, time: 0.3, transition: "linear", onComplete: [this.hideComplete, this.startAfterShow][isHideShow]});
			if (this.animationHideShow) this.hideShowByAnimation(isHideShow);
			else {
				TweenMax.killTweensOf(this);
				TweenMax.to(this, 0.3, {alpha: isHideShow, ease: Linear.easeNone, onComplete: [this.hideComplete, this.startAfterShow][isHideShow]});
			}
		}
		
		public function show(): void {
			this.isHideShow = 1;
			this.hideShow(1);
		}
		
		protected function startAfterShow(): void {
			//override it: fe. additional animation, adding listeners and mouse events
		}
		
		protected function stopBeforeHide(): void {
			//override it: fe. removing listeners and mouse events
		}
		
		public function hide(): void {
			this.stopBeforeHide();
			this.isHideShow = 0;
			this.hideShow(0);
		}
		
		protected function hideComplete(): void {
			this.deleteAnimationHideShow();
			this.destroy();
		}
		
		protected function destroy(): void {
			//override it to remove elements
		}
		
	}

}