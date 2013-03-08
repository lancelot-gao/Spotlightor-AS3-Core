package com.spotlightor.utils 
{
	/**
	 * ...
	 * @author 高鸣 - 交典创艺 (Spotlightor.com)
	 */
	public class BezierUtils
	{
		/**
		 * Calculate the bezier(Quadratic) value.
		 * @param	t	0-1
		 * @param	p0	start point
		 * @param	p1	control point
		 * @param	p2	end point
		 * @param	properties
		 * @return
		 */
		public static function bezierQuadratic(t:Number, p0:Object, p1:Object, p2:Object, properties:Array):Object
		{
			var result:Object = new Object();
			
			var m1:Number = 2 * t * (1 - t);
			var m2:Number = t * t;
			
			// loop properties and calculate bezier quadratic value
			for (var i:int = 0; i < properties.length; i++) {
				var p:String = properties[i];
				result[p] = p0[p];
				result[p] += m1 * (p1[p] - p0[p]) + m2 * (p2[p] - p0[p]);
			}
			
			return result;
		}
		
		/**
		 * Calculate the bezier(Cubic) value
		 * @param	t
		 * @param	p0
		 * @param	p1
		 * @param	p2
		 * @param	p3
		 * @param	properties
		 * @return
		 */
		public static function bezierCubic(t:Number, p0:Object, p1:Object, p2:Object, p3:Object, properties:Array):Object
		{
			var result:Object = new Object();
			
			var oneMinusT:Number = 1 - t;
			var tSquare:Number = t * t;
			var c1:Number = 3 * t * oneMinusT * oneMinusT;
			var c2:Number = 3 * tSquare * oneMinusT;
			var c3:Number = t * tSquare;
			
			// loop properties and calculate bezier cubic value
			for (var i:int = 0; i < properties.length; i++) {
				var p:String = properties[i];
				result[p] = p0[p] + c1 * (p1[p] - p0[p]) + c2 * (p2[p] - p0[p]) + c3 * (p3[p] - p0[p]);
			}
			
			return result;
		}
		
		
		/**
		 * Calculate the bezier(Quadratic) 3d value.
		 * @param	t(0-1)
		 * @param	startPoint: Object(x,y,z)
		 * @param	controlPoint: Object(x,y,z)
		 * @param	endPoint: Object(x,y,z)
		 * @return	Object(x,y,z)
		 */
		public static function bezierQuadratic3D(t:Number, startPoint:Object, controlPoint:Object, endPoint:Object):Object
		{
			return bezierQuadratic(t, startPoint, controlPoint, endPoint, ["x", "y", "z"]);
		}
		
	}

}