package src.levels {
    import Box2D.Common.Math.b2Vec2;
    import Box2D.Dynamics.b2Body;
    import Box2D.Dynamics.b2DebugDraw;
    import Box2D.Dynamics.b2World;
    import flash.display.DisplayObject;
    import flash.display.Sprite;
    import flash.display.Stage;
    import flash.display.MovieClip;
    import src.objects.Lever;
    import src.task.TaskManager;
    import src.util.GameObjectPanel;
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
        public static var taskManager:TaskManager;

        public var game:Game;
        
        public var world:b2World;
        private static var gravity:b2Vec2 = new b2Vec2(0, 0);
        protected var ROOM_FRICTION:Number = 8;
        
        var _doors:Array = new Array();
        var _gameObjects:Array = new Array();
        var _enemies:Array = new Array();
        
        var _tasks:Array = new Array();
        var currentTask:Task = null;
        
        static var _player:Player;
        private var playerBody:b2Body;
        private var gameObjectPanel:GameObjectPanel;
        
        private var activeAreas:Array=new Array();

        public function Room(game:Game) {
            this.game = game;
            
            world = new b2World(gravity, true);
            world.SetContactListener(new ContactListener(game));
            gameObjectPanel = new GameObjectPanel();
            addChild(gameObjectPanel);
            
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
            var i = 8;
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
                
                name = "door_" + direction;
                var door:Door = getChildByName(name) as Door;
                door.hide();
                door.setWall(wall);
                
                var exit:b2Body = collider.replaceWithSensor(world, { 'object' : door });
                door.setExit(exit);
                
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
        
        override public function addChild(child:DisplayObject):DisplayObject {
            var obj:DisplayObject = super.addChild(child);
            setChildIndex(gameObjectPanel, numChildren - 1);
            return obj;
        }
        
        public function init():void {
            playerBody.SetPosition(new b2Vec2(_player.x / Game.WORLD_SCALE, _player.y / Game.WORLD_SCALE));
            _player.setActorBody(playerBody);
            gameObjectPanel.addChild(_player);
            
            addEventListener("GUESS_EVENT", taskManager.guessEventListener, true);
            addEventListener(RoomEvent.ENEMY_KILL_EVENT, killEnemy, true);
            
            if ( hasTask() ) {
                lock();
            }
        }
        
        public function addPlayerToWorld():void {
            _player.getCollider();
        }
        
        public function addActiveObject(object:ActiveObject) {
            gameObjectPanel.addChild(object as DisplayObject);
            
            activeAreas.push(object.getActiveArea());
            
            //_gameObjects.push(object);
            
            object.createBodyFromCollider(world);
        }
        
        public function addEnenemy(object:Enemy) {
            _enemies.push(object);
            object.createBodyFromCollider(world);
            gameObjectPanel.addChild(object);
            
            if ( object is FlyingEnemy ) {
                FlyingEnemy(object).setTarget(playerBody);
            }
            
            if (Game.TEST_MODE) trace("enemy added", object.x);
        }
        
        public function removeEnemy(enemy:Enemy):void {
            var i = _enemies.length;
            while ( i-- ) {
                if ( _enemies[i] == enemy ) {
                    _enemies.splice(i, 1);
                    break;
                }
            }
        }
        
        public function killEnemy(e:RoomEvent):void {
            var enemy:Enemy = e.target as Enemy;
            gameObjectPanel.removeChild(enemy);
            world.DestroyBody(enemy.body);
            removeEnemy(enemy)
        }
        
        public function addObstacle(obstacle:Obstacle):void {
            if ( obstacle is GameObject ) {
                _gameObjects.push(obstacle);
                gameObjectPanel.addChild(obstacle);
            }
            else {
                addChild(obstacle);
            }
            
            var o:b2Body = obstacle.createBodyFromCollider(world);
        }
        // delete me in GlassPanel
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
            
            updateGameObjects();
            
            gameObjectPanel.update();
            
            if (Game.TEST_MODE) world.DrawDebugData();
        }
        
        private function updateEnemies() {
            var i = _enemies.length;
            while (i--) {
                _enemies[i].update();
            }
        }
        
        private function updateGameObjects():void {
            var i = _gameObjects.length;
            while ( i-- ) {
                _gameObjects[i].update();
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
        
        public function exit():void {
            removeEventListener("GUESS_EVENT", taskManager.guessEventListener, true);
            removeEventListener(RoomEvent.ENEMY_KILL_EVENT, killEnemy, true);
        }

    }
    
}
