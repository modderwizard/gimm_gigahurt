package lib.shoot
{
	import flash.media.Sound;
	import flash.media.SoundTransform;

	public class Sounds
	{
		public static const pause:Sound = new SoundPause();
		public static const unpause:Sound = new SoundUnpause();
		
		public static const hurt1:Sound = new SoundHurt1();
		public static const hurt2:Sound = new SoundHurt2();
		public static const hurtRaccoon:Sound = new SoundHurtRaccoon();
		public static const hurtRobot:Sound = new SoundHurtRobot();
		
		public static const powerup:Sound = new SoundPowerup();
		public static const explosion:Sound = new SoundExplosion();
		public static const shoot:Sound = new SoundShoot();
		
		public static const click:Sound = new SoundClick();
		
		public static const music:Sound = new SoundLevelMusic();
		
		public static function playSound(sound:Sound):void
		{
			if(GameSettings.enableSound)
			{
				var sndTrnsfrm:SoundTransform = new SoundTransform(0.5, 0);
				sound.play(0, 0, sndTrnsfrm);
			}
		}
	}
}
