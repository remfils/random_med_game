package src{

	import flash.display.MovieClip;


	public class Lever extends MovieClip implements ActiveObject {
		
		private var _collider:Collider;
		private var _activeArea:Collider;
		
		private var _active = true;

		public function Lever () {
			_collider = getChildByName( "collider" ) as Collider ;
			_activeArea = getChildByName( "activeArea" ) as Collider ;
		}
		
		public function active ():Boolean {
			return _active;
		}
		
		public function update (){}
		
		public function getCollider ():Collider {
			return _collider;
		}
		
		public function getActiveArea () :Collider {
			return _activeArea;
		}
		
		public function positiveOutcome () {
			if ( _active ) {
				_active = false;
				gotoAndPlay ("open");
			}
		}
		
		public function negativeOutcome () {
			if ( _active ) {
				gotoAndPlay ("break");
				_active = false;
			}
		}
		
	}

}