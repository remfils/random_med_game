package src.levels {
	import flash.events.Event;
	
	public class LevelLoadedEvent extends Event {
		var _levels:Array;
		public var first_level:Object;

		public function LevelLoadedEvent(levels:Array, first_level) {
			super("LevelLoaded");
			_levels = levels;
			this.first_level = first_level;
		}
		
		public function getLevel():Array {
			return _levels;
		}

	}
	
}
