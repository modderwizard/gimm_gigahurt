package lib.shoot.gui
{
	import flash.display.MovieClip;
	import flash.events.MouseEvent;

	import lib.shoot.Sounds;
	
	public class GuiButton extends MovieClip
	{
		public function GuiButton()
		{
			this.buttonMode = true;
			
			this.addEventListener(MouseEvent.MOUSE_OVER, onMouseEnter);
			this.addEventListener(MouseEvent.MOUSE_OUT, onMouseExit);
			
			this.addEventListener(MouseEvent.MOUSE_DOWN, onMouseDown);
			this.addEventListener(MouseEvent.MOUSE_UP, onMouseRelease);
		}
		
		private function onMouseEnter(evt:MouseEvent)
		{
			this.gotoAndPlay("HOVER_IN");
		}
		
		private function onMouseExit(evt:MouseEvent)
		{
			this.gotoAndPlay("HOVER_OUT");
		}
		
		private function onMouseDown(evt:MouseEvent)
		{
			this.gotoAndPlay("PRESSED");
		}
		
		private function onMouseRelease(evt:MouseEvent)
		{
			this.gotoAndPlay("HOVER");
			Sounds.playSound(Sounds.click);
		}
	}
}
