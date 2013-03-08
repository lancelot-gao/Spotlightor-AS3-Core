package com.spotlightor.filesystem 
{
	import com.adobe.images.JPGEncoder;
	import com.adobe.images.PNGEncoder;
	import com.spotlightor.utils.Log;
	import flash.display.BitmapData;
	import flash.filesystem.File;
	import flash.filesystem.FileMode;
	import flash.filesystem.FileStream;
	import flash.utils.ByteArray;
	import flash.utils.setTimeout;

	public function saveImage(imageData:BitmapData, imageFile:File, imageQuality:int = 80):ByteArray
	{
		if (!imageFile.exists)
		{
			/**
			 * Save the image
			 */
			var imageByteArray:ByteArray;
			var extension:String = imageFile.extension.toLowerCase();
			if (imageFile.extension == "png") imageByteArray = PNGEncoder.encode(imageData);
			else 
			{
				var jpgEncoder:JPGEncoder = new JPGEncoder(imageQuality);
				imageByteArray = jpgEncoder.encode(imageData);
			}
				
			var imageFileStream:FileStream = new FileStream();
			try {
				imageFileStream.open(imageFile, FileMode.WRITE);
				//imageFileStream.openAsync(imageFile, FileMode.WRITE);
				imageFileStream.writeBytes(imageByteArray);
				imageFileStream.close();
			}catch (error:Error) {
				Log.error(this, "Error occured for: " + imageFile.url, error);
			}
			return imageByteArray;
		}
	
		return null;
	}
}