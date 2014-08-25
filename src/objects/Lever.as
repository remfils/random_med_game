package src.objects {

	import flash.display.MovieClip;
	import src.interfaces.ActiveObject;
	import src.Main;
	import flash.events.Event;

	public class Lever extends MovieClip implements ActiveObject {
		
		private var _collider:Collider;
		private var _activeArea:Collider;
		private var _active = true;
		
		private var testFun:Function;

		public function Lever () {
			_collider = getChildByName( "collider" ) as Collider ;
			_activeArea = getChildByName( "activeArea" ) as Collider ;
		}
		
		public function isActive ():Boolean {
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
				//dispatchEvent(new Event(Main.OBJECT_ACTIVATE_EVENT));
			}
		}
		
		public function positiveOutcome() {
			gotoAndPlay("open");
		}
		
		public function negativeOutcome() {
			gotoAndPlay("break");
		}
	}

}