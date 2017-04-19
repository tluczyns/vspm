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
	import tl.loader.EventLoaderXML;
	import flash.utils.getDefinitionByName;

	public class ApplicationVSPMLite extends Sprite {
		
		protected var prefixClass: String;
		protected var loaderXMLContent: LoaderXMLContentView;
		private var containerApplication: ContainerApplicationVSPM;
		
		public function ApplicationVSPMLite(): void {
			Library.addSwf(this);
			var nameClassApplication: String = getQualifiedClassName(this);
			this.prefixClass = nameClassApplication.substr(0, nameClassApplication.indexOf('::'));
		}
		
		public function init(pathAssets: String = "", pathFileXML: String = "xml/content.xml"): void {
			this.loadXMLContent(pathAssets + pathFileXML);
		}
		
		protected function loadXMLContent(pathXML: String, strKeyEncryption: String = ""): void {
			this.loaderXMLContent = new LoaderXMLContentView(this.prefixClass);
			this.loaderXMLContent.loadXML(pathXML, strKeyEncryption);
			this.loaderXMLContent.addEventListener(EventLoaderXML.XML_LOADED, this.initOnXMLContentLoaded);
		}
		
		protected function initOnXMLContentLoaded(e: EventLoaderXML = null): void {
			this.loaderXMLContent.removeEventListener(EventLoaderXML.XML_LOADED, this.initOnXMLContentLoaded);
			this.initViews();
		}
		
		protected function initViews(startIndSection: String = ""): void {
			var classContainerApplication: Class;
			try {
				classContainerApplication = Class(getDefinitionByName(this.prefixClass + ".ContainerApplication"));
			} catch (e: Error) {
				classContainerApplication = ContainerApplicationVSPM;
			}
			this.containerApplication = new classContainerApplication();
			this.addChild(this.containerApplication);
			ManagerPopup.init(containerApplication.containerViewPopup);
			ManagerSection.init(containerApplication.containerViewSection, startIndSection);
		}
		
	}

}