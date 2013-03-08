package com.spotlightor.filesystem 
{
	import com.spotlightor.utils.Log;
	import flash.display.BitmapData;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.ProgressEvent;
	import flash.filesystem.File;
	import flash.filesystem.FileMode;
	import flash.filesystem.FileStream;
	import flash.utils.ByteArray;
	import ru.inspirit.utils.JPGEncoder;
	/**
	 * Use inspirit's JPGEncoder(Not adobe core lib's)
	 * http://blog.inspirit.ru/?p=201
	 * 
	 * @author Gao Ming (Spotlightor Interactive)
	 */
	public class JpegAsyncFileSaver extends EventDispatcher
	{
		private var _jpgEncoder:JPGEncoder;
		private var _imageFile:File;
		public function JpegAsyncFileSaver(quality:int = 90) 
		{
			_jpgEncoder = new JPGEncoder(quality);
		}
		
		public function saveJpegImage(imageData:BitmapData, imageFile:File):void
		{
			var extension:String = imageFile.extension.toLowerCase();
			if (imageFile.extension == "png") {
				Log.fatal(this, "Cannot save PNG image file, jpg please.");
				return;
			}
			else 
			{
				_imageFile = imageFile;
				_jpgEncoder.addEventListener(Event.COMPLETE, onEncodingComplete);
				_jpgEncoder.addEventListener(ProgressEvent.PROGRESS, dispatchEvent);
				_jpgEncoder.encodeAsync(imageData);
			}
		}
		
		private function onEncodingComplete(e:Event):void
		{
			_jpgEncoder.removeEventListener(Event.COMPLETE, onEncodingComplete);
			_jpgEncoder.removeEventListener(ProgressEvent.PROGRESS, dispatchEvent);
			
			var imageFileStream:FileStream = new FileStream();
			try {
				imageFileStream.open(_imageFile, FileMode.WRITE);
				//imageFileStream.openAsync(_imageFile, FileMode.WRITE);
				imageFileStream.writeBytes(_jpgEncoder.ImageData);
				imageFileStream.close();
			}catch (error:Error) {
				Log.error(this, "Error occured for: " + _imageFile.url, error);
			}
			dispatchEvent(e);
		}
		
		public function dispose():void
		{
			_jpgEncoder.cleanUp(false);
			
			if (_jpgEncoder.ImageData) {
				_jpgEncoder.ImageData.clear();
			}
			
			_imageFile = null;
			
			_jpgEncoder = null;
		}
		
		public function get imageFile():File 
		{
			return _imageFile;
		}
		
		public function get jpgByteArray():ByteArray { return _jpgEncoder.ImageData; }
	}

}