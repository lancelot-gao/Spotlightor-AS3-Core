package com.spotlightor.touchscreen 
{
	import flash.display.Stage;
	import flash.display.StageDisplayState;
	import flash.events.KeyboardEvent;
	import flash.events.MouseEvent;
	import flash.events.TimerEvent;
	import flash.ui.Keyboard;
	import flash.ui.Mouse;
	import flash.utils.Timer;
	/**
	 * com.TouchScreenUtilities
	 * ...
	 * @author Gao Ming (Spotlightor Interactive)
	 */
	public class TouchScreenUtilities
	{
		
		// CONSTANTS
		// Settings
		// Variables
		protected var _mouseLoopHideTimer:Timer;
		protected var _mouseHided:Boolean;
		
		protected var _fullScreenCursorGestureStep:int = 0;
		// References
		protected var _stage:Stage;
		
		public function TouchScreenUtilities(stage:Stage) 
		{
			if (stage)
			{
				_stage = stage;
				_mouseLoopHideTimer = new Timer(3000, 0);
				_mouseLoopHideTimer.addEventListener(TimerEvent.TIMER, onTimerDoMouseHide);
				stage.addEventListener(KeyboardEvent.KEY_DOWN, onKeyPressedOnStage);
				stage.addEventListener(MouseEvent.MOUSE_DOWN, onMouseDownOnStage);
			}
		}
		//{ region Pubilc methods
		public function hideMouse():void
		{
			Mouse.hide();
			_mouseHided = true;
			_mouseLoopHideTimer.reset();
			_mouseLoopHideTimer.start();
		}
		
		public function showMouse():void
		{
			Mouse.show();
			_mouseHided = false;
			_mouseLoopHideTimer.stop();
		}
		//} endregion
		
		//{ region Private/Protected methods
		
		//} endregion
		
		//{ region Event handlers
		private function onKeyPressedOnStage(e:KeyboardEvent):void 
		{
			switch(e.keyCode)
			{
				case Keyboard.F: {
					_stage.displayState = StageDisplayState.FULL_SCREEN;
					break;
				}
				case Keyboard.M: {
					if (!_mouseHided) {
						hideMouse();
					}
					else {
						showMouse();
					}
					break;
				}
			}
		}
		
		private function onMouseDownOnStage(e:MouseEvent):void 
		{
			// Switch Full Screen cursor gesture
			switch(_fullScreenCursorGestureStep)
			{
				case 0:
				{
					if (_stage.mouseX < 100 && _stage.mouseY < 100) _fullScreenCursorGestureStep = 1;
					break;
				}
				case 1:
				{
					if (_stage.stageWidth - _stage.mouseX < 100 && _stage.stageHeight - _stage.mouseY < 100)_fullScreenCursorGestureStep = 2;
					else _fullScreenCursorGestureStep = 0;
					break;
				}
				case 2:
				{
					if (_stage.stageWidth - _stage.mouseX < 100 && _stage.mouseY < 100)_fullScreenCursorGestureStep = 3;
					else _fullScreenCursorGestureStep = 0;
					break;
				}
				case 3:
				{
					if (_stage.mouseX < 100 && _stage.stageHeight - _stage.mouseY < 100) {
						if (_stage.displayState != StageDisplayState.FULL_SCREEN) _stage.displayState = StageDisplayState.FULL_SCREEN;
						else _stage.displayState = StageDisplayState.NORMAL;
					}
					_fullScreenCursorGestureStep = 0;
					break;
				}
			}
		}
		
		private function onTimerDoMouseHide(e:TimerEvent):void 
		{
			Mouse.hide();
		}
		//} endregion
		
		//{ region Getters & Setters
		
		//} endregion
	}

}