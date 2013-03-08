package com.spotlightor.armorframework.test 
{
	import com.spotlightor.events.TransitionEvent;
	import com.spotlightor.armorframework.interfaces.IPage;
	import com.spotlightor.armorframework.events.PageEvent;
	import com.spotlightor.loading.QueueLoader;
	import com.spotlightor.utils.Log;
	import flash.display.DisplayObject;
	import flash.events.Event;
	import flash.events.KeyboardEvent;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	import flash.system.ApplicationDomain;
	/**
	 * 在单独开发某一个IPage的时候，帮助你完成预载入assets
	 * 并可以通过键盘“I/O”键触发transitionIn和transitionOut
	 * 
	 * @author 高鸣 - 交典创艺 (Spotlightor.com)
	 */
	public class PageAloneTester
	{
		private var _page:IPage;
		private var _pageID:String;
		private var _rootPath:String;
		private var _assetsLoader:QueueLoader;
		
		public function PageAloneTester(page:IPage, appXmlURL:String, pageID:String) 
		{
			_page = page;
			_pageID = pageID;
			Log.info(this, "Start page alone tester for", _page, "id = " + _pageID);
			
			_rootPath = appXmlURL.substr(0, appXmlURL.lastIndexOf("/") + 1);
			Log.info(this, "Application root path retrieved from appXmlURL :", _rootPath);
			
			// load app xml to find assets to load
			var appXmlLoader:URLLoader = new URLLoader(new URLRequest(appXmlURL));
			appXmlLoader.addEventListener(Event.COMPLETE, onAppXmlLoaded);
		}
		
		private function onAppXmlLoaded(e:Event):void 
		{
			Log.status(this, "App xml loaded.");
			
			var appXML:XML = new XML((e.target as URLLoader).data);
			var pageBranch:XML = findPageBranch(_pageID, appXML.app.page);
			var numAssets:int = pageBranch.asset.length();
			
			if (numAssets > 0)
			{
				_assetsLoader = new QueueLoader();
				for (var i:int = 0; i < numAssets; i++) 
				{
					var assetID:String = pageBranch.asset[i].@id;
					var assetSrc:String = pageBranch.asset[i].@src;
					assetSrc = _rootPath + assetSrc;
					
					_assetsLoader.add(assetSrc, 1, null, assetID);
				}
				
				Log.status(this, "Start loading", numAssets, "assets.");
				
				_assetsLoader.addEventListener(Event.COMPLETE, onAssetsLoadingComplete);
				_assetsLoader.startLoading();
			}
			else 
			{
				_page.onAssetsLoaded(null);
				setupPageControl();
			}
		}
		
		private function onAssetsLoadingComplete(e:Event):void
		{
			Log.status(this, "Assets loading complete.");
			_page.onAssetsLoaded(_assetsLoader.getContentsDictionary());
			
			_assetsLoader.dispose();
			
			setupPageControl();
		}
		
		private function setupPageControl():void
		{
			_page.addEventListener(TransitionEvent.IN, onPageTransitionIn);
			_page.addEventListener(TransitionEvent.IN_COMPLETE, onPageTransitionInComplete);
			_page.addEventListener(TransitionEvent.OUT, onPageTransitionOut);
			_page.addEventListener(TransitionEvent.OUT_COMPLETE, onPageTransitionOutComplete);
			
			(_page as DisplayObject).stage.addEventListener(KeyboardEvent.KEY_DOWN, onKeyPressedOnStage);
			_page.addEventListener(PageEvent.REQUEST_GOTO, onPageGoto);
			
			Log.status(this, "Page control setup complete. 使用I/O键控制Page淡入淡出");
			
			_page.transitionOut(true);
		}
		
		private function onPageGoto(e:PageEvent):void 
		{
			Log.info(this, _page, "Try goto", e.object + ".");
			_page.transitionOut();
		}
		
		private function onPageTransitionOutComplete(e:TransitionEvent):void 
		{
			Log.status(this, "Page transition OUT complete.");
		}
		
		private function onPageTransitionOut(e:TransitionEvent):void 
		{
			Log.status(this, "Page transition OUT.");
		}
		
		private function onPageTransitionInComplete(e:TransitionEvent):void 
		{
			Log.status(this, "Page transition IN complete.");
		}
		
		private function onPageTransitionIn(e:TransitionEvent):void 
		{
			Log.status(this, "Page transition IN.");
		}
		
		/**
		 * 使用键盘的I/O键控制Page的transitionIn/Out
		 * @param	e
		 */
		private function onKeyPressedOnStage(e:KeyboardEvent):void 
		{
			switch(e.keyCode)
			{
				case 73: {
					_page.transitionIn();
					break;
				}
				case 79: {
					_page.transitionOut();
					break;
				}
			}
		}
		
		/**
		 * 递归寻找在xml中具有id的分支
		 * @param	id
		 * @param	xml
		 * @return
		 */
		private function findPageBranch(id:String, xml:XMLList):XML
		{
			if (xml)
			{
				for each (var item:XML in xml) 
				{
					if (item.@id == id) return item;
					else
					{
						var result:XML = findPageBranch(id, item.page);
						if (result != null) return result;
					}
				}
			}
			return null;
		}
	}

}