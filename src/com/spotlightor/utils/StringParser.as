package com.spotlightor.utils 
{
	import flash.geom.Point;
	/**
	 * 在编写XML或某些文本文档的时候使用字符串表示各种数据类型（String, int, Number, bool, Point, Color...）
	 * 但是在获取这些不同类型的数据时，我们都需要做相应的“解码”，同时可能还需要加入默认值、最大最小值等检验
	 * 这里的函数帮助你简化这个“解码”+“校验”+(“默认值”)的过程，同时提供了一套通用的字符串数据编码格式
	 * 
	 * @author 高鸣 - 交典创艺 (Spotlightor.com)
	 */
	public class StringParser
	{
		public static function stringValue(element:String, defaultValue:String):String
		{
			if (element == null || element == "") {
				//Log.warning("[StringParser]", "未设置String element或该element的值为空");
				return defaultValue;
			}
			return element;
		}
		
		public static function intValue(element:String, defaultValue:int, max:int = int.MIN_VALUE, min:int = int.MAX_VALUE):int
		{
			if (element == null || element == "") {
				//Log.warning("[StringParser]", "未设置int element或该element的值为空");
				return defaultValue;
			}
			else {
				var result:int = parseInt(element);
				if (max > min) result = Math.max(min, Math.min(max, result));
				return result;
			}
		}
		
		public static function numberValue(element:String, defaultValue:Number, max:Number = Number.MAX_VALUE, min:Number = int.MIN_VALUE):Number
		{
			if (element == null || element == "") {
				//Log.warning("[StringParser]", "未设置Number element或该element的值为空");
				return defaultValue;
			}
			else {
				var result:Number = parseFloat(element);
				if (max > min) result = Math.max(min, Math.min(max, result));
				return result;
			}
		}
		
		public static function booleanValue(element:String, defaultValue:Boolean):Boolean
		{
			if (element == null || element == "") {
				//Log.warning("[StringParser]", "未设置boolean element或该element的值为空");
				return defaultValue;
			}
			element = element.toLowerCase();
			return element == "true" || element == "1";
		}
		
		/**
		 * 数据格式：	x,y
		 * 举例：		12.3,36
		 * 
		 * @param	element
		 * @param	defaultValue
		 * @param	max
		 * @param	min
		 * @return
		 */
		public static function pointValue(element:String, defaultValue:Point, max:Point = null, min:Point = null):Point
		{
			if (element == null || element == "") {
				//Log.warning("[StringParser]", "未设置Point element或该element的值为空");
				return defaultValue;
			}
			else {
				var splits:Array = element.split(',');
				if (splits && splits.length == 2)
				{
					var result:Point = new Point(numberValue(splits[0], defaultValue.x), numberValue(splits[1], defaultValue.y));
					if (max && min)
					{
						result.x = Math.max(max.x, Math.min(min.x, result.x));
						result.y = Math.max(max.y, Math.min(min.y, result.y));
					}
					return result;
				}
				else {
					Log.warning("[StringParser]", "Point element的格式不符合XX,XX的规范");
					return defaultValue;
				}
			}
		}
		
		/**
		 * 有时我们只是想表示一连串的数字，使用多个element有些繁琐，而且不便于不熟悉xml的人进行修改。
		 * 因此可以使用a,b,c,d,e的形式来表示一连串number
		 * 
		 * @param	element
		 * @param	defaultValue
		 * @return
		 */
		public static function numbersValue(element:String, defaultValue:Vector.<Number>):Vector.<Number>
		{
			if (element == null || element == "") {
				//Log.warning("[StringParser]", "未设置numbers element或该element的值为空");
				return defaultValue;
			}
			else {
				var splits:Array = element.split(',');
				if (splits && splits.length >= 1)
				{
					var result:Vector.<Number> = new Vector.<Number>();
					for (var i:int = 0; i < splits.length; i++) result.push(parseFloat(splits[i]));
					return result;
				}
				else {
					Log.warning("[StringParser]", "numbers element的格式不符合XX,XX,XX,XX,XX的规范");
					return defaultValue;
				}
			}
		}
	}

}