package lib.shoot.entity 
{
	import flash.display.MovieClip;
	
	import lib.shoot.CameraManager;
	import lib.shoot.GameSettings;
	import lib.shoot.InputManager;
	import lib.shoot.MathHelper;
	import lib.shoot.Quadrilateral;
	
	public class EntityBullet extends Entity 
	{
		public var owner:Entity;
		
		public function EntityBullet(owner:Entity)
		{
			this.healthMax = int.MAX_VALUE;
			this.health = int.MAX_VALUE;
			
			this.physicsCheckTiles = false;
			this.physicsDoGravity = false;
			
			this.owner = owner;
			
			this.abilities.push(Ability.TOUCH_HURT);
			
			this.boundingBoxWidth = 9;
			this.boundingBoxHeight = 9;
			
			this.animation = "DEFAULT";
		}
		
		public override function update():void
		{
			if(!CameraManager.getCameraRect().containsRect(this.getBoundingBox().getContainerRect()))
			{
				this.isDead = true;
				this.canRemove = true;
			}
			
			if(this.yVel != 0)
			{
				if(this.xVel == 0)
				{
					this.animation = "UP";
				}
				else
				{
					this.animation = this.yVel < 0 ? "DUP" : "DDOWN";
				}
			}
			else
			{
				this.animation = "DEFAULT";
			}
			
			super.update();
		}
		
		public override function addScore(toAdd:Number):void
		{
			this.owner.addScore(toAdd);
		}
		
		public override function canAttack(entity:Entity):Boolean
		{
			if(entity == this || entity == this.owner || this.isDead)
			{
				return false;
			}
			
			this.setDead();
			
			return true;
		}
		
		protected override function updateAnimation():void
		{
			if(this.animation != this.animationPrev)
			{
				this.gotoAndStop(this.animation);
			}
			
			this.animationPrev = this.animation;
		}
		
		public override function onAttacked(attacker:Entity):void
		{
			if(attacker != this.owner)
			{
				//attacker.onAttacked(this);
				//this.setDead();
			}
		}
	}
}
