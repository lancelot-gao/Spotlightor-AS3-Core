package com.spotlightor.display 
{
	import flash.display.DisplayObject;
	
	/**
	 * 传入viewComponent并实现它的Transition In/Out特效
	 * @author 高鸣 - 交典创艺 (Spotlightor.com)
	 */
	public interface ITransitionManager extends ITransition
	{
		function get viewComponent():DisplayObject;
		
		function set viewComponent(value:DisplayObject):void;
		
		/**
		 * 在transitionIn和Out的时候是否自动控制visible
		 */
		function set autoVisible(value:Boolean):void;
		/**
		 * 在transitionIn和Out的时候是否自动控制mouseEnabled mouseChildren
		 */
		function set autoMouseEnable(value:Boolean):void;
		
		function get inTransition():Boolean;
	}
	
}