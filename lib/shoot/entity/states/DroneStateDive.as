// Contributors: Jonathan Vernon & Parker Ussery

package lib.shoot.entity.states
{
	import flash.ui.Keyboard;
	
	import lib.shoot.CameraManager;
	import lib.shoot.InputManager;
	import lib.shoot.MathHelper;
	import lib.shoot.entity.Entity;
	
	public class DroneStateDive implements State
	{
		public function update(entity:Entity, metadata:Object = null):void
		{
			
		}
		
		public function enter(entity:Entity, metadata:Object = null):void
		{
			entity.physicsDoGravity = true;
		}
		
		public function exit(entity:Entity, metadata:Object = null):void
		{
			
		}
	}
}
