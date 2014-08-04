package src.objects {
	
	import flash.display.MovieClip;
	import src.interfaces.GameObject;
	import src.Player;
	
	public class Door extends MovieClip implements GameObject {
		
		private var locked:Boolean = true;
		
		public var goto:int;
		
		public var level:int;
		
		private var _collider:Collider;
		private var _exit:Collider;

		public function Door() {
			_exit = getChildByName("exit") as Collider;
			_collider = getChildByName("collider") as Collider;
			
			show();
		}
		
		public function setDestination ( LEVEL:int ) {
			level = LEVEL;
		}
		
		public function getDirection ():String {
			var doorRotation = rotation;
			
			switch ( doorRotation ) {
				case 90:
					doorRotation = -90;
					break;
				case 180:
				case -180:
					doorRotation = 0;
					break;
				default:
					doorRotation += 180;
			}
			
			switch ( doorRotation ) {
				case   0: return "down";
				case  90: return "left";
				case -90: return "right";
				case 180: return "up";
				default: return "left";
			}
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

		public function unlock () {
			if ( visible ) {
				gotoAndPlay( "unlocked" );
				locked = false;
				_collider.unlock();
			}
		}
		
		public function hide () {
			visible = false;
		}
		
		public function show () {
			visible = true;
		}

	}
	
}
