package src.helpers {
	
	public class DoorLink {
		
		public var doorPosition:String;
		public var nextLevel:int;

		public function DoorLink( NAME:String, NL:int ) {
			nextLevel = NL;
			doorPosition = NAME;
		}

	}
	
}
