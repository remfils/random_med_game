package src.objects {
    import Box2D.Dynamics.b2World;
    import flash.display.MovieClip;
    import src.interfaces.ActiveObject;
    import src.Main;
    import flash.events.Event;
    import src.util.Collider;
    import Box2D.Dynamics.b2Body;

    public class Lever extends TaskObject {
        private var _activeArea:Collider;
        
        private var testFun:Function;

        public function Lever (id:uint=1):void {
            super(id);
            _activeArea = getChildByName( "activeArea" ) as Collider ;
        }
        
        override public function getActiveArea ():Collider {
            return _activeArea;
        }
        
        override public function positiveOutcome():void {
            gotoAndPlay("open");
        }
        
        override public function negativeOutcome():void {
            gotoAndPlay("break");
        }
    }

}