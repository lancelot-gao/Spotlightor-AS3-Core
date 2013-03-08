package com.spotlightor.utils 
{
	/**
	 * 帮助检测email是否合法，支持单email检测以及多email检测
	 * @author 高鸣
	 */
	public class EmailValidator 
	{
		// Popular actionscript email reg exp
		//private static const EMAIL_REGEX:RegExp = /^[A-Z0-9._%+-]+@(?:[A-Z0-9-]+\.)+[A-Z]{2,4}$/i;
		
		// James Watts and Francisco Jose Martin Moreno
		// http://fightingforalostcause.net/misc/2006/compare-email-regex.php
		private static const EMAIL_REGEX:RegExp = /^([\w\!\#$\%\&\'\*\+\-\/\=\?\^\`{\|\}\~]+\.)*[\w\!\#$\%\&\'\*\+\-\/\=\?\^\`{\|\}\~]+@((((([a-z0-9]{1}[a-z0-9\-]{0,62}[a-z0-9]{1})|[a-z])\.)+[a-z]{2,6})|(\d{1,3}\.){3}\d{1,3}(\:\d{1,5})?)$/i;
		
		public static function isValidEmailAddress(text:String):Boolean {
			return EMAIL_REGEX.test(text);
		}
		
		public static function isValidEmailAddresses(text:String, splitter:String = ';'):Boolean {
			var emailTexts:Array = text.split(splitter);
			if (emailTexts[emailTexts.length - 1] == '') emailTexts.splice(emailTexts.length - 1, 1);
			
			for each (var emailText:String in emailTexts) 
			{
				if (!isValidEmailAddress(emailText)) return false;
			}
			return true;
		}
	}

}