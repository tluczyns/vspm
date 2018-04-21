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
	import com.greensock.TimelineMax;
	import com.greensock.TweenMax;
	import com.greensock.easing.Linear;

	public class View extends Sprite implements IViewSection {
		
		public var description: DescriptionView;
		
		protected var isHideShow: uint;
		public var tMaxHideShow: TimelineMax;
		
		public function View(description: DescriptionView): void {
			this.description = description;
		}
		
		public function get content(): ContentView {
			return this.description.content;
		}
		
		public function init(): void {
			//override it: add elements
			//if (!this.tMaxHideShow) this.alpha = 0;
		}
		
		protected function hideShowTimelineMax(isHideShow: uint): void {
			if (isHideShow == 0) {
				this.tMaxHideShow.reverse();
				if (this.tMaxHideShow.totalProgress() == 0) this.hideComplete();
			} else if (isHideShow == 1) {
				this.tMaxHideShow.play();
				if (this.tMaxHideShow.totalProgress() == 1) this.startAfterShow();
			}
		}
		
		protected function hideShowEmpty(isHideShow: uint, timeDelayStartAfterShow: Number): void {
			TweenMax.killDelayedCallsTo(this.startAfterShow);
			if (isHideShow == 0) this.hideComplete();
			else if (isHideShow == 1) TweenMax.delayedCall(timeDelayStartAfterShow, this.startAfterShow);
		}
		
		protected function hideShow(isHideShow: uint): void {
			//Tweener.addTween(this, {alpha: isHideShow, time: 0.3, transition: "linear", onComplete: [this.hideComplete, this.startAfterShow][isHideShow]});
			if (this.tMaxHideShow) this.hideShowTimelineMax(isHideShow);
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
			this.destroy();
		}
		
		protected function destroy(): void {
			//override it to remove elements
			if (this.tMaxHideShow) {
				this.tMaxHideShow.kill();
				this.tMaxHideShow = null;
			}
		}
		
	}

}