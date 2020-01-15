// Contributors: Jonathan Vernon

package lib.shoot.entity.states
{
	import flash.ui.Keyboard;
	
	import lib.shoot.InputManager;
	import lib.shoot.MathHelper;
	import lib.shoot.entity.*;
	
	public class PlayerStateGround implements State
	{
		public function update(entity:Entity, metadata:Object = null):void
		{
			// Set different states
			if(!entity.onGround)
			{
				entity.setState(new PlayerStateAir());
			}
			
			// Movement
			var walkingSpeed:Number = 0.5;
			var walkingSpeedMax:Number = 1.5;
			var friction:Number = 0.2;
			
			if(InputManager.isKeyDown(Keyboard.LEFT))
			{
				entity.xVel -= walkingSpeed;
				entity.setDirection(-1);
			}
			
			if(InputManager.isKeyDown(Keyboard.RIGHT))
			{
				entity.xVel += walkingSpeed;
				entity.setDirection(1);
			}
			
			// In-place aiming
			if(InputManager.isKeyDown(Keyboard.F) && entity.onGround)
			{
				entity.setState(new PlayerStateFreeAim());
				
				return;
			}
			
			if(InputManager.isKeyPressed(Keyboard.SPACE))
			{
				entity.yVel = -2.5;
				entity.posY -= 0.1;
				
				return;
			}
			
			if(InputManager.isKeyPressed(Keyboard.SHIFT) && (entity as EntityPlayer).canDodge)
			{
				entity.setState(new PlayerStateDodge());
				
				return;
			}
			
			entity.xVel = MathHelper.clamp(entity.xVel, -walkingSpeedMax, walkingSpeedMax);
			entity.xVel = MathHelper.moveTowardsZero(entity.xVel, friction);

			// Update animation
			if(entity.xVel != 0)
			{
				entity.animation = "GROUND_WALK";
			}
			else
			{
				entity.animation = "GROUND_IDLE";
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
