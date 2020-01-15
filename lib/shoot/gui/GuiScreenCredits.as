package lib.shoot.gui
{
	import flash.display.MovieClip;
	import flash.events.MouseEvent;
	
	import lib.shoot.CameraManager;
	import lib.shoot.GameSettings;
	import lib.shoot.MathHelper;
	import lib.shoot.ShootDoc;
	import lib.shoot.Sounds;
	
	public class GuiScreenCredits extends MovieClip implements GuiScreen
	{
		public function onOpening():void
		{
			this.buttonBackToTitle.addEventListener(MouseEvent.CLICK, onMouseClick);
		}
		
		public function onClosing():void
		{
			this.buttonBackToTitle.removeEventListener(MouseEvent.CLICK, onMouseClick);
		}
		
		private function onMouseClick(evt:MouseEvent):void
		{
			Sounds.playSound(Sounds.click);
			if(evt.target == this.buttonBackToTitle) // Return to title screen
			{
				(this.parent as ShootDoc).setScreen(new GuiScreenStart());
			}
		}
	}
}
