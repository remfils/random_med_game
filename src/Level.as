package src {
	import flash.display.Stage;
	import flash.display.MovieClip;
	
	public class Level extends MovieClip implements GameObject {
		var _activeAreas:Array = new Array();
		var _colliders:Array = new Array();
		var _doors:Array = new Array();
		
		
		var finished:Boolean = false;
		var _player:Player;

		public function Level( player:Player ) {
			// player
			_player = player;
			
			// walls
			
		}
		
		public function update () {
			
		}
		
		public function checkCollisions ( X:Number, Y:Number ):Collider {
			var i=_activeAreas.length;
			while ( i-- ) {
				if ( _activeColliders[i].checkCollision ( X, Y ) ) {
					return  _activeColliders[i];
				}
			}
			
			return null;
		}
		
		public function active():Boolean {
			return finished;
		}
		
		public function getCollider ():Collider {
			return null;
		}
		
		public function addObject ( A:ActiveObject ) {
			_activeAreas.push ( A.getActiveArea() );
			_colliders.push ( A.getCollider() );
		}
		
		
		public function negativeOutcome ( A:ActiveObject ) {
			A.negativeOutcome ();
			// обработка результатов здесь
		}
		
		public function positimeOutcome ( A:ActiveObject ) {
			A.positiveOutcome ();
		}

	}
	
}
