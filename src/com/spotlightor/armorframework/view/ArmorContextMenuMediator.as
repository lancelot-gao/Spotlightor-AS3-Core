package com.spotlightor.armorframework.view 
{
	import com.spotlightor.armorframework.constants.ArmorNotifications;
	import com.spotlightor.armorframework.model.ArmorStructureProxy;
	import com.spotlightor.armorframework.model.vo.PageNode;
	import com.spotlightor.armorframework.modulepage.constants.PageNotifications;
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.ContextMenuEvent;
	import flash.ui.ContextMenu;
	import flash.ui.ContextMenuItem;
	import flash.utils.Dictionary;
	import org.puremvc.as3.multicore.patterns.mediator.Mediator;
	import org.puremvc.as3.multicore.interfaces.INotification;
	
	/**
	 * ...
	 * @author Gao Ming (Spotlightor Interactive)
	 */
	public class ArmorContextMenuMediator extends Mediator 
	{
		public static const NAME:String = "mediator_ArmorContextMenuMediator";
		
		protected var _captionPageIdDict:Dictionary;
		
		public function ArmorContextMenuMediator(viewComponent:Object) 
		{ 
			super(NAME, viewComponent);
		} 
		
		override public function onRegister():void 
		{
			buildContextMenu();
		}
		
		protected function buildContextMenu():void
		{
			var menu:ContextMenu = new ContextMenu();
			menu.hideBuiltInItems();
			
			var structureProxy:ArmorStructureProxy = facade.retrieveProxy(ArmorStructureProxy.NAME) as ArmorStructureProxy;
			var pageNode:PageNode = structureProxy.indexPageNode;
			
			addPageLinksHierachy(pageNode, menu, 0);
			
			view.contextMenu = menu;
		}
		
		protected function addPageLinksHierachy(pageNode:PageNode, menu:ContextMenu, lv:int):void
		{
			if (pageNode.landing && pageNode.menu) {
				var item:ContextMenuItem = new ContextMenuItem(getPageLinkTextFromPageNode(pageNode, lv), false, true, true);
				item.addEventListener(ContextMenuEvent.MENU_ITEM_SELECT, onSelectPageLink);
				menu.customItems.push(item);
				if (_captionPageIdDict == null)_captionPageIdDict = new Dictionary(true);
				_captionPageIdDict[item.caption] = pageNode.id;
				lv ++;
			}
			if (pageNode.childNodes && pageNode.childNodes.length > 0)
			{
				for each (var childPageNode:PageNode in pageNode.childNodes) addPageLinksHierachy(childPageNode, menu, lv);
			}
		}
		
		protected function getPageLinkTextFromPageNode(pageNode:PageNode, lv:int):String
		{
			var text:String = "";
			if (i > 0) text += " ";
			for (var i:int = 0; i < lv; i++) text += "-";
			if (i > 0) text += " ";
			text += pageNode.title;
			return text;
		}
		
		protected function getPageIdFromMenuCaption(caption:String):String
		{
			return _captionPageIdDict[caption] as String;
		}
		
		private function onSelectPageLink(e:ContextMenuEvent):void 
		{
			var menuItem:ContextMenuItem = e.target as ContextMenuItem;
			var pageID:String = getPageIdFromMenuCaption(menuItem.caption);
			sendNotification(ArmorNotifications.REQUEST_GOTO, pageID);
		}
		
		override public function listNotificationInterests():Array 
		{
			return [];
		}
		
		override public function handleNotification(notification:INotification):void 
		{
			switch(notification.getName())
			{
				
			}
		}
		
		public function get view():MovieClip { return viewComponent as MovieClip; }
	}
	
}