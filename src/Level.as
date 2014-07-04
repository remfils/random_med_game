package src {
	import flash.display.Stage;
	import flash.display.MovieClip;
	
	public class Level implements GameObject {
		var _activeAreas:Array = new Array();
		var _colliders:Array = new Array();
		
		var finished:Boolean = false;
		var _player:Player;

		public function Level( main:MovieClip, player:Player, gameObjectNames:Array ) {
			_player = player;
			
			// add gameObjects
			var i = gameObjectNames.length,
				A:ActiveObject = null;
			
			while ( i-- ) {
				A = main.getChildByName( gameObjectNames[i] ) as ActiveObject;
				
				_activeAreas.push ( A.getActiveArea () );
				_colliders.push ( A.getCollider () );
			}
		}
		
		public function update () {
			
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
