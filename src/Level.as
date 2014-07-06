﻿package src {
	import flash.display.Stage;
	import flash.display.MovieClip;
	
	public class Level extends MovieClip implements GameObject {
		var _activeAreas:Array = new Array();
		var _colliders:Array = new Array();
		var _doors:Array = new Array();
		var _exits:Array = new Array();
		
		
		var finished:Boolean = false;
		var _player:Player;
		
		var endLevel:Function;

		public function Level( player:Player, END_LEVEL:Function ) {
			// adding stuff ti level

			// player
			_player = player;
			
			endLevel = END_LEVEL;
			
			// walls
			var ar:Array = new Array ( "wall0", "wall1", "wall2", "wall3", "wall4", "wall5", "wall6", "wall7" ),
				i:int = ar.length;
			
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
		
		public function setNextLevel ( doors:Array ) {
			var i = doors.length;
			
			while ( i-- ) {
				switch ( doors[i].exitDirection ) {
					case "left" :
						_doors[0].show();
						_doors[0].unlock();
						_doors[0].setGoto ( doors[i].nextLevel );
						break;
					case "right" :
						_doors[2].show();
						_doors[2].unlock();
						_doors[2].setGoto ( doors[i].nextLevel );
						break;
					case "up" :
					case "top" :
						_doors[3].show();
						_doors[3].unlock();
						_doors[3].setGoto ( doors[i].nextLevel );
						break;
					case "down" :
					case "bottom":
						_doors[1].show();
						_doors[1].unlock();
						_doors[1].setGoto ( doors[i].nextLevel );
						break;
				}
			}
		}
		
		public function update () {
			checkCollisions();
		}
		
		public function checkCollisions () {
			
			var i = _colliders.length;
			while ( i-- ) {
				if ( _colliders[i].checkCollision ( _player.x, _player.y ) ) {
					_player.push(_colliders[i]);
				}
			}
			
			if ( finished ) {
				i = _exits.length;
				while ( i-- ) {
					if ( _exits[i].checkCollision ( _player.x, _player.y ) ) {
						endLevel ( _exits[i].parent );
						return;
						//endLevel ( i );
					}
				}
			}
			
		}
		
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
		
		public function negativeOutcome ( A:ActiveObject ) {
			A.negativeOutcome ();
			// обработка результатов здесь
		}
		
		public function positimeOutcome ( A:ActiveObject ) {
			A.positiveOutcome ();
		}

	}
	
}
