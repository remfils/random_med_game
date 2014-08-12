package src.enemy {
	import flash.display.MovieClip;
	import src.interfaces.GameObject;
	import src.util.Collider;
	import src.Player;
	
	public class Enemy extends MovieClip implements GameObject {
		var active:Boolean = true;
		var _collider:Collider;
		var player:Player;
		var px:Number;
		var py:Number;

		public function Enemy() {
			player = Player.getInstance();
			
			_collider = this.getChildByName("collider") as Collider;
			
			px = x;
			py = y;
		}
		
		public function update () {
			var temp_coordinate:Number = x;
			x += x - px;
			px = temp_coordinate;
			
			temp_coordinate = y;
			y += y - py;
			px = temp_coordinate;
		}

		public function isActive ():Boolean {
			return active;
		}
		
		public function getCollider ():Collider {
			return _collider;
		}

	}
	
}
