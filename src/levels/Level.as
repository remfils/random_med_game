package src.levels {
	import flash.display.Stage;
	import flash.display.MovieClip;
	import src.objects.Lever;
	import src.util.Random;
	import src.interfaces.GameObject;
	import src.interfaces.ActiveObject;
	import src.objects.*;
	import src.events.RoomEvent;
	import src.util.Collider;
	import src.Main;
	
	import src.Player;
	import flash.events.Event;
	import src.task.Task;
	
	public class Level extends MovieClip {
		var _gameObjects:Array = new Array();
		var _activeAreas:Array = new Array();
		var _colliders:Array = new Array();
		var _doors:Array = new Array();
		var _exits:Array = new Array();
		
		var _tasks:Array = new Array();
		var currentTask:Task = null;
		
		var finished:Boolean = true;
		var _player:Player;
		var i:int = 0;
		
		var endLevel:Function;

		public function Level() {
			// adding stuff ti level

			// player
			_player = Player.getInstance();
			
			// walls
			i = 8;
			while ( i-- ) {
				_colliders.push ( getChildByName ( "wall" + i ) as Collider );
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
			checkCollisions();
			
			if ( isThereTasks() ) {
				checkExitsCollision();
			}
		}
		
		private function isThereTasks():Boolean {
			return currentTask == null;
		}
		
		public function checkCollisions () {
			
			var i = _colliders.length;
			while ( i-- ) {
				if ( _colliders[i].checkCollision ( _player.x, _player.y ) ) {
					_player.push(_colliders[i]);
				}
			}
			
		}
		
		private function checkExitsCollision() {
			i = _exits.length;
			while (i--) {
				if ( _exits[i].checkCollision(_player.x, _player.y) ) {
					dispatchEvent(new Event(Main.EXIT_ROOM_EVENT));
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
				_gameObjects[i].addEventListener(Main.OBJECT_ACTIVATE_EVENT, completeCurrentTask);
			}
		}
		
		public function unsubscribeGameObjects() {
			var i = _gameObjects.length;
			while (i--) {
				_gameObjects[i].removeEventListener(Main.OBJECT_ACTIVATE_EVENT, completeCurrentTask);
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

	}
	
}
