// Contributors: Jonathan Vernon

package lib.shoot.entity.states
{
	import flash.ui.Keyboard;
	
	import lib.shoot.InputManager;
	import lib.shoot.MathHelper;
	import lib.shoot.entity.Entity;
	
	public class PlayerStateDead implements State
	{
		private var tick:int = 0;
		
		public function update(entity:Entity, metadata:Object = null):void
		{
			this.tick++;
			
			if(this.tick == 60)
			{
				entity.canRemove = true;
			}
		}
		
		public function enter(entity:Entity, metadata:Object = null):void
		{	
			entity.isDead = true;
			entity.physicsCheckEntities = false;
			entity.physicsCheckTiles = false;
			//entity.physicsDoGravity = false;
			entity.xVel = entity.getDirection() * 2;
			
			entity.animation = "DEAD";
		}
		
		public function exit(entity:Entity, metadata:Object = null):void
		{
			
		}
	}
}
