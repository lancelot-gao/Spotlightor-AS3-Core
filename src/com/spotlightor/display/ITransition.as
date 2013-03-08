package com.spotlightor.display 
{
	import flash.events.IEventDispatcher;
	
	/**
	 * ...
	 * @author 高鸣 - 交典创艺 (Spotlightor.com)
	 */
	public interface ITransition
	{
		[Event(name = "evt_transition_in", type = "com.spotlightor.events.TransitionEvent")]
		[Event(name = "evt_transition_out", type = "com.spotlightor.events.TransitionEvent")]
		[Event(name = "evt_transition_in_complete", type = "com.spotlightor.events.TransitionEvent")]
		[Event(name = "evt_transition_out_complete", type = "com.spotlightor.events.TransitionEvent")]
		
		/**
		 * Transition In
		 * @param	instant:	立刻执行完毕in
		 */
		function transitionIn(instant:Boolean = false):void;
		/**
		 * Transition Out
		 * @param	instant:	立刻执行完毕out
		 */
		function transitionOut(instant:Boolean = false):void;
	}
	
}