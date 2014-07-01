package src {
	
	import flash.display.MovieClip;
	import flash.events.*;
	import flash.ui.Keyboard;
	import flash.geom.Point;
	
	public class Main extends MovieClip {
		
		var _player:Player;
		var _walls:Array = new Array();

		var _doors:Array = new Array();
		var _GO:Array = new Array();

		var spawner:Spawner;
		
		public function Main() {
			super();
			
			_player = new Player();
			_player.move(200,200);
		}
		
		// FUNCTIONS FOR LEVEL START
		
		// setups game
		public function init() {
			this.stage.focus = this;
			addChild(_player);
			
			stage.addEventListener(Event.ENTER_FRAME, update);
			stage.addEventListener(KeyboardEvent.KEY_DOWN, keyDown_fun);
			stage.addEventListener(KeyboardEvent.KEY_UP, keyUp_fun);
		}
		
		// adding a wall to array
		public function addWall (A:Collider) {
			_walls.push(A);
		}
		
		// adds door
		public function addDoor (D:Door) {
			_doors.push(D);
		}
		
		// adds object
		public function addObject(A:GameObject) {
			_GO.push(A);
		}
		
		public function lockDoors() {
			for each (var k in _doors) {
				k.lock();
			}
			_walls.unlock();
		}
		
		
		// FUNCTION FOR MID-LEVEL
		
		public function update(e:Event){
			_player.update();
			
			checkCollisions();
		}
		
		public function checkCollisions () {
			_player.setCollide(false);
			for (var k in _doors) {
				if ( _doors[k].checkSloppyCollision ( _player ) ) {
					if ( _doors[k].checkCollision( _player ) ) {
						//_player.setCollide(true);
						_player.push( _doors[k].getCollider() );
					}
				}
			}
			
			// if (_doors[0].isPlayerLeaving(_player)) gotoLevelFromDoor(0);
		}
		
		public function keyDown_fun(E:KeyboardEvent) {
			switch(E.keyCode){
				case 37:
				case 65:
					_player.setMovement("west");
					break;
				case 38:
				case 87:
					_player.setMovement("north");
					break;
				case 39:
				case 68:
					_player.setMovement("east");
					break;
				case 40:
				case 83:
					_player.setMovement("south");
					break;
				case 32:
					openLevel();
					break;
			}
		}
		
		public function keyUp_fun(E:KeyboardEvent) {
			switch(E.keyCode){
				case 37:
				case 65:
					_player.setMovement("west",false);
					break;
				case 38:
				case 87:
					_player.setMovement("north",false);
					break;
				case 39:
				case 68:
					_player.setMovement("east",false);
					break;
				case 40:
				case 83:
					_player.setMovement("south",false);
					break;
			}
		}
		
		// FUNCTIONS FOR END GAME
		
				
		private function openLevel (){
			for each (var k in _doors) {
				k.unlock();
			}
		}
		
		public function gotoLevel (frame:Number) {
			gotoAndStop(frame);
		}
		
		public function gotoLevelFromDoor (I:Number) {
			gotoAndStop(_doors[I].frame);
			_player.x = _doors[I].x;
			_player.y = _doors[I].y;
		}
		
	}
	
}
