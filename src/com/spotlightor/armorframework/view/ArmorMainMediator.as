package com.spotlightor.armorframework.view 
{
	import com.spotlightor.armorframework.ArmorMain;
	import com.spotlightor.armorframework.constants.ArmorNotifications;
	import com.spotlightor.armorframework.constants.PageDepth;
	import com.spotlightor.armorframework.interfaces.IPage;
	import com.spotlightor.armorframework.model.vo.PageAsset;
	import com.spotlightor.armorframework.model.vo.PageNode;
	import com.spotlightor.utils.Log;
	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;
	import flash.utils.Dictionary;
	import org.puremvc.as3.multicore.interfaces.INotification;
	import org.puremvc.as3.multicore.patterns.mediator.Mediator;
	
	/**
	 * ...
	 * @author 高鸣 - 交典创艺 (Spotlightor.com)
	 */
	public class ArmorMainMediator extends Mediator 
	{
		public static const NAME:String = "mediator_armormain";
		
		public function ArmorMainMediator(viewComponent:ArmorMain) 
		{ 
			super(NAME, viewComponent);
		} 
		
		override public function listNotificationInterests():Array 
		{
			return [ArmorNotifications.APP_STRUCTURE_READY, ArmorNotifications.PRELOADER_LOADED, ArmorNotifications.PRELOAD_BRANCH_COMPLETE];
		}
		
		override public function handleNotification(notification:INotification):void 
		{
			switch(notification.getName())
			{
				case ArmorNotifications.APP_STRUCTURE_READY: initialize(); break;
				case ArmorNotifications.PRELOADER_LOADED: {
					armorMain.addChildAtDepth(notification.getBody() as DisplayObject, PageDepth.PRELOADER);
					Log.status(this, "Preloader added to main.preloaderLayer, READY.");
					sendNotification(ArmorNotifications.PRELOADER_READY, notification.getBody());
					break;
				}
				case ArmorNotifications.PRELOAD_BRANCH_COMPLETE: {
					var pagesLoaded:Vector.<PageNode> = notification.getBody() as Vector.<PageNode>;
					if (pagesLoaded) addPages(pagesLoaded);
					break;
				}
			}
		}
		
		private function initialize():void
		{
			armorMain.initializeLayers();
		}
		
		public function addChildAtDepth(child:DisplayObject, depth:int = PageDepth.MIDDLE):DisplayObject
		{
			return armorMain.addChildAtDepth(child, depth);
		}
		
		private function getChildByLongName(container:DisplayObjectContainer, longName:String):DisplayObject
		{
			var childNames:Array = longName.split('.');
			var child:DisplayObject = container;
			for (var i:int = 0; i < childNames.length; i++) 
			{
				var childName:String = childNames[i];
				child = (child as DisplayObjectContainer).getChildByName(childName);
				if (!(child is DisplayObjectContainer))
				{
					if (i == childNames.length - 1) return child;
					else return null;
				}
			}
			return child;
		}
		
		public function addPages(pageNodes:Vector.<PageNode>):void
		{
			for each (var pageNode:PageNode in pageNodes) 
			{
				var page:IPage = pageNode.content as IPage;
				if (page == null) Log.error(this, "addPages: Page content in page node is not IPage", pageNode.content, pageNode.id, pageNode.src);
				else 
				{
					facade.registerMediator(new PageMediator(page, pageNode.id));
					if (pageNode.depth != PageDepth.CHILD) armorMain.addChildAtDepth(page as DisplayObject, pageNode.depth);
					else {
						// child depth
						if (pageNode.parentNode && pageNode.parentNode.content)
						{
							if (pageNode.container == null)
							{
								(pageNode.parentNode.content as DisplayObjectContainer).addChild(page as DisplayObject);
								Log.debug(this, pageNode.id, "没有再pagenode中指定container属性，默认加入到", pageNode.parentNode.id, "的最高层");
							}
							else
							{
								var container:DisplayObjectContainer = getChildByLongName(pageNode.parentNode.content, pageNode.container) as DisplayObjectContainer;
								if (container) container.addChild(page as DisplayObject);
								else 
								{
									(pageNode.parentNode.content as DisplayObjectContainer).addChild(page as DisplayObject);
									Log.debug(this, pageNode.id, "没有在", pageNode.parentNode.content,"中找到container:",pageNode.container,"，默认加入到", pageNode.parentNode.id, "的最高层");
								}
							}
						}
						else Log.error(this, "无法将pagenode", pageNode.id, "加入到child层级，因为parentNode为空或者parentNode.content为空");
					}
					
					var assets:Dictionary = null;
					if (pageNode.assets)
					{
						assets = new Dictionary(true);
						for each (var asset:PageAsset in pageNode.assets) assets[asset.id] = asset.content;
					}
					
					page.onAssetsLoaded(assets);
					
					Log.info(this, "New page added to main:", page);
				}
			}
		}
		
		protected function get armorMain():ArmorMain { return viewComponent as ArmorMain; }
	}
	
}