package com.spotlightor.filesystem 
{
	import com.spotlightor.utils.Log;
	import flash.filesystem.File;
	import flash.filesystem.FileMode;
	import flash.filesystem.FileStream;
	import flash.utils.setTimeout;

	/**
	 * 存储文本类型的文件，不一定后缀必须是txt，xml，html等皆可
	 * @param	content
	 * @param	file
	 * @return
	 */
	public function saveTxt(content:String, file:File):File
	{
		//if (!file.exists) file.deleteFile();
		if (file.exists) file.deleteFile();
		/**
		 * Save text content
		 */
		var fileStream:FileStream = new FileStream();
		try {
			fileStream.open(file, FileMode.WRITE);
			//fileStream.openAsync(file, FileMode.WRITE);
			fileStream.writeUTF(content);
			fileStream.close();
		}catch (error:Error) {
			Log.error(this, "Error occured for: " + file.url, error);
		}

	
		return file;
	}
}