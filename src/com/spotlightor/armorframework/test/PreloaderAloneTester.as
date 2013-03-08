package com.spotlightor.armorframework.test 
{
	import com.spotlightor.display.IPreloader;
	import com.spotlightor.loading.QueueLoader;
	import com.spotlightor.loading.SmartLoader;
	import flash.events.Event;
	import flash.events.ProgressEvent;
	/**
	 * ...
	 * @author 高鸣 - 交典创艺 (Spotlightor.com)
	 */
	public class PreloaderAloneTester
	{
		private var _preloader:IPreloader;
		public function PreloaderAloneTester(preloader:IPreloader, assetsURLs:Array) 
		{
			_preloader = preloader;
			
			var queueLoader:QueueLoader = new QueueLoader();
			for each (var item:String in assetsURLs) queueLoader.add(item, 100, null);
			queueLoader.addEventListener(Event.COMPLETE, onLoadingComplete);
			queueLoader.addEventListener(ProgressEvent.PROGRESS, onProgress);
			queueLoader.startLoading();
			_preloader.updateProgress(0, queueLoader.totalWeight);
			_preloader.transitionIn();
		}
		
		private function onLoadingComplete(e:Event):void 
		{
			_preloader.transitionOut();
		}
		
		private function onProgress(e:ProgressEvent):void 
		{
			_preloader.updateProgress(e.bytesLoaded, e.bytesTotal);
		}
		
	}

}