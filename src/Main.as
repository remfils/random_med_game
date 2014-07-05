package src{

	import flash.display.MovieClip;
	import flash.events.*;
	import flash.ui.Keyboard;
	import flash.geom.Point;
	
	import src.levels.CastleLevel;
	import fl.transitions.Tween;
	import fl.transitions.TweenEvent;
	import fl.transitions.easing.*;

	public class Main extends MovieClip {
		// true если уровень закончен
		private var finished:Boolean = false;

		var _player:Player;

		var _levels:Array = new Array();
		var cLevel:Level;
		

		public function Main () {
			super ();

			_player = new Player();
			_player.move (200,200);
		}

		// FUNCTIONS FOR LEVEL START

		// setups game
		public function init ( levels:Array ) {
			// setup stage
			this.stage.focus = this;
			
			cLevel = new CastleLevel ( _player );
			
			createLevels ( levels );
			
			//setUpLevel ();
			
			addChild (_player);

			// add event listeners
			/*stage.addEventListener ( Event.ENTER_FRAME, update );*/
			stage.addEventListener ( KeyboardEvent.KEY_DOWN, keyDown_fun );
			stage.addEventListener ( KeyboardEvent.KEY_UP, keyUp_fun );
		}
		
		public function createLevels ( instructions:Array ) {
			var	level:Level = null;
			
			for ( var i=0; i<instructions.length; i++ ) {
				level = new CastleLevel ( _player );
				level.x = instructions[i][0]*level.width;
				level.y = instructions[i][1]*level.height;
				
				_levels.push ( level );
				
				addChild ( level );
			}
		}

/* отправить в level
		public function lockDoors () {
			for each (var k in _doors) {
				k.lock ();
			}
			_walls.unlock ();
		}
*/


		// FUNCTION FOR MID-LEVEL

		public function update (e:Event) {
			_player.update ();
			
			cLevel.update();

			//checkCollisions ();
		}

		/* public function checkCollisions () {
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
		}*/
/* отправить в level
		public function checkActiveObjectsCollision ():Boolean {
			var i:int = _activeAreas.length;
			
			while ( i-- ) {
				if ( _activeAreas[i].checkCollision ( _player.x, _player.y ) ) {
					_activeAreas[i].parent.positiveOutcome ();
					return true;
				}
			}
			
			return false;
		}
*/
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
					/*if ( checkActiveObjectsCollision () ) {
						if ( !finished ) openLevel ();
					}*/
					break;
				case 32 :
					endLevel ();
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
		
		public function endLevel () {
//			gotoAndStop (2) ;

			cLevel = _levels[1];
			
			//setUpLevel();
			
			var tween:Tween = new Tween (this, "x",Strong.easeInOut,x,x-cLevel.width, 25);
			
			tween.addEventListener(TweenEvent.MOTION_FINISH, function () {
				_player.x = cLevel.x + 100;
				_player.y = cLevel.y + 100;
				
				// cLevel.showLevel ();
			} );
		}

		// FUNCTIONS FOR END GAME

/* отправить в level
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
*/
/*
		public function gotoLevel (frame:Number) {
			
			
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
*/
	}

}