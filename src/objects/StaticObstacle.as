package src.objects {
    import Box2D.Dynamics.b2Body;
    import Box2D.Dynamics.b2World;
    import flash.display.MovieClip;
    import flash.display.Sprite;
    import src.util.Collider;
	/**
     * ...
     * @author vlad
     */
    public class StaticObstacle extends MovieClip {
        
        public function StaticObstacle() {
            
        }
        
        public function createBodyFromCollider(world:b2World):b2Body {
            var collider:Collider = getChildByName("collider") as Collider;
            return collider.replaceWithStaticB2Body(world);
        }
    }

}