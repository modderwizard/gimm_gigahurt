package lib.shoot
{
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.utils.getDefinitionByName;

	public class ParallaxBackground extends MovieClip
	{
		// Three instances of the background
		public var bgLeft:MovieClip, bgCenter:MovieClip, bgRight:MovieClip;
		
		// Parallax scrolling speeds
		public var scrollSpeedHorizontal:Number, scrollSpeedVertical:Number;
		
		private var initialOffsetY:Number;
		
		// MovieClip unfortunately doesn't have any clone function. We pass the class name so we don't
		// have to manually pass three instances every time we create a ParallaxBackground instance.
		//
		// TODO: (?) ParallaxBackgroundMode.Wrap, ParallaxBackgroundMode.Clamp (?)
		//
		public function ParallaxBackground(className:String, scrollSpeedHorizontal:Number, scrollSpeedVertical:Number, initialOffsetY:Number)
		{
			var backgroundClass:Class = getDefinitionByName(className) as Class;
			
			// Init background instances
			this.bgCenter = new backgroundClass();
			this.bgLeft = new backgroundClass();
			this.bgRight = new backgroundClass();
			
			this.addChild(this.bgCenter);
			this.addChild(this.bgLeft);
			this.addChild(this.bgRight);
			
			this.scrollSpeedHorizontal = scrollSpeedHorizontal;
			this.scrollSpeedVertical = scrollSpeedVertical;
			
			this.initialOffsetY = initialOffsetY;
			
			this.addEventListener(Event.ENTER_FRAME, update);
		}
		
		public function update(evt:Event):void
		{
			// Calculate the background position from the camera position
			var cameraScrollHorizontal:Number = CameraManager.getCameraPosition().x % int(CameraManager.resWidth / this.scrollSpeedHorizontal);
			var cameraScrollVertical:Number = CameraManager.getCameraPosition().y;
			//var cameraScrollVertical:Number = CameraManager.getCameraPosition().y % int(224 / this.scrollSpeedVertical);
			
			// Apply the movement to the background
			this.bgCenter.x = -(cameraScrollHorizontal * this.scrollSpeedHorizontal);
			this.bgCenter.y = -(cameraScrollVertical * this.scrollSpeedVertical) + this.initialOffsetY;
			
			// Adjust the position of the two other instances based
			this.bgLeft.x = this.bgCenter.x - this.bgCenter.width;
			this.bgLeft.y = this.bgCenter.y;
			
			this.bgRight.x = this.bgCenter.x + this.bgCenter.width;
			this.bgRight.y = this.bgCenter.y;
		}
	}
}