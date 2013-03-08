package com.spotlightor.armorframework.controller 
{
	import com.spotlightor.armorframework.constants.PageDepth;
	import com.spotlightor.armorframework.model.ArmorStructureProxy;
	import com.spotlightor.armorframework.model.vo.PageAsset;
	import com.spotlightor.armorframework.view.ArmorMainMediator;
	import com.spotlightor.armorframework.view.ArmorPreloaderMediator;
	import com.spotlightor.display.IPreloader;
	import com.spotlightor.utils.Log;
	import flash.display.DisplayObject;
	import org.puremvc.as3.multicore.interfaces.INotification;
	import org.puremvc.as3.multicore.patterns.command.SimpleCommand;
	/**
	 * 从ArmorStructureProxy获取preloader asset，加入到ArmorMain的PRELOADER层级，然后在PreloaderMediator中进行注册
	 * @author Gao Ming (Spotlightor Interactive)
	 */
	public class AddNewPreloaderCommand extends SimpleCommand
	{
		override public function execute(notification:INotification):void 
		{
			var preloaderAssetID:String = notification.getBody() as String;
			if (preloaderAssetID && preloaderAssetID != "")
			{
				var armorStructureProxy:ArmorStructureProxy = facade.retrieveProxy(ArmorStructureProxy.NAME) as ArmorStructureProxy;
				var asset:PageAsset = armorStructureProxy.getPageAssetByID(preloaderAssetID);
				if (asset.content)
				{
					if (asset.content is IPreloader)
					{
						var mainMediator:ArmorMainMediator = facade.retrieveMediator(ArmorMainMediator.NAME) as ArmorMainMediator;
						mainMediator.addChildAtDepth(asset.content as DisplayObject, PageDepth.PRELOADER);
						Log.info(this, "Prelader Asset", preloaderAssetID, " added to armor main in preloader depth");
						
						var preloaderMediator:ArmorPreloaderMediator = facade.retrieveMediator(ArmorPreloaderMediator.NAME) as ArmorPreloaderMediator;
						preloaderMediator.registerPreloader(asset.content as IPreloader, asset.id);
						Log.info(this, "Depth Asset", preloaderAssetID, "registered with ArmorPreloaderMediator");
					}
					else Log.fatal(this, "Cannot add preloader, asset content is not IPreloader!", preloaderAssetID, asset.content);
				}
				else Log.fatal(this, "Cannot add preloader, asset content is null!", preloaderAssetID);
			}
			else Log.warning(this, "Cannot add preloader because assetID in notification body is null!");
		}
	}

}