package src.enemy {
    import Box2D.Dynamics.b2Body;
    import Box2D.Dynamics.b2BodyDef;
    import Box2D.Dynamics.b2FixtureDef;
    import Box2D.Dynamics.b2World;
    import fl.motion.Color;
    import fl.motion.ColorMatrix;
    import flash.display.MovieClip;
    import flash.events.Event;
    import flash.filters.ColorMatrixFilter;
    import src.events.RoomEvent;
    import src.Game;
    import src.interfaces.GameObject;
    import src.levels.Room;
    import src.util.Collider;
    import src.Player;
    
    public class Enemy extends MovieClip implements GameObject {
        protected var health:Number = 100;
        public var damage:Number = 1;
        var agroDistance:Number = 150;
        
        public var killed:Boolean = false;
        var active:Boolean = false;
        
        public var body:b2Body;
        public var cRoom:Room;
        var player:Player;
        var playerDistance:Number;
        private var hitFrames:uint = 0;
        
        private static var hitColor:Color = new Color();
        
        protected var enemyFixtureDefenition:b2FixtureDef;

        public function Enemy():void {
            player = Player.getInstance();
            
            enemyFixtureDefenition = new b2FixtureDef();
            enemyFixtureDefenition.density = 0.3;
            enemyFixtureDefenition.userData = {"object": this};
        }
        
        public function update ():void {
            calculateDistanceToPlayer();
            if ( killed ) {
                destroy();
                return;
            }
            
            if ( hitFrames ) {
                hitFrames --;
                
                hitColor.setTint(0xff0000, 0.5);
                if ( hitFrames == 0 )
                    hitColor.setTint(0, 0);
                
                transform.colorTransform = hitColor;
            }
            
            x = body.GetPosition().x * Game.WORLD_SCALE;
            y = body.GetPosition().y * Game.WORLD_SCALE;
            
            if ( !isActive() ){
                if ( agroDistance > playerDistance ) {
                    activate();
                }
            }
            else {
                if ( agroDistance < playerDistance ) {
                    deactivate();
                }
            }
        }
        
        public function createBodyFromCollider(world:b2World):b2Body {
            var collider:Collider = getChildByName("collider001") as Collider;
            body = collider.replaceWithDynamicB2Body(world, enemyFixtureDefenition);
            return body;
        }

        public function isActive ():Boolean {
            return active;
        }
        
        public function activate ():void {
            active = true;
        }
        
        public function deactivate():void {
            active = false;
        }
        
        public function setPosition (X:Number, Y:Number):void {
            x = X;
            y = Y;
        }
        
        protected function calculateDistanceToPlayer():void {
            var dx = player.x - x,
                dy = player.y - y;
            playerDistance = Math.sqrt(dx*dx + dy*dy);
        }
        
        public function makeHit(damage:Number):void {
            health -= damage;
            
            hitFrames = 5;
            
            if ( health <= 0 ) {
                killed = true;
            }
        }
        
        protected function destroy():void {
            dispatchEvent(new RoomEvent(RoomEvent.ENEMY_KILL_EVENT));
        }

    }
    
}
