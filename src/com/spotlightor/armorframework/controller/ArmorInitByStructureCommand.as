package com.spotlightor.armorframework.controller 
{
	import com.spotlightor.armorframework.constants.ArmorNotifications;
	import com.spotlightor.armorframework.model.ArmorStructureProxy;
	import com.spotlightor.armorframework.model.BranchPreloaderProxy;
	import com.spotlightor.armorframework.view.ArmorBranchTransitionMediator;
	import com.spotlightor.armorframework.view.ArmorContextMenuMediator;
	import com.spotlightor.armorframework.view.ArmorMainMediator;
	import com.spotlightor.armorframework.view.ArmorPreloaderMediator;
	import org.puremvc.as3.multicore.interfaces.INotification;
	import org.puremvc.as3.multicore.patterns.command.MacroCommand;
	import org.puremvc.as3.multicore.patterns.command.SimpleCommand;
	/**
	 * 在app xml被载入并且顺利parse为ArmorStructure之后，由APP_STRUCTURE_READY消息触发执行。
	 * 在这里通过armorStructure的属性来注册Armor Framework的剩余核心组件并设置相关属性。
	 * 
	 * @author 高鸣 - 交典创艺 (Spotlightor.com)
	 */
	public class ArmorInitByStructureCommand extends SimpleCommand
	{
		override public function execute(notification:INotification):void 
		{
			var armorStructureProxy:ArmorStructureProxy = facade.retrieveProxy(ArmorStructureProxy.NAME) as ArmorStructureProxy;
			
			if (!facade.hasCommand(ArmorNotifications.PRELOADER_READY)) facade.registerCommand(ArmorNotifications.PRELOADER_READY, GotoFirstBranchCommand);
			
			facade.registerProxy(new BranchPreloaderProxy());
			
			facade.registerMediator(new ArmorBranchTransitionMediator());
			facade.registerMediator(new ArmorPreloaderMediator("preloader.swf"));
			
			var mainMediator:ArmorMainMediator = facade.retrieveMediator(ArmorMainMediator.NAME) as ArmorMainMediator;
			facade.registerMediator(new ArmorContextMenuMediator(mainMediator.getViewComponent()));
		}
	}

}