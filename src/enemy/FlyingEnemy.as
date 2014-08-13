package src.enemy {
	
	public class FlyingEnemy extends Enemy {
		var MAX_SPEED:Number = 3;
		
		public function FlyingEnemy() {
			super();
		}
		
		override public function update() {
			super.update();
			
			followPlayer();
		}
		
		private function followPlayer() {
			if (!isActive()) return;
			/*var k:Number = (player.y - py) / (player.x - px),
				b = -k * player.x + player.y;
				
			x = (-b+y+x/k)*k/(k*k+1);
			y = k*x + b;*/
			
			var dy = y - player.getYInRoom();
			y -= dy/Math.abs(dy)*MAX_SPEED;
			
			dy = x - player.x;
			x -= dy/Math.abs(dy)*MAX_SPEED;
		}
		
		override public function activate():void {
			super.activate();
			pushToPlayer();
		}
		
		private function pushToPlayer() {
			px = x;
			py = y;
			var temp_v:Number = MAX_SPEED / playerDistance;
			
			x += temp_v * ( -x + player.x );
			y += temp_v * ( -y + player.getYInRoom() );
		}
	}
	
}
