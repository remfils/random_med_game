﻿package src.levels {
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
	
	public class Level extends MovieClip implements GameObject {
		var _gameObjects:Array = new Array();
		var _activeAreas:Array = new Array();
		var _colliders:Array = new Array();
		var _doors:Array = new Array();
		var _exits:Array = new Array();
		
		var currentTask:Task;
		
		var finished:Boolean = true;
		var _player:Player;
		var i:int = 0;
		
		var endLevel:Function;

		public function Level() {
			// adding stuff ti level

			// player
			_player = Player.getInstance();
			
			// walls
			var ar:Array = new Array ( "wall0", "wall1", "wall2", "wall3", "wall4", "wall5", "wall6", "wall7" );
			i = ar.length;
			
			while ( i-- ) {
				_colliders.push ( getChildByName ( ar[i] ) as Collider );
			}
			
			// doors
			var D:Door = null;
			ar = new Array("door0", "door1", "door2", "door3");
			i = ar.length;
			while ( i-- ) {
				D = getChildByName ( ar[i] ) as Door ;
				D.hide();
				
				_doors.push( D );
				_colliders.push( D.getCollider() );
				_exits.push ( D.getExit() );
			}
			
		}
		
		public function addActiveObject(object:ActiveObject) {
			_activeAreas.push(object.getActiveArea());
			_colliders.push(object.getCollider());
			
			_gameObjects.push(object);
			
			addChild(MovieClip(object));
		}
		
		public function addTask(type:String) {
			currentTask = new Task(type);
			
			if ( type != "distant" )
			finished = false;
		}
		
		public function setNextLevel ( STATE:String, doors:Array ) {
			i = doors.length;
			
			switch (STATE) {
				case "start":
					gotoAndStop("start_room");
					break;
				case "normal1":
					gotoAndStop ("normal_room_1");
					break;
				case "normal2":
					gotoAndStop ("normal_room_2");
					break;
				case "normal3":
					gotoAndStop ("normal_room_3");
					break;
				case "normal4":
					gotoAndStop ("normal_room_4");
					break;
				case "normal5":
					gotoAndStop ("normal_room_5");
					break;
				case "normal6":
					gotoAndStop ("normal_room_6");
					break;
			}
			
			while ( i-- ) {
				switch ( doors[i] ) {
					case "left" :
						_doors[0].show();
						_doors[0].unlock();
						break;
					case "right" :
						_doors[2].show();
						_doors[2].unlock();
						break;
					case "up" :
					case "top" :
						_doors[3].show();
						_doors[3].unlock();
						break;
					case "down" :
					case "bottom":
						_doors[1].show();
						_doors[1].unlock();
						break;
				}
			}
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
			gotoAndStop ("normal_room_1");
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
					
				}
			}
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
		
		// ------------------------
		public function getOppositeDoor ( d:Door ):Door {
			var doorRotation = d.rotation;
			
			//trace (doorRotation);
			
			switch ( doorRotation ) {
				case 90:
					doorRotation = -90;
					break;
				case 180:
				case -180:
					doorRotation = 0;
					break;
				default:
					doorRotation += 180;
			}
				
			var i = _doors.length;
			
			while ( i-- ) {
				if ( _doors[i].rotation == doorRotation ) return _doors[i];
			}
			
			return new Door();
		}
		
		public function active():Boolean {
			return finished;
		}
		
		public function getCollider ():Collider {
			return null;
		}
		
		public function addObject ( A:ActiveObject ) {
			_activeAreas.push ( A.getActiveArea() );
			_colliders.push ( A.getCollider() );
		}
		
		public function lock () {
			if ( finished ) return;
			
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
		
		public function finish () {
			unlock();
			
			finished = true;
		}

	}
	
}
