package com.spotlightor.media 
{
	import com.greensock.plugins.SoundTransformPlugin;
	import com.greensock.plugins.TweenPlugin;
	import com.greensock.TweenLite;
	import flash.events.EventDispatcher;
	import flash.media.Sound;
	import flash.media.SoundChannel;
	import flash.media.SoundTransform;
	/**
	 * ...
	 * @author Gao Ming (Spotlightor Interactive)
	 */
	public class BGM extends EventDispatcher
	{
		
		// CONSTANTS
		// Settings
		private var _volume			:Number;
		private var _durationIn		:Number;
		private var _durationOut	:Number;
		// Variables
		private var _bgmSound		:Sound;
		private var _soundChannel	:SoundChannel;
		// References
		
		public function BGM(bgmSound:Sound, volume:Number = 1, durationIn:Number = 1, durationOut:Number = 1) 
		{
			_volume = volume;
			_durationIn = durationIn;
			_durationOut = durationOut;
			_bgmSound = bgmSound;
			
			TweenPlugin.activate([SoundTransformPlugin]);
		}
		//{ region Pubilc methods
		public function play():void
		{
			if (_soundChannel)
			{
				// still playing
				TweenLite.to(_soundChannel, _durationIn, { soundTransform: { volume:_volume }} );
			}
			else
			{
				_soundChannel = _bgmSound.play(0, int.MAX_VALUE, new SoundTransform(0));
				TweenLite.to(_soundChannel, _durationIn, { soundTransform: { volume:_volume }} );
			}
		}
		
		public function stop():void
		{
			if (_soundChannel)
			{
				TweenLite.to(_soundChannel, _durationIn, { soundTransform: { volume:0 }, onComplete:onSoundFadeOutComplete} );
			}
		}
		
		private function onSoundFadeOutComplete():void 
		{
			if (_soundChannel) {
				_soundChannel.stop();
				_soundChannel = null;
			}
		}
		//} endregion
		
		//{ region Private/Protected methods
		
		//} endregion
		
		//{ region Event handlers
		
		//} endregion
		
		//{ region Getters & Setters
		
		//} endregion
	}

}