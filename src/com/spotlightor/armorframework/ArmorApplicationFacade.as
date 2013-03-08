package com.spotlightor.armorframework 
{
	import com.spotlightor.armorframework.constants.ArmorNotifications;
	import com.spotlightor.armorframework.controller.AddNewPreloaderCommand;
	import com.spotlightor.armorframework.controller.ArmorInitByStructureCommand;
	import com.spotlightor.armorframework.controller.ArmorStartupCommand;
	import com.spotlightor.armorframework.controller.CancelPreloadBranchCommand;
	import com.spotlightor.armorframework.controller.PreloadBranchCommand;
	import com.spotlightor.armorframework.controller.RequestGotoCommand;
	import com.spotlightor.armorframework.controller.UnloadPageCommand;
	import org.puremvc.as3.multicore.interfaces.IMediator;
	import org.puremvc.as3.multicore.interfaces.IProxy;
	import org.puremvc.as3.multicore.patterns.facade.Facade;
	/**
	 * ...
	 * @author 高鸣 - 交典创艺 (Spotlightor.com)
	 */
	public class ArmorApplicationFacade extends Facade
	{
		
		public static const STARTUP:String = "nt_armorapplication_startup";
		
		public function ArmorApplicationFacade(key:String) 
		{
			super(key);
		}
		
		public static function getInstance(key:String):ArmorApplicationFacade 
		{
			if (instanceMap[key] == null) instanceMap[key] = new ArmorApplicationFacade(key);
			return instanceMap[key] as ArmorApplicationFacade;	
		}
		
		override protected function initializeController():void 
		{
			super.initializeController();
			registerCommand(STARTUP, ArmorStartupCommand);
			registerCommand(ArmorNotifications.APP_STRUCTURE_READY, ArmorInitByStructureCommand);
			registerCommand(ArmorNotifications.PRELOAD_BRANCH, PreloadBranchCommand);
			registerCommand(ArmorNotifications.CANCEL_PRELOAD_BRANCH, CancelPreloadBranchCommand);
			registerCommand(ArmorNotifications.REQUEST_GOTO, RequestGotoCommand);
			registerCommand(ArmorNotifications.ADD_NEW_PRELOADER, AddNewPreloaderCommand);
			registerCommand(ArmorNotifications.UNLOAD_PAGE, UnloadPageCommand);
		}
		
		public function startup(main:Object, addonMediators:Array = null, addonProxies:Array = null):void {
			if (addonMediators) {
				for each (var mediator:IMediator in addonMediators) registerMediator(mediator);
			}
			if (addonProxies) {
				for each (var proxy:IProxy in addonProxies) registerProxy(proxy);
			}
			
			sendNotification(STARTUP, main);
		}
	}
	
}