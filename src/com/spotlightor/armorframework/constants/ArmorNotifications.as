package com.spotlightor.armorframework.constants 
{
	/**
	 * ...
	 * @author 高鸣 - 交典创艺 (Spotlightor.com)
	 */
	public class ArmorNotifications
	{
		public static const APP_STRUCTURE_READY				:String = "nt_armor_app_structure_ready";// body = ArmorStructure
		public static const PRELOADER_LOADED				:String = "nt_preloader_loaded";// body = preloader.swf(IPreloader)
		public static const PRELOADER_READY					:String = "nt_preloader_ready";
		
		public static const REQUEST_GOTO					:String = "nt_armorframework_request_goto";// body = branchString(String) eg: index/work/interaction
		public static const GOTO_INTERNAL					:String = "nt_armorframework_goto";// body = branchNodes(Vector<PageNode>)
		public static const CANCEL_PRELOAD_BRANCH			:String = "nt_armorframework_cancel_preload_branch";
		public static const TRANSITION_OUT_BRANCH			:String = "nt_armorframework_transition_out_branch";
		public static const TRANSITION_OUT_BRANCH_COMPLETE	:String = "nt_armorframework_transition_out_branch_complete";
		public static const UNLOAD_PAGE						:String = "nt_armorframework_unload_page";// unload and stop page, remove mediator
		public static const PRELOAD_BRANCH					:String = "nt_armorframework_preload_branch";// body = branchNodesToPreload(Vector<PrageNode>)
		public static const PRELOAD_BRANCH_START			:String = "nt_armorframework_preload_branch_start";// body = pageNodesToPreload(Vector<PrageNode>)此前已经preload的，不会出现, type = preloader id
		public static const PRELOAD_BRANCH_PROGRESS			:String = "nt_armorframework_preload_branch_progress";// body = ProgressEvent
		public static const ADD_NEW_PRELOADER				:String = "nt_armorframework_add_new_preloader";// body= preloader asset id在载入的时候，会根据pagenode中的preloader属性指定custom preloader，如果此时还没有在PreloaderMediator内注册，则会发送这个note，尝试addchild并注册
		public static const PRELOAD_BRANCH_COMPLETE			:String = "nt_armorframework_preload_branch_complete";// body = pageNodesPreloaded此前已经preload的，不会出现
		public static const TRANSITION_IN_BRANCH			:String = "nt_armorframework_transition_in_branch";
		public static const TRANSITION_IN_BRANCH_COMPLETE	:String = "nt_armorframework_transition_in_branch_complete";
		
		
		// SPECIAL for pages
		public static const CROSS_PAGE_NOTIFICATION			:String = "nt_armorframework_cross_page_notification";// body = notification, type = page id that send the nt
	}

}