package src {
	
	public class Spark extends Bullet {		
		public function Spark() {
			super(90);
		}
		
		static public function getBullet ():Bullet {
			if ( !bullet ) bullet = new Spark();
			return bullet;
		}
	}
	
}
