package src.levels {
    import Box2D.Dynamics.b2ContactListener;
    import Box2D.Dynamics.Contacts.b2Contact;
    import flash.display.Sprite;
    import flash.events.Event;
    import src.enemy.Enemy;
    import src.events.RoomEvent;
    import src.Game;
    import src.objects.Door;
    import src.Player;
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
            
            checkPlayerEnemyCollision(userDataA, userDataB);
        }
        
        private function checkExitCollide(userDataA:Object, userDataB:Object):void {
            if ( userDataA.object is Door || userDataB.object is Door ) {
                if ( userDataA.object is Player ) {
                    Sprite(userDataA.object).dispatchEvent(new RoomEvent(RoomEvent.EXIT_ROOM_EVENT));
                }
                if ( userDataB.object is Player ) {
                    Sprite(userDataB.object).dispatchEvent(new RoomEvent(RoomEvent.EXIT_ROOM_EVENT));
                }
            }
        }
        
        private function checkPlayerEnemyCollision(userDataA:Object, userDataB:Object):void {
            if ( userDataA.object is Enemy || userDataB.object is Enemy ) {
                if ( userDataA.object is Player ) {
                    Player(userDataA.object).makeHit( Enemy(userDataB.object).damage );
                }
                
                if ( userDataB.object is Player ) {
                    Player(userDataB.object).makeHit( Enemy(userDataA.object).damage );
                }
            }
        }
        
    }

}