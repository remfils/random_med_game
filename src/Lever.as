package src{

	import flash.display.MovieClip;


	public class Lever extends MovieClip implements ActiveGameObject {
		
		private var _collider:Collider;
		private var _activeArea:Collider;

		public function Lever () {
			_collider = this.getChildByName( "collider" ) as Collider ;
			_activeArea = this.getChildByName( "activeArea" ) as Collider ;
		}
		
		public function active ():Boolean {
			return true;
		}
		
		public function update (){}
		
		public function getCollider ():Collider {
			return _collider;
		}
		
		public function getActiveArea () :Collider {
			return _activeArea;
		}
		
	}

}