package com.spotlightor.display 
{
	import flash.display.DisplayObject;
	import flash.display.SimpleButton;
	/**
	 * 使用Hittest state作为disable状态
	 * @author 高鸣
	 */
	public class SimpleButtonHack extends SimpleButton
	{
		private var _upStateBackup:DisplayObject;
		
		//public function SimpeButtonHack():void
		//{
			//super(
		//}
		
		override public function set enabled(value:Boolean):void 
		{
			
			if (value) {
				if(_upStateBackup) upState = _upStateBackup;
			}
			else {
				if(!_upStateBackup)_upStateBackup = upState;
				upState = hitTestState;
			}
			
			super.enabled = value;
		}
	}

}