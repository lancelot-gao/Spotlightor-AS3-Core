package com.spotlightor.armorframework.events 
{
	import flash.events.Event;
	
	/**
	 * 由Armor framework向IPage发送的事件（通过IPage.dispatchEvent实现），用于向IPage通告framework的各种状态。
	 * IPage可以通过addEventListener来监听感兴趣的Armor framework事件，例如通过监听GOTO来改变Nav Page的按钮状态
	 * 
	 * @author 高鸣 - 交典创艺 (Spotlightor.com)
	 */
	public class ArmorEvent extends Event 
	{
		/**
		 * 只有在真正发生页面跳转时才会触发这个事件（请求页面跳转可能不成功）。
		 * 注意区分与PageEvent.REQUEST_GOTO的区别，REQUEST_GOTO用于向Armor发送，请求页面跳转。
		 * 而这个GOTO由Armor向IPage发送，用来告知当前Armor Framework发生了页面跳转。
		 */
		public static const GOTO							:String = "armorframework_armorevent_goto";
		public static const PRELOAD							:String = "armorframework_armorevent_preload";
		public static const PRELOAD_COMPLETE				:String = "armorframework_armorevent_preload_complete";
		public static const TRASITION_OUT_BRANCH			:String = "armorframework_armorevent_transition_out_branch";
		public static const TRASITION_OUT_BRANCH_COMPLETE	:String = "armorframework_armorevent_transition_out_branch_complete";
		public static const TRASITION_IN_BRANCH				:String = "armorframework_armorevent_transition_in_branch";
		public static const TRASITION_IN_BRANCH_COMPLETE	:String = "armorframework_armorevent_transition_in_branch_complete";
		
		private var _branch:String;
		
		public function ArmorEvent(type:String, branch:String, bubbles:Boolean=false, cancelable:Boolean=false) 
		{ 
			super(type, bubbles, cancelable);
			_branch = branch;
		} 
		
		public override function clone():Event 
		{ 
			return new ArmorEvent(type, _branch, bubbles, cancelable);
		} 
		
		public override function toString():String 
		{ 
			return formatToString("ArmorEvent", "type", "branch", "bubbles", "cancelable", "eventPhase"); 
		}
		
		public function get branch():String { return _branch; }
		
	}
	
}