package src.stat {
	
	import flash.display.MovieClip;
	
	
	public class PlayerStat extends MovieClip {
		public var current_theme = 1;
		
		public function PlayerStat() {
			gotoAndStop(current_theme);
		}
		
		public function swapMenuTheme(keyFrame:int) {
			gotoAndStop(keyFrame);
		}
		
		public function nextMenuTheme () {
			current_theme ++;
			if (current_theme == totalFrames) current_theme = 1;
			gotoAndStop( current_theme );
		}
	}
	
}
