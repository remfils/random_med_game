package src.enemy {
    import Box2D.Dynamics.b2Body;
    import Box2D.Dynamics.b2BodyDef;
    import Box2D.Dynamics.b2World;
    import flash.display.MovieClip;
    import src.interfaces.GameObject;
    import src.util.Collider;
    import src.Player;
    
    public class Enemy extends MovieClip implements GameObject {
        var active:Boolean = false;
        var _collider:Collider;
        var player:Player;
        var px:Number;
        var py:Number;
        var agroDistance:Number = 150;
        var playerDistance:Number;

        public function Enemy():void {
            player = Player.getInstance();
            
            _collider = this.getChildByName("collider") as Collider;
            
            px = x;
            py = y;
        }
        
        public function update ():void {
            calculateDistanceToPlayer();
            
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
        // TODO: finish it
        public function createBodyFromCollider(world:b2World):b2Body {
            return new b2Body(new b2BodyDef(), world);
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
                dy = player.getYInRoom() - y;
            playerDistance = Math.sqrt(dx*dx + dy*dy);
        }

    }
    
}
