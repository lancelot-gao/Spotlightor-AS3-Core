package com.spotlightor.loading 
{
	import com.spotlightor.utils.Log;
	import flash.display.DisplayObject;
	import flash.display.Loader;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.IOErrorEvent;
	import flash.events.ProgressEvent;
	import flash.media.Sound;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	import flash.system.ApplicationDomain;
	import flash.system.LoaderContext;
	/**
	 * 将URLLoader和Loader二合为一，根据传入的URL自动判断该使用哪种loader
	 * 当载入失败时，会自动重试一定次数。
	 * 会像一般的Loader/URLLoader一样发送各种载入事件
	 * 
	 * @author 高鸣 - 交典创艺 (Spotlightor.com)
	 */
	public class SmartLoader extends EventDispatcher
	{
		public static const TYPE_MEDIA		:int = 0;
		public static const TYPE_DATA		:int = 1;
		public static const TYPE_SOUND		:int = 2;
	
		public static const STATE_IDEL		:int = 0;// 挂起状态，loader未运行
		public static const STATE_LOADING	:int = 1;// 正在载入
		public static const STATE_LOADED	:int = 2;// 载入完毕
		
		public static var MAX_ATTEMPTS		:int = 3;// 最大重试次数
		
		protected var _url			:String;
		protected var _id			:String;
		protected var _type			:int;
		protected var _state		:int;
		protected var _pctLoaded	:Number = 0;
		
		protected var _attempts		:int = 0;
		
		protected var _loader		:*;
		protected var _context		:LoaderContext;
		
		public function SmartLoader(url:String, id:String, appDomain:ApplicationDomain) 
		{
			_url = url;
			_id = id;
			
			_type = getLoaderTypeByURL(url);
			_context = new LoaderContext(false, appDomain); // 默认为currentDomain
			
			initLoader();
			
			_state = STATE_IDEL;
		}
		
		/**
		 * 根据url判断应该使用的loader类型
		 * @param	url
		 * @return	(int):	TYPE_DATA / TYPE_MEDIA
		 */
		private function getLoaderTypeByURL(url:String):int
		{
			var ext:String = url.substr(url.lastIndexOf('.') + 1).toLowerCase();
			switch(ext)
			{
				case "xml":
				case "txt": return TYPE_DATA;
				case "mp3": return TYPE_SOUND;
				case "png": 
				case "jpg":
				case "swf":
				case "gif":
				case "bmp": return TYPE_MEDIA;
				default:
					return TYPE_DATA
			}
		}
		
		/**
		 * 根据载入素材的类型初始化loader并注册event listener
		 */
		private function initLoader():void
		{
			var progressEventDispatcher:EventDispatcher = null;
			if (_type == TYPE_DATA)
			{
				_loader = new URLLoader();
				progressEventDispatcher = _loader;
			}
			else if (_type == TYPE_MEDIA)
			{
				_loader = new Loader();
				progressEventDispatcher = (_loader as Loader).contentLoaderInfo;
			}
			else if (_type == TYPE_SOUND)
			{
				_loader = new Sound();
				progressEventDispatcher = _loader;
			}
			else Log.fatal(this, "Loading unknown type.", _url);
			
			if (progressEventDispatcher)
			{
				progressEventDispatcher.addEventListener(IOErrorEvent.IO_ERROR, onLoadingError, false, 0, false);
				progressEventDispatcher.addEventListener(ProgressEvent.PROGRESS, onProgress, false, 0, false);
				progressEventDispatcher.addEventListener(Event.COMPLETE, onLoadingComplete, false, 0, false);
			}
			_pctLoaded = 0;
		}
		
		/**
		 * 开始载入
		 */
		public function startLoading():void 
		{
			if (_state == STATE_IDEL)
			{
				_state = STATE_LOADING;
				if (_loader is URLLoader || _loader is Sound)_loader.load(new URLRequest(_url));
				else _loader.load(new URLRequest(_url), _context);
			}
			else if (_state == STATE_LOADED) onLoadingComplete(null);
			else Log.warning(this, "Item is loading...", _url);
		}
		
		/**
		 * 载入完成后请手动调用本函数，释放loader以及所有event listener
		 */
		public function dispose():void
		{
			if (!_loader) return;
			
			if (_state == STATE_LOADING) {
				try {
					_loader.close();
				}catch (e:Error){}
			}
			
			var progressEventDispatcher:EventDispatcher;
			if (_type != TYPE_MEDIA) progressEventDispatcher = _loader;
			else progressEventDispatcher = (_loader as Loader).contentLoaderInfo;
			
			if (progressEventDispatcher)
			{
				progressEventDispatcher.removeEventListener(IOErrorEvent.IO_ERROR, onLoadingError);
				progressEventDispatcher.removeEventListener(ProgressEvent.PROGRESS, onProgress);
				progressEventDispatcher.removeEventListener(Event.COMPLETE, onLoadingComplete);
			}
			
			_loader = null;
		}
		
		private function onLoadingComplete(e:Event):void 
		{
			_pctLoaded = 1;
			_state = STATE_LOADED;
			dispatchEvent(new Event(Event.COMPLETE));
		}
		
		private function onProgress(e:ProgressEvent):void 
		{
			_pctLoaded = e.bytesLoaded / e.bytesTotal;
			dispatchEvent(e);
		}
		
		private function onLoadingError(e:IOErrorEvent):void 
		{
			_pctLoaded = 0;
			_state = STATE_IDEL;
			_attempts++;
			if (_attempts < MAX_ATTEMPTS) startLoading();// 重试
			else 
			{
				// 超过重试次数
				_attempts = 0;
				dispatchEvent(e);
			}
		}
		
		public function get url():String { return _url; }
		
		public function get id():String { return _id; }
		
		public function get type():int { return _type; }
		
		public function get content():* {
			if (!_loader) return null;
			if (_type == TYPE_DATA) return (_loader as URLLoader).data;
			else if (_type == TYPE_SOUND) return _loader as Sound;
			else return (_loader as Loader).content;
		}
		
		public function get percentLoaded():Number { return _pctLoaded; }
		
		override public function toString():String 
		{
			return "[SmartLoader :: " + _id + "]";
		}
	}

}