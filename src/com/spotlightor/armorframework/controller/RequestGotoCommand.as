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
	 * ...
	 * @author 高鸣 - 交典创艺 (Spotlightor.com)
	 */
	public class RequestGotoCommand extends SimpleCommand
	{
		override public function execute(notification:INotification):void 
		{
			var pageID:String = notification.getBody() as String;
			if (pageID == null || pageID == "")
			{
				Log.warning(this, "The pageID(String) in notification's body is null.");
				return;
			}
			
			var armorStructureProxy: ArmorStructureProxy = facade.retrieveProxy(ArmorStructureProxy.NAME) as ArmorStructureProxy;
			var branchNodes:Vector.<PageNode> = armorStructureProxy.getBranchNodesByPageID(pageID);
			if (branchNodes && branchNodes.length > 0)
			{
				if (branchNodes[branchNodes.length - 1].landing)
				{
					facade.sendNotification(ArmorNotifications.GOTO_INTERNAL, branchNodes);
				}
				else
				{
					Log.warning(this, "The top of branch is not a landing page!");
					//TODO: 自动移动到该分支下最近的一个Landing page
					facade.sendNotification(ArmorNotifications.GOTO_INTERNAL, branchNodes);
				}
			}
			else
			{
				Log.error(this, "Cannot get branchNodes from pageID:", pageID);
			}
		}
	}

}