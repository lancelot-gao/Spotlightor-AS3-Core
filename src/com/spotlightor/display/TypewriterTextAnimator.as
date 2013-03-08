package com.spotlightor.display 
{
	import com.greensock.easing.Linear;
	import com.greensock.TweenLite;
	import flash.text.TextField;
	/**
	 * ...
	 * @author Gao Ming (Spotlightor Interactive)
	 */
	public class TypewriterTextAnimator extends TextFieldTextAnimator
	{
		private var _charsInPerSecond:int;
		private var _charsOutPerSecond:int;
		private var _targetText:String;
		private var _oldProgressIn:Number;
		public var progressIn:Number;
		public function TypewriterTextAnimator(textField:TextField, charsInPerSecond:int = 30, charsOutPerSecond:int = 50) 
		{
			_charsInPerSecond = charsInPerSecond;
			_charsOutPerSecond = charsOutPerSecond;
			super(textField);
		}
		
		override protected function doAnimateIn(text:String):void 
		{
			_targetText = text;
			_textField.text = '';
			progressIn = _oldProgressIn = 0;
			TweenLite.to(this, text.length / _charsInPerSecond, {
				progressIn:1, ease:Linear.easeOut, onUpdate:updateText, onComplete:completeTextAnimation
			});
		}
		
		private function updateText():void 
		{
			var dProgress:Number = progressIn - _oldProgressIn;
			var numChars:int = dProgress * _targetText.length;
			if (numChars > 0)
			{
				_textField.appendText(_targetText.substr(_oldProgressIn * _targetText.length, numChars));
				_oldProgressIn += 0.0000001+(numChars) / _targetText.length;
			}
		}
		
	}

}