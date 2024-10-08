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
	import tl.loader.Library;
	import flash.utils.getQualifiedClassName;
	import tl.app.HandlerInvokeWithParams;
	import tl.loader.EventLoaderXML;
	import flash.utils.getDefinitionByName;

	public class ApplicationVSPM extends Sprite {
		
		protected var prefixClass: String;
		protected var loaderXMLContent: LoaderXMLContentView;
		protected var containerApplication: ContainerApplicationVSPM;
		
		public function ApplicationVSPM(): void {
			Library.addSwf(this);
			new LoaderImgs();
			var nameClassApplication: String = getQualifiedClassName(this);
			this.prefixClass = nameClassApplication.substr(0, nameClassApplication.indexOf('::'));
		}
		
		public function init(pathAssets: String = "", pathXMLContent: String = "xml/content.xml", strKeyEncryption: String = "", xmlContent: XML = null): void {
			HandlerInvokeWithParams.init(this.stage, this.handleInvokeWithParams, this.paramsInvoke, false, true);
			this.loadXMLContent(pathAssets + pathXMLContent, strKeyEncryption, xmlContent);
		}
		
		public function handleInvokeWithParams(...params): void {
			if ((params) && (params.length >= 1)) {
				var indSection: String = params[0];
				if (indSection)	this.handleInvokeWithIndSection(indSection);
			}
		}
		
		protected function handleInvokeWithIndSection(indSection: String): void {
			SWFAddress.setValueWithParameters(indSection);
		}
		
		protected function get paramsInvoke(): Array {
			return [];
		}
		
		protected function loadXMLContent(pathXMLContent: String, strKeyEncryption: String = "", xmlContent: XML = null): void {
			this.loaderXMLContent = new LoaderXMLContentView(this.prefixClass);
			if (!xmlContent) this.loaderXMLContent.loadXML(pathXMLContent, strKeyEncryption);
			this.loaderXMLContent.addEventListener(EventLoaderXML.XML_LOADED, this.initOnXMLContentLoaded);
			if (xmlContent) {
				this.loaderXMLContent.parseXML(xmlContent);
				this.loaderXMLContent.dispatchEvent(new EventLoaderXML(EventLoaderXML.XML_LOADED, xmlContent));
			}
		}
		
		protected function initOnXMLContentLoaded(e: EventLoaderXML = null): void {
			this.loaderXMLContent.removeEventListener(EventLoaderXML.XML_LOADED, this.initOnXMLContentLoaded);
			this.registerFonts();
			this.loadImgs();
			this.initContainers();
			this.initViews();
		}
		
		protected function registerFonts(): void {}

		protected function loadImgs(): void {
			LoaderImgs.instance.loadImgs();
		}
		
		protected function initContainers(): void {
			var classContainerApplication: Class;
			try {
				classContainerApplication = Class(getDefinitionByName(this.prefixClass + ".container.ContainerApplication"));
			} catch (e: Error) {
				classContainerApplication = ContainerApplicationVSPM;
			}
			this.containerApplication = new classContainerApplication();
			this.addChild(this.containerApplication);
		}
		
		protected function initViews(startIndSection: String = ""): void {
			ManagerPopup.init(containerApplication.containerViewPopup);
			ManagerSection.init(containerApplication.containerViewSection, startIndSection);
			this.createMetrics();
			HandlerInvokeWithParams.setAppReadyAndCallFunctionHandle();
		}
		
		protected function createMetrics(): void {
			Metrics.createVecMetricsFromContent(LoaderXMLContentView.content, this.stage);
			Metrics.isAnonymous = this.isAnonymousMetrics;
		}
		
		protected function get isAnonymousMetrics(): Boolean {
			return false;
		}
		
	}

}