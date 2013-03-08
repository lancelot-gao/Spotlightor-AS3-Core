package com.spotlightor.armorframework.modulepage.constants 
{
	/**
	 * 与IPage相关的Notification，需要附加ModulePageMediator才可以自动发送或处理下列Notification
	 * 
	 * @author 高鸣 - 交典创艺 (Spotlightor.com)
	 */
	public class PageNotifications
	{
		public static const PAGE_TRANSITION_IN				:String = "nt_armorframework_page_in";
		public static const PAGE_TRANSITION_IN_COMPLETE		:String = "nt_armorframework_page_in_complete";
		public static const PAGE_TRANSITION_OUT				:String = "nt_armorframework_page_out";
		public static const PAGE_TRANSITION_OUT_COMPELTE	:String = "nt_armorframework_page_out_complete";
		
		/**
		 * 跳转页面，object设定为目标branch
		 */
		public static const REQUEST_GOTO					:String = "nt_armorframework_page_request_goto";
	}

}