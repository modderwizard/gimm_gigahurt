package lib.shoot.entity 
{
	import flash.display.MovieClip;
	
	import lib.shoot.InputManager;
	import lib.shoot.MathHelper;
	import lib.shoot.Quadrilateral;
	import lib.shoot.entity.states.*;
	
	public class EntityEnemy1 extends Entity 
	{
		public function EntityEnemy1()
		{
			this.healthMax = 1;
			this.health = 1;
			
			this.abilities.push(Ability.TOUCH_HURT);
			
			this.setDirection(-1);
			
			this.setState(new Enemy1StateIdle());
			
			this.boundingBoxWidth = 38;
			this.boundingBoxHeight = 41;
		}
	}
}
