package src.enemy {
    import Box2D.Dynamics.b2Body;
    import Box2D.Dynamics.b2BodyDef;
    import Box2D.Dynamics.b2FixtureDef;
    import Box2D.Dynamics.b2World;
    import flash.display.MovieClip;
    import src.Game;
    import src.interfaces.GameObject;
    import src.util.Collider;
    import src.Player;
    
    public class Enemy extends MovieClip implements GameObject {
        public var damage:Number = 1;
        var active:Boolean = false;
        var _collider:Collider;
        var player:Player;
        var px:Number;
        var py:Number;
        var agroDistance:Number = 150;
        var playerDistance:Number;
        protected var body:b2Body;
        
        protected var enemyFixtureDefenition:b2FixtureDef;

        public function Enemy():void {
            player = Player.getInstance();
            
            enemyFixtureDefenition = new b2FixtureDef();
            enemyFixtureDefenition.density = 0.3;
            enemyFixtureDefenition.userData = {"object": this};
            
            _collider = this.getChildByName("collider") as Collider;
            
            px = x;
            py = y;
        }
        
        public function update ():void {
            calculateDistanceToPlayer();
            
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
        
        public function getCollider ():Collider {
            return _collider;
        }
        
        public function setPosition (X:Number, Y:Number):void {
            x = px = X;
            y = py = Y;
        }
        
        protected function calculateDistanceToPlayer():void {
            var dx = player.x - x,
                dy = player.y - y;
            playerDistance = Math.sqrt(dx*dx + dy*dy);
        }

    }
    
}
