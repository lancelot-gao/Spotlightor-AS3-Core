package com.spotlightor.utils 
{
	/**
	 * 随机函数集合
	 * @author 高鸣 - 交典创艺 (Spotlightor.com)
	 */
	public class Random
	{
		/**
		 * 生成一个介于min和max之间的随机整数（可达到max值）
		 * @param	min
		 * @param	max
		 * @return
		 */
		public static function rangeInt(min:int, max:int):int
		{
			return min + Math.floor(Math.random() * (max + 1 - min));
		}
		
		/**
		 * 生成一个介于min和max之间的随机小数
		 * @param	min
		 * @param	max
		 * @return
		 */
		public static function rangeNumber(min:Number, max:Number):Number
		{
			return min + Math.random() * (max - min);
		}
		
		/**
		 * 生成一个多范围浮点数，依次传递min0, max0, min1, max1,...
		 * @param	..arguments	:(Number) min0, max0, min1, max1,...
		 * @return
		 */
		public static function multiRangeNumber(...arguments):Number
		{
			var ranges:Vector.<Number> = new Vector.<Number>();
			var totalRange:Number = 0;
			for (var i:int = 0; i < arguments.length - 1; i+=2) 
			{
				var min:Number = arguments[i];
				var max:Number = arguments[i + 1];
				var range:Number = max - min;
				ranges.push(range);
				totalRange += range;
			}
			
			i = 0;
			var randomValue:Number = Math.random() * totalRange;
			var rangeStack:Number = 0;
			while (randomValue >= rangeStack && i < ranges.length)
			{
				rangeStack += ranges[i];
				i++;
			}
			var rangeIndex:int = i - 1;
			var dToMax:Number = rangeStack - randomValue;
			
			var rangeMax:Number = arguments[rangeIndex * 2 +1];
			return rangeMax - dToMax;
		}
	}

}