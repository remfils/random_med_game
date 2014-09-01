package src.levels {
    import Box2D.Dynamics.b2ContactListener;
    import Box2D.Dynamics.Contacts.b2Contact;
    import flash.display.Sprite;
    import flash.events.Event;
    import src.Game;
	/**
     * ...
     * @author vlad
     */
    public class ContactListener extends b2ContactListener {
        
        public function ContactListener() {
            
        }
        
        override public function BeginContact(contact:b2Contact):void {
            super.BeginContact(contact);
            
            var userDataA:Object = contact.GetFixtureA().GetUserData();
            var userDataB:Object = contact.GetFixtureB().GetUserData();
            
            if ( userDataA == null  || userDataB == null) return;
            checkExitCollide(userDataA, userDataB);
        }
        
        private function checkExitCollide(userDataA:Object, userDataB:Object):void {
            var regexp:RegExp = new RegExp("door_.*");
            var name:String = userDataA.object.name as String;
            if ( regexp.test(name) ) {
                if ( Game.TEST_MODE ) trace("event dispathed");
                Sprite(userDataA.object).dispatchEvent(new Event("event_IS_UNTYPED"));
            }
            
            var name:String = userDataB.object.name as String;
            trace(name);
            if ( regexp.test(name) ) {
                if ( Game.TEST_MODE ) trace("event dispathed");
                 Sprite(userDataB.object).dispatchEvent(new Event("event_IS_UNTYPED"));
            }
        }
        
    }

}