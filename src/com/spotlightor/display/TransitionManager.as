package com.spotlightor.display 
{
	import com.spotlightor.events.TransitionEvent;
	import flash.display.DisplayObject;
	import flash.display.Sprite;
	import flash.events.EventDispatcher;
	/**
	 * ...
	 * @author 高鸣 - 交典创艺 (Spotlightor.com)
	 */
	public class TransitionManager implements ITransitionManager
	{
		protected static const STATE_UNKNOWN		: int = -1;
		protected static const STATE_IN				: int = 0;
		protected static const STATE_TRANSITION_IN	: int = 1;
		protected static const STATE_OUT			: int = 2;
		protected static const STATE_TRANSITION_OUT	: int = 3;
		
		protected var _autoVisible					:Boolean = true;
		protected var _autoMouseEnable				:Boolean = true;
		
		/**
		 * Manager所控制的界面元件
		 */
		protected var _viewComponent:DisplayObject;
		/**
		 * 当前所处的状态
		 */
		protected var _state:int;
		
		public function TransitionManager(view:DisplayObject) 
		{
			viewComponent = view;
		}
		
		/* INTERFACE com.spotlightor.display.ITransitionManager */
		
		public function get viewComponent():DisplayObject
		{
			return _viewComponent;
		}
		
		public function set viewComponent(value:DisplayObject):void
		{
			_viewComponent = value;
			_state = STATE_UNKNOWN;// 鬼知道当前viewComponent是什么状态
		}
		
		public function transitionIn(instant:Boolean = false):void
		{
			switch(_state)
			{
				case STATE_IN: {
					_viewComponent.dispatchEvent(new TransitionEvent(TransitionEvent.IN_COMPLETE));
					break;
				}
				case STATE_TRANSITION_IN: break;
				case STATE_UNKNOWN:
				case STATE_OUT: 
				case STATE_TRANSITION_OUT:
				{
					_state = STATE_TRANSITION_IN;
					if (viewComponent is Sprite) 
					{
						var viewSprite:Sprite = viewComponent as Sprite;
						if(_autoMouseEnable) viewSprite.mouseChildren = viewSprite.mouseEnabled = false;
					}
					if (_autoVisible) {
						viewComponent.visible = true;
						//trace("Show because autovisible");
					}
					_viewComponent.dispatchEvent(new TransitionEvent(TransitionEvent.IN, instant));
					doTransitionIn(instant);
					break;
				}
			}
		}
		
		/**
		 * 在这里实现具体的transition in特效，不要碰触transitionIn(instant)
		 * @param	instant
		 */
		protected function doTransitionIn(instant:Boolean = false):void
		{
			// override for custom transition in effect
			throw new Error("doTransitionIn not implement yet!");
		}
		
		/**
		 * 在transition in结束后调用本函数，发送TransitionEvent.IN_COMPLETE事件
		 */
		protected function transitionInComplete():void
		{
			if (viewComponent is Sprite) 
			{
				var viewSprite:Sprite = viewComponent as Sprite;
				if(_autoMouseEnable) viewSprite.mouseChildren = viewSprite.mouseEnabled = true;
			}
			
			_state = STATE_IN;
			_viewComponent.dispatchEvent(new TransitionEvent(TransitionEvent.IN_COMPLETE));
		}
		
		public function transitionOut(instant:Boolean = false):void
		{
			switch(_state)
			{
				case STATE_UNKNOWN:
				case STATE_IN:
				case STATE_TRANSITION_IN: {
					_state = STATE_TRANSITION_OUT;
					if (viewComponent is Sprite && _autoMouseEnable) 
					{
						var viewSprite:Sprite = viewComponent as Sprite;
						viewSprite.mouseChildren = viewSprite.mouseEnabled = false;
					}
					_viewComponent.dispatchEvent(new TransitionEvent(TransitionEvent.OUT, instant));
					doTransitionOut(instant);
					break;
				}
				case STATE_OUT: {
					_viewComponent.dispatchEvent(new TransitionEvent(TransitionEvent.OUT_COMPLETE));
					break;
				}
				case STATE_TRANSITION_OUT: break;
			}
		}
		
		/**
		 * 在这里实现具体的transition out特效，不要碰触transitionOut(instant)
		 * @param	instant
		 */
		protected function doTransitionOut(instant:Boolean = false):void
		{
			// override for custom transition out effect
			throw new Error("doTransitionOut not implement yet!");
		}
		
		/**
		 * 在transition out结束后调用本函数，发送TransitionEvent.OUT_COMPLETE事件
		 */
		protected function transitionOutComplete():void
		{
			if (_autoVisible) {
				viewComponent.visible = false;
				//trace("Hide becaouse auto visible");
			}
			
			_state = STATE_OUT;
			_viewComponent.dispatchEvent(new TransitionEvent(TransitionEvent.OUT_COMPLETE));
		}
		
		/* INTERFACE com.spotlightor.display.ITransitionManager */
		
		public function get inTransition():Boolean 
		{
			return _state == STATE_TRANSITION_IN || _state == STATE_TRANSITION_OUT;
		}
		
		public function set autoMouseEnable(value:Boolean):void
		{
			_autoMouseEnable = value;
		}
		
		public function set autoVisible(value:Boolean):void
		{
			_autoVisible = value;
		}
	}

}