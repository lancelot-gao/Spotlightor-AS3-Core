package com.spotlightor.armorframework.view.components 
{
	import com.spotlightor.armorframework.interfaces.IPage;
	import com.spotlightor.display.ITransitionManager;
	import com.spotlightor.display.TimeLineTransitionManager;
	import flash.display.MovieClip;
	import flash.events.KeyboardEvent;
	import flash.ui.Keyboard;
	import flash.utils.Dictionary;
	/**
	 * com.spotlightor.armorframework.view.components.TimelineAnimationArmorPage
	 * ...
	 * @author Gao Ming (Spotlightor Interactive)
	 */
	public class TimelineAnimationArmorPage extends MovieClip implements IPage
	{
		protected var _transitionManager:ITransitionManager;
		
		public function TimelineAnimationArmorPage() 
		{
			_transitionManager = new TimeLineTransitionManager(this);
			transitionOut(true);
			
			if (stage)
			{
				// For develop debug
				stage.addEventListener(KeyboardEvent.KEY_DOWN, onKeyPreseed);
			}
		}
		
		private function onKeyPreseed(e:KeyboardEvent):void 
		{
			switch(e.keyCode)
			{
				case Keyboard.I: { transitionIn(); break; }
				case Keyboard.O: { transitionOut(); break; }
			}
		}
		
		/* INTERFACE com.spotlightor.armorframework.interfaces.IPage */
		
		public function onAssetsLoaded(assets:Dictionary):void {}
		
		public function transitionIn(instant:Boolean = false):void 
		{
			_transitionManager.transitionIn(instant);
		}
		
		public function transitionOut(instant:Boolean = false):void 
		{
			_transitionManager.transitionOut(instant);
		}
	}

}