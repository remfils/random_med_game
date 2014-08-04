package src.stats {
	
	import flash.display.MovieClip;
	
	public class PlayerStat extends MovieClip {
		public var current_theme = 1;
		private var level_map;
		
		public function PlayerStat() {
			gotoAndStop(current_theme);
			level_map = Map(getChildByName("map"));
		}
		
		public function swapMenuTheme(keyFrame:int) {
			gotoAndStop(keyFrame);
		}
		
		public function nextMenuTheme () {
			current_theme ++;
			if (current_theme == totalFrames + 1) current_theme = 1;
			gotoAndStop( current_theme );
		}
		
		public function getMapMC ():Map {
			return level_map;
		}
	}
	
}
