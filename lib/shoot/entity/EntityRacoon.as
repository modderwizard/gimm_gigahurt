package lib.shoot.entity 
{
	import flash.display.MovieClip;
	
	import lib.shoot.Sounds;
	import lib.shoot.CameraManager;
	import lib.shoot.InputManager;
	import lib.shoot.MathHelper;
	import lib.shoot.Quadrilateral;
	
	public class EntityRacoon extends Entity 
	{
		public function EntityRacoon()
		{
			this.abilities.push(Ability.TOUCH_HURT);
			
			this.setDirection(-1);
		}
		
		public override function update():void
		{
			if(CameraManager.getEntityTracking().posX < this.posX)
			{
				this.setDirection(-1);
			}
			else
			{
				this.setDirection(1);
			}
			
			if(!CameraManager.getCameraRect().containsRect(this.getBoundingBox().getContainerRect()) && this.isDead)
			{
				this.canRemove = true;
			}
			
			super.update();
		}
		
		public override function setDead():void
		{
			this.isDead = true;
			this.physicsCheckTiles = false;
			this.physicsCheckEntities = false;
			
			this.xVel = -2 * this.direction;
			
			this.animation = "DEAD";
			
			Sounds.playSound(Sounds.hurtRaccoon);
		}
	}
}
