package com.spotlightor.controls
{
	import com.spotlightor.display.MovieClipPlayer;
	import flash.display.FrameLabel;
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.events.MouseEvent;
	
	/**
	 * TODO:重新整理
	 * 相对于SimpleButton增加了disable状态，去除了Hit状态。
	 * 允许在disable<->over<->up三个状态之间增加动画帧
	 * 
	 * 使用方法：在影片剪辑中由左至右（通常是第一帧至最后一帧）依次添加以下名称关键帧
	 * 		disable	- 未激活状态，对应enable = false
	 * 		up		- Up态，对应鼠标未移动上去的状态
	 * 		over	- Over态，对应MouseOver
	 * 		down	- Down态，对于MouseDown
	 * @author GaoMing(5ii studio)
	 */
	public class ComplexButton extends MovieClip
	{
		private var _disableStateFrame:int;
		private var _upStateFrame:int;
		private var _overStateFrame:int;
		private var _downStateFrame:int;
		
		
		private var _moviePlayer:MovieClipPlayer;
		protected var _hold:Boolean			= false;
		//protected var _highlighted:Boolean	= false;
		
		public function ComplexButton() 
		{
			_moviePlayer = new MovieClipPlayer(this);
			
			stop();
			
			var registerResult:Boolean = registerStateFrames();
			if (registerResult == false)
			{
				trace("[ComplexButton]", this, "register state frames failed!");
				
				_disableStateFrame = _upStateFrame = _overStateFrame = _downStateFrame = 1;
			}
			
			makeMeActLikeButton();
			
			gotoAndStop(_upStateFrame);
		}
		
		private function registerStateFrames():Boolean
		{
			var frameLabels:Array = currentLabels;
			for (var i:int = 0; i < frameLabels.length; i++) 
			{
				var frameLabel:FrameLabel = frameLabels[i];
				if (frameLabel.name == "disable")_disableStateFrame = frameLabel.frame;
				else if (frameLabel.name == "up")_upStateFrame = frameLabel.frame;
				else if (frameLabel.name == "over")_overStateFrame = frameLabel.frame;
				else if (frameLabel.name == "down")_downStateFrame = frameLabel.frame;
			}
			
			if (_disableStateFrame == 0 && _upStateFrame != 0)_disableStateFrame = _upStateFrame;
			if (_downStateFrame == 0 && _overStateFrame != 0)_downStateFrame = _overStateFrame;
			
			return (_disableStateFrame != 0 && _upStateFrame != 0 && _overStateFrame != 0 && _downStateFrame != 0);
		}
		
		private function makeMeActLikeButton():void
		{
			useHandCursor = true;
			buttonMode = true;
			
			addEventListener(MouseEvent.ROLL_OVER, onRollOverComplexButton);
			addEventListener(MouseEvent.ROLL_OUT, onRollOutComplexButton);
			addEventListener(MouseEvent.MOUSE_DOWN, onMouseDownComplexButton);
			addEventListener(MouseEvent.MOUSE_UP, onMouseUpComplexButton);
		}
		
		private function onMouseUpComplexButton(e:MouseEvent):void 
		{
			_moviePlayer.gotoAndStop(_overStateFrame);
			if (_hold)
			{
				removeEventListener(Event.ENTER_FRAME, onHold);
				//dispatchEvent(new Event(UIEventConstants.RELEASE));
				_hold = false;
			}
		}
		
		private function onMouseDownComplexButton(e:MouseEvent):void 
		{
			_hold = true;
			if (_downStateFrame != _overStateFrame) addEventListener(Event.ENTER_FRAME, onHold);
		}
		
		private function onHold(e:Event):void 
		{
			//dispatchEvent(new Event(UIEventConstants.HOLD));
		}
		
		private function onRollOutComplexButton(e:MouseEvent):void 
		{
			if (enabled) playToFrame(_upStateFrame);
			if (_hold)
			{
				removeEventListener(Event.ENTER_FRAME, onHold);
				//dispatchEvent(new Event(UIEventConstants.RELEASE));
				_hold = false;
			}
		}
		
		private function onRollOverComplexButton(e:MouseEvent):void 
		{
			playToFrame(_overStateFrame);
		}
		
		
		private function playToFrame(frameIndex:int):void
		{
			if (stage == null) _moviePlayer.gotoAndStop(frameIndex);
			else
			{
				var framesToGo:int = Math.abs(currentFrame - frameIndex);
				if (framesToGo == 0)
				{
					_moviePlayer.stop();
					return;
				}
				else if(framesToGo == 1)
				{
					_moviePlayer.gotoAndStop(frameIndex);
				}
				else
				{
					_moviePlayer.playToAndStop(frameIndex);
				}
			}
		}
		
		override public function set enabled(value:Boolean):void 
		{
			super.enabled = value;
			
			mouseChildren = mouseEnabled = value;
			
			if (value == true) playToFrame(_upStateFrame);
			else  playToFrame(_disableStateFrame);
		}
		
		/**
		 * Is the button being hold by mouse.
		 */
		public function get hold():Boolean { return _hold; }
		
		//public function get highlighted():Boolean { return _highlighted; }
		//
		//public function set highlighted(value:Boolean):void 
		//{
			//_highlighted = value;
			//
			//if (value) filters = [new GlowFilter(0x333300, 0.8, 4, 4)];
			//else filters = [];
		//}
	}
	
}