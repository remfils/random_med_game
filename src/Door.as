package src {
	import flash.display.MovieClip;
	
	public class Door extends MovieClip implements GameObject {
		
		private var locked:Boolean = true;
		
		public var level:int;
		
		private var _collider:Collider;
		private var _exit:Collider;

		public function Door() {
			_exit = getChildByName("exit") as Collider;
			_collider = getChildByName("collider") as Collider;
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
		
		public function getExit ():Collider {
			return _exit;
		}
		
		public function checkExitCollision ( P:Player ): Boolean {
			return !locked && _exit.checkCollision( P.x, P.y );
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
