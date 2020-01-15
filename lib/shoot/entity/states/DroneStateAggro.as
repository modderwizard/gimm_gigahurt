// Contributors: Jonathan Vernon

package lib.shoot.entity.states
{
	import flash.ui.Keyboard;
	
	import lib.shoot.CameraManager;
	import lib.shoot.InputManager;
	import lib.shoot.MathHelper;
	import lib.shoot.entity.Entity;
	
	public class DroneStateAggro implements State
	{
		public function update(entity:Entity, metadata:Object = null):void
		{
			var player:Entity = CameraManager.getEntityTracking();
			
			if(player == null || player.isDead)
			{
				entity.setState(new DroneStateIdle());
			}
			
			//var moveDirection:int = player.getBoundingBox().getCenterPoint().x < entity.getBoundingBox().getCenterPoint().x ? -1 : 1;
			
			//entity.setDirection(moveDirection);
			//entity.xVel = 0.5 * moveDirection;
		}
		
		public function enter(entity:Entity, metadata:Object = null):void
		{
			
		}
		
		public function exit(entity:Entity, metadata:Object = null):void
		{
			
		}
	}
}
