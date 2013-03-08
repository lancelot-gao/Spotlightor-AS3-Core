package com.spotlightor.armorframework.model.vo 
{
	import com.spotlightor.armorframework.constants.PageDepth;
	import com.spotlightor.utils.Log;
	import com.spotlightor.utils.StringParser;
	import flash.system.ApplicationDomain;
	/**
	 * ...
	 * @author 高鸣 - 交典创艺 (Spotlightor.com)
	 */
	public class PageAsset
	{
		protected var _id			:String;
		protected var _src			:String;
		protected var _bytes		:int;
		protected var _content		:* = null;
		protected var _appDomain	:ApplicationDomain;// child; isolated; current(default)
		
		
		public function PageAsset(xml:XML) 
		{
			parseXML(xml);
		}
		
		protected function parseXML(xml:XML):void
		{
			_id = StringParser.stringValue(xml.@id, "");
			_src = StringParser.stringValue(xml.@src, "");
			if (_id == "") Log.error(this, "id is null");
			if (_src == "") Log.error(this, "src is null");
			
			var domain:String = StringParser.stringValue(xml.@domain, "");
			if (domain == "child") _appDomain = new ApplicationDomain(ApplicationDomain.currentDomain);
			else if (domain == "isolated") _appDomain = new ApplicationDomain(null);
			else _appDomain = ApplicationDomain.currentDomain;
			
			_bytes = StringParser.intValue(xml.@bytes, 100, int.MAX_VALUE, 1);
		}
		
		public function get id():String { return _id; }
		
		public function get src():String { return _src; }
		
		public function get bytes():int { return _bytes; }
		
		public function get content():* { return _content; }
		
		public function set content(value:*):void { _content = value; }
		
		public function get appDomain():ApplicationDomain 
		{
			return _appDomain;
		}
	}

}