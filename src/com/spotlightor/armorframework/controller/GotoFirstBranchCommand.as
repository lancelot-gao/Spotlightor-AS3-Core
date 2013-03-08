package com.spotlightor.armorframework.controller 
{
	import com.spotlightor.armorframework.constants.ArmorNotifications;
	import com.spotlightor.armorframework.model.ArmorStructureProxy;
	import com.spotlightor.armorframework.model.vo.ArmorStructure;
	import com.spotlightor.armorframework.model.vo.PageNode;
	import com.spotlightor.utils.Log;
	import org.puremvc.as3.multicore.interfaces.INotification;
	import org.puremvc.as3.multicore.patterns.command.SimpleCommand;
	/**
	 * 在收到PRELOADER_READY消息后默认执行的Command，直接载入app的第一分支。
	 * 如果PRELOADER_READY注册有别的Command，则本Command不会注册并执行。
	 * 当注册了其他Proxy或Mediator的时候（通过ArmorApplicationFacade.startup指定addons）会覆盖这个Command，例如由SWFAddress来确定第一次Goto应该去哪里。
	 * 
	 * @author 高鸣 - 交典创艺 (Spotlightor.com)
	 */
	public class GotoFirstBranchCommand extends SimpleCommand
	{
		override public function execute(notification:INotification):void 
		{
			var armorStructureProxy:ArmorStructureProxy = facade.retrieveProxy(ArmorStructureProxy.NAME) as ArmorStructureProxy;
			var firstBranch:Vector.<PageNode> = armorStructureProxy.firstBranchNodes;
			
			if (firstBranch == null) {
				Log.fatal(this, "The first branch nodes are empty!");
				return;
			}
			
			sendNotification(ArmorNotifications.GOTO_INTERNAL, firstBranch);
		}
	}

}