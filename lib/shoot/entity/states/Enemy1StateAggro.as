// Contributors: Jonathan Vernon

package lib.shoot.entity.states
{
	import flash.ui.Keyboard;
	
	import lib.shoot.CameraManager;
	import lib.shoot.InputManager;
	import lib.shoot.MathHelper;
	import lib.shoot.entity.*;
	
	public class Enemy1StateAggro implements State
	{
		private var tick:int = 0;
		
		public function update(entity:Entity, metadata:Object = null):void
		{
			this.tick++;
			
			var player:Entity = CameraManager.getEntityTracking();
			
			if(player == null || player.isDead)
			{
				entity.setState(new Enemy1StateIdle());
			}
			
			var moveDirection:int = player.getBoundingBox().getCenterPoint().x < entity.getBoundingBox().getCenterPoint().x ? -1 : 1;
			
			entity.setDirection(moveDirection);
			entity.xVel = 0.5 * moveDirection;
			
			if(this.tick >= 60 * 2)
			{
				this.tick = 0;
				
				var bullet:EntityBullet = new EntityBullet(entity);
				bullet.posX = entity.x + (entity.getDirection() == -1 ? -bullet.width : 0);
				bullet.posY = entity.y - (bullet.height / 2);
				bullet.setDirection(entity.getDirection());
				entity.level.addEntity(bullet);
				bullet.xVel = bullet.getDirection() * 5;
			}
		}
		
		public function enter(entity:Entity, metadata:Object = null):void
		{
			entity.animation = "GROUND_WALK";
		}
		
		public function exit(entity:Entity, metadata:Object = null):void
		{
			
		}
	}
}
