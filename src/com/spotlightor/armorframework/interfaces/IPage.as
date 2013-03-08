package com.spotlightor.armorframework.interfaces 
{
	import com.spotlightor.display.ITransition;
	import flash.events.IEventDispatcher;
	import flash.utils.Dictionary;
	
	/**
	 * ...
	 * @author 高鸣 - 交典创艺 (Spotlightor.com)
	 */
	public interface IPage extends ITransition, IEventDispatcher
	{
		/**
		 * 当该Page的assets载入完毕后，调用该函数传入assets
		 * 此时是根据assets进行初始化的好时机
		 */
		function onAssetsLoaded(assets:Dictionary):void;
	}
	
}