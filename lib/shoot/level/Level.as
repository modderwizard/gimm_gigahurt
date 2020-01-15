package lib.shoot.level
{
	import flash.display.MovieClip;	
	
	import lib.shoot.Config;
	import lib.shoot.CameraManager;
	import lib.shoot.Physics;
	import lib.shoot.Quadrilateral;
	import lib.shoot.entity.Entity;
	import lib.shoot.entity.EntityPlayer;
	
	import fl.Layer;
	
	public class Level
	{
		private var width:int, height:int;
		
		private var layerBackground:Layer;
		private var layerDefault:Layer;
		
		private var loadEntityData:Array;
		private var loadEntityMetaData:Array;
		private var loadCollisionData:Array;
		
		private var entities:Array = new Array();
		public var entitiesToAdd:Array = new Array();
		public var entitiesToRemove:Array = new Array();
		private var tileHitboxes:Array = new Array();
		private var emptyArray:Array = new Array();
		
		public function update():void
		{
			for each(var entity:Entity in this.entities)
			{
				if(entity.canRemove)
				{
					this.entities.removeAt(this.entities.indexOf(entity));
					this.entitiesToRemove.push(entity);
				}
				else
				{
					entity.update();
					
					//if(entity is EntityPlayer)
					{
						Physics.entityUpdatePhysics(entity, this.tileHitboxes, this.entities);
					}
					
					if(entity.posX < -9500 || entity.posX > 9500 || entity.posY < -9500 || entity.posY > 9500)
					{
						entity.setDead();
					}
				}
			}
		}
		
		public function load(fileLines:Array):void
		{
			var config:Config = new Config(fileLines);
			config.load();
			
			// Load level size
			this.width = parseInt(config.getValue("Width"));
			this.height = parseInt(config.getValue("Height"));
			
			// Set up the loaded data arrays
			this.loadEntityData = new Array(this.width * this.height);
			this.loadEntityMetaData = new Array(this.width * this.height);
			this.loadCollisionData = new Array(this.width * this.height);
			
			// Load stuff from file
			var entityDataArray:Array = config.getValue("EntityData").split(",");
			var entityMetaDataArray:Array = config.getValue("EntityMetaData").split(",");
			var collisionDataArray:Array = config.getValue("CollisionData").split(",");
			
			// Convert the string data into it's correct type
			for(var i:int = 0; i < entityDataArray.length; i++)
			{
				this.loadEntityData[i] = null;
				if(entityDataArray[i] != "")
				{
					this.loadEntityData[i] = entityDataArray[i];
				}
				
				this.loadEntityMetaData[i] = parseInt(entityMetaDataArray[i]);
				
				this.loadCollisionData[i] = collisionDataArray[i] == "True";
			}
			
			// Load background layer
			this.layerBackground = new Layer();
			this.layerBackground.load(config.getValue("Layer_Background"));
			
			// Load default layer
			this.layerDefault = new Layer();
			this.layerDefault.load(config.getValue("Layer_Default"));
		}
		
		private function setupLayer(layer:Layer, tileMovieClips:Array, firstTime:Boolean)
		{
			for(var i:int = 0; i < layer.getTileData().length; i++)
			{					
				var gridX:int = this.indexToX(i);
				var gridY:int = this.indexToY(i);
				
				if(layer.getTileData()[i] != 0 && firstTime)
				{
					var tileInstance:MovieClip = (TileEntry.tileEntries[layer.getTileData()[i]] as TileEntry).createInstance();
					tileInstance.gotoAndStop(layer.getTileMetaData()[i] + 1);
					tileInstance.x = gridX * 24;
					tileInstance.y = gridY * 24;
					
					tileMovieClips.push(tileInstance);
				}
			}
		}
		
		public function setupLevel(firstTime:Boolean = true):Array
		{
			// Clear the arrays first
			this.entities.length = 0;
			this.entitiesToAdd.length = 0;
			this.entitiesToRemove.length = 0;
			this.tileHitboxes.length = 0;
			
			var tileMovieClips:Array = new Array();
			
			this.setupLayer(this.layerBackground, tileMovieClips, firstTime);
			this.setupLayer(this.layerDefault, tileMovieClips, firstTime);
			
			for(var i:int = 0; i < this.loadEntityData.length; i++)
			{					
				var gridX:int = this.indexToX(i);
				var gridY:int = this.indexToY(i);
				
				if(this.loadEntityData[i] != null)
				{
					var entityInstance:Entity = (EntityEntry.entityEntries[this.loadEntityData[i]] as EntityEntry).createInstance();
					(entityInstance as MovieClip).x = gridX * 24;
					(entityInstance as MovieClip).y = gridY * 24;
					entityInstance.setDirection(this.loadEntityMetaData[i]);
					
					// TODO: Fix the level editor so it doesn't save invalid metadata for entities. This is a quick fix.
					entityInstance.setDirection(entityInstance.getDirection() == 0 ? 1 : entityInstance.getDirection());
					
					entityInstance.posX = gridX * 24;
					entityInstance.posY = gridY * 24;
					
					entityInstance.posY -= entityInstance.getBoundingBox().height;
					entityInstance.posY += 24;
					
					if(entityInstance is EntityPlayer)
					{
						CameraManager.setEntityTracking(entityInstance);
					}
					
					this.addEntity(entityInstance);
				}
				
				if(this.loadCollisionData[i])
				{
					var collider:Quadrilateral = new Quadrilateral().fromPositionAndSize(gridX * 24, gridY * 24, 24, 24);
					this.tileHitboxes.push(collider);
					
					// If there is a block on a side of a quad, disable collision for that side
					if(gridX > 0 && this.loadCollisionData[this.xyToIndex(gridX - 1, gridY)] != false)
					{
						collider.leftLineEnabled = false;
					}
					if(gridX < this.width && this.loadCollisionData[this.xyToIndex(gridX + 1, gridY)] != false)
					{
						collider.rightLineEnabled = false;
					}
					if(gridY > 0 && this.loadCollisionData[this.xyToIndex(gridX, gridY - 1)] != false)
					{
						collider.topLineEnabled = false;
					}
					if(gridY < this.height && this.loadCollisionData[this.xyToIndex(gridX, gridY + 1)] != false)
					{
						collider.bottomLineEnabled = false;
					}
				}
			}
			
			return tileMovieClips;
		}
		
		private function indexToX(index:int):int
		{
			return index % this.width;
		}
		
		private function indexToY(index:int):int
		{
			return index / this.width;
		}
		
		private function xyToIndex(x:int, y:int):int
		{
			return y * this.width + x;
		}
		
		public function addEntity(entity:Entity)
		{
			entity.level = this;
			this.entities.push(entity);
			this.entitiesToAdd.push(entity);
		}
		
		public function getEntities():Array
		{
			return this.entities;
		}
		
		public function getTileHitboxes():Array
		{
			return this.tileHitboxes;
		}
	}
}