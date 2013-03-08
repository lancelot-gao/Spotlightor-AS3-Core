package com.spotlightor.armorframework.controller 
{
	import com.spotlightor.armorframework.ArmorMain;
	import com.spotlightor.armorframework.ArmorSettings;
	import com.spotlightor.armorframework.model.ArmorStructureProxy;
	import com.spotlightor.armorframework.model.BranchPreloaderProxy;
	import com.spotlightor.armorframework.view.ArmorMainMediator;
	import com.spotlightor.utils.Log;
	import org.puremvc.as3.multicore.interfaces.INotification;
	import org.puremvc.as3.multicore.patterns.command.SimpleCommand;
	/**
	 * ...
	 * @author 高鸣 - 交典创艺 (Spotlightor.com)
	 */
	public class ArmorStartupCommand extends SimpleCommand
	{
		override public function execute(notification:INotification):void 
		{
			Log.status(this, "Armor framework PureMVC started. Version:", ArmorSettings.VERSION);
			
			// proxies
			facade.registerProxy(new ArmorStructureProxy(ArmorSettings.APP_XML_URL));
			facade.registerProxy(new BranchPreloaderProxy());
			
			// mediators
			facade.registerMediator(new ArmorMainMediator(notification.getBody() as ArmorMain));
		}
	}

}