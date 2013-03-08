package com.spotlightor.display 
{
	import com.greensock.easing.Expo;
	import com.greensock.easing.Sine;
	import com.greensock.TweenLite;
	import com.spotlightor.utils.MathUtils;
	import com.spotlightor.utils.Random;
	import flash.text.TextField;
	import flash.utils.getTimer;
	/**
	 * ...
	 * @author 高鸣
	 */
	public class RandomCharTextAnimator extends TextFieldTextAnimator
	{
		public static const STATIC_CHARS	:String = ',.;:{}][<>?!@#$%^&*()_+=-~`/\/\"\'，。：；、！ ';
		private var _randomChars	:String;
		private var _durationIn		:Number;
		private var _durationOut	:Number;
		private var _numRandomizationsPerSecond:int;
		
		private var _targetText		:String;
		private var _randomizationProgressStep	:Number;
		private var _animationProgressOld		:Number = 0;
		private var _animationProgress			:Number = 0;
		
		public function RandomCharTextAnimator(textField:TextField, randomChars:String, durationIn:Number = 3, durationOut:Number = 2, numRandomizationsPerSecond:int = 10) 
		{
			super(textField);
			_randomChars = randomChars;
			_durationIn = durationIn;
			_durationOut = durationOut;
			_numRandomizationsPerSecond = numRandomizationsPerSecond;
		}
		
		override public function animateInText(text:String, instant:Boolean = false):void 
		{
			if (instant) {
				_textField.text = text;
				TweenLite.killTweensOf(this);
			}
			else
			{
				_targetText = text;
				_animationProgress = 0;
				_randomizationProgressStep = 1 / (_durationIn * _numRandomizationsPerSecond);
				TweenLite.to(this, _durationIn, { animationProgress:1, ease:Sine.easeOut, onUpdate:updateText, onComplete:showTargetText } );
			}
		}
		
		private function showTargetText():void 
		{
			_textField.text = _targetText;
		}
		
		private function updateText():void 
		{
			var dProgress:Number = Math.abs(_animationProgress - _animationProgressOld);
			if (dProgress >= _randomizationProgressStep) {
				randomizeChars();
				_animationProgressOld = _animationProgress + dProgress - _randomizationProgressStep;
			}
		}
		
		private function randomizeChars():void 
		{
			var numRandomChars:int = _randomChars.length;
			var start:int = Random.rangeInt(0, numRandomChars - 1);
			var step:int = Random.rangeInt(1, numRandomChars - 2);
			
			var randomText = '';
			var targetChar:String;
			var index:int;
			for (var i:int = 0; i < _targetText.length; i++) 
			{
				targetChar = _targetText.charAt(i);
				if (STATIC_CHARS.indexOf(targetChar) == -1)
				{
					index = (start + i * step) % numRandomChars;
					randomText += _randomChars.charAt(index);
				}
				else randomText += targetChar;
			}
			
			_textField.text = randomText;
		}
		
		override public function animateOutText(instant:Boolean = false):void 
		{
			if (instant) {
				_textField.text = '';
				TweenLite.killTweensOf(this);
			}
		}
		
		public function get animationProgress():Number { return _animationProgress; }
		
		public function set animationProgress(value:Number):void 
		{
			_animationProgress = value;
		}
	}

}