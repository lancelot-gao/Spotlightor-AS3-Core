package com.spotlightor.utils 
{
	import flash.display.FrameLabel;
	import flash.display.MovieClip;
	/**
	 * ...
	 * @author 高鸣 - 交典创艺 (Spotlightor.com)
	 */
	public class FrameLabelUtils
	{
		private var _movieClip:MovieClip;
		private var _labelsByName:Array;
		public function FrameLabelUtils(mc:MovieClip) 
		{
			_movieClip = mc;
			_labelsByName = new Array();
			for each (var label:FrameLabel in _movieClip.currentLabels) _labelsByName[label.name] = label.frame;
		}
		
		public function getFrameByLabelName(labelName:String):uint 
		{
			return _labelsByName[labelName];
		}
		
		public function addFrameScript(frameLabel:String, func:Function):void
		{
			var frameIndex:int = getFrameByLabelName(frameLabel) - 1;
			if (frameIndex < 0)
			{
				Log.error(this, "Frame label index < 0:", frameLabel);
				return;
			}
			// addFrameScript的起始帧为0，不是1，因此-1
			_movieClip.addFrameScript(frameIndex, func);
		}
	}

}