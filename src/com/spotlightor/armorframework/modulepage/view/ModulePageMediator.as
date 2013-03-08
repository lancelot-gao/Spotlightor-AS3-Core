package com.spotlightor.armorframework.modulepage.view 
{
	import com.spotlightor.armorframework.events.ArmorEvent;
	import com.spotlightor.armorframework.events.CrossPageNotificationEvent;
	import com.spotlightor.armorframework.events.PageEvent;
	import com.spotlightor.armorframework.interfaces.IPage;
	import com.spotlightor.armorframework.modulepage.constants.ArmorEventNotifications;
	import com.spotlightor.armorframework.modulepage.constants.PageNotifications;
	import com.spotlightor.events.TransitionEvent;
	import com.spotlightor.utils.Log;
	import org.puremvc.as3.multicore.interfaces.INotification;
	import org.puremvc.as3.multicore.patterns.mediator.Mediator;
	
	/**
	 * 如果IPage是PureMVC的一个Core，必须要为其添加ModulePageMediator以实现Armor-PureMVC的相关功能
	 * 
	 * 【转播功能】
	 * 监听IPage的TransitionEvent，自动将其转化为PageNotifications进行广播。
	 * 监听IPage的ArmorEvent，自动将其转化为ArmorEventNotifications进行广播。
	 * 监听IPage的CrossPageNotificationEvent.RECIEVE，将其携带的Notification进行广播。
	 * 
	 * 【通过Notification调用相应IPage功能】
	 * 监听PageNotifications.REQUEST_GOTO，调用IPage发送PageEvent实现页面跳转请求。
	 * 在收到notificationsToShare中所列任意Notification时自动将其通过CrossPageNotificationEvent.SEND发送给Armor
	 * @author 高鸣 - 交典创艺 (Spotlightor.com)
	 */
	public class ModulePageMediator extends Mediator 
	{
		private var _notificationsToBroadcast:Array;
		private var _notificationsToRelay:Array;
		/**
		 * 
		 * @param	mediatorName
		 * @param	viewComponent
		 * @param	notificationsToShare	Array(String): 需要自动转发给其他puremvc core的notification
		 */
		public function ModulePageMediator(mediatorName:String, viewComponent:IPage, notificationsToBroadcast:Array = null, notificationsToRelay:Array = null) 
		{ 
			_notificationsToBroadcast = notificationsToBroadcast;
			_notificationsToRelay = notificationsToRelay;
			
			super(mediatorName, viewComponent);
		} 
		
		override public function onRegister():void 
		{
			// page transition events
			page.addEventListener(TransitionEvent.IN, onPageTransitionEvent);
			page.addEventListener(TransitionEvent.OUT, onPageTransitionEvent);
			page.addEventListener(TransitionEvent.IN_COMPLETE, onPageTransitionEvent);
			page.addEventListener(TransitionEvent.OUT_COMPLETE, onPageTransitionEvent);
			
			// armor events
			page.addEventListener(ArmorEvent.GOTO, onArmorEvent);
			page.addEventListener(ArmorEvent.PRELOAD, onArmorEvent);
			page.addEventListener(ArmorEvent.PRELOAD_COMPLETE, onArmorEvent);
			page.addEventListener(ArmorEvent.TRASITION_IN_BRANCH, onArmorEvent);
			page.addEventListener(ArmorEvent.TRASITION_IN_BRANCH_COMPLETE, onArmorEvent);
			page.addEventListener(ArmorEvent.TRASITION_OUT_BRANCH, onArmorEvent);
			page.addEventListener(ArmorEvent.TRASITION_OUT_BRANCH_COMPLETE, onArmorEvent);
			
			page.addEventListener(CrossPageNotificationEvent.RECEIVE, onCrossPageNotificationReceived);
		}
		
		override public function onRemove():void 
		{
			// page transition events
			page.removeEventListener(TransitionEvent.IN, onPageTransitionEvent);
			page.removeEventListener(TransitionEvent.OUT, onPageTransitionEvent);
			page.removeEventListener(TransitionEvent.IN_COMPLETE, onPageTransitionEvent);
			page.removeEventListener(TransitionEvent.OUT_COMPLETE, onPageTransitionEvent);
			
			// armor events
			page.removeEventListener(ArmorEvent.GOTO, onArmorEvent);
			page.removeEventListener(ArmorEvent.PRELOAD, onArmorEvent);
			page.removeEventListener(ArmorEvent.PRELOAD_COMPLETE, onArmorEvent);
			page.removeEventListener(ArmorEvent.TRASITION_IN_BRANCH, onArmorEvent);
			page.removeEventListener(ArmorEvent.TRASITION_IN_BRANCH_COMPLETE, onArmorEvent);
			page.removeEventListener(ArmorEvent.TRASITION_OUT_BRANCH, onArmorEvent);
			page.removeEventListener(ArmorEvent.TRASITION_OUT_BRANCH_COMPLETE, onArmorEvent);
			
			page.removeEventListener(CrossPageNotificationEvent.RECEIVE, onCrossPageNotificationReceived);
			
			viewComponent = null;
		}
		
		private function onPageTransitionEvent(e:TransitionEvent):void 
		{
			var ntName:String = null;
			switch(e.type)
			{
				case TransitionEvent.IN:ntName = PageNotifications.PAGE_TRANSITION_IN; break;
				case TransitionEvent.IN_COMPLETE:ntName = PageNotifications.PAGE_TRANSITION_IN_COMPLETE; break;
				case TransitionEvent.OUT:ntName = PageNotifications.PAGE_TRANSITION_OUT; break;
				case TransitionEvent.OUT_COMPLETE:ntName = PageNotifications.PAGE_TRANSITION_OUT_COMPELTE; break;
			}
			if (ntName) sendNotification(ntName, page);
			else Log.warning(this, "TransitionEvent to PageNotifications translation failed:", e.type);
		}
		
		private function onArmorEvent(e:ArmorEvent):void 
		{
			var ntName:String = null;
			switch(e.type)
			{
				case ArmorEvent.GOTO:ntName = ArmorEventNotifications.GOTO; break;
				case ArmorEvent.PRELOAD:ntName = ArmorEventNotifications.PRELOAD; break;
				case ArmorEvent.PRELOAD_COMPLETE:ntName = ArmorEventNotifications.PRELOAD_COMPLETE; break;
				case ArmorEvent.TRASITION_OUT_BRANCH:ntName = ArmorEventNotifications.TRASITION_OUT_BRANCH; break;
				case ArmorEvent.TRASITION_OUT_BRANCH_COMPLETE:ntName = ArmorEventNotifications.TRASITION_OUT_BRANCH_COMPLETE; break;
				case ArmorEvent.TRASITION_IN_BRANCH:ntName = ArmorEventNotifications.TRASITION_IN_BRANCH; break;
				case ArmorEvent.TRASITION_IN_BRANCH_COMPLETE:ntName = ArmorEventNotifications.TRASITION_IN_BRANCH_COMPLETE; break;
			}
			if (ntName) sendNotification(ntName, e.branch);
			else Log.warning(this, "ArmorEvent to ArmorEventNotifications translation failed:", e.type);
		}
		
		private function onCrossPageNotificationReceived(e:CrossPageNotificationEvent):void 
		{
			// 将外部收到的notification在core内转发
			if (_notificationsToRelay && _notificationsToRelay.indexOf(e.notificationName) != -1) sendNotification(e.notificationName, e.notificationBody, e.notificationType);
		}
		
		override public function listNotificationInterests():Array 
		{
			var notes:Array = [PageNotifications.REQUEST_GOTO];
			return notes.concat(_notificationsToBroadcast);
		}
		
		override public function handleNotification(notification:INotification):void 
		{
			if (_notificationsToBroadcast && _notificationsToBroadcast.indexOf(notification.getName()) != -1)
			{
				// 将需要发送给外部core的notification通过CrossPageNotificationEvent发送别的core
				page.dispatchEvent(new CrossPageNotificationEvent(CrossPageNotificationEvent.SEND, notification.getName(), notification.getBody(), notification.getType(), false, false));
			}
			else
			{
				switch(notification.getName())
				{
					case PageNotifications.REQUEST_GOTO: {
						var branch:String = notification.getBody() as String;
						if (!branch || branch == "") Log.error(this, "Request goto branch, but no branch specified in notification.");
						else page.dispatchEvent(new PageEvent(PageEvent.REQUEST_GOTO, branch, true, false));
						break;
					}
				}
			}
		}
		
		public function get page():IPage { return viewComponent as IPage; }
	}
	
}