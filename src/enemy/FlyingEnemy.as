package src.enemy {
	
	public class FlyingEnemy extends Enemy {
		
		
		public function FlyingEnemy() {
			super();
		}
		
		override public function update() {
			super.update();
			
			followPlayer();
		}
		
		private function followPlayer() {
			var k:Number = (player.x - py) / (player.x - px),
				b = -k * player.x + player.y;
				
			x = b/(2*k) + x/2 +y;
			y = k*x + b;
		}
	}
	
}
