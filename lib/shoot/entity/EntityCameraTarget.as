package lib.shoot.entity 
{
	import flash.display.MovieClip;
	
	import lib.shoot.GameSettings;
	import lib.shoot.InputManager;
	import lib.shoot.MathHelper;
	import lib.shoot.Quadrilateral;
	
	public class EntityCameraTarget extends Entity 
	{
		public function EntityCameraTarget()
		{
			this.physicsCheckTiles = false;
			this.physicsCheckEntities = false;
			this.physicsDoGravity = false;
		}
		
		public override function update():void
		{
			// TODO: Change this later
			this.visible = GameSettings.enableDebugHotkeys;
		}
		
		public override function setDead():void
		{
			this.canRemove = true;
		}
	}
}
