package com.spotlightor.utils
{
	
	/**
	 * ...
	 * @author 高鸣 - 交典创艺 (Spotlightor.com)
	 */
	public class MathUtils
	{
		/**
		 * 一些很有用的常量
		 */
		public static const TWO_PI:Number = 2 * Math.PI;
		public static const HALF_PI:Number = 0.5 * Math.PI;
		public static const TO_DEGREES:Number = 180 / Math.PI;
		public static const TO_RADIANS:Number = Math.PI / 180;
		
		/**
		 * 单位化，根据min和max将value转换为0-1的小数
		 *
		 * @param $value 	Number
		 * @param $min		Number
		 * @param $max		Number
		 * @return 			Number
		 *
		 */
		public static function normalize($value:Number, $min:Number, $max:Number):Number
		{
			return ($value - $min) / ($max - $min);
		}
		
		/**
		 * 差值，根据normValue得到介于min和max之间的数值
		 *
		 * @param $normValue	Number
		 * @param $min			Number
		 * @param $max			Number
		 * @return 				Number
		 *
		 */
		public static function interpolate($normValue:Number, $min:Number, $max:Number):Number
		{
			return $min + ($max - $min) * $normValue;
		}
		
		/**
		 * 保持value在min和max之间
		 * @param	value
		 * @param	min
		 * @param	max
		 * @return
		 */
		public static function bounds(value:Number, min:Number, max:Number):Number
		{
			return Math.min(max, Math.max(value, min));
		}
		
		/**
		 * 取value0和moreValues的绝对值，返回最大的一个绝对值
		 * @param	value0
		 * @param	...moreValues
		 * @return
		 */
		public static function maxAbs(value0:Number, ... moreValues):Number
		{
			var result:Number = Math.abs(value0);
			for each (var value:Number in moreValues)
				result = Math.max(result, Math.abs(value));
			return result;
		}
		
		/**
		 * 取value0和moreValues的绝对值，返回最小的一个绝对值
		 * @param	value0
		 * @param	...moreValues
		 * @return
		 */
		public static function minAbs(value0:Number, ... moreValues):Number
		{
			var result:Number = Math.abs(value0);
			for each (var value:Number in moreValues)
				result = Math.min(result, Math.abs(value));
			return result;
		}
		
		/**
		 * 将rot角转化为180至-180的范围内
		 * @param	rot
		 * @return
		 */
		public static function normolizeRotationInCircle(rot:Number):Number
		{
			rot %= 360;
			if (rot > 180)
				return rot - 360;
			else if (rot < -180)
				return rot + 360;
			return rot;
		}
		
		/**
		 * 在一个圆周上做角度（in degrees）插值。
		 * 不管传入的from和to的度数怎样，都会在一个圆周内寻找最近的差值（变化量小于180）
		 * @param	normValue
		 * @param	from
		 * @param	to
		 * @return
		 */
		public static function interpolateRotationInCircle(normValue:Number, from:Number, to:Number):Number
		{
			from = normolizeRotationInCircle(from);
			to = normolizeRotationInCircle(to);
			var d:Number = normolizeRotationInCircle(to - from);
			return from + d * normValue;
		}
		
		/**
		 * 使value介于0和1之间
		 * @param	value
		 * @return
		 */
		public static function clamp01(value:Number):Number
		{
			return clamp(value, 0, 1);
		}
		
		/**
		 * 使value位于min和max之间
		 * @param	value
		 * @param	min
		 * @param	max
		 * @return
		 */
		public static function clamp(value:Number, min:Number, max:Number):Number
		{
			return Math.max(min, Math.min(max, value));
		}
	}

}