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
	import flash.display.Stage;
	import com.google.analytics.GATracker;

	public class Metrics extends Sprite {
		
		static private const GA: String = "ga";
		static private const OMNITURE: String = "omniture";
		static private const ARR_POSSIBLE_TYPE: Array = [GA, OMNITURE];
		
		static internal var vecMetrics: Vector.<Metrics>;
		
		private var type: String;
		private var data: Object;
		private var isOnlyForwardTrack: Boolean;
		private var tracker: *;
		
		static internal function createVecMetricsFromContent(content: Object, stage: Stage): void {
			Metrics.vecMetrics = new Vector.<Metrics>();
			for (var i: uint = 0; i < Metrics.ARR_POSSIBLE_TYPE.length; i++) {
				var possibleType: String = Metrics.ARR_POSSIBLE_TYPE[i];
				if (content[possibleType]) {
					var metrics: Metrics = new Metrics();
					stage.addChild(metrics);
					metrics.init(possibleType, content[possibleType]);
					Metrics.vecMetrics.push(metrics);
				}
			}
		}
		
		public function Metrics(): void {}
		
		private function init(type: String, dataPrimitive: Object): void {
			if (Metrics.ARR_POSSIBLE_TYPE.indexOf(type) != -1) {
				this.type = type;
				if (this.type == Metrics.GA) this.data = String(dataPrimitive.value);
				else if (this.type == Metrics.OMNITURE) this.data = dataPrimitive;
				this.isOnlyForwardTrack = Boolean(uint(dataPrimitive.isOnlyForwardTrack));
				if (this.data) {
					//try {
						if (this.type == Metrics.GA) this.tracker = new GATracker(this, String(this.data));
						else if (this.type == Metrics.OMNITURE) this.tracker = new OmnitureTracker(this.data);
					//} catch (e: Error) {}
				} else throw new Error("No data in given metrics!");
			} else throw new Error("Metrics is not of possible types!");
		}
		
		internal function trackView(indView: String, isBackwardForward: uint): void {
			if (!this.isOnlyForwardTrack || isBackwardForward == 1) {
				//trace("trackPageview:", indView)
				this.tracker.trackPageview(indView);
			}
		}
		
	}

}