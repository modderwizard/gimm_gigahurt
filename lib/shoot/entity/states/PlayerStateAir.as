// Contributors: Jonathan Vernon

package lib.shoot.entity.states
{
	import flash.ui.Keyboard;
	
	import lib.shoot.InputManager;
	import lib.shoot.MathHelper;
	import lib.shoot.entity.*;
	
	//state is an interface and not a regular class
	public class PlayerStateAir implements State
	{
		public function update(entity:Entity, metadata:Object = null):void
		{
			if(entity.onGround)
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
			
			if(InputManager.isKeyPressed(Keyboard.SHIFT)&& (entity as EntityPlayer).canDodge)
			{
				entity.setState(new PlayerStateDodge());
				
				return;
			}
			
			// Update animation
			if(entity.yVel < 0)
			{
				entity.animation = "AIR_JUMP";
			}
			else
			{
				entity.animation = "AIR_FALL";
			}
		}
		
		public function enter(entity:Entity, metadata:Object = null):void
		{	
			entity.onGround = false;
		}
		
		//
		public function exit(entity:Entity, metadata:Object = null):void
		{
			
		}
	}
}
