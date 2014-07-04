package src {
	import flash.display.MovieClip;
	
	public class Door extends MovieClip implements GameObject {
		
		private var locked:Boolean = true;
		
		public var level:int;
		
		private var _collider:Collider;
		private var _spawner:Collider;

		public function Door() {
			_spawner = this.getChildByName("spawner") as Collider;
			_collider = this.getChildByName("collider") as Collider;
		}
		
		public function setDestination ( LEVEL:int ) {
			level = LEVEL;
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
		
		public function checkSpawner ( P:Player ): Boolean {
			return !locked && _spawner.checkCollision( P.x, P.y );
		}
		
		public function lock ():void {
			gotoAndPlay( "locked" );
			locked = true;
			
			_collider.lock();
		}

		public function unlock ():void {
			gotoAndPlay( "unlocked" );
			locked = false;
			
			_collider.unlock();
		}

	}
	
}
