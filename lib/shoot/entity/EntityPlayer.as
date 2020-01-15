package lib.shoot.entity
{
    import flash.display.MovieClip;
    import flash.events.TimerEvent;
    import flash.utils.Timer;
    import flash.ui.Keyboard;
    import flash.events.Event;
   
    import fl.motion.Color;
   
	import lib.shoot.GameSettings;
    import lib.shoot.InputManager;
    import lib.shoot.MathHelper;
    import lib.shoot.Quadrilateral;
	import lib.shoot.Sounds;
    import lib.shoot.entity.states.*;
 
    public class EntityPlayer extends Entity
    {
        private var invulnTimer:Timer;
       
        public var canDodge:Boolean;
		public var aimDirection:String;
       
        public function EntityPlayer()
        {
            this.healthMax = 3;
            this.health = 3;
           
            this.canDodge = true;
           
            this.abilities.push(Ability.BOUNCEBACK);
           
            this.setState(new PlayerStateGround());
			
			this.boundingBoxWidth = 38;
			this.boundingBoxHeight = 50;
			
			this.shootFrom.visible = false;
        }
       
        public override function update():void
        {
            // Noclip movement
			if(GameSettings.enableNoclip)
            {
                if(InputManager.isKeyDown(Keyboard.LEFT))
                {
                    this.posX -= 3;
                }
                if(InputManager.isKeyDown(Keyboard.RIGHT))
                {
                    this.posX += 3;
                }
               
                if(InputManager.isKeyDown(Keyboard.UP))
                {
                    this.posY -= 3;
                }
                if(InputManager.isKeyDown(Keyboard.DOWN))
                {
                    this.posY += 3;
                }
            }
			
			// Shooting
			if(InputManager.isKeyPressed(Keyboard.D))
			{
				var bullet:EntityBullet = new EntityBullet(this);
				bullet.posX = this.x + (this.direction == -1 ? -this.shootFrom.x - bullet.width : this.shootFrom.x);
				bullet.posY = this.y + this.shootFrom.y - (bullet.height / 2);
				bullet.setDirection(this.direction);
				this.level.addEntity(bullet);
				
				bullet.xVel = bullet.getDirection() * 5;
				
				// In place aiming
				if(this.state is PlayerStateFreeAim)
				{
					bullet.xVel = 0;
					
					if(InputManager.isKeyDown(Keyboard.RIGHT))
					{
						bullet.xVel += 5;
					}
					if(InputManager.isKeyDown(Keyboard.LEFT))
					{
						bullet.xVel -= 5;
					}
					if(InputManager.isKeyDown(Keyboard.UP))
					{
						bullet.yVel -= 5;
					}
					if(InputManager.isKeyDown(Keyboard.DOWN))
					{
						bullet.yVel += 5;
						bullet.xVel = this.direction * 5;
					}
					
					if(bullet.xVel == 0 && bullet.yVel == 0)
					{
						bullet.xVel = this.direction * 5;
					}
				}
				
				bullet.setDirection(bullet.xVel > 0 ? 1 : -1);
				
				Sounds.playSound(Sounds.shoot);
			}
			
			if(this.onGround)
			{
				this.canDodge = true;
			}

            super.update();
        }
       
        public override function onAttacked(attacker:Entity):void
        {
            if(!this.isInvulnerable)
            {
                this.health--;
                this.setState(new PlayerStateDodge());
				Sounds.playSound(Sounds.hurt1);
            }
           
            if(this.health <= 0)
            {
				this.isDead = true;
                this.setState(new PlayerStateDead());
            }
        }
       
        public override function setInvulnverable(invulnerable:Boolean):void
        {
            if(!this.isInvulnerable)
            {
                this.isInvulnerable = invulnerable;
           
                var invulnTimeSeconds:Number = 1;
                var invlinTicksPerSecond:Number = 64;
               
                this.invulnTimer = new Timer((invulnTimeSeconds / invlinTicksPerSecond) * 1000, invulnTimeSeconds * invlinTicksPerSecond);
                this.invulnTimer.addEventListener(TimerEvent.TIMER, onInvulnTimerTick);
                this.invulnTimer.addEventListener(TimerEvent.TIMER_COMPLETE, onInvulnTimerEnd);
                this.onInvulnTimerTick(null);
                this.invulnTimer.start();
            }
        }
       
        private function onInvulnTimerTick(evt:TimerEvent):void
        {
            if(this.invulnTimer.running)
            {
                if(this.alpha < 1)
                {
                    this.alpha = 1;
                }
                else
                {
                    this.alpha = 1;
                }
            }
        }
       
        private function onInvulnTimerEnd(evt:TimerEvent):void
        {
            this.isInvulnerable = false;
           
            this.transform.colorTransform.alphaMultiplier = 1;
        }
    }
}