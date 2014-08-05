package src.levels {
	import flash.events.Event;
	
	public class LevelLoadedEvent extends Event {
		var _levels:Array;

		public function LevelLoadedEvent(levels:Array) {
			super("LevelLoaded");
			_levels = levels;
		}
		
		public function getLevel():Array {
			return _levels;
		}

	}
	
}
