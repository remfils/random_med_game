package src.levels {
    import Box2D.Common.Math.b2Vec2;
    import Box2D.Dynamics.b2DebugDraw;
    import Box2D.Dynamics.b2World;
    import flash.display.Sprite;
	import flash.display.Stage;
	import flash.display.MovieClip;
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
        private var world:b2World;
        private static var gravity:b2Vec2 = new b2Vec2(0, 0);
        
		var _gameObjects:Array = new Array();
		var _activeAreas:Array = new Array();
		var _colliders:Array = new Array();
		var _doors:Array = new Array();
		var _exits:Array = new Array();
		
		var _enemies:Array = new Array();
		
		var _tasks:Array = new Array();
		var currentTask:Task = null;
		
		var finished:Boolean = true;
		var _player:Player;
		var i:int = 0;
		
		var endLevel:Function;

		public function Room() {
			// adding stuff ti level
            world = new b2World(gravity, true);

			// player
			_player = Player.getInstance();
			
			// walls
			i = 8;
            var collider:Collider = new Collider();
			while ( i-- ) {
                collider = getChildByName ( "wall" + i ) as Collider
				collider.replaceWithB2Body(world);
			}
			
			// doors
			var door:Door = null;
			i = 4;
			while ( i-- ) {
				door = getChildByName ( "door" + i ) as Door ;
				door.hide();
				
				_doors.push( door );
				_colliders.push( door.getCollider() );
				_exits.push ( door.getExit() );
			}
            if (Game.TEST_MODE) setDebugDraw();
		}
        
        private function setDebugDraw():void {
            var debugSprite:Sprite = new Sprite();
            
            var debugDraw:b2DebugDraw = new b2DebugDraw();
            debugDraw.SetSprite(debugSprite);
            debugDraw.SetDrawScale(Game.WORLD_SCALE);
            
            world.SetDebugDraw(debugDraw);
            addChild(debugSprite);
        }
		
		public function addActiveObject(object:ActiveObject) {
			_activeAreas.push(object.getActiveArea());
			_colliders.push(object.getCollider());
			
			_gameObjects.push(object);
			
			addChild(MovieClip(object));
		}
		
		public function addTask(type:String) {
			_tasks.push(currentTask);
			currentTask = new Task(type);
		}
		
		public function addEnenemy(object:Enemy) {
			_enemies.push(object);
			_colliders.push(object.getCollider());
			addChild(object as FlyingEnemy);
			trace("enemy added", object.x);
		}
		
		public function getGameObjects():Array {
			return _gameObjects;
		}
		
		public function getDoor(dir:String):Door {
			switch ( dir ) {
				case "left" :
					return _doors[0];
				case "right" :
					return _doors[2];
				case "up" :
					return _doors[3];
				case "down" :
					return _doors[1];
				default:
					return null;
			}
		}
		
		public function makeDoorWay (wallName:String) {
			switch ( wallName ) {
				case "left" :
					_doors[0].show();
					_doors[0].unlock();
					break;
				case "right" :
					_doors[2].show();
					_doors[2].unlock();
					break;
				case "up" :
					_doors[3].show();
					_doors[3].unlock();
					break;
				case "down" :
					_doors[1].show();
					_doors[1].unlock();
					break;
			}
		}
		
		public function update () {
            world.Step(Game.TIME_STEP, 5, 5);

			updateEnemies();
            
			
			checkCollisions();
			
			if ( isThereTasks() ) {
				checkExitsCollision();
			}
            
            if (Game.TEST_MODE) world.DrawDebugData();
		}
		
		private function updateEnemies() {
			var i = _enemies.length;
			while (i--) {
				_enemies[i].update();
			}
		}
		
		public function checkCollisions () {
			
			var i = _colliders.length;
			while ( i-- ) {
				if ( _colliders[i].checkObjectCollision ( _player.getCollider() ) ) {
					_player.push(_colliders[i]);
				}
			}
			
		}
		
		private function isThereTasks():Boolean {
			return currentTask == null;
		}
		
		private function checkExitsCollision() {
			i = _exits.length;
			while (i--) {
				if ( _exits[i].checkCollision(_player.x, _player.y) ) {
					dispatchEvent(new Event(Game.EXIT_ROOM_EVENT));
				}
			}
		}
		
		public function checkCollision (X:Number, Y:Number):Boolean {
			var i = _colliders.length;
			while ( i-- ) {
				if ( _colliders[i].checkCollision ( X, Y ) ) {
					return true;
				}
			}
			return false;
		}
		
		public function getCurrentActiveObject():ActiveObject {
			var i = _activeAreas.length;
			
			while ( i-- ) {
				if ( _activeAreas[i].checkCollision( _player.x, _player.y) ) {
					return _activeAreas[i].parent;
				}
			}
			
			return null;
		}
		
		public function completeCurrentTask (e:Event) {
			var object:ActiveObject = ActiveObject(e.target);
			
			var i = _activeAreas.length;
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
			}
		}
		
		private function getNextTask():Task {
			return _tasks.pop();
		}
		
		public function subscribeGameObjects() {
			var i = _gameObjects.length;
			while (i--) {
				_gameObjects[i].addEventListener(Game.OBJECT_ACTIVATE_EVENT, completeCurrentTask);
			}
		}
		
		public function unsubscribeGameObjects() {
			var i = _gameObjects.length;
			while (i--) {
				_gameObjects[i].removeEventListener(Game.OBJECT_ACTIVATE_EVENT, completeCurrentTask);
			}
		}
		
		public function lock () {
			if ( isThereTasks() ) return;
			
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

	}
	
}
