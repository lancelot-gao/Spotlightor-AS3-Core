package com.spotlightor.display 
{
	import com.greensock.TweenLite;
	import com.greensock.easing.*;
	import com.spotlightor.events.TransitionEvent;
	import flash.display.DisplayObject;
	import flash.display.Sprite;
	/**
	 * ...
	 * @author 高鸣 - 交典创艺 (Spotlightor.com)
	 */
	public class TweenTransitionManager extends TransitionManager
	{
		protected var _inVars				:Object;
		protected var _outVars				:Object;
		protected var _inStartStates		:Object;
		protected var _durationIn			:Number = 0;
		protected var _durationOut			:Number = 0;
		public function TweenTransitionManager(view:DisplayObject, outVars:Object, durationIn:Number = 1.5, durationOut:Number = 1, inVars:Object = null, inStartStates:Object = null) 
		{
			super(view);
			
			_durationIn = durationIn;
			_durationOut = durationOut;
			
			_outVars = outVars != null?outVars: { };
			
			if (inVars) _inVars = inVars;
			else {
				_inVars = { };
				if (view)
				{
					for (var pName:String in outVars) 
					{
						if (view.hasOwnProperty(pName)) _inVars[pName] = (view as Object)[pName];
						else _inVars[pName] = _outVars[pName];
					}
				}
			}
			
			_inStartStates = inStartStates;
			
			_inVars.onComplete = transitionInComplete;
			_outVars.onComplete = transitionOutComplete;
		}
		
		protected function restoreInStartStates()
		{
			for (var pName:String in _inStartStates) (viewComponent as Object)[pName] = _inStartStates[pName];
		}
		
		override protected function doTransitionIn(instant:Boolean = false):void 
		{
			TweenLite.killTweensOf(viewComponent);
			if (instant) TweenLite.to(_viewComponent, 0, _inVars);
			else {
				if (_state == STATE_OUT && _inStartStates) restoreInStartStates();
				TweenLite.to(_viewComponent, _durationIn, _inVars);
			}
		}
		
		override protected function doTransitionOut(instant:Boolean = false):void 
		{
			TweenLite.killTweensOf(viewComponent);
			if (instant) TweenLite.to(_viewComponent, 0, _outVars);
			else TweenLite.to(_viewComponent, _durationOut, _outVars);
		}
		
		//{ region Getters & Setters
		
		public function get inVars():Object { return _inVars; }
		
		public function set inVars(value:Object):void 
		{
			_inVars = value;
		}
		
		public function get outVars():Object { return _outVars; }
		
		public function set outVars(value:Object):void 
		{
			_outVars = value;
		}
		
		public function get durationIn():Number { return _durationIn; }
		
		public function set durationIn(value:Number):void 
		{
			_durationIn = value;
		}
		
		public function get durationOut():Number { return _durationOut; }
		
		public function set durationOut(value:Number):void 
		{
			_durationOut = value;
		}
		
		public function get inStartStates():Object { return _inStartStates; }
		
		public function set inStartStates(value:Object):void 
		{
			_inStartStates = value;
		}
		
		//} endregion
	}

}