package com.spotlightor.armorframework.view 
{
	import com.spotlightor.armorframework.constants.ArmorNotifications;
	import com.spotlightor.armorframework.events.ArmorEvent;
	import com.spotlightor.armorframework.events.CrossPageNotificationEvent;
	import com.spotlightor.armorframework.events.PageEvent;
	import com.spotlightor.armorframework.interfaces.IPage;
	import com.spotlightor.armorframework.model.vo.PageNode;
	import com.spotlightor.utils.Log;
	import org.puremvc.as3.multicore.interfaces.INotification;
	import org.puremvc.as3.multicore.patterns.mediator.Mediator;
	import org.puremvc.as3.multicore.patterns.observer.Notification;
	
	/**
	 * ...
	 * @author 高鸣 - 交典创艺 (Spotlightor.com)
	 */
	public class PageMediator extends Mediator 
	{
		private var _pageID:String;
		public function PageMediator(page:IPage, id:String) 
		{
			super(nameByPageID(id), page);
			
			_pageID = id;
			page.addEventListener(PageEvent.REQUEST_GOTO, onPageRequestGoto);
			page.addEventListener(CrossPageNotificationEvent.SEND, onPageSendCrossPageNotification);
		} 
		
		override public function onRemove():void 
		{
			page.removeEventListener(PageEvent.REQUEST_GOTO, onPageRequestGoto);
			page.removeEventListener(CrossPageNotificationEvent.SEND, onPageSendCrossPageNotification);
			viewComponent = null;
			
			Log.info(this, "Page mediator", _pageID, "removed.");
		}
		
		private function onPageSendCrossPageNotification(e:CrossPageNotificationEvent):void 
		{
			sendNotification(ArmorNotifications.CROSS_PAGE_NOTIFICATION, new Notification(e.notificationName, e.notificationBody, e.notificationType), _pageID);
		}
		
		private function onPageRequestGoto(e:PageEvent):void 
		{
			sendNotification(ArmorNotifications.REQUEST_GOTO, e.object as String);
		}
		
		public static function nameByPageID(pageID:String):String
		{
			return "mediator_armorframework_page_" + pageID;
		}
		
		override public function listNotificationInterests():Array 
		{
			return [ArmorNotifications.CROSS_PAGE_NOTIFICATION, ArmorNotifications.GOTO_INTERNAL, ArmorNotifications.PRELOAD_BRANCH_START, ArmorNotifications.PRELOAD_BRANCH_COMPLETE,
			ArmorNotifications.TRANSITION_IN_BRANCH, ArmorNotifications.TRANSITION_IN_BRANCH_COMPLETE, ArmorNotifications.TRANSITION_OUT_BRANCH, ArmorNotifications.TRANSITION_OUT_BRANCH_COMPLETE];
		}
		
		override public function handleNotification(notification:INotification):void 
		{
			switch(notification.getName())
			{
				case ArmorNotifications.CROSS_PAGE_NOTIFICATION: {
					if (notification.getType() != _pageID) 
					{
						var crossPageNotification:Notification = notification.getBody() as Notification;
						page.dispatchEvent(new CrossPageNotificationEvent(CrossPageNotificationEvent.RECEIVE, crossPageNotification.getName(), crossPageNotification.getBody(), crossPageNotification.getType(), false, false));
					}
					break;
				}
				case ArmorNotifications.GOTO_INTERNAL: {
					page.dispatchEvent(new ArmorEvent(ArmorEvent.GOTO, branchNodeToBranchString(notification.getBody() as Vector.<PageNode>)));
					break;
				}
				case ArmorNotifications.PRELOAD_BRANCH_START: {
					page.dispatchEvent(new ArmorEvent(ArmorEvent.PRELOAD, branchNodeToBranchString(notification.getBody() as Vector.<PageNode>)));
					break;
				}
				case ArmorNotifications.PRELOAD_BRANCH_COMPLETE: {
					page.dispatchEvent(new ArmorEvent(ArmorEvent.PRELOAD_COMPLETE, branchNodeToBranchString(notification.getBody() as Vector.<PageNode>)));
					break;
				}
				case ArmorNotifications.TRANSITION_IN_BRANCH: {
					page.dispatchEvent(new ArmorEvent(ArmorEvent.TRASITION_IN_BRANCH, branchNodeToBranchString(notification.getBody() as Vector.<PageNode>)));
					break;
				}
				case ArmorNotifications.TRANSITION_IN_BRANCH_COMPLETE: {
					page.dispatchEvent(new ArmorEvent(ArmorEvent.TRASITION_IN_BRANCH_COMPLETE, branchNodeToBranchString(notification.getBody() as Vector.<PageNode>)));
					break;
				}
				case ArmorNotifications.TRANSITION_OUT_BRANCH: {
					page.dispatchEvent(new ArmorEvent(ArmorEvent.TRASITION_OUT_BRANCH, branchNodeToBranchString(notification.getBody() as Vector.<PageNode>)));
					break;
				}
				case ArmorNotifications.TRANSITION_OUT_BRANCH_COMPLETE: {
					page.dispatchEvent(new ArmorEvent(ArmorEvent.TRASITION_OUT_BRANCH_COMPLETE, branchNodeToBranchString(notification.getBody() as Vector.<PageNode>)));
					break;
				}
			}
		}
		
		private function branchNodeToBranchString(branchNode:Vector.<PageNode>):String
		{
			if (branchNode == null) return "";
			var branch:String = "";
			for (var i:int = 0; i < branchNode.length; i++) 
			{
				branch += branchNode[i].id;
				if (i < branchNode.length - 1) branch += "/";
			}
			return branch;
		}
		
		protected function get page():IPage { return viewComponent as IPage; }
	}
	
}