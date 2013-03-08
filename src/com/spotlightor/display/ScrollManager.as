package com.spotlightor.display 
{
	import com.spotlightor.utils.Log;
	import com.spotlightor.utils.MathUtils;
	import flash.display.DisplayObject;
	import flash.events.Event;
	import flash.events.MouseEvent;
	/**
	 * ...
	 * @author Gao Ming (Spotlightor Interactive)
	 */
	public class ScrollManager
	{
		
		// CONSTANTS
		// Settings
		// Variables
		private var _buttonScrollRangeMin	:Number;
		private var _buttonScrollRangeMax	:Number;
		private var _scrollProgress			:Number = 0;
		private var _mouseDownOnButtonY		:Number;
		// References
		private var _button		:DisplayObject;
		private var _bar		:DisplayObject;
		private var _content	:DisplayObject;
		private var _mask		:DisplayObject;
		
		public function ScrollManager(scrollButton:DisplayObject, scrollBar:DisplayObject, scrollContent:DisplayObject, scrollMask:DisplayObject) 
		{
			_button = scrollButton;
			_bar = scrollBar;
			_content = scrollContent;
			_mask = scrollMask;
			
			_content.mask = _mask;
			_buttonScrollRangeMin = _bar.y;
			_buttonScrollRangeMax = _buttonScrollRangeMin + _bar.height - _button.height;
			
			_button.addEventListener(MouseEvent.MOUSE_DOWN, onButtonMouseDown);
			
			scrollProgress = 0;
		}
		
		//{ region Pubilc methods
		
		//} endregion
		
		//{ region Private/Protected methods
		
		//} endregion
		
		//{ region Event handlers
		
		private function onButtonMouseDown(e:MouseEvent):void 
		{
			_mouseDownOnButtonY = _button.parent.mouseY - _button.y;
			
			_button.addEventListener(MouseEvent.MOUSE_UP, stopScrolling);
			if (_button.stage)
			{
				_button.stage.addEventListener(MouseEvent.MOUSE_UP, stopScrolling);
				_button.stage.addEventListener(MouseEvent.ROLL_OUT, stopScrolling);
			}
			
			_button.addEventListener(Event.ENTER_FRAME, onFrameUpdateDragging);
		}
		
		private function onFrameUpdateDragging(e:Event):void 
		{
			scrollProgress = MathUtils.bounds(MathUtils.normalize(_button.parent.mouseY - _mouseDownOnButtonY, _buttonScrollRangeMin, _buttonScrollRangeMax), 0, 1);
		}
		
		private function stopScrolling(e:Event):void 
		{
			_button.removeEventListener(MouseEvent.MOUSE_UP, stopScrolling);
			if (_button.stage)
			{
				_button.stage.removeEventListener(MouseEvent.MOUSE_UP, stopScrolling);
				_button.stage.removeEventListener(MouseEvent.ROLL_OUT, stopScrolling);
			}
			
			_button.removeEventListener(Event.ENTER_FRAME, onFrameUpdateDragging);
		}
		
		//} endregion
		
		//{ region Getters & Setters
		
		private function get contentTopPos():Number { return _mask.y; }
		private function get contentBottomPos():Number { return _mask.y - _content.height + _mask.height - 10; }// magic 10 pix for the textfield
		
		public function get scrollProgress():Number 
		{
			return _scrollProgress;
		}
		
		public function set scrollProgress(value:Number):void 
		{
			_scrollProgress = value;
			
			_button.y = MathUtils.interpolate(_scrollProgress, _buttonScrollRangeMin, _buttonScrollRangeMax);
			_content.y = MathUtils.interpolate(_scrollProgress, contentTopPos, contentBottomPos);
			
			//Log.debug(this, "progress:", _scrollProgress);
		}
		//} endregion
	}

}