package com.spotlightor.armorframework.model 
{
	import com.spotlightor.armorframework.constants.ArmorNotifications;
	import com.spotlightor.armorframework.model.vo.ArmorStructure;
	import com.spotlightor.armorframework.model.vo.PageAsset;
	import com.spotlightor.armorframework.model.vo.PageNode;
	import com.spotlightor.loading.SmartLoader;
	import com.spotlightor.utils.Log;
	import flash.events.ErrorEvent;
	import flash.events.Event;
	import org.puremvc.as3.multicore.patterns.proxy.Proxy;
	/**
	 * 自动载入app.xml，并保存由它生产的ArmorStructure数据，对外提供操作ArmorStructure以及获取其相关数据的接口。
	 * 
	 * @author 高鸣 - 交典创艺 (Spotlightor.com)
	 */
	public class ArmorStructureProxy extends Proxy
	{
		public static const NAME	:String = "proxy_armor_structure";
		
		public function ArmorStructureProxy(appXmlURL:String) 
		{
			super(NAME, null);
			loadAppXML(appXmlURL);
		}
		
		public function getBranchNodes(branch:String):Vector.<PageNode> { return armorStructure.getBranchNodes(branch); }
		public function getBranchNodesByPageID(pageID:String):Vector.<PageNode> { return armorStructure.getBranchNodesByPageID(pageID); }
		public function getPageAssetByID(assetID:String):PageAsset { return armorStructure.getPageAssetByID(assetID); }
		public function getPageNodeByID(pageID:String):PageNode { return armorStructure.getPageNodeByID(pageID); }
		
		private function loadAppXML(appXmlURL:String):void
		{
			if (appXmlURL == null || appXmlURL.length == 0) {
				Log.fatal(this, "appXmlURL not valid:", appXmlURL);
				return;
			}
			Log.status(this, "Start loading app xml:", appXmlURL);
			var appXMLLoader:SmartLoader = new SmartLoader(appXmlURL, "app xml", null);
			appXMLLoader.addEventListener(Event.COMPLETE, onAppXMLLoaded);
			appXMLLoader.addEventListener(ErrorEvent.ERROR, onAppXMLLoadError);
			appXMLLoader.startLoading();
		}
		
		private function onAppXMLLoadError(e:ErrorEvent):void 
		{
			Log.fatal(this, "Load app xml error!", e);
		}
		
		private function onAppXMLLoaded(e:Event):void 
		{
			var appXML:XML = XML((e.target as SmartLoader).content);
			Log.status(this, "app xml loaded.");
			
			data = new ArmorStructure(appXML);
			
			Log.status(this, "app structure ready");
			sendNotification(ArmorNotifications.APP_STRUCTURE_READY, data);
		}
		
		public function get firstBranchNodes():Vector.<PageNode> { return armorStructure.firstBranchNodes; }
		
		public function get indexPageNode():PageNode { return armorStructure.indexPageNode; }
		
		protected function get armorStructure():ArmorStructure { return data as ArmorStructure; }
	}

}