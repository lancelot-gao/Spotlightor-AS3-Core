package com.spotlightor.utils 
{
	import flash.display.DisplayObject;
	import flash.geom.Matrix;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	/**
	 * ...
	 * @author 高鸣 - 交典创艺 (Spotlightor.com)
	 */
	public class DisplayUtils
	{
		public static const FIT_IMAGE		:int 	= 0;
		public static const FIT_WIDTH		:int 	= 1;
		public static const FIT_HEIGHT		:int 	= 2;
		public static const FIT_AREA		:int 	= 3;
		
		/**
		 * 将image置于area里面，根据fitMethod决定放置的样式
		 * 
		 * @param	image
		 * @param	area
		 * @param	fitMethod
		 */
		public static function fitInArea(target:DisplayObject, area:Rectangle, fitMethod:int = FIT_IMAGE):void
		{
			var resultMatrix:Matrix = fitRectInArea(target.getRect(target.parent), area, fitMethod);// updated 2011.10.27
			//var resultMatrix:Matrix = fitRectInArea(new Rectangle(0, 0, target.width, target.height), area, fitMethod);
			target.transform.matrix = resultMatrix;
		}
		
		public static function fitRectInArea(rect:Rectangle, area:Rectangle, fitMethod:int = FIT_AREA):Matrix
		{
			var areaWidthVsHeight:Number = area.width / area.height;
			var rectWidthVsHeight:Number = rect.width / rect.height;
			
			var matchWidth:Boolean = false;
			
			switch(fitMethod)
			{
				case FIT_IMAGE: {
					if (rectWidthVsHeight > areaWidthVsHeight) matchWidth = true; break;
				}
				case FIT_WIDTH: break;
				case FIT_HEIGHT: {
					matchWidth = true; break;
				}
				case FIT_AREA: {
					if (rectWidthVsHeight < areaWidthVsHeight) matchWidth = true; break;
				}
			}
			
			var matrix:Matrix = new Matrix();
			
			matrix.translate( -rect.x, -rect.y);// updated 2011.10.27
			
			var scale:Number = 1;
			if (matchWidth) {
				scale = area.width / rect.width;
				matrix.scale(scale, scale);
			}
			else {
				scale = area.height / rect.height;
				matrix.scale(scale, scale);
			}
			matrix.translate(0.5 * (area.width - rect.width * scale) + area.x, 0.5 * (area.height - rect.height * scale) + area.y);
			return matrix;
		}
		
		public static function centerInArea(target:DisplayObject, area:Rectangle):void
		{
			target.x = 0.5 * (area.width - target.width) + area.x;
			target.y = 0.5 * (area.height - target.height) + area.y;
		}
		
		/**
		 * 让target以父物体坐标(x,y)为中心缩放为scaleX,scaleY
		 * @param	target
		 * @param	x
		 * @param	y
		 * @param	scaleX
		 * @param	scaleY
		 */
		public static function scaleAroundExternalPoint(target:DisplayObject, x:Number, y:Number, scaleX:Number, scaleY:Number):void
		{
			if (target.parent == null) {
				Log.error(target, "Cannot scaleAroundExternalPoint because no parent.");
				return;
			}
			
			var exPointLocal:Point = target.globalToLocal(target.parent.localToGlobal(new Point(x, y)));
			target.scaleX = scaleX;
			target.scaleY = scaleY;
			var newExPoint:Point = target.parent.globalToLocal(target.localToGlobal(exPointLocal));
			target.x += x - newExPoint.x;
			target.y += y - newExPoint.y;
		}
		
		/**
		 * 让target以自身坐标系内点(x,y)为中心缩放为scaleX,scaleY
		 * @param	target
		 * @param	x
		 * @param	y
		 * @param	scaleX
		 * @param	scaleY
		 */
		public static function scaleAroundInnerPoint(target:DisplayObject, x:Number, y:Number, scaleX:Number, scaleY:Number):void
		{
			if (target.parent == null) {
				Log.error(target, "Cannot scaleAroundInnerPoint because no parent.");
				// TODO:  按理说应该是可以scale的，即使没有parent
				return;
			}
			
			var exPoint:Point = target.parent.globalToLocal(target.localToGlobal(new Point(x, y)));
			scaleAroundExternalPoint(target, exPoint.x, exPoint.y, scaleX, scaleY);
		}
	}

}