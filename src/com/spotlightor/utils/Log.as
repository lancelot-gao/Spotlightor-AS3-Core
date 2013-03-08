package com.spotlightor.utils 
{
	import flash.utils.getQualifiedClassName;
	/**
	 * 输出不同级别的log信息
	 * @author 高鸣 - 交典创艺 (Spotlightor.com)
	 */
	public class Log
	{
		public static const LV_INFO		:int = 0;
		public static const LV_STATUS	:int = 1;
		public static const LV_DEBUG	:int = 2;
		public static const LV_WARNING	:int = 3;
		public static const LV_ERROR	:int = 4;
		public static const LV_FATAL	:int = 5;
		
		
		public static function info(source:*, ...arguments):void {
			log("INFO", source, arguments);
		}
		
		public static function status(source:*, ...arguments):void {
			log("STATUS", source, arguments);
		}
		
		public static function debug(source:*, ...arguments):void {
			log("DEBUG", source, arguments);
		}
		
		public static function warning(source:*, ...arguments):void {
			log("!WARNING", source, arguments);
		}
		
		public static function error(source:*, ...arguments):void {
			log("!!ERROR", source, arguments);
		}
		
		public static function fatal(source:*, ...arguments):void {
			log("!!!FATAL", source, arguments);
		}
		
		private static function log(level:String, source:*, objects:Array):void
		{
			var sourceClassName:String = source ? getClassName(source) : "";
			
			while (level.length < 8) level += " ";
			
			var logString = level + ":::	" + sourceClassName + "	:: ";
			for each (var item:Object in objects) 
			{
				if (item == null) logString += " NULL";
				else logString += ' ' + item.toString();
				//if (item || item) logString += " " + item.toString();
				//else logString += " null";
			}
			
			trace(logString);
		}
		
		private static function getClassName(obj:*):String {
			if (obj is String) return obj;
			var flashClassName:String = getQualifiedClassName(obj);
			return flashClassName.split("::")[1] || flashClassName;
		}
	}

}