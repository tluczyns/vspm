package tl.vspm.helper {
	import flash.display.Sprite;
	import tl.btn.BtnHit;
	import tl.vspm.DescriptionView;
	import tl.vspm.DescriptionViewSection;
	import tl.vspm.EventModel;
	import tl.vspm.EventStateModel;
	import tl.vspm.LoaderXMLContentView;
	import tl.vspm.ManagerSection;
	import tl.vspm.StateModel;
	import tl.vspm.View;
	import tl.btn.InjectorBtnHitVSPM;
	import tl.btn.EventBtnHit;
	import tl.btn.InjectorBtnHit;
	import tl.vspm.SWFAddress;
	
	public class Menu extends Sprite {
		
		private var vecDescriptionViewSectionForBtn: Vector.<DescriptionViewSection>;
		private var lengthBaseIndSection: uint;
		private var isOpenSectionFromFirstBtn: Boolean;
		private var _numActiveBtn: int = -1;
		
		public var vecBtn: Vector.<BtnHit>;
		
		public function Menu(baseIndSection: String, suffIndSectionForBtn: String, isOpenSectionFromFirstBtn: Boolean = true): void {
			this.isOpenSectionFromFirstBtn = isOpenSectionFromFirstBtn;
			this.lengthBaseIndSection = ManagerSection.getLengthIndSection(baseIndSection);
			this.vecDescriptionViewSectionForBtn = Vector.<DescriptionViewSection>(LoaderXMLContentView.dictIndViewSectionToVecDescriptionSubViewSection[baseIndSection]).map(function(descriptionViewSection: DescriptionViewSection, i: uint, vec: Vector.<DescriptionViewSection>): Boolean {
				return (ManagerSection.getElementIndSection(this.lengthBaseIndSection, descriptionViewSection.ind) == suffIndSectionForBtn);
			});
			if (this.isOpenSectionFromFirstBtn) {
				StateModel.addEventListener(EventStateModel.START_CHANGE_SECTION, this.checkAndOpenSectionFromFirstBtn);
				StateModel.addEventListener(EventStateModel.CHANGE_SECTION, this.checkAndOpenSectionFromFirstBtn);
				this.checkAndOpenSectionFromFirstBtn();
			}
			StateModel.addEventListener(EventStateModel.START_CHANGE_SECTION, this.checkAndSetBtnActive);
			StateModel.addEventListener(EventStateModel.CHANGE_SECTION, this.checkAndSetBtnActive);
		}
		
		private function createBtns(): void {
			this.vecBtn = new Vector.<BtnHit>(this.vecDescriptionViewSectionForBtn.length);
			this.initArrangeBtns();
			var descriptionViewSection: DescriptionViewSection;
			for (var i: uint = 0; i < this.vecDescriptionViewSectionForBtn.length; i++) {
				descriptionViewSection = this.vecDescriptionViewSectionForBtn[i];
				var btn: BtnHit = this.getBtn(descriptionViewSection);
				btn.addInjector(new InjectorBtnHitVSPM(descriptionViewSection ));
				this.arrangeBtn(btn);
				btn.addEventListener(EventBtnHit.CLICKED, this.onBtnClicked);
				this.addChild(btn);
				this.vecBtn[i] = btn;
			}
		}
		
		protected function getBtn(descriptionViewSection: DescriptionViewSection): BtnHit {
			return null;
		}
		
		protected function initArrangeBtns(): void {
			
		}
		
		protected function arrangeBtn(btn: BtnHit): void {
			
		}
		
		protected function onBtnClicked(e: EventBtnHit): void {
			SWFAddress.setValueWithParameters(this.getIndSectionForBtn(BtnHit(e.target)), {});
		}
		
		protected function getIndSectionForBtn(btn: BtnHit): String {
			var injectorVSPM: InjectorBtnHitVSPM = btn.vecInjector.filter(function(injector: InjectorBtnHit, num: uint, vec: * ) {trace("vec:", vec);  return injector is InjectorBtnHitVSPM})[0];
			return injectorVSPM.descriptionView.ind;
		}
		
		private function deleteBtns(): void {
			for (var i: uint = 0; i < this.vecBtn.length; i++) {
				var btn: BtnHit = this.vecBtn[i];
				this.removeChild(btn);
				btn.removeEventListener(EventBtnHit.CLICKED, this.onBtnClicked);
				btn.destroy();
				btn = null;
			}
			this.vecBtn = new <BtnHit>[];
			this.sumWidth = 0;
		}
		
		//open first btn
		
		private function checkAndOpenSectionFromFirstBtn(e: EventStateModel = null): void {
			var indSection: String = (e.type == EventStateModel.CHANGE_SECTION) ? ManagerSection.currIndSection : ManagerSection.newIndSection;
			if ((ManagerSection.getElementIndSection(this.lengthBaseIndSection, indSection) == "") || (!ManagerSection.dictDescriptionViewSection[indSection]))
				SWFAddress.setValueWithCurrentParameters(this.vecBtn[0].dispatchEvent(new EventBtnHit(EventBtnHit.CLICKED)));
		}
		
		//set btn active
		
		private function checkAndSetBtnActive(e: EventStateModel): void {
			var indSection: String = (e.type == EventStateModel.CHANGE_SECTION) ? ManagerSection.currIndSection : ManagerSection.newIndSection;
			var indSectionToMatchWithBtn: String = ManagerSection.getSubstringIndSection(0, this.lengthBaseIndSection + 1, indSection);
			var i: uint = 0;
			while ((i < this.vecDescriptionViewSectionForBtn.length) && (this.vecDescriptionViewSectionForBtn[i].ind != indSectionToMatchWithBtn)) //(!ManagerSection.isEqualsElementsIndSection(this.vecDescriptionViewSectionForBtn[i].ind, indSection))
				i++; 
			this.numActiveBtn = (i < this.vecDescriptionViewSectionForBtn.length) ? i : -1;
		}
		
		public function get numActiveBtn(): int {
			return this._numActiveBtn;
		}
		
		public function set numActiveBtn(value: int): void {
			if (value != this._numActiveBtn) {
				this._numActiveBtn = value;
				this.dispatchEvent(new EventModel(Menu.CHANGED_NUM_ACTIVE_BTN, value));
			}
		}
		
		//
		
		public function destroy(): void {
			StateModel.removeEventListener(EventStateModel.START_CHANGE_SECTION, this.checkAndSetBtnActive);
			StateModel.removeEventListener(EventStateModel.CHANGE_SECTION, this.checkAndSetBtnActive);
			if (this.isOpenSectionFromFirstBtn) {
				StateModel.removeEventListener(EventStateModel.START_CHANGE_SECTION, this.checkAndOpenSectionFromFirstBtn);
				StateModel.removeEventListener(EventStateModel.CHANGE_SECTION, this.checkAndOpenSectionFromFirstBtn);
				this.checkAndOpenSectionFromFirstBtn();
			}
			this.deleteBtns();
		}
		
	}
	
}