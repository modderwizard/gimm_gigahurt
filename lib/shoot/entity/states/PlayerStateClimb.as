// Contributors: Jonathan Vernon

package lib.shoot.entity.states
{
	import flash.ui.Keyboard;
	
	import lib.shoot.InputManager;
	import lib.shoot.MathHelper;
	import lib.shoot.entity.*;
	//public var contact = metadata;

	public class PlayerStateClimb implements State
	{
		public var contact:String = "";

		public function update(entity:Entity, metadata:Object = null):void
		{
			//public var contact = metadata;
			// Set different states
			//trace(contact);
			
			//entity.physicsCheckTiles = false;
			if(contact == "LEFT" && InputManager.isKeyDown(Keyboard.LEFT))
			{
				entity.physicsDoGravity = true;
				entity.setState(new PlayerStateDodge());
				//entity.xPos += 3;
			}

			if(contact == "RIGHT" && InputManager.isKeyDown(Keyboard.RIGHT))
			{
				entity.physicsDoGravity = true;
				entity.setState(new PlayerStateDodge());
				
				//entity.xPos -= 3;
			}
			if(entity.posY < 213.3  && InputManager.isKeyDown(Keyboard.UP))
			{
				entity.physicsDoGravity = true;
				//entity.setState(new PlayerStateDodge());
				entity.posX += 3;
				entity.setState(new PlayerStateGround());
			}
			
			// Movement
			//entity.metadata as String ==
			var walkingSpeed:Number = 1.2;
			var walkingSpeedMax:Number = 1.5;
			var friction:Number = 0.2;
			
			if(InputManager.isKeyDown(Keyboard.UP))
			{
				
				entity.posY -= walkingSpeed;
				//entity.setDirection(-1);
			}
			
			if(InputManager.isKeyDown(Keyboard.DOWN))
			{
				entity.posY += walkingSpeed;
			}
			
			entity.xVel = MathHelper.clamp(entity.xVel, -walkingSpeedMax, walkingSpeedMax);
			entity.xVel = MathHelper.moveTowardsZero(entity.xVel, friction);
			 
			// Update animation
			
		}
		
		public function enter(entity:Entity, metadata:Object = null):void
		{
			contact = String(metadata);
			entity.physicsDoGravity = false;
			entity.yVel = 0;
		}
		
		public function exit(entity:Entity, metadata:Object = null):void
		{
			entity.physicsDoGravity = true;
		}
	}
}
