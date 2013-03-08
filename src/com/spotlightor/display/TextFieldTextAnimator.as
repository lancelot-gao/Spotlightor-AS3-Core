package com.spotlightor.display 
{
	import com.spotlightor.utils.Log;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.text.TextField;
	/**
	 * ...
	 * @author 高鸣
	 */
	public class TextFieldTextAnimator implements ITextAnimator
	{
		protected var _textField:TextField;
		public function TextFieldTextAnimator(textField:TextField) 
		{
			_textField = textField;
		}
		
		/* INTERFACE com.spotlightor.display.ITextAnimator */
		
		public function animateInText(text:String, instant:Boolean = false):void 
		{
			if (instant) 
			{
				_textField.text = text;
				completeTextAnimation();
			}
			else doAnimateIn(text);
		}
		
		protected function doAnimateIn(text:String):void
		{
			Log.warning(this, '不要忘记调用completeTextAnimation哦');
		}
		
		public function get text():String 
		{
			return _textField.text;
		}
		
		protected function completeTextAnimation():void
		{
			// 可以override这个函数，添加更多complete的任务
			_textField.dispatchEvent(new Event(Event.COMPLETE));
		}
		
		public function set textField(value:TextField):void { _textField = value; }
	}

}