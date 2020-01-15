// Contributors: Jonathan Vernon

package lib.shoot.entity.states
{
	import flash.ui.Keyboard;
	
	import lib.shoot.InputManager;
	import lib.shoot.MathHelper;
	import lib.shoot.entity.*;
	
	public class PlayerStateFreeAim implements State
	{
		public function update(entity:Entity, metadata:Object = null):void
		{
			if(!InputManager.isKeyDown(Keyboard.F))
			{
				entity.setState(new PlayerStateGround());
				return;
			}
			
			if(InputManager.isKeyDown(Keyboard.LEFT))
			{
				entity.setDirection(-1);
			}
			
			if(InputManager.isKeyDown(Keyboard.RIGHT))
			{
				entity.setDirection(1);
			}
			
			// In-place aiming
			entity.xVel = 0;
			
			var isAimingUp:Boolean = InputManager.isKeyDown(Keyboard.UP);
			var isAimingDown:Boolean = InputManager.isKeyDown(Keyboard.DOWN);
			var isAimingSide:Boolean = InputManager.isKeyDown(Keyboard.LEFT) || InputManager.isKeyDown(Keyboard.RIGHT);
			
			// Up and down cancel eachother out
			if(isAimingDown && isAimingUp)
			{
				isAimingDown = isAimingUp = false;
			}
			
			entity.animation = "AIM0";
			
			if(isAimingUp && isAimingSide)
			{
				entity.animation = "AIM1";
			}
			
			if(isAimingUp && !isAimingSide)
			{
				entity.animation = "AIM3";
			}
			
			if(isAimingDown)
			{
				entity.animation = "AIM2";
			}
		}
		
		public function enter(entity:Entity, metadata:Object = null):void
		{
			entity.xVel = 0;
		}
		
		public function exit(entity:Entity, metadata:Object = null):void
		{
			
		}
	}
}
