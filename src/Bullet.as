package src {
	import flash.display.MovieClip;
	
	public class Bullet extends MovieClip {
		static var bullet:Bullet;
		var vx = 1, vy = 0;

		public function Bullet(InputRotation:Number) {
			
		}
		
		public function update() {
			x += vx;
			y += vy;
		}
		
		static public function getBullet():Bullet {
			if (!bullet) bullet = new Bullet(90);
			return bullet;
		}

	}
	
}
