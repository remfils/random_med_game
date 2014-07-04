package src {
	
	public class Level implement GameObject {
		var _activeAreas:Array = new Array();
		
		private var finished:Boolean = false;
		private var _player:Player;
		
		public function Level( player:Player ) {
			_player = player;
		}
		
		public function update () {}
		
		function active ():Boolean {
			return finished;
		}
		
		function getCollider ():Collider {
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
