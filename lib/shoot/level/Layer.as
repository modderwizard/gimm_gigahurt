package lib.shoot.level
{
	import flash.display.MovieClip;	
	
	import lib.shoot.Config;
	import lib.shoot.CameraManager;
	import lib.shoot.Physics;
	import lib.shoot.Quadrilateral;
	import lib.shoot.entity.Entity;
	import lib.shoot.entity.EntityPlayer;
	
	public class Layer
	{
		private var width:int, height:int;
		
		private var loadTileData:Array = new Array();
		private var loadTileMetaData:Array = new Array();
		
		public function load(line:String):void
		{
			var lineSplit0:Array = line.split(",");
			
			for(var i:int = 0; i < lineSplit0.length; i++)
			{
				// Individual id/meta definition
				var lineSplit1:Array = lineSplit0[i].split("|");
				
				loadTileData.push(parseInt(lineSplit1[0]));
				loadTileMetaData.push(parseInt(lineSplit1[1]));
			}
		}
		
		public function getTileData():Array
		{
			return this.loadTileData;
		}
		
		public function getTileMetaData():Array
		{
			return this.loadTileMetaData;
		}
	}
}