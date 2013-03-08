package com.spotlightor.armorframework.events 
{
	import com.spotlightor.events.ObjectEvent;
	import flash.events.Event;
	
	/**
	 * 由IPage向Armor framework发送的事件，用来向framework提交各种功能请求（例如request_goto）。
	 * PageEvent需要由IPage发送
	 * 注意：IPage继承自ITransition，也会发送TransitionEvent
	 * 
	 * @author 高鸣 - 交典创艺 (Spotlightor.com)
	 */
	public class PageEvent extends ObjectEvent 
	{
		public static const REQUEST_GOTO			:String = "armorframework_pageevent_request_goto";
		
		
		public function PageEvent(type:String, object:Object, bubbles:Boolean=false, cancelable:Boolean=false) 
		{ 
			super(type, object, bubbles, cancelable);
		} 
		
		public override function clone():Event 
		{ 
			return new PageEvent(type, object, bubbles, cancelable);
		} 
		
		public override function toString():String 
		{ 
			return formatToString("PageEvent", "type", "targetPageID", "bubbles", "cancelable", "eventPhase"); 
		}
		
	}
	
}