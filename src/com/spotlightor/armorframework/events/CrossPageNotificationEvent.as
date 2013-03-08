package com.spotlightor.armorframework.events 
{
	import flash.events.Event;
	
	/**
	 * 将信息传递给其他IPage以及其他ModulePage
	 * 对于ModulePage，_name _body _type会被自动转化为notification并在core内发送
	 * 
	 * 当需要将某一个Notification共享给Armor中的所有Core时，由IPage发送SEND并携带信息。
	 * PageMediator会监听IPage的RECEIVE，获取别的Core广播的信息，转化为Notification，然后将它在自己的core内进行广播。
	 * 
	 * @author 高鸣 - 交典创艺 (Spotlightor.com)
	 */
	public class CrossPageNotificationEvent extends Event 
	{
		public static const SEND		:String = "cross_page_nt_evt_send";
		public static const RECEIVE		:String = "cross_page_nt_evt_receive";
		
		private var _notificationName	:String;
		private var _notificationBody	:Object;
		private var _notificationType	:String;
		
		public function CrossPageNotificationEvent(type:String, ntName:String, ntBody:Object = null, ntType:String = "", bubbles:Boolean=false, cancelable:Boolean=false) 
		{ 
			super(type, bubbles, cancelable);
			
			_notificationName = ntName;
			_notificationBody = ntBody;
			_notificationType = ntType;
		} 
		
		public override function clone():Event 
		{ 
			return new CrossPageNotificationEvent(type, _notificationName, _notificationBody, _notificationType, bubbles, cancelable);
		} 
		
		public override function toString():String 
		{ 
			return formatToString("CrossPageNotificationEvent", "type", "notificationName", "notificationBody", "notificationType", "bubbles", "cancelable", "eventPhase"); 
		}
		
		public function get notificationName():String { return _notificationName; }
		
		public function get notificationBody():Object { return _notificationBody; }
		
		public function get notificationType():String { return _notificationType; }
		
	}
	
}