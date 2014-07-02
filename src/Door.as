package src {
	import flash.display.MovieClip;
	
	public class Door extends MovieClip implements GameObject {
		
		private var locked:Boolean = true;
		
		private var _collider:Collider;
		private var _spawner:Collider;

		public function Door() {
			_spawner = this.getChildByName("spawner") as Collider;
			_collider = this.getChildByName("collider") as Collider;
		}
		
		// gameobjct methods
		public function active ():Boolean {
			return locked;
		}
		
		public function update () {
			
		}
		
		public function getCollider () : Collider {
			return _collider;
		}
		
		public function checkSloppyCollision ( P:Player ):Boolean {
			return locked && _collider.checkSloppyCollision( P );
		}
		
		public function checkCollision ( P:Player ) {
			return locked && _collider.checkCollision( P );
		}
		
		public function checkSpawner ( P:Player ): Boolean {
			return !locked && _spawner.checkSloppyCollision( P );
		}

		public function unlock ():void {
			gotoAndPlay( "unlocked" );
			locked = false;
		}

	}
	
}
