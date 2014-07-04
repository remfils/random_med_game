package src{

	public interface ActiveObject extends GameObject {

		// Interface methods:
		function getActiveArea ():Collider;
		
		function positiveOutcome ();
		
		function negativeOutcome ();
	}

}