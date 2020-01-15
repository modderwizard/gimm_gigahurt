package lib.shoot.entity
{
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	
	import lib.shoot.DebugHelper;
	import lib.shoot.GameSettings;
	import lib.shoot.Quadrilateral;
	import lib.shoot.entity.states.*;
	import lib.shoot.level.Level;
	
	public class Entity extends MovieClip
	{
		// State
		public var state:State = null;		
		public var animation:String = "GROUND_IDLE";
		protected var animationPrev:String = "GROUND_IDLE";
		
		public var healthMax:Number;
		public var health:Number;
		public var score:Number;
		public var isDead:Boolean;
		public var canRemove:Boolean;
		protected var isInvulnerable:Boolean;
		
		protected var abilities:Array;
		
		// Position
		public var posX:Number;
		public var posY:Number;
		public var posXPrev:Number;
		public var posYPrev:Number;
		
		// Facing
		protected var direction:int;
		protected var directionPrev:int;
		
		// Velocity
		public var xVel:Number;
		public var yVel:Number;
		public var xVelPrev:Number;
		public var yVelPrev:Number;
		
		// Physics
		public var onGround:Boolean;
		public var physicsCheckTiles:Boolean;
		public var physicsCheckEntities:Boolean;
		public var physicsDoGravity:Boolean;
		
		public var boundingBoxWidth:int;
		public var boundingBoxHeight:int;
		protected var boundingBox:Quadrilateral;
		protected var boundingBoxPrev:Quadrilateral;
		
		public var level:Level;
		
		public function Entity()
		{
			this.healthMax = 1;
			this.health = 1;
			this.score = 0;
			this.isDead = false;
			this.canRemove = false;
			this.isInvulnerable = false;
			
			this.abilities = new Array();
			
			this.posX = x;
			this.posY = y;
			this.posXPrev = x;
			this.posYPrev = y;
			
			this.direction = 1;
			this.directionPrev = 1;
			
			this.xVel = 0;
			this.yVel = 0;
			this.xVelPrev = 0;
			this.yVelPrev = 0;
			
			this.onGround = false;
			this.physicsCheckTiles = true;
			this.physicsCheckEntities = true;
			this.physicsDoGravity = true;
			
			this.boundingBox = new Quadrilateral();
			this.boundingBoxPrev = new Quadrilateral();

			this.boundingBoxWidth = 24;
			this.boundingBoxHeight = 24;
		}
		
		public function update():void
		{
			if(this.state != null)
			{
				this.state.update(this);
			}
			
			// Update 'previous' values
			this.xVelPrev = this.xVel;
			this.yVelPrev = this.yVel;
			
			this.posXPrev = posX;
			this.posYPrev = posY;
			
			this.posX += xVel;
			this.posY += yVel;
			
			// Set new x and y position
			this.x = this.posX;
			this.y = this.posY;
			
			this.updateAnimation();
		}
		
		public function getBoundingBox():Quadrilateral
		{
			return this.boundingBox.fromPositionAndSize(this.posX - this.getBoundingBoxXOffset(), this.posY, this.boundingBoxWidth, this.boundingBoxHeight);
		}
		
		public function getBoundingBoxPrev():Quadrilateral
		{
			return this.boundingBoxPrev.fromPositionAndSize(this.posXPrev - this.getBoundingBoxXOffset(), this.posYPrev, this.boundingBoxWidth, this.boundingBoxHeight);
		}
		
		public function getBoundingBoxXOffset():int
		{
			return this.direction == -1 ? this.boundingBoxWidth : 0;
		}
		
		public function getDirection():int
		{
			return this.direction;
		}
		
		public function setDirection(direction:int):void
		{
			this.directionPrev = this.direction;
			this.direction = direction;
			
			if(this.direction != this.directionPrev)
			{
				if(this.direction == -1)
				{
					this.posX += this.getBoundingBox().width;
				}
				else
				{
					this.posX -= this.getBoundingBox().width;
				}
				
				this.scaleX = this.direction;
			}
		}
		
		public function setState(state:State, enterMeta:Object = null):void
		{
			if(this.state != null)
			{
				this.state.exit(this);
			}
			
			this.state = state;
			this.state.enter(this, enterMeta);
		}
		
		public function getState():State
		{
			return this.state;
		}
		
		protected function updateAnimation():void
		{
			if(this.animation != this.animationPrev)
			{
				this.gotoAndPlay(this.animation);
			}
			
			this.animationPrev = this.animation;
		}
		
		public function canAttack(entity:Entity):Boolean
		{
			return entity != this;
		}
		
		public function onAttacked(attacker:Entity):void
		{
			this.health--;
						
			if(this.health <= 0)
			{
				this.setDead();
				
				attacker.addScore(1);
			}
		}
		
		public function onTileHit(side:String):void
		{
			
		}
		
		public function setDead():void
		{
			this.isDead = true;
			this.canRemove = true;
		}
		
		public function setInvulnverable(invulnerable:Boolean):void
		{
			this.isInvulnerable = invulnerable;
		}
		
		public function isInvulnverable():Boolean
		{
			return this.isInvulnerable;
		}
		
		public function addScore(toAdd:Number):void
		{
			this.score += toAdd;
		}
		
		public function hasAbility(ability:Ability):Boolean
		{
			return this.abilities.indexOf(ability) >= 0;
		}
	}
}