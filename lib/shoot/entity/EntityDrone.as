package lib.shoot.entity 
{
	import flash.display.MovieClip;
	
	import lib.shoot.InputManager;
	import lib.shoot.MathHelper;
	import lib.shoot.Quadrilateral;
	import lib.shoot.entity.states.*;
	import lib.shoot.KinematicSegment;
	
	public class EntityDrone extends Entity 
	{
		private var chains:Vector.<KinematicSegment> = new Vector.<KinematicSegment>();
		
		public function EntityDrone()
		{
			this.healthMax = 1;
			this.health = 1;
			
			this.physicsDoGravity = false;
			
			this.abilities.push(Ability.TOUCH_HURT);
			
			this.setDirection(-1);
			
			this.setState(new DroneStateIdle());
			
			this.boundingBoxWidth = 26;
			this.boundingBoxHeight = 27;
			
			this.addChain(new KinematicSegment(3, 11));
			this.addChain(new KinematicSegment(3, 11));
			this.addChain(new KinematicSegment(3, 11));
			this.addChain(new KinematicSegment(3, 11));
		}
		
		private function addChain(chain:KinematicSegment)
		{
			//this.chains.push(chain);
			//this.addChild(chain);
		}
		
		public override function onTileHit(side:String):void
		{
			if(state is DroneStateDive)
			{	
				this.setDead();
				var explosion:EntityExplosion = new EntityExplosion(true);
				explosion.posX = this.x + (this.direction == -1 ? explosion.width : 0);
				explosion.posY = this.y + (explosion.height / 2);
				explosion.setDirection(this.direction);
				this.level.addEntity(explosion);
			};
			
		}
		
		public override function update():void
		{
			/*this.posX += 0.08;
			
			for(var i:int = 0; i < this.chains.length; i++)
			{
				this.chains[i].rotation = 25;
				
				if(i == 0)
				{
					this.chains[i].x = this.getBoundingBox().getCenterPoint().x;
					this.chains[i].y = this.getBoundingBox().getCenterPoint().y;
				}
				else
				{
					this.chains[i].x = this.chains[i - 1].getPin().x;
					this.chains[i].y = this.chains[i - 1].getPin().y;
				}
			}*/
			
			super.update();
		}
		
		protected override function updateAnimation():void
		{
			
		}
	}
}
