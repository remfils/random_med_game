package src {
	import flash.display.MovieClip;
	
	public class Bullet extends MovieClip {
		public const SPEED:Number = 10;
		static public const DELAY:Number = 500;
		
		private var vx = 1;
		private var vy = 0;

		public function Bullet() {
			
		}
		
		public function update() {
			x += vx;
			y += vy;
		}
		
		public function setSpeed (dx:Number, dy:Number) {
			vx = SPEED * dx;
			vy = SPEED * dy;
		}

	}
	
}
