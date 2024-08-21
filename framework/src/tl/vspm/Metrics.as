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
	import libraries.uanalytics.tracker.AppTracker;
	import libraries.uanalytics.utils.*;
	import pl.nowaera.piwik.settings.PiwikSettings;
	import libraries.uanalytics.tracking.Tracker;
	import pl.nowaera.piwik.PiwikTracker;
	
	public class Metrics extends Sprite {
		
		static public const GA: String = "ga";
		static public const OMNITURE: String = "omniture";
		static public const PIWIK: String = "piwik";
		static private const ARR_POSSIBLE_TYPE: Array = [GA, OMNITURE, PIWIK];
		
		static public var vecMetrics: Vector.<Metrics>;
		
		private var _type: String;
		private var data: Object;
		private var isOnlyForwardTrack: Boolean;
		private var _tracker: *;
		
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
				this._type = type;
				if (type == Metrics.GA) this.data = String(dataPrimitive.value);
				else if ((type == Metrics.OMNITURE) || (type == Metrics.PIWIK)) this.data = dataPrimitive;
				this.isOnlyForwardTrack = Boolean(uint(dataPrimitive.isOnlyForwardTrack));
				if (this.data) {
					//try {
						if (type == Metrics.GA) {
							this._tracker = new AppTracker(String(this.data));
							this._tracker.add(generateAIRAppInfo().toDictionary());
							this._tracker.add(generateAIRSystemInfo().toDictionary());
						} else if (type == Metrics.OMNITURE) {
							this._tracker = new this.baseClassTracker(this.data);
						} else if (type == Metrics.PIWIK) {
							this._tracker = new this.baseClassTracker(new PiwikSettings(this.data.idSite, this.data.url));
						}
					//} catch (e: Error) {}
				} else throw new Error("No data in given metrics!");
			} else throw new Error("Metrics is not of possible types!");
		}
		
		internal function trackView(indView: String, titleView: String, isBackwardForward: uint): void {
			if (!this.isOnlyForwardTrack || isBackwardForward == 1) {
				//trace("trackView:", indView)
				this._tracker.pageview(indView, titleView);
			}
		}
		
		internal function trackLink(urlLink: String, titleLink: String): void {
			if (this.type == Metrics.PIWIK) PiwikTracker(this._tracker).link(urlLink, titleLink);
		}
		
		internal function trackEvent(category: String, action: String, label: String = "", value: int = -1): void {
			if ((this.type == Metrics.GA) || (this.type == Metrics.PIWIK)) this._tracker.event(category, action, label, value);
		}
		
		public function get tracker(): * {
			return this._tracker;
		}
		
		public function get type(): String {
			return this._type;
		}
		
		public function get baseClassTracker(): Class {
			var result: Class;
			switch (this._type) {
				case Metrics.GA: result = Tracker; break;
				case Metrics.OMNITURE: result = OmnitureTracker; break;
				case Metrics.PIWIK: result = PiwikTracker; break;
				
			}
			return result;
		}
		
	}

}