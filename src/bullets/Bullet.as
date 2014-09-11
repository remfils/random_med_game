package src.bullets {
    import Box2D.Common.Math.b2Vec2;
    import Box2D.Dynamics.b2Body;
    import Box2D.Dynamics.b2BodyDef;
    import Box2D.Dynamics.b2FixtureDef;
    import Box2D.Dynamics.b2World;
    import flash.display.MovieClip;
    import src.Game;
    import src.interfaces.GameObject;
    import src.util.Collider;
    
    public class Bullet extends MovieClip implements GameObject {
        public var speed:Number = 10;
        static public const DELAY:Number = 500;
        
        protected var body:b2Body;
        
        private var active = true;

        public function Bullet() {
            
        }
        
        public function createBodyFromCollider(world:b2World):b2Body {
            var collider:Collider = getChildByName("collider001") as Collider;
            
            var fixtureDef:b2FixtureDef = new b2FixtureDef();
            fixtureDef.userData = { "object": this };
            fixtureDef.density = 1;
            fixtureDef.friction = 0;
            fixtureDef.restitution = 0;
            
            body = collider.replaceWithDynamicB2Body(world, fixtureDef);
            body.SetBullet(true);
            
            return body;
        }
        
        public function setSpeedDirection(dir_x:Number, dir_y:Number):void {
            body.SetLinearVelocity(new b2Vec2(dir_x * speed, dir_y * speed));
        }
        
        public function update():void {
            if (currentFrame == totalFrames) deactivate();
            if (!active) return;
            
            x = body.GetPosition().x * Game.WORLD_SCALE;
            y = body.GetPosition().y * Game.WORLD_SCALE;
        }
        
        public function disableMovement():void {
             body.SetActive(false);
        }
        
        public function activate():void {
            active = true;
            updateActiveState();
        }
        
        public function deactivate():void {
            active = false;
            updateActiveState();
        }
        
        private function updateActiveState():void {
            body.SetActive(active);
            visible = active;
        }
        
        public function isActive():Boolean {
            return active;
        }
        
        public function moveTo(X:Number, Y:Number):void {
            this.x = X;
            this.y = Y;
            body.SetPosition(new b2Vec2(X / Game.WORLD_SCALE, Y / Game.WORLD_SCALE));
        }

    }
    
}
