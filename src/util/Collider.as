package src.util {

    import Box2D.Collision.Shapes.b2PolygonShape;
    import Box2D.Dynamics.b2Body;
    import Box2D.Dynamics.b2BodyDef;
    import Box2D.Dynamics.b2Fixture;
    import Box2D.Dynamics.b2FixtureDef;
    import Box2D.Dynamics.b2World;
    import flash.display.MovieClip;
    import flash.geom.Point;
    import src.Game;
    import src.Main;
    import flash.display.DisplayObject;


    public class Collider extends MovieClip {
        public var unlocked:Boolean = true;
        
        protected var top_left:Point;
        protected var bottom_right:Point;

        //создаём коллайдер
        public function Collider () {
        }
        
        public function replaceWithB2Body(world:b2World):b2Body {
            var bodyDef:b2BodyDef = new b2BodyDef();
            bodyDef.position.Set( getGlobalX() / Game.WORLD_SCALE, getGlobalY() / Game.WORLD_SCALE);
            
            var shape:b2PolygonShape = new b2PolygonShape();
            shape.SetAsBox(width/2, height/2);
            
            var fixtureDef:b2FixtureDef = new b2FixtureDef();
            fixtureDef.shape = shape;
            
            var body:b2Body = world.CreateBody(bodyDef);
            body.CreateFixture(fixtureDef);
            
            parent.removeChild(this);
            
            return body;
        }

        // разблокирываем коллайдер
        public function unlock () {
            unlocked = false;
        }

        // блокируем коллайдер
        public function lock () {
            unlocked = true;
        }
        
        public function checkObjectCollision (O:DisplayObject):Boolean {
            return unlocked && this.hitTestObject(O);
        }

        // проверка столкновений
        public function checkCollision ( X:Number, Y:Number ):Boolean {
            return unlocked && this.hitTestPoint( X, Y );
        }
        
        public function getCollider ():Collider {
            return this;
        }
        
        public function getGlobalX():Number {
            return localToGlobal(new Point(0,0)).x;
        }
        
        public function getGlobalY():Number {
            return localToGlobal(new Point(0,0)).y;
        }

    }

}