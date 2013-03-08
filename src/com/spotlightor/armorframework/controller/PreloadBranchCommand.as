package com.spotlightor.armorframework.controller 
{
	import com.spotlightor.armorframework.model.BranchPreloaderProxy;
	import com.spotlightor.armorframework.model.vo.PageNode;
	import com.spotlightor.utils.Log;
	import org.puremvc.as3.multicore.interfaces.INotification;
	import org.puremvc.as3.multicore.patterns.command.SimpleCommand;
	/**
	 * ...
	 * @author 高鸣 - 交典创艺 (Spotlightor.com)
	 */
	public class PreloadBranchCommand extends SimpleCommand
	{
		override public function execute(notification:INotification):void 
		{
			var branchLoaderProxy:BranchPreloaderProxy = facade.retrieveProxy(BranchPreloaderProxy.NAME) as BranchPreloaderProxy;
			if (!branchLoaderProxy) Log.fatal(this, "The BranchLoaderProxy wasn't registered by the facade! The preload failed.");
			else
			{
				var branchNodes:Vector.<PageNode> = notification.getBody() as Vector.<PageNode>;
				if (branchNodes) branchLoaderProxy.preloadBranch(branchNodes);
				else Log.error(this, "The branchNodes bypassed by notification is null:", notification.getBody());
			}
		}
	}

}