package com.spotlightor.events 
{
	import flash.events.Event;
	
	/**
	 * 可以绑定数据
	 * @author 高鸣
	 */
	public class ObjectEvent extends Event 
	{
		public var object:Object;
		public function ObjectEvent(type:String, obj:Object, bubbles:Boolean=false, cancelable:Boolean=false) 
		{ 
			super(type, bubbles, cancelable);
			object = obj;
		} 
		
		public override function clone():Event 
		{ 
			return new ObjectEvent(type, object, bubbles, cancelable);
		} 
		
		public override function toString():String 
		{ 
			return formatToString("ObjectEvent", "type", "object", "bubbles", "cancelable", "eventPhase"); 
		}
		
	}
	
}