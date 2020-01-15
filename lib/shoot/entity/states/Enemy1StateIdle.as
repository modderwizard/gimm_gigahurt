// Contributors: Jonathan Vernon

package lib.shoot.entity.states
{
	import flash.ui.Keyboard;
	
	import lib.shoot.CameraManager;
	import lib.shoot.InputManager;
	import lib.shoot.MathHelper;
	import lib.shoot.entity.Entity;
	
	public class Enemy1StateIdle implements State
	{
		public function update(entity:Entity, metadata:Object = null):void
		{
			if(!CameraManager.getEntityTracking().isDead && CameraManager.getCameraRect().containsRect(entity.getBoundingBox().getContainerRect()))
			{
				entity.setState(new Enemy1StateAggro());
			}
		}
		
		public function enter(entity:Entity, metadata:Object = null):void
		{
			
		}
		
		public function exit(entity:Entity, metadata:Object = null):void
		{
			
		}
	}
}
