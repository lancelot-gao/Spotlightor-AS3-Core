package com.spotlightor.loading 
{
	import com.spotlightor.utils.Log;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.IOErrorEvent;
	import flash.events.ProgressEvent;
	import flash.system.ApplicationDomain;
	import flash.utils.Dictionary;
	/**
	 * 依次载入一系列资源文件。
	 * 可以同时开启多个载入进程（MAX_CONNECTIONS）。
	 * 会像普通loader一样发出ProgressEvent/Event.Complete/IOError_Event
	 * 目前为一次性使用，一旦_loaderStarted以后就无法再add，即使dispose
	 * 
	 * @author 高鸣 - 交典创艺 (Spotlightor.com)
	 */
	public class QueueLoader extends EventDispatcher
	{
		/**
		 * 最多同时进行的载入进程
		 */
		public static var MAX_CONNECTIONS	:int = 2;
		
		private var _itemsToLoad	:Vector.<SmartLoader>;
		private var _itemsWeight	:Vector.<Number>;
		private var _totalWeight	:Number = 0;
		
		private var _loaderStarted			:Boolean = false;
		private var _numActiveLoaders		:int = 0;
		private var _nextLoaderIndex		:int = 0;
		private var _numCompleteLoaders		:int = 0;
		private var _numErrorLoaders		:int = 0;
		
		public function QueueLoader() 
		{
			_itemsToLoad = new Vector.<SmartLoader>();
			_itemsWeight = new Vector.<Number>();
		}
		
		/**
		 * 增加一个待载入资源到队列中
		 * @param	url
		 * @param	weight
		 * @param	id
		 * @return
		 */
		public function add(url:String, weight:Number, appDomain:ApplicationDomain, id:String = null):SmartLoader
		{
			if (_loaderStarted) 
			{
				Log.error(this, "You can't add anything any more.");
				return null;
			}
			
			if (id == null) id = url;
			
			var smartLoader:SmartLoader = new SmartLoader(url, id, appDomain);
			smartLoader.addEventListener(ProgressEvent.PROGRESS, onItemProgress, false, 999, false);
			smartLoader.addEventListener(IOErrorEvent.IO_ERROR, onItemLoadingError, false, 999, false);
			smartLoader.addEventListener(Event.COMPLETE, onItemLoadingComplete, false, 999, false);
			
			_itemsToLoad.push(smartLoader);
			_itemsWeight.push(weight);
			
			_totalWeight += weight;
			
			return smartLoader;
		}
		
		/**
		 * 开始载入队列
		 */
		public function startLoading():void
		{
			if (_loaderStarted)
			{
				Log.warning(this, "Loader has already started.");
				return;
			}
			_loaderStarted = true;
			Log.status(this, "Start loading " + _itemsToLoad.length.toString() + " items.");
			
			var numToLoad:int = Math.min(_itemsToLoad.length, MAX_CONNECTIONS);
			while (_numActiveLoaders < numToLoad) {
				loadNextItem();
			}
		}
		
		/**
		 * 释放内存
		 */
		public function dispose():void
		{
			for each (var item:SmartLoader in _itemsToLoad) item.dispose();
			
			_itemsToLoad = null;
			_itemsWeight = null;
		}
		
		/**
		 * 根据add时指定的id获取载入的资源内容
		 * @param	id	(String): 在add的时候所指定的id
		 * @return
		 */
		public function getContentByID(id:String):*
		{
			if (!_itemsToLoad) return null;
			
			for each (var item:SmartLoader in _itemsToLoad) 
			{
				if (item.id == id) return item.content;
			}
			return null;
		}
		
		/**
		 * 将所有载入的资源以id为key置入一个字典中，并返回该字典
		 * @return
		 */
		public function getContentsDictionary():Dictionary
		{
			var contents:Dictionary = new Dictionary(true);
			for each (var item:SmartLoader in _itemsToLoad) contents[item.id] = item.content;
			return contents;
		}
		
		/**
		 * 将所有载入的资源依次（add的顺序）放入数组，并返回该数组
		 * @return
		 */
		public function getContentsArray():Array
		{
			var contents:Array = new Array();
			for each (var item:SmartLoader in _itemsToLoad) contents.push(item.content);
			return contents;
		}
		
		/**
		 * 根据_nextLoaderIndex载入下一个item，并更新_numActiveLoaders & _nextLoaderIndex
		 */
		private function loadNextItem():void
		{
			var loader:SmartLoader = _itemsToLoad[_nextLoaderIndex];
			loader.startLoading();
			
			Log.status(this, "Start loading", loader, "url:" + loader.url);
			
			_numActiveLoaders ++;
			_nextLoaderIndex++;
		}
		
		private function onItemLoadingComplete(e:Event):void 
		{
			var loader:SmartLoader = (e.target as SmartLoader);
			Log.status(this, "Complete loading", loader);
			
			cleanupLoaderAndTryLoadingNext(loader, true);
		}
		
		private function onItemLoadingError(e:IOErrorEvent):void 
		{
			var loader:SmartLoader = (e.target as SmartLoader);
			Log.error(this, "Can't load", loader);
			
			cleanupLoaderAndTryLoadingNext(loader, false);
		}
		
		private function onItemProgress(e:ProgressEvent):void 
		{
			var weightLoaded:Number = 0;
			for (var i:int = 0; i < _itemsToLoad.length; i++) weightLoaded += _itemsWeight[i] * _itemsToLoad[i].percentLoaded;
			
			dispatchEvent(new ProgressEvent(ProgressEvent.PROGRESS, false, false, weightLoaded, _totalWeight));
		}
		
		/**
		 * 移除loader的所有event listeners
		 * 根据isComplete更新_numActiveLoaders/_numCompleteLoaders/_numErrorLoaders，
		 * 尝试载入下一个资源文件，如果没有下一个了，则根据载入的情况调用相应的结束函数（allLoadersComplete/notAllLoadersComplete）
		 * 
		 * @param	loader
		 * @param	isComplete
		 */
		private function cleanupLoaderAndTryLoadingNext(loader:SmartLoader, isComplete:Boolean = true):void
		{
			loader.removeEventListener(ProgressEvent.PROGRESS, onItemProgress);
			loader.removeEventListener(IOErrorEvent.IO_ERROR, onItemLoadingError);
			loader.removeEventListener(Event.COMPLETE, onItemLoadingComplete);
			
			_numActiveLoaders--;
			if (isComplete)_numCompleteLoaders++;
			else _numErrorLoaders++;
			
			if (_numCompleteLoaders == _itemsToLoad.length) allLoadersComplete();
			else if (_nextLoaderIndex < _itemsToLoad.length) loadNextItem();
			else if (_numActiveLoaders > 0) { }
			else notAllLoadersComplete();// 所有loader都已经完成，但有一部分item没能正常载入
		}
		
		private function allLoadersComplete():void
		{
			Log.status(this, "Loading complete.");
			dispatchEvent(new Event(Event.COMPLETE));
		}
		
		private function notAllLoadersComplete():void
		{
			Log.error(this, "Some of the loaders are not complete!");
			dispatchEvent(new IOErrorEvent(IOErrorEvent.IO_ERROR, false, false, "Some of the loaders cannot be loaded!"));
		}
		
		public function get totalWeight():Number { return _totalWeight; }
	}
}