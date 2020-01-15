package lib.shoot
{
	import flash.display.MovieClip
	import flash.display.Stage3D;
	import flash.events.Event;
	import flash.geom.Point;
	import flash.events.MouseEvent;
	import flash.media.Sound;
	import flash.ui.Keyboard;
	import flash.utils.getTimer;
	
	import fl.VirtualCamera;
	
	import lib.shoot.entity.*;
	import lib.shoot.level.Level;
	import lib.shoot.level.LevelDataInternal;
	import lib.shoot.level.Tile;
	import flash.display.Stage;
	
	public class ShootGame extends MovieClip
	{
		private var level:Level = new Level();
		
		private var interfaceElements:Array = new Array();
		
		// Framerate counter stuff
		private var timeStart:Number = 0;
		private var framesElasped:Number = 0;
		private var fpsCurrent:Number = 0;
		
		private var pauseScreen:PauseScreen;
		private var paused:Boolean = false;
		
		public function ShootGame()
		{
			// Event listeners
			this.addEventListener(Event.ENTER_FRAME, update);
			
			this.timeStart = getTimer();
			
			// Load level and initialize it
			this.level.load(LevelDataInternal.level1);
			this.restartLevel();
			
			Sounds.playSound(Sounds.music);
		}
		
		private function update(evt:Event):void
		{
			var doRestart:Boolean = false;
			
			CameraManager.update();
			
			// Set our position to the inverse of the Camera's position
			this.x = -CameraManager.getCameraPosition().x;
			this.y = -CameraManager.getCameraPosition().y;
			
			if(InputManager.isKeyPressed(Keyboard.ESCAPE))
			{
				if(this.paused)
				{
					Sounds.playSound(Sounds.unpause);
					this.interfaceElements.removeAt(this.interfaceElements.indexOf(this.pauseScreen));
					this.removeChild(this.pauseScreen);
					this.pauseScreen = null;
				}
				else
				{
					Sounds.playSound(Sounds.pause);
					this.pauseScreen = new PauseScreen();
					this.addChild(this.pauseScreen);
					this.interfaceElements.push(this.pauseScreen);
				}
				
				this.paused = !this.paused;
			}
			
			// Update level, adding and removing entities as specified by the level object
			if(this.level != null && !this.paused)
			{
				this.level.update();
				
				// Add entities
				for each(var entity:Entity in this.level.entitiesToAdd)
				{
					if(entity is EntityPlayer)
					{
						CameraManager.setEntityTracking(entity);
					}
					
					this.addChild(entity);
				}
				
				// Remove entities
				for each(entity in this.level.entitiesToRemove)
				{
					if(entity is EntityPlayer)
					{
						var deathFade:DeathFade = new DeathFade();
						this.addChild(deathFade);
						this.interfaceElements.push(deathFade);
					}
					
					this.removeChild(entity);
				}
				
				// Clear the entitiesToAdd and entitiesToRemove arrays
				this.level.entitiesToAdd.length = 0;
				this.level.entitiesToRemove.length = 0;
			}
			
			// Update interface elements
			for each(var interfaceElement:MovieClip in this.interfaceElements)
			{
				interfaceElement.x = CameraManager.getCameraPosition().x;
				interfaceElement.y = CameraManager.getCameraPosition().y;
				
				if(interfaceElement is HUD)
				{
					var hud:HUD = HUD(interfaceElement);
					
					// Update the HUD numbers if the camera is tracking something
					if(CameraManager.getEntityTracking() != null)
					{
						var healthPercentage:Number = Number(CameraManager.getEntityTracking().health) / Number(CameraManager.getEntityTracking().healthMax) * 100;

						hud.healthP1.gotoAndStop(100 - int(healthPercentage));
						hud.healthP1.textHealth.text = CameraManager.getEntityTracking().health + " HP, Score: " + CameraManager.getEntityTracking().score;
					}
				}
			}
			
			this.doDebugInfo();
			
			InputManager.updateForNext();
			
			// Update framerate
			var timeCurrent:Number = (getTimer() - this.timeStart) / 1000;
			this.framesElasped++;
			
			if(timeCurrent > 1)
			{
				this.fpsCurrent = this.framesElasped / timeCurrent;
				this.timeStart = getTimer();
				this.framesElasped = 0;
			}
		}
		
		public function restartLevel():void
		{
			// Start fresh
			this.removeChildren();
			this.interfaceElements.length = 0;
			
			// Add the level background
			var parallaxBackground:ParallaxBackground = new ParallaxBackground("ParallaxTest0", 0, 0, 0);
			this.addChild(parallaxBackground);
			
			var parallaxBackground2:ParallaxBackground = new ParallaxBackground("ParallaxTest1", 0.0025, 0, 0);
			this.addChild(parallaxBackground2);
			
			var parallaxBackground3:ParallaxBackground = new ParallaxBackground("ParallaxTest2", 0.01, 0, 0);
			this.addChild(parallaxBackground3);
			
			var parallaxBackground4:ParallaxBackground = new ParallaxBackground("ParallaxTest3", 0.035, 0, 0);
			this.addChild(parallaxBackground4);
			
			// Setup the level
			var tileMovieClips:Array = this.level.setupLevel();
			for each(var tile:MovieClip in tileMovieClips)
			{
				this.addChild(tile);
			}
			
			// Interface elements
			this.interfaceElements.push(new HUD());
			this.interfaceElements.push(DebugHelper.getInstance());
			this.interfaceElements.push(new CircleFade());
			
			for each(var interfaceElement:MovieClip in this.interfaceElements)
			{
				this.addChild(interfaceElement);
			}
			
			// Parallax backgrounds get pushed afterwards so they don't get added on top of anything else
			this.interfaceElements.push(parallaxBackground4);
			this.interfaceElements.push(parallaxBackground3);
			this.interfaceElements.push(parallaxBackground2);
			this.interfaceElements.push(parallaxBackground);
		}
		
		private function doDebugInfo():void
		{
			var debugText:String = "";
			
			// Toggle debug information
			if(InputManager.isKeyPressed(Keyboard.NUMBER_1) && GameSettings.enableDebugHotkeys)
			{
				GameSettings.enableDebugInfo = !GameSettings.enableDebugInfo;
			}
			
			// Toggle noclip
			if(InputManager.isKeyPressed(Keyboard.NUMBER_2) && GameSettings.enableDebugHotkeys && CameraManager.getEntityTracking() != null)
			{
				CameraManager.getEntityTracking().yVel = CameraManager.getEntityTracking().xVel = 0;
				GameSettings.enableNoclip = !GameSettings.enableNoclip;
				
				CameraManager.getEntityTracking().physicsCheckEntities = !GameSettings.enableNoclip;
				CameraManager.getEntityTracking().physicsCheckTiles = !GameSettings.enableNoclip;
				CameraManager.getEntityTracking().physicsDoGravity = !GameSettings.enableNoclip;
			}
			
			// Spawn a raccoon
			if(InputManager.isKeyPressed(Keyboard.NUMBER_3) && GameSettings.enableDebugHotkeys && CameraManager.getEntityTracking() != null)
			{
				var racc:Entity = new EntityEnemy1();
				racc.posX = CameraManager.getEntityTracking().posX + 64;
				racc.posY = CameraManager.getEntityTracking().posY;
				this.level.addEntity(racc);
			}
			
			// Suicide
			if(InputManager.isKeyPressed(Keyboard.NUMBER_4) && GameSettings.enableDebugHotkeys)
			{
				CameraManager.getEntityTracking().setDead();
			}
			
			if(GameSettings.enableNoclip)
			{
				CameraManager.getEntityTracking().xVel = 0;
				CameraManager.getEntityTracking().yVel = 0;
			}
			
			DebugHelper.clear();
			
			// Draw debug information on screen
			if(GameSettings.enableDebugInfo)
			{
				// Draw tile hitboxes
				for each(var quad:Quadrilateral in this.level.getTileHitboxes())
				{
					DebugHelper.drawQuadrilateral(quad, 0xFF0000, 1);
				}
				
				// Draw entity hitboxes
				for each(var entity in this.level.getEntities())
				{
					//if(entity.physicsEnabled)
					{
						// Draw bounding box and path collider
						DebugHelper.drawQuadrilateral(entity.getBoundingBox(), entity is EntityPlayer ? 0x00FF00 : 0x0000FF);
						DebugHelper.drawQuadrilateral(entity.getBoundingBoxPrev(), entity is EntityPlayer ? 0x00FF00 : 0x0000FF, 0.15);
						DebugHelper.drawQuadrilateral(Physics.entityGetPathCollision(entity), entity is EntityPlayer ? 0x00FF00 : 0x0000FF);
					}
				}
				
				// Update debug text
				debugText += "FPS: " + this.fpsCurrent.toFixed(0) + ", Entities: " + this.level.getEntities().length + ", Children: " + this.numChildren + "\n";
				
				if(CameraManager.getEntityTracking() != null)
				{
					var tempText:String = "" + CameraManager.getEntityTracking();
					debugText += "Tracking=" + tempText.substr(8, tempText.length - 1 - 8);
					tempText = "" + CameraManager.getEntityTracking().getState();
					tempText = tempText.substr(8, tempText.length - 1 - 8);
					debugText += ", State=" + tempText + "\n";
					
					debugText += "X: " + CameraManager.getEntityTracking().posX.toFixed(3) + ", Y: " + CameraManager.getEntityTracking().posY.toFixed(3) + ", Xvel: " + CameraManager.getEntityTracking().xVel.toFixed(3) + ", Yvel: " + CameraManager.getEntityTracking().yVel.toFixed(3) + "\n";
					debugText += "Facing: " + CameraManager.getEntityTracking().getDirection() + ", On ground: " + CameraManager.getEntityTracking().onGround + ", Invulnerable: " + CameraManager.getEntityTracking().isInvulnverable() + ", Dead: " + CameraManager.getEntityTracking().isDead + "\n";
				}
				else
				{
					debugText += "Camera tracking entity is null!\n";
				}
			}
			
			DebugHelper.setDebugTextLeft(debugText);
		}
	}
}