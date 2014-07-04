package src{

	import flash.display.MovieClip;
	import flash.events.*;
	import flash.ui.Keyboard;
	import flash.geom.Point;

	public class Main extends MovieClip {
		// true если уровень закончен
		private var finished:Boolean = false;

		var _player:Player;

		var _colliders:Array = new Array ();
		var _walls:Array = new Array();

		var _doors:Array = new Array();
		var _activeAreas:Array = new Array();

		var spawner:Spawner;

		public function Main () {
			super ();

			_player = new Player();
			_player.move (200,200);
		}

		// FUNCTIONS FOR LEVEL START

		// setups game
		public function init () {
			this.stage.focus = this;
			addChild (_player);

			stage.addEventListener (Event.ENTER_FRAME, update);
			stage.addEventListener (KeyboardEvent.KEY_DOWN, keyDown_fun);
			stage.addEventListener (KeyboardEvent.KEY_UP, keyUp_fun);
		}

		// adding a wall to array
		public function addWall ( A:Collider ) {
			_walls.push (A);
			_colliders.push ( A );
		}

		// adds door
		public function addDoor (D:Door) {
			_doors.push (D);
			_colliders.push ( D.getCollider() );
		}

		// adds object
		public function addObject ( A:ActiveObject ) {
			_activeAreas.push ( A.getActiveArea() );
			_colliders.push ( A.getCollider() );
		}

		public function lockDoors () {
			for each (var k in _doors) {
				k.lock ();
			}
			_walls.unlock ();
		}


		// FUNCTION FOR MID-LEVEL

		public function update (e:Event) {
			_player.update ();

			checkCollisions ();
		}

		public function checkCollisions () {
			var ray:Ray;
			
			for ( var i:int=0; i < 3; i++ ) {
				switch ( i ) {
					case 0:
						ray = new Ray(_player.getCastPointX(),_player.y,_player.getVX(),_player.getVY());
						break;
					case 1:
						ray = new Ray(_player.y,_player.getCastPointY(),_player.getVX(),_player.getVY());
						break;
					default:
						ray = new Ray(_player.getCastPointX(),_player.getCastPointY(),_player.getVX(),_player.getVY());
				}
				

				while ( ray.collided() ) {
					for (var k in _colliders) {
						if (_colliders[k].checkCollision(ray.x,ray.y)) {
							_player.push ( _colliders[k] );
						}
					}
	
					ray.inc ();
				}
			}
			
			// check spawner collision
			if ( finished ) {
				for ( k in _doors ) {
					if ( _doors[k].checkSpawner ( _player ) ) {
						goOut ( _doors[k] );
					}
					
				}
			}
		}
		
		public function checkActiveObjectsCollision ():Boolean {
			var i:int = _activeAreas.length;
			
			while ( i-- ) {
				if ( _activeAreas[i].checkCollision ( _player.x, _player.y ) ) {
					return true;
				}
			}
			
			return false;
		}

		public function keyDown_fun (E:KeyboardEvent) {
			// trace (E.keyCode);
			
			switch (E.keyCode) {
				case 37 :
				case 65 :
					_player.setMovement ("west");
					break;
				case 38 :
				case 87 :
					_player.setMovement ("north");
					break;
				case 39 :
				case 68 :
					_player.setMovement ("east");
					break;
				case 40 :
				case 83 :
					_player.setMovement ("south");
					break;
				case 69:
					if ( checkActiveObjectsCollision () ) {
						if ( !finished ) openLevel ();
					}
					break;
				case 32 :
					
					break;
			}
		}

		public function keyUp_fun (E:KeyboardEvent) {
			switch (E.keyCode) {
				case 37 :
				case 65 :
					_player.setMovement ("west",false);
					break;
				case 38 :
				case 87 :
					_player.setMovement ("north",false);
					break;
				case 39 :
				case 68 :
					_player.setMovement ("east",false);
					break;
				case 40 :
				case 83 :
					_player.setMovement ("south",false);
					break;
			}
		}

		// FUNCTIONS FOR END GAME


		private function openLevel () {
			finished = true;
			for each (var k in _doors) {
				k.unlock ();
			}
		}
		
		private function lockLevel () {
			finished = false;
			for(var k in _doors) {
				_doors[k].lock ();
			}
		}

		public function gotoLevel (frame:Number) {
			gotoAndStop (frame);
			
			lockLevel ();
		}
		
		public function goOut ( DOOR:Door ) {
			gotoLevel ( DOOR.level );
			
			_player.move (DOOR.x, DOOR.y);
		}

// --
		public function gotoLevelFromDoor (I:Number) {
			gotoAndStop (_doors[I].frame);
			_player.x = _doors[I].x;
			_player.y = _doors[I].y;
		}

	}

}