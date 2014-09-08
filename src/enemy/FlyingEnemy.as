﻿package src.enemy {
	
	public class FlyingEnemy extends Enemy {
		var MAX_SPEED:Number = 1;
		var FRICTION:Number = 1;
		var ERROR:Number = 0.5;
		
		public function FlyingEnemy() {
			super();
		}
		
		override public function update():void {
			super.update();
			
			agroDistance = 400;
			
			moveEnemy();
			
			followPlayer();
		}
		
		private function moveEnemy () {
			
			var temp_coordinate:Number = x;
			x += (x - px) * FRICTION;
			px = temp_coordinate;
			
			temp_coordinate = y;
			y += (y - py) * FRICTION;
			py = temp_coordinate;
		}
		
		private function followPlayer() {
			if (!isActive()) return;
			/*var k:Number = (player.y - py) / (player.x - px),
				b = -k * player.x + player.y;
				
			x = (-b+y+x/k)*k/(k*k+1);
			y = k*x + b;*/
			
			var dy = y - player.getYInRoom();
			y -= dy/Math.abs(dy) * MAX_SPEED * ERROR;
			
			dy = x - player.x;
			x -= dy/Math.abs(dy) * MAX_SPEED * ERROR;
		}
		
		override public function activate():void {
			super.activate();
			FRICTION = 1;
			pushToPlayer();
		}
		
		override public function deactivate():void {
			super.deactivate();
			FRICTION = 0.9;
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
