package src.objects {

	import flash.display.MovieClip;
	import src.interfaces.ActiveObject;

	public class Lever extends MovieClip implements ActiveObject {
		
		private var _collider:Collider;
		private var _activeArea:Collider;
		private var _active = true;
		
		private var testFun:Function;

		public function Lever (fun:Function) {
			testFun = fun;
			
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
		
		public function getActiveArea ():Collider {
			return _activeArea;
		}
		
		public function setFun ( f:Function ) {
			testFun = f;
		}
		
		public function action () {
			if ( _active ) {
				if ( testFun () ) {
					gotoAndPlay("open");
				}
				else {
					gotoAndPlay("break");
				}
				
				_active = false;
			}
		}
	}

}