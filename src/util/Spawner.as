package src.util {

	// this is usseless
	// should be deleted soon

	import flash.display.MovieClip;
	import flash.geom.Point;


	public class Spawner extends Collider {
		private var frame = 0;

		private var spawn_point:Point;

		public function Spawner () {
			visible = false;

			spawn_point = new Point (  );
		}

		public function setSpawner (FRAME:Number) {
			frame = FRAME;
		}

		public function checkPlayer ( P:Player ):Boolean {
			return hitTestPoint ( P.x, P.y );
		}

		public function spawnPlayer ( P:Player ) {
			P.move ( this.x, this.y - 50 );
		}

		public function setPlayerPosition (P:Player) {
			P.move (this.x, this.y - 50);
		}
	}

}