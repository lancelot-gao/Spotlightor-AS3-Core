package com.spotlightor.armorframework.controller 
{
	import com.spotlightor.armorframework.model.BranchPreloaderProxy;
	import com.spotlightor.utils.Log;
	import org.puremvc.as3.multicore.interfaces.INotification;
	import org.puremvc.as3.multicore.patterns.command.SimpleCommand;
	/**
	 * ...
	 * @author 高鸣 - 交典创艺 (Spotlightor.com)
	 */
	public class CancelPreloadBranchCommand extends SimpleCommand
	{
		override public function execute(notification:INotification):void 
		{
			var branchLoaderProxy:BranchPreloaderProxy = facade.retrieveProxy(BranchPreloaderProxy.NAME) as BranchPreloaderProxy;
			if (!branchLoaderProxy) Log.fatal(this, "The BranchLoaderProxy wasn't registered by the facade! Cancel preload failed.");
			else branchLoaderProxy.cancelPreloading();
		}
	}

}