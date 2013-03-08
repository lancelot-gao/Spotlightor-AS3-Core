package com.spotlightor.armorframework.model.vo 
{
	import com.spotlightor.armorframework.constants.PageDepth;
	import com.spotlightor.utils.StringParser;
	import flash.utils.Dictionary;
	/**
	 * ...
	 * @author 高鸣 - 交典创艺 (Spotlightor.com)
	 */
	public class PageNode extends PageAsset
	{
		private var _title			:String;
		private var _menu			:Boolean = true;
		private var _landing		:Boolean = false;
		private var _assets			:Vector.<PageAsset>;
		private var _assetsDict		:Dictionary;// Use dictionary to store assets by id
		private var _childNodes		:Vector.<PageNode>;// Use vector to store child nodes by index.
		private var _childNodesDict	:Dictionary;// Use dictionary to store child nodes by id.
		private var _parentNode		:PageNode;
		private var _depth			:int;
		private var _container		:String;// 只有在depth=child的时候会用到，用来标明放在parent page中的哪个物体里面，例如mc_gallery.mc_content
		private var _preloaderID	:String;
		private var _unload			:Boolean;
		
		public function PageNode(xml:XML, parentNode:PageNode) 
		{
			_parentNode = parentNode;
			super(xml);
		}
		
		override protected function parseXML(xml:XML):void 
		{
			super.parseXML(xml);
			
			_title = StringParser.stringValue(xml.@title, id);
			_menu = StringParser.booleanValue(xml.@menu, _menu);
			_landing = StringParser.booleanValue(xml.@landing, _landing);
			
			if (xml.asset.length() > 0)
			{
				_assets = new Vector.<PageAsset>();
				_assetsDict = new Dictionary(true);
				for each (var assetXML:XML in xml.asset) 
				{
					var asset:PageAsset = new PageAsset(assetXML);
					_assets.push(asset);
					_assetsDict[asset.id] = asset;
				}
			}
			if (xml.page.length() > 0)
			{
				_childNodes = new Vector.<PageNode>();
				for each (var pageXML:XML in xml.page) _childNodes.push(new PageNode(pageXML, this));
				_childNodesDict = new Dictionary(true);
				for each (var pageNode:PageNode in _childNodes) _childNodesDict[pageNode.id] = pageNode;
			}
			else _landing = true; // 最后一页永远可以landing
			
			var depthName:String = xml.@depth;
			switch(depthName.toLowerCase())
			{
				case "top":			_depth = PageDepth.TOP; break;
				case "bottom":		_depth = PageDepth.BOTTOM; break;
				case "preloader":	_depth = PageDepth.PRELOADER; break;
				case "middle":		_depth = PageDepth.MIDDLE; break;
				case "child":		_depth = PageDepth.CHILD; break;
				default:			_depth = PageDepth.NULL; break; // null depth表示该asset不会自动加入到舞台上
			}
			
			_container = StringParser.stringValue(xml.@container, null);
			
			// preloader id
			_preloaderID = StringParser.stringValue(xml.@preloader, null);
			
			// Unload when transition out?
			_unload = StringParser.booleanValue(xml.@unload, false);
		}
		
		public function get title():String { return _title; }
		
		public function get menu():Boolean { return _menu; }
		
		public function get landing():Boolean { return _landing; }
		
		public function get assets():Vector.<PageAsset> { return _assets; }
		
		public function get assetsDict():Dictionary { return _assetsDict; }
		
		public function get childNodes():Vector.<PageNode> { return _childNodes; }
		
		public function get parentNode():PageNode { return _parentNode; }
		
		public function get childNodesDict():Dictionary { return _childNodesDict; }
		
		public function get preloaded():Boolean { return content != null; }
		
		public function get preloaderID():String { return _preloaderID;}
		
		public function get depth():int { return _depth; }
		
		public function get container():String 
		{
			return _container;
		}
		
		public function get unload():Boolean { return _unload; }
	}

}