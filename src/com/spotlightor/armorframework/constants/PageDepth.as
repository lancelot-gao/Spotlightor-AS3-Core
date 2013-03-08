package com.spotlightor.armorframework.constants 
{
	
	/**
	 * ...
	 * @author 高鸣 - 交典创艺 (Spotlightor.com)
	 */
	public class PageDepth 
	{
		public static const NULL		:int = -1;//一般用于asset，表示没有层级，不会被加入舞台
		public static const BOTTOM		:int = 0;
		public static const MIDDLE		:int = 1;
		public static const TOP			:int = 2;
		public static const PRELOADER	:int = 3;
		public static const CHILD		:int = 4;//加于另一个IPage内部，需要和另2个属性container（IPage的id）和childIndex(在IPage中的index）配合使用
		
	}
	
}