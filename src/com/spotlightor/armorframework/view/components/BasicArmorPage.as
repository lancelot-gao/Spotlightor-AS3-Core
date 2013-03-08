package com.spotlightor.armorframework.view.components
{
	import com.spotlightor.armorframework.events.PageEvent;
	import com.spotlightor.armorframework.interfaces.IPage;
	import com.spotlightor.armorframework.test.PageAloneTester;
	import com.spotlightor.display.ITransitionManager;
	import flash.display.MovieClip;
	import flash.utils.Dictionary;
	
	/**
	 * 一个基本的ArmorPage模版，一个好的开始
	 * 
	 * @author Gao Ming (Spotlightor Interactive)
	 */
	public class BasicArmorPage extends MovieClip implements IPage
	{
		protected var _transitionManager:ITransitionManager;
		
		public function BasicArmorPage (transitionManager:ITransitionManager, pageID:String, appXmlURL:String = "app.xml") 
		{
			_transitionManager = transitionManager;
			if (stage) {// in debug mode
				new PageAloneTester(this, appXmlURL, pageID);
			}
		}
		
		/**
		 * 向Armor Shell发送前往某一个页面的请求
		 * @param	pageID
		 */
		public function requestGotoPage(pageID:String):void
		{
			dispatchEvent(new PageEvent(PageEvent.REQUEST_GOTO, pageID));
		}
		
		/* INTERFACE com.spotlightor.armorframework.interfaces.IPage */
		
		public function onAssetsLoaded(assets:Dictionary):void
		{
			// Override me
		}
		
		public function transitionIn(instant:Boolean = false):void
		{
			if (_transitionManager)_transitionManager.transitionIn(instant);
		}
		
		public function transitionOut(instant:Boolean = false):void
		{
			if (_transitionManager)_transitionManager.transitionOut(instant);
		}
		
	}

}