package src{

	import flash.display.MovieClip;
	import flash.events.*;
	import flash.ui.Keyboard;
	import flash.geom.Point;

	public class Main extends MovieClip {

		var _player:Player;

		var _colliders:Array = new Array ();
		var _walls:Array = new Array();

		var _doors:Array = new Array();
		var _GO:Array = new Array();

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
		public function addObject (A:GameObject) {
			_GO.push (A);
			
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
			var ray:Ray = new Ray(_player.getCastPointX(),_player.getCastPointY(),_player.getVX(),_player.getVY(), 1);

			while ( ray.collided() ) {
				for (var k in _colliders) {
					if (_colliders[k].hitTestPoint(ray.x,ray.y)) {
						_player.push ( _colliders[k] );
					}
				}

				ray.inc ();
			}
		}

		public function keyDown_fun (E:KeyboardEvent) {
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
				case 32 :
					openLevel ();
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
			for each (var k in _doors) {
				k.unlock ();
			}
		}

		public function gotoLevel (frame:Number) {
			gotoAndStop (frame);
		}

		public function gotoLevelFromDoor (I:Number) {
			gotoAndStop (_doors[I].frame);
			_player.x = _doors[I].x;
			_player.y = _doors[I].y;
		}

	}

}