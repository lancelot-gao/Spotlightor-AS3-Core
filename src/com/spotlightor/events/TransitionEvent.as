package com.spotlightor.events 
{
	import flash.events.Event;
	
	/**
	 * 所有在transition In/Out的过程中会发送的事件
	 * @author 高鸣 - 交典创艺 (Spotlightor.com)
	 */
	public class TransitionEvent extends Event 
	{
		public static const IN				: String = "evt_transition_in";
		public static const OUT				: String = "evt_transition_out";
		public static const IN_COMPLETE		: String = "evt_transition_in_complete";
		public static const OUT_COMPLETE	: String = "evt_transition_out_complete";
		
		private var _instantTransition		: Boolean = false;
		public function TransitionEvent(type:String, instant:Boolean = false, bubbles:Boolean=false, cancelable:Boolean=false) 
		{ 
			super(type, bubbles, cancelable);
			_instantTransition = instant;
		} 
		
		public override function clone():Event 
		{ 
			return new TransitionEvent(type, _instantTransition, bubbles, cancelable);
		} 
		
		public override function toString():String 
		{ 
			return formatToString("TransitionEvent", "instantTransition", "type", "bubbles", "cancelable", "eventPhase"); 
		}
		
		public function get instantTransition():Boolean { return _instantTransition; }
		
	}
	
}