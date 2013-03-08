package com.spotlightor.display 
{
	
	/**
	 * ...
	 * @author 高鸣 - 交典创艺 (Spotlightor.com)
	 */
	public interface IPreloader extends ITransition
	{
		/**
		 * 更新载入进度
		 * 
		 * @param	bytesLoaded	:int 已经载入的bytes数
		 * @param	bytesTotal	:int 全部bytes数
		 */
		function updateProgress(bytesLoaded:int, bytesTotal:int):void
	}
	
}