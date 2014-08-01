package src{

	import flash.display.MovieClip;
	import flash.events.*;
	import flash.ui.Keyboard;
	import flash.geom.Point;
	
	import src.levels.CastleLevel;
	import fl.transitions.Tween;
	import fl.transitions.TweenEvent;
	import fl.transitions.easing.*;
	import src.stat.PlayerStat;
	import src.stat.Map;

	public class Main extends MovieClip {
		// true если уровень закончен
		private var blockControlls:Boolean = false;

		var stat:PlayerStat;

		var _player:Player;

		var _levels:Array = new Array();
		var cLevel:Level;
		
		var cLevel_x:int = 0;
		var cLevel_y:int = 0;
		
		var levelMap:MovieClip;
		
		var bulletController:BulletController;
		

		public function Main () {
			super ();

			_player = new Player();
			_player.move (385,400);
		}

		// FUNCTIONS FOR LEVEL START

		// setups game
		public function init ( levels:Array ) {
			// setup stage
			this.stage.focus = this;
			
			cLevel = new CastleLevel ( _player, nextLevel );
			
			// setup menu
			stat = new PlayerStat();
			stat.x = 0;
			stat.y = 0;
			addChild (stat);
			
			createLevels ( levels );
			
			levelMap.y = cLevel.y + stage.stageHeight - cLevel.height;
			
			_levels[-1][0].addTask();
			
			bulletController = new BulletController(cLevel);
			
			//setUpLevel ();
			addChild (_player);
			
			this.setChildIndex(stat,1);

			// add event listeners
			stage.addEventListener ( Event.ENTER_FRAME, update );
			stage.addEventListener ( KeyboardEvent.KEY_DOWN, keyDown_fun );
			stage.addEventListener ( KeyboardEvent.KEY_UP, keyUp_fun );
		}
		
		public function createLevels ( instructions:Array ) {
			var	level:Level = null;
			
			levelMap = new MovieClip();
			
			for ( var i=0; i<instructions.length; i++ ) {
				level = new CastleLevel ( _player, nextLevel );
				level.x = instructions[i][0]*level.width;
				level.y = instructions[i][1]*level.height;
				
				level.setNextLevel ( instructions[i][2],instructions[i][3] );
				
				if ( _levels[ instructions[i][0] ] ) {
					_levels[ instructions[i][0] ][ instructions[i][1] ] = level;
				}
				else {
					_levels[ instructions[i][0] ] = new Array();
					_levels[ instructions[i][0] ][ instructions[i][1] ] = level;
				}
				
				
				levelMap.addChild ( level );
			}
			
			addChild ( levelMap );
			
			var map:Map = stat.getMapMC();
			map.setUpScale(_levels);
			map.update(_levels,cLevel_x, cLevel_y);
			
			cLevel = _levels[cLevel_x][cLevel_y];
			cLevel.lock();
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
			
			if ( !blockControlls ) cLevel.update();
			
			bulletController.update();
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
			//trace (E.keyCode);
			
			if ( blockControlls ) return;
			
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
					var A:ActiveObject = cLevel.checkActiveAreasCollision();
					if ( A == null ) return;
					A.action();
					break;
				case 32 :
					stat.nextMenuTheme();
					break;
				case 74 :
					bulletController.spawnBullet();
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
		
		public function nextLevel ( exitDoor:Door ) {
			var doorDirection = exitDoor.getDirection();
			
			switch ( doorDirection ) {
				case "up":
					cLevel_y --;
					break;
				case "down":
					cLevel_y ++;
					break;
				case "left":
					cLevel_x --;
					break;
				case "right":
					cLevel_x ++;
					break;
			}
			cLevel = _levels[ cLevel_x ][ cLevel_y ] ;
			bulletController.changeLevel(cLevel);
			
			var enterDoor:Door = cLevel.getOppositeDoor ( exitDoor ) as Door;
			var correctY = stage.stageHeight - cLevel.height;
			
			var map = stat.getMapMC();
			map.update(_levels, cLevel_x, cLevel_y);
			
			//trace (enterDoor.y);
			
			blockControlls = true;
			var playerXTween:Tween = new Tween (_player, "x", Strong.easeInOut, _player.x, enterDoor.x, 25 );
			var playerYTween:Tween = new Tween (_player, "y", Strong.easeInOut, _player.y, enterDoor.y + correctY, 25 );
			
			//trace (cLevel.y);
			
			var tweenX:Tween = new Tween (levelMap, "x",Strong.easeInOut, levelMap.x, -cLevel.x, 25);
			var tweenY:Tween = new Tween (levelMap, "y",Strong.easeInOut, levelMap.y, -cLevel.y + correctY , 25);
			
			tweenX.addEventListener(TweenEvent.MOTION_FINISH, function () {
				cLevel.lock();
				blockControlls = false;
			} );
		}
		
		public function endLevel () {
			cLevel.unlock();

			cLevel = _levels[1];
			
			//setUpLevel();
			
			var tween:Tween = new Tween (this, "x",Strong.easeInOut,x,x-cLevel.width, 25);
			
			tween.addEventListener(TweenEvent.MOTION_FINISH, function () {
				cLevel.lock();
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