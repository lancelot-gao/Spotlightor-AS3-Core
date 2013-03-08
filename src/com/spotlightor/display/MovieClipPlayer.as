package com.spotlightor.display
{
	import com.spotlightor.utils.FrameLabelUtils;
	import com.spotlightor.utils.Log;
	import flash.display.MovieClip;
	import flash.events.Event;
	
	/**
	 * ...
	 * @author GaoMing(5ii studio)
	 */
	public class MovieClipPlayer 
	{
		// CONSTANTS
		
		// Storage & References
		private var _movieClip:MovieClip;
		
		// Settings
		
		// Variables
		private var _targetFrame:int;
		private var _frameLabelUtils:FrameLabelUtils;
		private var _onPlayToComplete:Function;
		private var _onPlayToCompleteParams:Array;
		
		// Switches
		public function MovieClipPlayer(movieClip:MovieClip) 
		{
			_movieClip = movieClip;
			_frameLabelUtils = new FrameLabelUtils(movieClip);
		}
		
		public function playToAndStop(targetFrame:Object, onComplete:Function = null, onCompleteParams:Array = null):void
		{
			var targetFrameNumber:int;
			if (targetFrame is int) targetFrameNumber = targetFrame as int;
			else if (targetFrame is String) targetFrameNumber = _frameLabelUtils.getFrameByLabelName(targetFrame as String);
			if (targetFrameNumber < 1 || targetFrameNumber >_movieClip.totalFrames)
			{
				Log.warning(this, "playToAndStop targetFrame " + targetFrameNumber.toString() + " is out of index!");
				return;
			}
			
			var framesToGo:int = Math.abs(_movieClip.currentFrame - targetFrameNumber);
			if (framesToGo == 0)
			{
				stop();
				
				if (onComplete != null) onComplete.apply(_movieClip, onCompleteParams);
				cleanPlayTo();
				return;
			}
			else if(framesToGo == 1)
			{
				gotoAndStop(targetFrameNumber);
				
				if (onComplete != null) onComplete.apply(_movieClip, onCompleteParams);
				cleanPlayTo();
				return;
			}
			else
			{
				startOnFramePlayTo(targetFrameNumber, onComplete, onCompleteParams);
			}
		}
		
		public function gotoAndPlay(targetFrame:Object):void
		{
			cleanPlayTo();
			
			_movieClip.gotoAndPlay(targetFrame);
		}
		
		public function gotoAndStop(targetFrame:Object):void
		{
			cleanPlayTo();
			
			_movieClip.gotoAndStop(targetFrame);
		}
		
		public function stop():void
		{
			cleanPlayTo();
			
			_movieClip.stop();
		}
		
		private function cleanPlayTo():void
		{
			_onPlayToComplete = null;
			_onPlayToCompleteParams = null;
			_movieClip.removeEventListener(Event.ENTER_FRAME, onFramePlayToTargetFrame);
		}
		
		/**
		 * 在运行之前请确定targetFrame在范围之内，最好还要确定targetFrame与currentFrame相差多于一帧
		 * @param	targetFrame
		 * @param	onComplete
		 * @param	onCompleteParams
		 */
		private function startOnFramePlayTo(targetFrame:int, onComplete:Function, onCompleteParams:Array):void
		{
			_targetFrame = targetFrame;
			_onPlayToComplete = onComplete;
			_onPlayToCompleteParams = onCompleteParams;
			
			_movieClip.addEventListener(Event.ENTER_FRAME, onFramePlayToTargetFrame);
		}
		
		
		private function onFramePlayToTargetFrame(e:Event):void 
		{
			if (_movieClip.currentFrame < _targetFrame)_movieClip.nextFrame();
			else if (_movieClip.currentFrame > _targetFrame)_movieClip.prevFrame();
			
			if (_movieClip.currentFrame == _targetFrame) completeOnFramePlayTo();
		}
		
		/**
		 * 在运行之前请确定currentFrame == _targetFrame
		 */
		private function completeOnFramePlayTo():void
		{
			_movieClip.stop();
			
			var completeFunc:Function = _onPlayToComplete;
			var completeFuncParams:Array = _onPlayToCompleteParams;
			
			cleanPlayTo();
			
			if (completeFunc != null)completeFunc.apply(_movieClip, completeFuncParams);
		}
	}
	
}