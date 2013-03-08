package com.spotlightor.media 
{
	import com.spotlightor.utils.Log;
	import flash.display.BitmapData;
	import flash.events.Event;
	import flash.events.StatusEvent;
	import flash.geom.Matrix;
	import flash.media.Camera;
	import flash.media.Video;
	import flash.system.Capabilities;
	/**
	 * 完成摄像头与video的连接，自动重复连接
	 * 提供drawBitmap的功能
	 * @author 高鸣 - 交典创艺 (Spotlightor.com)
	 */
	public class CameraVideo extends Video
	{
		public static const EVENT_NO_CAMERA:String = "evt_no_camera";
		public static const EVENT_REJECTED:String = "evt_rejected";
		
		private var _camera:Camera;
		private var _drawMatrix:Matrix;
		private var _bitmapdata:BitmapData;
		
		private var _refreshRate:int;
		private var _quality:int;
		
		private var _cameraConnected		:Boolean = false;
		
		/**
		 * 连接摄像头。drawScale设置为0将不会初始化bitmapdata。
		 * 如果用户没有连接任何摄像头，会发送EVENT_NO_CAMERA
		 * 如果用户拒绝连接摄像头，会发送EVENT_REJECTED
		 * 成功连接摄像头以后，会发送Event.COMPLETE事件
		 * 
		 * @param	camWidth
		 * @param	camHeight
		 * @param	refreshRate	摄像头图像刷新率
		 * @param	drawScale	0-1表示draw缩放的比例
		 */
		public function CameraVideo(camWidth:int = 640, camHeight:int = 480, refreshRate:int = 15, quality:int = 100, drawScale:Number = 1) 
		{
			super(camWidth, camHeight);
			
			_refreshRate = refreshRate;
			_quality = quality;
			
			if (drawScale > 0)
			{
				_bitmapdata = new BitmapData(camWidth * drawScale, camHeight * drawScale);
				_drawMatrix = new Matrix();
				_drawMatrix.scale(drawScale, drawScale);
				Log.info(this, "Camera draw bitmap inited:", _bitmapdata.width, _bitmapdata.height);
			}
		}
		
		public function connect():void
		{
			_camera = Camera.getCamera();
			if (_camera)
			{
				_camera.setMode(width, height, _refreshRate);
				_camera.setQuality(0, _quality);
				if (Capabilities.playerType == "Desktop") {
					connectCamera();
					Log.status(this, "In AIR, just connect to camera.");
				}
				else if (_camera.muted == false) {
					Log.status(this, "The user always access camera, connect.");
					connectCamera();
				}
				else tryConnectCamera();
			}
			else
			{
				Log.status(this, "no camera connected!");
				dispatchEvent(new Event(EVENT_NO_CAMERA));
			}
		}
		
		public function drawBitmapdata()
		{
			if (_bitmapdata) {
				_bitmapdata.draw(this, _drawMatrix);
			}
			else Log.warning(this, "No bitmapdata to draw!");
		}
		
		private function onCameraStatus(e:StatusEvent):void 
		{
			if (e.code == "Camera.Unmuted")
			{
				_cameraConnected = true;
				Log.status(this, "Camera connection allowed.");
				
				dispatchEvent(new Event(Event.COMPLETE));
				_camera.removeEventListener(StatusEvent.STATUS, onCameraStatus);
			}
			if (e.code == "Camera.Muted")
			{
				Log.status(this, "Camera connection rejected!");
				
				dispatchEvent(new Event(EVENT_REJECTED));
				_camera.removeEventListener(StatusEvent.STATUS, onCameraStatus);
			}
		}
		
		private function tryConnectCamera():void
		{
			Log.status(this, "Waiting for user's camera access permission...");
			attachCamera(_camera);
			_camera.addEventListener(StatusEvent.STATUS, onCameraStatus);
		}
		
		private function connectCamera():void
		{
			attachCamera(_camera);
			_cameraConnected = true;
			dispatchEvent(new Event(Event.COMPLETE));
		}
		
		public function get camera():Camera { return _camera; }
		
		public function get bitmapdata():BitmapData { return _bitmapdata; }
		
		public function get cameraConnected():Boolean { return _cameraConnected; }
		
		public function get drawMatrix():Matrix 
		{
			return _drawMatrix;
		}
	}

}