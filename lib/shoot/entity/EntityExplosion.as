package lib.shoot.entity 
{
	import flash.display.MovieClip;
	
	import lib.shoot.CameraManager;
	import lib.shoot.GameSettings;
	import lib.shoot.InputManager;
	import lib.shoot.MathHelper;
	import lib.shoot.Quadrilateral;
	
	public class EntityExplosion extends Entity 
	{
		private var canDoHarm:Boolean;
		
		public function EntityExplosion(canDoHarm:Boolean)
		{
			this.healthMax = int.MAX_VALUE;
			this.health = int.MAX_VALUE;
			
			this.physicsCheckTiles = false;
			this.physicsDoGravity = false;
			
			this.abilities.push(Ability.TOUCH_HURT);
			
			this.boundingBoxWidth = 9;
			this.boundingBoxHeight = 9;
			
			this.canDoHarm = canDoHarm;
		}
		
		public override function canAttack(entity:Entity):Boolean
		{
			return this.canDoHarm && entity is EntityPlayer;
		}
	}
}
