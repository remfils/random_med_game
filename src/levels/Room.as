package src.levels {
    import Box2D.Common.Math.b2Vec2;
    import Box2D.Dynamics.b2Body;
    import Box2D.Dynamics.b2DebugDraw;
    import Box2D.Dynamics.b2World;
    import flash.display.Sprite;
    import flash.display.Stage;
    import flash.display.MovieClip;
    import src.interfaces.ActiveGameObject;
    import src.objects.Lever;
    import src.util.Random;
    import src.interfaces.GameObject;
    import src.interfaces.ActiveObject;
    import src.objects.*;
    import src.events.RoomEvent;
    import src.util.Collider;
    import src.Game;
    import src.enemy.*;
    
    import src.Player;
    import flash.events.Event;
    import src.task.Task;
    
    public class Room extends MovieClip {
        protected static const directions:Array = ["left", "right", "up", "down"];

        public var world:b2World;
        private static var gravity:b2Vec2 = new b2Vec2(0, 0);
        protected var ROOM_FRICTION:Number = 8;
        
        var _doors:Array = new Array();
        
        var _enemies:Array = new Array();
        
        var _tasks:Array = new Array();
        var currentTask:Task = null;
        
        var finished:Boolean = true;
        static var _player:Player;
        private var playerBody:b2Body;
        
        private var activeAreas:Array=new Array();
        var i:int = 0;

        public function Room() {
            world = new b2World(gravity, true);
            world.SetContactListener(new ContactListener());
            
            _player = Player.getInstance();
            
            createPlayerBody();
            
            addWalls();
            
            addDoors();
            
            if (Game.TEST_MODE) setDebugDraw();
        }
        
        private function createPlayerBody():void {
            var collider:Collider = _player.getCollider().copy();
            
            playerBody = collider.replaceWithDynamicB2Body(world, Player.fixtureDef);
            
            playerBody.GetFixtureList().SetUserData( { "object": _player } );
            
            playerBody.SetPosition(new b2Vec2(300 / Game.WORLD_SCALE, 200 / Game.WORLD_SCALE));
            playerBody.SetLinearDamping(ROOM_FRICTION);
            playerBody.SetFixedRotation(true);
        }
        
        private function addWalls():void {
            i = 8;
            var collider:Collider = new Collider();
            while ( i-- ) {
                collider = getChildByName ( "wall" + i ) as Collider
                collider.replaceWithStaticB2Body(world);
            }
        }
        
        private function addDoors():void {
            var collider:Collider;
            for each ( var direction:String in directions) {
                var name:String = "door_collider_" + direction;
                collider = getChildByName(name) as Collider;
                var wall:b2Body = collider.replaceWithStaticB2Body(world);
                
                name = "exit_" + direction;
                collider = getChildByName(name) as Collider;
                var exit:b2Body = collider.replaceWithSensor(world);
                
                name = "door_" + direction;
                var door:Door = getChildByName(name) as Door;
                door.hide();
                door.setWall(wall);
                door.setExit(exit);
                
                exit.GetFixtureList().SetUserData( { 'object' : door } );
                
                _doors.push(door);
            }
        }
        
        private function setDebugDraw():void {
            var debugDraw:b2DebugDraw = new b2DebugDraw();
            debugDraw.SetSprite(Game.TestModePanel);
            debugDraw.SetDrawScale(Game.WORLD_SCALE);
            debugDraw.SetFillAlpha(0.3);
            debugDraw.SetAlpha(0.3);
            debugDraw.SetFlags(b2DebugDraw.e_shapeBit | b2DebugDraw.e_pairBit | b2DebugDraw.e_jointBit);
            
            world.SetDebugDraw(debugDraw);
        }
        
        public function init():void {
            playerBody.SetPosition(new b2Vec2(_player.x / Game.WORLD_SCALE, _player.y / Game.WORLD_SCALE));
            _player.setActorBody(playerBody);
            
            if ( hasTask() ) {
                lock();
            }
        }
        
        public function addPlayerToWorld():void {
            _player.getCollider();
        }
        
        public function addActiveObject(object:ActiveObject) {
            addChild(MovieClip(object));
            
            activeAreas.push(object.getActiveArea());
            
            //_gameObjects.push(object);
            
            object.createBodyFromCollider(world);
        }
        
        public function addEnenemy(object:Enemy) {
            _enemies.push(object);
            object.createBodyFromCollider(world);
            addChild(object);
            
            if ( object is FlyingEnemy ) {
                FlyingEnemy(object).setTarget(playerBody);
            }
            
            if (Game.TEST_MODE) trace("enemy added", object.x);
        }
        
        public function addObstacle(obstacle:Obstacle):void {
            addChild(obstacle);
            var o:b2Body = obstacle.createBodyFromCollider(world);
        }
        
        public function getGameObjects():Array {
            return new Array();
        }
        
        public function makeDoorWay (direction:String) {
            var door:Door = getDoorByDirection(direction);
            door.show();
            door.unlock();
        }
        
        public function getDoorByDirection(direction:String):Door {
            return getChildByName("door_" + direction) as Door;
        }
        
        public function update () {
            world.Step(Game.TIME_STEP, 5, 5);
            world.ClearForces();
            
            updateEnemies();
            
            
            if (Game.TEST_MODE) world.DrawDebugData();
        }
        
        private function updateEnemies() {
            var i = _enemies.length;
            while (i--) {
                _enemies[i].update();
            }
        }
        
        public function activateObjectNearPlayer():void {
            for each ( var activeArea:Collider in activeAreas ) {
                if ( activeArea.checkObjectCollision(_player.getCollider()) ) {
                    activeArea.parent.dispatchEvent(new Event("GUESS_EVENT"));
                    break;
                }
            }
        }
        
        public function hasTask():Boolean {
            return currentTask != null;
        }
        
        public function getCurrentActiveObject():ActiveObject {
            /*var i = activeAreas.length;
            
            while ( i-- ) {
                if ( activeAreas[i].checkCollision( _player.x, _player.y) ) {
                    return activeAreas[i].parent;
                }
            }*/
            
            return null;
        }
        
        public function completeCurrentTask (e:Event) {
            /*var object:ActiveObject = ActiveObject(e.target);
            
            var i = activeAreas.length;
            while (i--) {
                if ( object == _gameObjects[i] ) {
                    if ( i == currentTask.getAnswer() ) {
                        object.positiveOutcome();
                        currentTask = getNextTask();
                        unsubscribeGameObjects();
                        unlock();
                    }
                    else {
                        object.negativeOutcome();
                    }
                }
            }*/
        }
        
        private function getNextTask():Task {
            return _tasks.pop();
        }
        
        public function subscribeGameObjects() {
            /*var i = _gameObjects.length;
            while (i--) {
                _gameObjects[i].addEventListener(Game.OBJECT_ACTIVATE_EVENT, completeCurrentTask);
            }*/
        }
        
        public function unsubscribeGameObjects() {
            /*var i = _gameObjects.length;
            while (i--) {
                _gameObjects[i].removeEventListener(Game.OBJECT_ACTIVATE_EVENT, completeCurrentTask);
            }*/
        }
        
        public function lock () {
            var i=_doors.length;
            
            while ( i-- ) {
                _doors[i].lock ();
            }
        }
        
        public function unlock () {
            var i=_doors.length;

            while ( i-- ) {
                _doors[i].unlock ();
            }
        }
        
        public function setParameters (param:Object):void {
            if ( param.hasOwnProperty("type") ) {
                gotoAndStop(param.type);
            }
        }
        
        public function assignTask(task:Task) {
            currentTask = task;
            
            if ( currentTask == null ) unlock();
        }

    }
    
}
