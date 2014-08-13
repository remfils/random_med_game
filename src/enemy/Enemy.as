package src.enemy {
	import flash.display.MovieClip;
	import src.interfaces.GameObject;
	import src.util.Collider;
	import src.Player;
	
	public class Enemy extends MovieClip implements GameObject {
		var active:Boolean = false;
		var _collider:Collider;
		var player:Player;
		var px:Number;
		var py:Number;
		var agroDistance:Number = 300;
		var playerDistance:Number;

		public function Enemy() {
			player = Player.getInstance();
			
			_collider = this.getChildByName("collider") as Collider;
			
			px = x;
			py = y;
		}
		
		public function update () {
			calculatePlayerDistance();
			
			if ( !isActive() ){
				if ( agroDistance > playerDistance ) {
					activate();
				}
			}
			else {
				if ( agroDistance < playerDistance ) {
					deactivate();
				}
			}
			
			//if ( !isActive() ) return;
			
			var temp_coordinate:Number = x;
			x += (x - px) * 0.3;
			px = temp_coordinate;
			
			temp_coordinate = y;
			y += (y - py) * 0.3;
			py = temp_coordinate;
		}

		public function isActive ():Boolean {
			return active;
		}
		
		public function activate ():void {
			active = true;
		}
		
		public function deactivate():void {
			trace("enemy deactivated");
			active = false;
		}
		
		public function getCollider ():Collider {
			return _collider;
		}
		
		public function setPosition (X:Number, Y:Number) {
			x = px = X;
			y = py = Y;
		}
		
		protected function calculatePlayerDistance() {
			var dx = player.x - x,
				dy = player.y - y;
			playerDistance = Math.sqrt(dx*dx + dy*dy);
		}

	}
	
}
