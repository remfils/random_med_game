package src.objects {
    import Box2D.Common.Math.b2Vec2;
    import Box2D.Dynamics.b2FixtureDef;
    import Box2D.Dynamics.b2World;
    import Box2D.Dynamics.b2Body;
    import src.Game;
    import src.interfaces.GameObject;
    import src.util.Collider;
    public class DynamicObstacle extends Obstacle implements GameObject {
        private var fixtureDef:b2FixtureDef;
        private var body:b2Body;
        
        public function DynamicObstacle() {
            super();
            fixtureDef = new b2FixtureDef();
            fixtureDef.density = 10;
            fixtureDef.friction = 0.6;
        }
        
        override public function createBodyFromCollider(world:b2World):b2Body {
            var collider:Collider = getChildByName("collider001") as Collider;
            this.body = collider.replaceWithDynamicB2Body(world, fixtureDef);
            this.body.SetPosition(new b2Vec2( (x + collider.x) / Game.WORLD_SCALE, (y + collider.y) / Game.WORLD_SCALE));
            this.body.SetLinearDamping(5);
            return this.body;
        }
        
        public function update():void {
            x = body.GetPosition().x * Game.WORLD_SCALE;
            y = body.GetPosition().y * Game.WORLD_SCALE;
        }
        
        public function isActive():Boolean {
            return true;
        }
        
    }

}