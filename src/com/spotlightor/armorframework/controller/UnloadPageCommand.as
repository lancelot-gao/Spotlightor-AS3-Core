package com.spotlightor.armorframework.controller 
{
	import com.spotlightor.armorframework.model.ArmorStructureProxy;
	import com.spotlightor.armorframework.model.vo.PageAsset;
	import com.spotlightor.armorframework.model.vo.PageNode;
	import com.spotlightor.armorframework.view.PageMediator;
	import com.spotlightor.utils.Log;
	import flash.display.DisplayObject;
	import org.puremvc.as3.multicore.interfaces.INotification;
	import org.puremvc.as3.multicore.patterns.command.SimpleCommand;
	/**
	 * com.spotlightor.armorframework.controller.UnloadPageCommand
	 * ...
	 * @author Gao Ming (Spotlightor Interactive)
	 */
	public class UnloadPageCommand extends SimpleCommand
	{
		override public function execute(notification:INotification):void 
		{
			var pageID:String = notification.getBody() as String;
			if (pageID && pageID != "")
			{
				var structureProxy:ArmorStructureProxy = facade.retrieveProxy(ArmorStructureProxy.NAME) as ArmorStructureProxy;
				var pageNode:PageNode = structureProxy.getPageNodeByID(pageID);
				
				if (pageNode.unload == true)
				{
					var pageMediator:PageMediator = facade.retrieveMediator(PageMediator.nameByPageID(pageID)) as PageMediator;
					
					// unload assets
					for each (var asset:PageAsset in pageNode.assets) 
					{
						if (asset.content is DisplayObject) {
							Log.info(this, "asset unload and stop:", asset.content);
							(asset.content as DisplayObject).loaderInfo.loader.unloadAndStop(true);
						}
						asset.content = null;
					}
					
					// remove page mediator
					facade.removeMediator(PageMediator.nameByPageID(pageID));
					
					// unload page
					var page:DisplayObject = pageNode.content as DisplayObject;
					Log.info(this, "page unload and stop:", page);
					if (page.parent) page.parent.removeChild(page);
					page.loaderInfo.loader.unloadAndStop(true);
					pageNode.content = null;
				}
				else Log.error(this, "Trying to unload a page that not unloadable:", pageNode.id);
			}
			else  Log.error(this, "Invalid page id:", pageID);
		}
	}

}