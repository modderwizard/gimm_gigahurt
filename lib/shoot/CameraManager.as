package lib.shoot
{
	import flash.display.DisplayObject;
	import flash.display.Stage;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	
	import fl.VirtualCamera;
	
	import lib.shoot.entity.Entity;
	
	public class CameraManager
	{
		public static var resWidth:int = 480;
		public static var resHeight:int = 224;
		
		private static var entityTracking:Entity = null;
		
		private static var posX:Number = 0;
		private static var posY:Number = 0;
		private static var posXPrev:Number = 0;
		private static var posYPrev:Number = 0;
		
		private static var root:DisplayObject = null;
		
		public static function initialize(root:DisplayObject):void
		{
			var camera:VirtualCamera = VirtualCamera.getCamera(root);
			CameraManager.root = root;
			
			CameraManager.updatePosAndScale();
		}
		
		public static function updatePosAndScale():void
		{
			var camera:VirtualCamera = VirtualCamera.getCamera(CameraManager.root);
			
			camera.setZoom(300);
			camera.setPosition(resWidth, resHeight);
		}
		
		// TODO: 
		public static function update():void
		{
			if(CameraManager.getEntityTracking() == null || CameraManager.getEntityTracking().isDead)
			{
				return;
			}
			
			CameraManager.posXPrev = CameraManager.posX;
			CameraManager.posYPrev = CameraManager.posY;				
			
			var camera:VirtualCamera = VirtualCamera.getCamera(CameraManager.root);
			
			var trackingX:Number = CameraManager.entityTracking.getBoundingBox().getCenterPoint().x;
			var trackingY:Number = CameraManager.entityTracking.getBoundingBox().getCenterPoint().y;
	
			// Correct camera X position
			var cameraXZone:Number = 250;
			
			// Left side screen disabled
			/*if(trackingX < CameraManager.posX + cameraXZone)
			{
				CameraManager.posX -= (CameraManager.posX + cameraXZone) - trackingX;
			}*/
			
			if(trackingX > CameraManager.posX + resWidth - cameraXZone)
			{
				CameraManager.posX += trackingX - (CameraManager.posX + resWidth - cameraXZone);
			}
			
			// Correct camera Y position
			var cameraYZone:Number = 50;
			
			if(trackingY < CameraManager.posY + cameraYZone)
			{
				CameraManager.posY -= (CameraManager.posY + cameraYZone) - trackingY;
			}
			
			if(trackingY > CameraManager.posY + resHeight - cameraYZone)
			{
				CameraManager.posY += trackingY - (CameraManager.posY + resHeight - cameraYZone);
			}
			
			CameraManager.posX = MathHelper.clamp(CameraManager.posX, -9000, 9000);
			CameraManager.posY = MathHelper.clamp(CameraManager.posY, -9000, 9000);
			
			
			if(CameraManager.entityTracking.posX - CameraManager.entityTracking.getBoundingBoxXOffset() < CameraManager.posX)
			{
				CameraManager.getEntityTracking().posX = CameraManager.posX + CameraManager.getEntityTracking().getBoundingBoxXOffset();
			}
			
			// Flash camera coordinates are inverted? So we have to subtract instead of add.
			camera.setPosition(resWidth - CameraManager.posX, resHeight - CameraManager.posY);
		}
		
		public static function getCameraPosition():Point
		{
			return new Point(CameraManager.posX, CameraManager.posY);
		}
		
		public static function getCameraPositionPrev():Point
		{
			return new Point(CameraManager.posXPrev, CameraManager.posYPrev);
		}
		
		public static function getCameraRect():Rectangle
		{
			return new Rectangle(CameraManager.posX, CameraManager.posY, resWidth, resHeight);
		}
		
		public static function getEntityTracking():Entity
		{
			return CameraManager.entityTracking;
		}
		
		public static function setEntityTracking(entity:Entity):void
		{
			CameraManager.entityTracking = entity;
			
			if(entity != null)
			{
				CameraManager.posX = entity.posX + (entity.width / 2) - 160;
				CameraManager.posY = entity.posY + (entity.height / 2) - 190;
			}
		}
	}
}