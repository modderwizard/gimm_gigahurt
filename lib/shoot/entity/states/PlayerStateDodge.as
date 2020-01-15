// Contributors: Jonathan Vernon

package lib.shoot.entity.states
{
	import flash.ui.Keyboard;
	
	import lib.shoot.InputManager;
	import lib.shoot.MathHelper;
	import lib.shoot.entity.EntityPlayer;
	import lib.shoot.entity.Entity;
	
	public class PlayerStateDodge implements State
	{
		private var tick:int = 0;
		
		public function update(entity:Entity, metadata:Object = null):void
		{
			this.tick++;
			
			entity.xVel = MathHelper.moveTowardsZero(entity.xVel, 0.15);
			
			if(this.tick == 10)
			{
				if(entity.onGround)
				{
					entity.setState(new PlayerStateGround());
				}
				else
				{
					entity.setState(new PlayerStateAir());
				}
			}
			
			if(!entity.onGround)
			{
				(entity as EntityPlayer).canDodge = false;
			}
		}
		
		public function enter(entity:Entity, metadata:Object = null):void
		{	
			entity.setInvulnverable(true);
			entity.animation = "GROUND_IDLE";
			
			(entity as EntityPlayer).canDodge = false;

			if(InputManager.isKeyDown(Keyboard.LEFT))
			{
				entity.animation = "DODGE_TOWARDS";
				entity.xVel = -4;
			}
			
			if(InputManager.isKeyDown(Keyboard.RIGHT))
			{
				entity.animation = "DODGE_TOWARDS";
				entity.xVel = 4;				
			}
			
			if(InputManager.isKeyDown(Keyboard.UP))
			{
				entity.animation = "AIR_JUMP";
				entity.yVel = -3;
				entity.posY -= 1;
			}
			if(InputManager.isKeyDown(Keyboard.DOWN))
			{
				entity.animation = "AIR_FALL";
				entity.yVel = 3;
			}
		}
		
		public function exit(entity:Entity, metadata:Object = null):void
		{
			
		}
	}
}
