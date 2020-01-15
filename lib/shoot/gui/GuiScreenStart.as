package lib.shoot.gui
{
	import flash.display.MovieClip;
	import flash.events.MouseEvent;
	
	import lib.shoot.ShootDoc;
	
	public dynamic class GuiScreenStart extends MovieClip implements GuiScreen
	{
		public function onOpening():void
		{
			this.buttonSingleplayer.addEventListener(MouseEvent.CLICK, onMouseClick);
			this.buttonSettings.addEventListener(MouseEvent.CLICK, onMouseClick);
			this.buttonCredits.addEventListener(MouseEvent.CLICK, onMouseClick);
		}
		
		public function onClosing():void
		{
			this.buttonSingleplayer.removeEventListener(MouseEvent.CLICK, onMouseClick);
			this.buttonSettings.removeEventListener(MouseEvent.CLICK, onMouseClick);
			this.buttonCredits.removeEventListener(MouseEvent.CLICK, onMouseClick);
		}
		
		public function onMouseClick(evt:MouseEvent):void
		{
			if(evt.target == this.buttonSingleplayer)
			{
				(this.parent as ShootDoc).startGame();
			}
			if(evt.target == this.buttonSettings)
			{
				(this.parent as ShootDoc).setScreen(new GuiScreenOptions());
			}
			if(evt.target == this.buttonCredits)
			{
				(this.parent as ShootDoc).setScreen(new GuiScreenCredits());
			}
		}
	}
}
