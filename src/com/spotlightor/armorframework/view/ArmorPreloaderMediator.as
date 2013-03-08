package com.spotlightor.armorframework.view 
{
	import com.spotlightor.armorframework.constants.ArmorNotifications;
	import com.spotlightor.display.IPreloader;
	import com.spotlightor.loading.SmartLoader;
	import com.spotlightor.utils.Log;
	import flash.events.Event;
	import flash.events.ProgressEvent;
	import flash.system.ApplicationDomain;
	import flash.utils.Dictionary;
	import org.puremvc.as3.multicore.patterns.mediator.Mediator;
	import org.puremvc.as3.multicore.interfaces.INotification;
	
	/**
	 * ...
	 * @author 高鸣 - 交典创艺 (Spotlightor.com)
	 */
	public class ArmorPreloaderMediator extends Mediator 
	{
		public static const NAME:						String = "mediator_ArmorPreloaderMediator";
		public static const DEFAULT_PRELOADER_ID		:String = "preloader";
		
		private var _preloaders:Dictionary;
		
		public function ArmorPreloaderMediator(preloaderURL:String = "preloader.swf") 
		{ 
			super(NAME, null);
			
			var preloaderLoader:SmartLoader = new SmartLoader(preloaderURL, "preloader", ApplicationDomain.currentDomain);
			preloaderLoader.addEventListener(Event.COMPLETE, onPreloaderLoaded);
			preloaderLoader.startLoading();
		}
		
		private function onPreloaderLoaded(e:Event):void 
		{
			var loaded:IPreloader = (e.target as SmartLoader).content as IPreloader;
			if (loaded == null)
			{
				Log.fatal(this, "The preloader is not valid IPreloader:", (e.target as SmartLoader).content);
				return;
			}
			else
			{
				viewComponent = loaded;
				Log.status(this, "Preloader loaded:", loaded);
				sendNotification(ArmorNotifications.PRELOADER_LOADED, loaded);
			}
		}
		
		/**
		 * 注册一个新的preloader，然后在page xmlnode中指定preloader = id即可使用对应的preloader进入载入
		 * @param	newPreloader
		 * @param	id
		 */
		public function registerPreloader(newPreloader:IPreloader, id:String):void
		{
			if (!_preloaders)
			{
				_preloaders = new Dictionary(true);
				_preloaders[DEFAULT_PRELOADER_ID] = viewComponent;
			}
			_preloaders[id] = newPreloader;
			viewComponent = newPreloader;
			Log.info(this, "New preloader registered:", newPreloader, "with id", id);
		}
		
		private function changePreloaderByID(preloaderID:String):void
		{
			if (preloaderID == null || preloaderID == DEFAULT_PRELOADER_ID) viewComponent = defaultPreloader;
			else if (_preloaders == null || _preloaders[preloaderID] == null) sendNotification(ArmorNotifications.ADD_NEW_PRELOADER, preloaderID);
		}
		
		override public function listNotificationInterests():Array 
		{
			return [ArmorNotifications.PRELOAD_BRANCH_START, ArmorNotifications.PRELOAD_BRANCH_PROGRESS, ArmorNotifications.PRELOAD_BRANCH_COMPLETE];
		}
		
		override public function handleNotification(notification:INotification):void 
		{
			switch(notification.getName())
			{
				case ArmorNotifications.PRELOAD_BRANCH_START: {
					changePreloaderByID(notification.getType());
					trace(preloader);
					preloader.updateProgress(0, 0);
					preloader.transitionIn();
					break;
				}
				case ArmorNotifications.PRELOAD_BRANCH_PROGRESS: {
					var progressEvent:ProgressEvent = notification.getBody() as ProgressEvent;
					if (progressEvent) preloader.updateProgress(progressEvent.bytesLoaded, progressEvent.bytesTotal);
					break;
				}
				case ArmorNotifications.PRELOAD_BRANCH_COMPLETE: {
					preloader.transitionOut();
					break;
				}
			}
		}
		
		public function get preloader():IPreloader { return viewComponent as IPreloader; }
		
		private function get defaultPreloader():IPreloader { 
			if (_preloaders != null) return _preloaders[DEFAULT_PRELOADER_ID];
			else return viewComponent as IPreloader;
		}
	}
	
}