package src.objects {

    import Box2D.Dynamics.b2Body;
    import Box2D.Dynamics.b2World;
	import flash.display.MovieClip;
	import src.interfaces.ActiveObject;
	import src.Main;
	import flash.events.Event;
    import src.util.Collider;

	public class Lever extends MovieClip implements ActiveObject {
        private var body:b2Body;
		private var _activeArea:Collider;
		private var _active = true;
		
		private var testFun:Function;

		public function Lever () {
			
			_activeArea = getChildByName( "activeArea" ) as Collider ;
		}
		
		public function isActive ():Boolean {
			return _active;
		}
		
		public function update () { }
        
        public function createBodyFromCollider (world:b2World):b2Body {
            var collider:Collider = getChildByName( "collider" ) as Collider ;
            body = collider.replaceWithStaticB2Body(world);
            return body;
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