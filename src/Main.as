package src {

	import flash.display.MovieClip;
	import flash.events.*;
	import flash.ui.Keyboard;
	import flash.geom.Point;
	
	import src.levels.CastleLevel;
	import fl.transitions.Tween;
	import fl.transitions.TweenEvent;
	import fl.transitions.easing.*;
	import src.stats.PlayerStat;
	import src.stats.Map;
	
	import src.objects.*;
	import src.levels.*;
	import src.bullets.BulletController;

	public class Main extends MovieClip {
		// true если уровень закончен
		private var blockControlls:Boolean = false;

		var stat:PlayerStat;

		var _player:Player;

		var _LEVEL:Array = new Array();
		var cLevel:Level;
		
		var currentRoom:Object = {x:0, y:0, z:0};
		
		var levelMap:MovieClip;
		
		var bulletController:BulletController;
		

		public function Main () {
			super ();

			_player = Player.getInstance();
			_player.move (385,400);
			
			bulletController = new BulletController(stage);
		}

		// FUNCTIONS FOR LEVEL START

		// setups game
		public function init ( levels:Array ) {
			var levelLoader:LevelLoader = new LevelLoader();
			levelLoader.addLoadLevelListener(onLoadLevelComplete);
			
			levelLoader.startLevelLoad("level000");
		}
		
		private function onLoadLevelComplete(e:LevelLoadedEvent) {
			_LEVEL = e.getLevel();
			_player.currentRoom = e.first_level;
			
			this.stage.focus = this;
			
			addObjectsToStage();
			
			setUpLevelMapPosition();
			
			addEventListeners();
		}
		
		private function addObjectsToStage() {
			addLevel();
			
			addPlayerStat();
			
			addPlayer();
		}
		
		private function addLevel() {
			var k:int = _LEVEL.length;
			
			levelMap = new MovieClip();
			
			while (k--) {
				for (var i in _LEVEL[k]) {
					for (var j in _LEVEL[k][i]) {
						levelMap.addChild(_LEVEL[k][i][j]);
					}
				}
			}
			
			addChild(levelMap);
		}
		
		private function addPlayerStat() {
			stat = new PlayerStat();
			stat.x = 0;
			stat.y = 0;
			addChild (stat);
		}
		
		private function addPlayer() {
			_player = Player.getInstance();
			addChild(_player);
		}
		
		private function setUpLevelMapPosition() {
			cLevel = _LEVEL[_player.currentRoom.z][_player.currentRoom.x][_player.currentRoom.y];
			
			trace(_player.currentRoom.x,_player.currentRoom.y,_player.currentRoom.z);
			
			levelMap.y += stat.height;
			levelMap.x -= _player.currentRoom.x * cLevel.width;
			levelMap.y -= _player.currentRoom.y * cLevel.height;
		}
		
		private function addEventListeners() {
			stage.addEventListener ( Event.ENTER_FRAME, update );
			stage.addEventListener ( KeyboardEvent.KEY_DOWN, keyDown_fun );
			stage.addEventListener ( KeyboardEvent.KEY_UP, keyUp_fun );
		}
		
		public function init1 ( levels:Array ) {
			// setup stage
			
			
			cLevel = new CastleLevel ( );
			
			// setup menu
			
			
			createLevels ( levels );
			
			levelMap.y = cLevel.y + stage.stageHeight - cLevel.height;
			
			_LEVEL[-1][0].addTask();
			
			
			
			//setUpLevel ();
			addChild (_player);
			
			this.setChildIndex(stat,1);

			// add event listeners
		}
		
		public function createLevels ( instructions:Array ) {
			var	level:Level = null;
			
			levelMap = new MovieClip();
			
			for ( var i=0; i<instructions.length; i++ ) {
				level = new CastleLevel ();
				level.x = instructions[i][0]*level.width;
				level.y = instructions[i][1]*level.height;
				
				level.setNextLevel ( instructions[i][2],instructions[i][3] );
				
				if ( _LEVEL[ instructions[i][0] ] ) {
					_LEVEL[ instructions[i][0] ][ instructions[i][1] ] = level;
				}
				else {
					_LEVEL[ instructions[i][0] ] = new Array();
					_LEVEL[ instructions[i][0] ][ instructions[i][1] ] = level;
				}
				
				
				levelMap.addChild ( level );
			}
			
			addChild ( levelMap );
			
			var map:Map = stat.getMapMC();
			map.setUpScale(_LEVEL);
			map.update(_LEVEL);
			
			cLevel = _LEVEL[_player.currentRoom.x][_player.currentRoom.y];
			cLevel.lock();
		}

		// FUNCTION FOR MID-LEVEL

		public function update (e:Event) {
			_player.update ();
			
			if ( !blockControlls ) cLevel.update();
			
			bulletController.update();
		}

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
					_player.currentRoom.y --;
					break;
				case "down":
					_player.currentRoom.y ++;
					break;
				case "left":
					_player.currentRoom.x --;
					break;
				case "right":
					_player.currentRoom.x ++;
					break;
			}
			cLevel = _LEVEL[ _player.currentRoom.z ][ _player.currentRoom.x ][ _player.currentRoom.y ] ;
			bulletController.changeLevel(cLevel);
			
			var enterDoor:Door = cLevel.getOppositeDoor ( exitDoor ) as Door;
			var correctY = stage.stageHeight - cLevel.height;
			
			var map = stat.getMapMC();
			map.update(_LEVEL);
			
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

			cLevel = _LEVEL[1];
			
			//setUpLevel();
			
			var tween:Tween = new Tween (this, "x",Strong.easeInOut,x,x-cLevel.width, 25);
			
			tween.addEventListener(TweenEvent.MOTION_FINISH, function () {
				cLevel.lock();
			} );
		}

		// FUNCTIONS FOR END GAME
	}

}