package com.spotlightor.armorframework.model 
{
	import com.spotlightor.armorframework.constants.ArmorNotifications;
	import com.spotlightor.armorframework.model.vo.PageAsset;
	import com.spotlightor.armorframework.model.vo.PageNode;
	import com.spotlightor.loading.QueueLoader;
	import com.spotlightor.loading.SmartLoader;
	import com.spotlightor.utils.Log;
	import flash.events.ErrorEvent;
	import flash.events.Event;
	import flash.events.ProgressEvent;
	import flash.utils.Dictionary;
	import org.puremvc.as3.multicore.patterns.proxy.Proxy;
	/**
	 * ...
	 * @author 高鸣 - 交典创艺 (Spotlightor.com)
	 */
	public class BranchPreloaderProxy extends Proxy
	{
		public static const NAME		:String = "proxy_armorframework_branchpreloader";
		
		private var _pagesToPreload		:Vector.<PageNode>;
		
		public function BranchPreloaderProxy() 
		{
			super(NAME, null);
		}
		
		public function preloadBranch(branchNodes:Vector.<PageNode>):void
		{
			if (branchNodes && branchNodes.length > 0)
			{
				var pageNodesNotLoaded:Vector.<PageNode> = new Vector.<PageNode>();
				for each (var pageNode:PageNode in branchNodes) 
				{
					if (!pageNode.preloaded) pageNodesNotLoaded.push(pageNode);
				}
				if (pageNodesNotLoaded.length > 0)
				{
					_pagesToPreload = pageNodesNotLoaded;
					sendNotification(ArmorNotifications.PRELOAD_BRANCH_START, _pagesToPreload, branchNodes[branchNodes.length - 1].preloaderID);
					preload();
				}
				else
				{
					sendNotification(ArmorNotifications.PRELOAD_BRANCH_COMPLETE, null);
				}
			}
			else sendNotification(ArmorNotifications.PRELOAD_BRANCH_COMPLETE, null);
		}
		
		private function preload():void
		{
			data = new QueueLoader();
			for each (var pageNode:PageNode in _pagesToPreload) 
			{
				preloader.add(pageNode.src, pageNode.bytes, pageNode.appDomain, pageNode.id);
				if (pageNode.assets)
				{
					for each (var asset:PageAsset in pageNode.assets) 
					{
						var assetLoader:SmartLoader = preloader.add(asset.src, asset.bytes, asset.appDomain, asset.id);
					}
				}
			}
			preloader.addEventListener(Event.COMPLETE, onPreloadComplete);
			preloader.addEventListener(ProgressEvent.PROGRESS, onPreloadProgress);
			preloader.addEventListener(ErrorEvent.ERROR, onPreloadError);
			
			preloader.startLoading();
		}
		
		private function dispose()
		{
			if (preloader) {
				preloader.removeEventListener(Event.COMPLETE, onPreloadComplete);
				preloader.removeEventListener(ProgressEvent.PROGRESS, onPreloadProgress);
				preloader.removeEventListener(ErrorEvent.ERROR, onPreloadError);
				preloader.dispose();
				data = null;
			}
			_pagesToPreload = null;
		}
		
		private function onPreloadComplete(e:Event):void 
		{
			var contents:Dictionary = preloader.getContentsDictionary();
			for each (var pageNode:PageNode in _pagesToPreload) 
			{
				pageNode.content = contents[pageNode.id];
				if (pageNode.assets)
				{
					for each (var asset:PageAsset in pageNode.assets) asset.content = contents[asset.id];
				}
			}
			sendNotification(ArmorNotifications.PRELOAD_BRANCH_COMPLETE, _pagesToPreload);
			
			contents = null;
			dispose();
		}
		
		private function onPreloadError(e:ErrorEvent):void 
		{
			Log.fatal(this, "Preload", _pagesToPreload, "error:", e);
			dispose();
			//卡死在这儿了
			//TODO自动回滚机制
		}
		
		private function onPreloadProgress(e:ProgressEvent):void 
		{
			sendNotification(ArmorNotifications.PRELOAD_BRANCH_PROGRESS, e);
		}
		
		public function cancelPreloading():void
		{
			if (preloader) {
				preloader.dispose();
				data = null;
			}
		}
		
		protected function get preloader():QueueLoader { return data as QueueLoader; }
		
		//private function getAssetsToPreload(pageNode:PageNode):Vector.<pageas>
	}

}