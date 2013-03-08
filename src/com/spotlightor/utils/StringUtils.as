package com.spotlightor.utils 
{
	/**
	 * ...
	 * @author 高鸣 - 交典创艺 (Spotlightor.com)
	 */
	public class StringUtils
	{
		
		/**
		 * 将整数value转换为固定位数的整数字符串（前方补零）
		 * @param	value:	(int) 转换的整数
		 * @param	length:	(int) 位数
		 * @return
		 */
		public static function toFixedInt(value:int, length:int):String
		{
			var absValue:int = Math.abs(value);
			var result:String = absValue.toString();
			while (result.length < length) result = "0" + result;
			if (value < 0) result = "-" + result;
			return result;
		}
		
		public static function formatDate(date:Date, split:String = '_'):String
		{
			return toFixedInt(date.fullYear, 4) + split + toFixedInt(date.month + 1, 2) + split + toFixedInt(date.date, 2) + split + toFixedInt(date.hours, 2) + split + toFixedInt(date.minutes, 2) + split + toFixedInt(date.seconds, 2) + split + toFixedInt(date.milliseconds, 3);
		}
	}

}