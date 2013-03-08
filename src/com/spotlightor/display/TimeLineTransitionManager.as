package com.spotlightor.display 
{
	import com.spotlightor.utils.FrameLabelUtils;
	import com.spotlightor.utils.Log;
	import flash.display.DisplayObject;
	import flash.display.FrameLabel;
	import flash.display.MovieClip;
	/**
	 * ...
	 * @author 高鸣 - 交典创艺 (Spotlightor.com)
	 */
	public class TimeLineTransitionManager extends TransitionManager
	{
		private static const LABEL_IN_START				:String = "IN_START";
		private static const LABEL_IN_COMPLETE			:String = "IN_COMPLETE";
		private static const LABEL_OUT_START			:String = "OUT_START";
		private static const LABEL_OUT_COMPLETE			:String = "OUT_COMPLETE";
		
		protected var _mcPlayer			:MovieClipPlayer;
		protected var _frameLabelUtils	:FrameLabelUtils;
		
		protected var _frameInStart		:int = 0;
		protected var _frameInComplete	:int = 0;
		protected var _frameOutStart		:int = 0;
		protected var _frameOutComplete	:int = 0;
		
		public function TimeLineTransitionManager(view:MovieClip) 
		{
			super(view);
			_mcPlayer = new MovieClipPlayer(view);
			_frameLabelUtils = new FrameLabelUtils(view);
			
			setTransitionInFrameLabels();
			setTransitionOutFrameLabels();	
			
			view.stop();
		}
		
		public function setTransitionOutFrameLabels(outStartLabelName:String = LABEL_OUT_START, outCompleteLabelName = LABEL_OUT_COMPLETE):void
		{
			_frameOutStart = _frameLabelUtils.getFrameByLabelName(outStartLabelName);
			_frameOutComplete = _frameLabelUtils.getFrameByLabelName(outCompleteLabelName);
			if (_frameOutStart == 0) Log.error(this, "No frame label [" + outStartLabelName + "] in", viewMC);
			if (_frameOutComplete == 0) Log.error(this, "No frame label [" + outCompleteLabelName + "] in", viewMC);
		}
		
		public function setTransitionInFrameLabels(inStartLabelName:String = LABEL_IN_START, inCompleteLabelName = LABEL_IN_COMPLETE):void
		{
			_frameInStart = _frameLabelUtils.getFrameByLabelName(inStartLabelName);
			_frameInComplete = _frameLabelUtils.getFrameByLabelName(inCompleteLabelName);
			if (_frameInStart == 0) Log.error(this, "No frame label [" + inStartLabelName + "] in", viewMC);
			if (_frameInComplete == 0) Log.error(this, "No frame label [" + inCompleteLabelName + "] in", viewMC);
		}
		
		override protected function doTransitionIn(instant:Boolean = false):void 
		{
			if (instant) {
				_mcPlayer.gotoAndStop(_frameInComplete);
				transitionInComplete();
			}
			else {
				if (viewMC.currentFrame < _frameInStart || viewMC.currentFrame > _frameInComplete) _mcPlayer.gotoAndStop(_frameInStart);
				_mcPlayer.playToAndStop(_frameInComplete, transitionInComplete);
			}
		}
		
		override protected function doTransitionOut(instant:Boolean = false):void 
		{
			if (instant) {
				_mcPlayer.gotoAndStop(_frameOutComplete);
				transitionOutComplete();
			}
			else {
				if (viewMC.currentFrame < _frameOutStart || viewMC.currentFrame > _frameOutComplete) _mcPlayer.gotoAndStop(_frameOutStart);
				_mcPlayer.playToAndStop(_frameOutComplete, transitionOutComplete);
			}
		}
		
		protected function get viewMC():MovieClip { return viewComponent as MovieClip; }
	}

}