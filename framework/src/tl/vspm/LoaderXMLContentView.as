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
	import tl.loader.LoaderXML;
	import flash.utils.Dictionary;
	import tl.loader.URLLoaderExt;
	import tl.types.ObjectUtils;
	import tl.types.StringUtils;
	import tl.flashUtils.FlashUtils;
	import flash.utils.getDefinitionByName;
	import flash.utils.getQualifiedClassName;
	import flash.system.ApplicationDomain;
	
	public class LoaderXMLContentView extends LoaderXML {
		
		static public const NAME_SECTION_EMPTY: String = "empty";
		
		private var prefixClass: String;
		static public var content: Object;
		static public var dictIndViewSectionToVecDescriptionSubViewSection: Dictionary = new Dictionary();
		static public var isUseAliasIndSection: Boolean = true;
		static public var dictIndToAliasIndSection: Dictionary;
		static public var dictAliasIndToIndSection: Dictionary;
		
		function LoaderXMLContentView(prefixClass: String): void {
			this.prefixClass = prefixClass;
		}
		
		override public function parseXML(xmlNode: XML): void {
			this.initDictIndAliasViewSection();
			this.parseXMLPopup(xmlNode);
			var xmlContent: XML = this.parseXMLSection(xmlNode, "", "", 0);
			this.createObjFromXMLContent(xmlContent);
			new DescriptionViewSection(LoaderXMLContentView.NAME_SECTION_EMPTY, ViewSectionEmpty, null, -1);
			if ((xmlNode.@isSection == 1) || (xmlNode.@isSectionAndContent == 1)) {
				var objClasses: Object = this.getObjClassContentAndViewSection(xmlNode.name());
				if (objClasses.classViewSection)
					new DescriptionViewSection("", objClasses.classViewSection, new objClasses.classContentViewSection(xmlContent), -1);
			}
		}
		
		private function initDictIndAliasViewSection(): void {
			if (LoaderXMLContentView.isUseAliasIndSection) {
				if (!LoaderXMLContentView.dictIndToAliasIndSection) LoaderXMLContentView.dictIndToAliasIndSection = new Dictionary();
				if (!LoaderXMLContentView.dictAliasIndToIndSection) LoaderXMLContentView.dictAliasIndToIndSection = new Dictionary();
			}
		}
		
		private function createObjFromXMLContent(xmlContent: XML): void {
			var content: Object = URLLoaderExt.parseXMLToObject(xmlContent);
			if (!LoaderXMLContentView.content) LoaderXMLContentView.content = content;
			else LoaderXMLContentView.content = ObjectUtils.populateObj(content, LoaderXMLContentView.content);
		}
		
		private function parseXMLSection(xmlSection: XML, predIndSection: String, predIndSectionAlias: String, depth: uint): XML {
			if (xmlSection.toString() != "") {
				if (predIndSectionAlias == "") predIndSectionAlias = predIndSection;
				var xmlListSubSection: XMLList = xmlSection.*.((attribute("isSection") == "1") || (attribute("isSectionAndContent") == "1"));
				var arrSuffIndSubSectionInXMLListSubSection: Array = [];
				var xmlSubSection: XML;
				var suffIndSubSection: String;
				for (var i: uint = 0; i < xmlListSubSection.length(); i++) {
					xmlSubSection = xmlListSubSection[i];
					suffIndSubSection = xmlSubSection.name();
					if (arrSuffIndSubSectionInXMLListSubSection.indexOf(suffIndSubSection) == -1) arrSuffIndSubSectionInXMLListSubSection.push(suffIndSubSection);
				}
				//iterate through subsections
				var order: uint = 0;
				if (!LoaderXMLContentView.dictIndViewSectionToVecDescriptionSubViewSection[predIndSection]) LoaderXMLContentView.dictIndViewSectionToVecDescriptionSubViewSection[predIndSection] = new Vector.<DescriptionViewSection>();
				for (i = 0; i < arrSuffIndSubSectionInXMLListSubSection.length; i++) {
					suffIndSubSection = arrSuffIndSubSectionInXMLListSubSection[i];
					var objClasses: Object = this.getObjClassContentAndViewSection(suffIndSubSection);
					var xmlListSubSectionWithSameName: XMLList = xmlSection[suffIndSubSection];
					//trace("xmlListSubSectionWithSameName:", objClasses.contentSubViewSection, xmlListSubSectionWithSameName)
					var indSubSection: String = ((predIndSection == "") ? "" : predIndSection + "/") + suffIndSubSection;
					var indSubSectionWithWoNum: String;
					for (var j: uint = 0; j < xmlListSubSectionWithSameName.length(); j++) {
						var strWoNumSubSection: String = [String(j), ""][uint(xmlListSubSectionWithSameName.length() == 1)]
						indSubSectionWithWoNum = indSubSection + strWoNumSubSection;
						xmlSubSection = xmlListSubSectionWithSameName[j];
						var suffIndSubSectionAlias: String = this.getSuffIndSectionAlias(xmlSubSection);
						if (suffIndSubSectionAlias == "") suffIndSubSectionAlias = suffIndSubSection + strWoNumSubSection;
						var indSubSectionAlias: String = ((predIndSectionAlias == "") ? "" : predIndSectionAlias + "/") + suffIndSubSectionAlias;
						xmlSubSection = this.parseXMLSection(xmlSubSection, indSubSectionWithWoNum, indSubSectionAlias, depth + 1);
						var descriptionSubViewSection: DescriptionViewSection;
						var contentSubViewSection: ContentViewSection = new objClasses.classContentViewSection(xmlSubSection, order, depth);
						if (LoaderXMLContentView.isUseAliasIndSection) {
							dictIndToAliasIndSection[indSubSectionWithWoNum] = indSubSectionAlias;
							if (xmlListSubSectionWithSameName.length() == 1) LoaderXMLContentView.dictIndToAliasIndSection[indSubSectionWithWoNum + "0"] = indSubSectionAlias;
							LoaderXMLContentView.dictAliasIndToIndSection[indSubSectionAlias] = indSubSectionWithWoNum;
						}
						descriptionSubViewSection = new DescriptionViewSection(indSubSection, objClasses.classViewSection, contentSubViewSection, (xmlListSubSectionWithSameName.length() == 1) ? -1 : j);
						LoaderXMLContentView.addToArrDescriptionSubViewSection(predIndSection, descriptionSubViewSection);
						order++;
						if (!uint(xmlListSubSectionWithSameName[j].@isSectionAndContent)) xmlListSubSectionWithSameName[j] = "empty";
					}
					//if (!uint(xmlSection[suffIndSubSection].@isSectionAndContent)) delete xmlSection[suffIndSubSection];
				}
			}
			return xmlSection;
		}
		
		static private function addToArrDescriptionSubViewSection(indSection: String, descriptionViewSection: DescriptionViewSection): void {
			var vecDescriptionSubViewSection: Vector.<DescriptionViewSection> = LoaderXMLContentView.getVecDescriptionSubViewSectionForIndSection(indSection);
			var i: uint = 0;
			while ((i < vecDescriptionSubViewSection.length) && (DescriptionViewSection(vecDescriptionSubViewSection[i]).ind != descriptionViewSection.ind))
				i++;
			if (i < vecDescriptionSubViewSection.length) DescriptionViewSection(vecDescriptionSubViewSection[i]).addAdditionalContent(descriptionViewSection);
			else vecDescriptionSubViewSection.push(descriptionViewSection);
			LoaderXMLContentView.dictIndViewSectionToVecDescriptionSubViewSection[indSection] = vecDescriptionSubViewSection;
		}
		
		private function getObjClassContentAndViewSection(suffIndSection: String): Object {
			var suffIndSectionCode: String = StringUtils.toUpperCaseFromUnderscore(suffIndSection);
			var classContentViewSection: Class = this.getClassDefinition(this.prefixClass + ".content.Content" + suffIndSectionCode);;
			if ((!classContentViewSection) || (!FlashUtils.isSuperclass(classContentViewSection, ContentViewSection))) classContentViewSection = ContentViewSection;
			var classViewSection: Class = this.getClassDefinition(this.prefixClass + ".viewSection.ViewSection" + suffIndSectionCode);
			return {classContentViewSection: classContentViewSection, classViewSection: classViewSection};
		}
		
		private function getSuffIndSectionAlias(xmlSection: XML): String {
			var objSection: Object = URLLoaderExt.parseXMLToObject(xmlSection);
			var objSuffIndSectionAlias: * = objSection.name || objSection.label || objSection.title || "";
			if (getDefinitionByName(getQualifiedClassName(objSuffIndSectionAlias)) == Object) objSuffIndSectionAlias = Object(objSuffIndSectionAlias).text;
			var suffIndSectionAlias: String = StringUtils.depolonize(String(objSuffIndSectionAlias)).toLowerCase();
			suffIndSectionAlias = suffIndSectionAlias.replace("%", "");
			return suffIndSectionAlias;
		}
		
		static public function getVecDescriptionSubViewSectionForIndSection(indSection: String): Vector.<DescriptionViewSection> {
			return LoaderXMLContentView.dictIndViewSectionToVecDescriptionSubViewSection[indSection] || new Vector.<DescriptionViewSection>();
		}
		
		//popup
		
		private function parseXMLPopup(xmlPopup: XML): void {
			var xmlListSubPopup: XMLList = xmlPopup.*;	
			var xmlSubPopup: XML;
			var suffIndSubPopup: String;
			for (var i: uint = 0; i < xmlListSubPopup.length(); i++) {
				xmlSubPopup = xmlListSubPopup[i];
				suffIndSubPopup = xmlSubPopup.name();
				if (uint(xmlSubPopup.@isPopup)) {
					var objClasses: Object = this.getObjClassContentAndViewPopup(suffIndSubPopup);
					var contentSubViewPopup: ContentViewPopup = new objClasses.classContentViewPopup(xmlSubPopup);
					var objParamsWithValuesToShow: Object = {};
					if (contentSubViewPopup.objParamsWithValuesToShow) objParamsWithValuesToShow = JSON.parse(contentSubViewPopup.objParamsWithValuesToShow);
					var descriptionSubViewPopup: DescriptionViewPopup = new DescriptionViewPopup(suffIndSubPopup, objClasses.classViewPopup, contentSubViewPopup, objParamsWithValuesToShow);
				} else this.parseXMLPopup(xmlSubPopup);
			}
		}
		
		private function getObjClassContentAndViewPopup(suffIndPopup: String): Object {
			var suffIndPopupCode: String = StringUtils.toUpperCaseFromUnderscore(suffIndPopup);
			var classContentViewPopup: Class = this.getClassDefinition(this.prefixClass + ".content.ContentPopup" + suffIndPopupCode);
			if ((!classContentViewPopup) || (!FlashUtils.isSuperclass(classContentViewPopup, ContentViewPopup))) classContentViewPopup = ContentViewPopup;
			var classViewPopup: Class = this.getClassDefinition(this.prefixClass + ".viewPopup.ViewPopup" + suffIndPopupCode);
			return {classContentViewPopup: classContentViewPopup, classViewPopup: classViewPopup};
		}
		
		//helper
		
		private function getClassDefinition(nameClass: String): Class {
			var classDefinition: Class = null;
			try {
				if (ApplicationDomain.currentDomain.hasDefinition(nameClass))
					classDefinition = Class(getDefinitionByName(nameClass));
			} catch (e: Error) { }
			return classDefinition;
		}
		
	}
	
}