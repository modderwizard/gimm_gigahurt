package lib.shoot
{	
	public class MathHelper
	{
		// 'Wraps' a value to the specified range. EX: Range = 0-360, Value = 361, Returns 1
		public static function wrap(value:Number, min:Number, max:Number):Number
		{
            var newValue:Number = value;

            while(newValue < min)
            {
                newValue += max;
            }
            while(newValue > max)
            {
                newValue -= max;
            }

            return newValue;
		}
		
		// 'Clamps' a value to the specified range. EX: Range = 0-20, Value = 35, Returns 20
		public static function clamp(value:Number, min:Number, max:Number):Number
        {
            return value < min ? min : value > max ? max : value;
        }
		
		// Moves a value towards zero at the specified change rate
		public static function moveTowardsZero(value:Number, change:Number):Number
        {
            var newValue:Number = value + ((value < 0) ? change : (value > 0) ? -change : 0);
			
			if((newValue <= 0 && value >= 0) || (newValue >= 0 && value <= 0))
			{
				newValue = 0;
			}
			
			return newValue;
        }
		
		// Returns true if the specified value is within the specified range
		public static function isInRange(value:Number, min:Number, max:Number, minInclusive:Boolean = true, maxInclusive:Boolean = true)
		{
			var fitsMin:Boolean = minInclusive ? value >= min : value > min;
			var fitsMax:Boolean = maxInclusive ? value <= max : value < max;
			
			return fitsMin && fitsMax;
		}
		
		// Returns true if the specified value is 'invalid' (+INFINITY, -INFINITY, NAN)
		public static function isNumberInvalid(value:Number):Boolean
		{
			return value == Number.POSITIVE_INFINITY || value == Number.NEGATIVE_INFINITY || isNaN(value);
		}
	}
}