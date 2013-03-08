package com.spotlightor.armorframework.modulepage.constants 
{
	/**
	 * 由Armor发送给IPage的ArmorEvent翻译成的Notification，ArmorEvent.branch由body存储。
	 * 需要配合ModulePageMediator使用
	 * 
	 * @author 高鸣 - 交典创艺 (Spotlightor.com)
	 */
	public class ArmorEventNotifications
	{
		public static const GOTO							:String = "nt_armorframework_armor_goto";
		public static const PRELOAD							:String = "nt_armorframework_armor_preload";
		public static const PRELOAD_COMPLETE				:String = "nt_armorframework_armor_preload_complete";
		public static const TRASITION_OUT_BRANCH			:String = "nt_armorframework_armor_transition_out_branch";
		public static const TRASITION_OUT_BRANCH_COMPLETE	:String = "nt_armorframework_armor_transition_out_branch_complete";
		public static const TRASITION_IN_BRANCH				:String = "nt_armorframework_armor_transition_in_branch";
		public static const TRASITION_IN_BRANCH_COMPLETE	:String = "nt_armorframework_armor_transition_in_branch_complete";
	}

}