package src.interfaces {
	import src.util.Collider;

	public interface ActiveObject extends GameObject {

		// Interface methods:
		function getActiveArea ():Collider;
		
		function positiveOutcome():void;
		
		function negativeOutcome():void;
	}

}