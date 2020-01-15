package lib.shoot.entity.states
{
	import lib.shoot.entity.Entity;
	
	public interface State 
	{
		function update(entity:Entity, metadata:Object = null):void;
		function enter(entity:Entity, metadata:Object = null):void;
		function exit(entity:Entity, metadata:Object = null):void;
	}
}
