package com.spotlightor.armorframework 
{
	import com.spotlightor.armorframework.constants.PageDepth;
	import com.spotlightor.utils.Log;
	import flash.display.DisplayObject;
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.Event;
	/**
	 * 网站架构的最上层(Shell)
	 * @author 高鸣 - 交典创艺 (Spotlightor.com)
	 */
	public class ArmorMain extends MovieClip
	{
		private var _layerPreloader:Sprite;
		private var _layerTop:Sprite;
		private var _layerMiddle:Sprite;
		private var _layerBottom:Sprite;
		
		public function startup():void
		{
			ArmorApplicationFacade.getInstance(key).startup(this);
		}
		
		protected function get key():String {
			Log.warning(this, "应该override key getter为每一个application指定一个新的key，这样更为保险。");
			return "shell-armor";
		}
		
		/**
		 * 在app.xml载入后再调用本函数，因为其中可能有一些设置会改变Layers的属性（例如Preloader depth）
		 */
		public function initializeLayers():void
		{
			_layerBottom = new Sprite();
			_layerMiddle = new Sprite();
			_layerTop = new Sprite();
			_layerPreloader = new Sprite();
			
			_layerBottom.mouseEnabled = false;
			_layerMiddle.mouseEnabled = false;
			_layerTop.mouseEnabled = false;
			_layerPreloader.mouseEnabled = false;
			
			addChild(_layerBottom);
			addChild(_layerMiddle);
			addChild(_layerTop);
			addChild(_layerPreloader);
			
			//TODO: if preloader depth...
		}
		
		public function addChildAtDepth(child:DisplayObject, depth:int = PageDepth.MIDDLE):DisplayObject
		{
			if (child == null) {
				Log.error(this, "Cannot add null child at depth", depth);
			}
			switch(depth)
			{
				case PageDepth.BOTTOM		: _layerBottom.addChild(child); break;
				case PageDepth.MIDDLE		: _layerMiddle.addChild(child); break;
				case PageDepth.TOP			: _layerTop.addChild(child); break;
				case PageDepth.PRELOADER	: _layerPreloader.addChild(child); break;
				default						: _layerMiddle.addChild(child); break;
			}
			return child;
		}
	}

}