package src.objects {
    import Box2D.Common.Math.b2Vec2;
    import Box2D.Dynamics.b2Body;
    import Box2D.Dynamics.b2BodyDef;
    import Box2D.Dynamics.b2World;
    import flash.display.MovieClip;
    import src.Game;
    import src.util.Collider;
	/**
     * ...
     * @author vlad
     */
    public class Obstacle extends MovieClip {
        
        public function Obstacle() {
            
        }
        
        public function createBodyFromCollider(world:b2World):b2Body {
            var col:Collider = getChildByName("collider001") as Collider;
            var body:b2Body = col.replaceWithStaticB2Body(world);
            body.SetPosition(new b2Vec2( (x + col.x) / Game.WORLD_SCALE, (y + col.y) / Game.WORLD_SCALE));
            return body;
        }
        
    }

}