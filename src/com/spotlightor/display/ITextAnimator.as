package com.spotlightor.display 
{
	
	/**
	 * ...
	 * @author 高鸣
	 */
	public interface ITextAnimator 
	{
		function animateInText(text:String, instant:Boolean = false):void;
		
		//function animateOutText(instant:Boolean = false):void;
		
		function get text():String;
	}
	
}