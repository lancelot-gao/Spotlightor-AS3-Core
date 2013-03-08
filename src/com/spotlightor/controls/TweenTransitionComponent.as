package com.spotlightor.controls 
{
	import com.spotlightor.display.ITransition;
	import com.spotlightor.display.ITransitionManager;
	import com.spotlightor.display.TweenTransitionManager;
	import com.spotlightor.events.TransitionEvent;
	import com.spotlightor.utils.Log;
	import flash.display.MovieClip;
	import com.greensock.TweenLite;
	import com.greensock.easing.*;
	import flash.events.Event;
	/**
	 * com.spotlightor.controls.TweenTransitionComponent
	 * 
	 * 这个元件的作用是让设计师即使不编程也可以方便地做出Transition In/Out过渡动画
	 * 除了将本Class作为元件的Base Class外，还需要设置它为Component
	 * 
	 * @author 高鸣 - 交典创艺 (Spotlightor.com)
	 */
	public class TweenTransitionComponent extends MovieClip implements ITransition
	{
		public static var DEFAULT_EASE_IN	:Function = Expo.easeOut;
		public static var DEFAULT_EASE_OUT	:Function = Expo.easeOut;
		
		protected var _transitionManager	:TweenTransitionManager;
		
		private var _initialConditions		:Object;
		
		private var _invisibleAtFirst		:Boolean = false;
		
		public function TweenTransitionComponent() 
		{
			_transitionManager = new TweenTransitionManager(this, { } );
			_transitionManager.autoMouseEnable = false;
			
			_initialConditions = { x:x, y:y, z:z, scaleX:scaleX, scaleY:scaleY, alpha:alpha, rotation:rotation };
			
			visible = false;
			
			addEventListener(Event.ENTER_FRAME, onFirstFrame);
		}
		
		/* INTERFACE com.spotlightor.display.ITransition */
		
		public function transitionIn(instant:Boolean = false):void
		{
			_transitionManager.transitionIn(instant);
		}
		
		public function transitionOut(instant:Boolean = false):void
		{
			_transitionManager.transitionOut(instant);
		}
		
		//{ region Event Handlers
		
		private function onFirstFrame(e:Event):void 
		{
			removeEventListener(Event.ENTER_FRAME, onFirstFrame);
			if (_invisibleAtFirst) transitionOut(true);
			//if (name == "mc_tv") trace(_invisibleAtFirst);
		}
		
		private function transitionInWithParent(e:TransitionEvent):void 
		{
			transitionIn(e.instantTransition);
		}
		
		private function transitionOutWithParent(e:TransitionEvent):void 
		{
			transitionOut(e.instantTransition);
		}
		
		//} endregion
		
		//{ region Getters&Setters
		
		[Inspectable(defaultValue=1.5, name="durationIn", type="Number")]
		public function set durationIn(value:Number):void 
		{
			if (value != 0) {
				_transitionManager.durationIn = value;
			}
		}
		
		[Inspectable(defaultValue=0, name="delayIn", type="Number")]
		public function set delayIn(value:Number):void 
		{
			if (value != 0) {
				_transitionManager.inVars.delay = value;
			}
		}
		
		[Inspectable(defaultValue=1.5, name="durationOut", type="Number")]
		public function set durationOut(value:Number):void 
		{
			if (value != 0) {
				_transitionManager.durationOut = value;
			}
		}
		
		[Inspectable(defaultValue=0, name="delayOut", type="Number")]
		public function set delayOut(value:Number):void 
		{
			if (value != 0) {
				_transitionManager.outVars.delay = value;
			}
		}
		
		[Inspectable(type="String", defaultValue="Expo.easeOut", name="EaseIn")]
		public function set easeInFuncName(value:String):void 
		{
			var easeFunc:Function = EaseLookup.find(value);
			_transitionManager.inVars.ease = (easeFunc != null) ? easeFunc:DEFAULT_EASE_IN;
		}
		
		[Inspectable(type="String", defaultValue="Expo.easeOut", name="EaseOut")]
		public function set easeOutFuncName(value:String):void
		{
			var easeFunc:Function = EaseLookup.find(value);
			_transitionManager.outVars.ease = (easeFunc != null) ? easeFunc:DEFAULT_EASE_OUT;
		}
		
		[Inspectable(defaultValue=0, name="oX", type="Number")]
		public function set dx(value:Number):void 
		{
			if (value != 0) {
				_transitionManager.outVars.x = value;
				_transitionManager.inVars.x = _initialConditions.x;
			}
		}
		
		[Inspectable(defaultValue=0, name="oY", type="Number")]
		public function set dy(value:Number):void 
		{
			if (value != 0) {
				_transitionManager.outVars.y = value;
				_transitionManager.inVars.y = _initialConditions.y;
			}
		}
		
		[Inspectable(defaultValue=0, name="oZ", type="Number")]
		public function set dz(value:Number):void 
		{
			if (value != 0) {
				_transitionManager.outVars.z = value;
				_transitionManager.inVars.z = _initialConditions.z;
			}
		}
		
		[Inspectable(defaultValue=0, name="oAlpha", type="Number")]
		public function set dAlpha(value:Number):void 
		{
			if (value != 0) {
				_transitionManager.outVars.alpha = value;
				_transitionManager.inVars.alpha = _initialConditions.alpha;
			}
		}
		
		[Inspectable(defaultValue=0, name="oRotation", type="Number")]
		public function set dRotation(value:Number):void 
		{
			if (value != 0) {
				_transitionManager.outVars.rotation = value;
				_transitionManager.inVars.rotation = _initialConditions.rotation;
			}
		}
		
		[Inspectable(defaultValue=0, name="oScaleX", type="Number")]
		public function set dScaleX(value:Number):void 
		{
			if (value != 0) {
				_transitionManager.outVars.scaleX = value;
				_transitionManager.inVars.scaleX = _initialConditions.scaleX;
			}
		}
		
		[Inspectable(defaultValue=0, name="oScaleY", type="Number")]
		public function set dScaleY(value:Number):void
		{
			if (value != 0) {
				_transitionManager.outVars.scaleY = value;
				_transitionManager.inVars.scaleY = _initialConditions.scaleY;
			}
		}
		
		/**
		 * 设置为true，则默认情况下为out的状态，否则为in的状态
		 */
		[Inspectable(defaultValue="true", name="out at 1st", type="Boolean")]
		public function set outAtFirst(value:Boolean):void 
		{
			_invisibleAtFirst = value;
		}
		
		/**
		 * 设置为true，则当parent transition in/out的时候，自己也会自动transition。
		 * 适合应用在装饰素材上，可以无须编程直接和parent同步transition
		 */
		[Inspectable(defaultValue="true", name="transit with parent", type="Boolean")]
		public function set transitWithParent(value:Boolean):void 
		{
			if (value && parent) {
				parent.addEventListener(TransitionEvent.IN, transitionInWithParent);
				parent.addEventListener(TransitionEvent.OUT, transitionOutWithParent);
				Log.debug(this, "register event listeners to transit with parent");
			}
			else if(!value && parent)
			{
				parent.removeEventListener(TransitionEvent.IN, transitionInWithParent);
				parent.removeEventListener(TransitionEvent.OUT, transitionOutWithParent);
			}
		}
		
		/**
		 * 设置为true，则不会自动根据in/out设置mouseEnabled mouseChildren状态
		 */
		[Inspectable(defaultValue="true", name="autoMouseEnabled", type="Boolean")]
		public function set autoMouseEnabled(value:Boolean):void 
		{
			_transitionManager.autoMouseEnable = value;
		}
		
		//} endregion
	}

}