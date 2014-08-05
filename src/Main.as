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
	import src.events.*;
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
			cLevel.addEventListener ( RoomEvent.EXIT_ROOM_EVENT , nextRoom );
			
			stat.getMapMC().setUpScale(_LEVEL[_player.currentRoom.z]);
			stat.getMapMC().update(_LEVEL[_player.currentRoom.z]);
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
			cLevel = getCurrentLevel();
			
			levelMap.y += stat.height;
			levelMap.x -= _player.currentRoom.x * cLevel.width;
			levelMap.y -= _player.currentRoom.y * cLevel.height;
		}
		
		private function getCurrentLevel ():Level {
			return _LEVEL[ _player.currentRoom.z ][ _player.currentRoom.x ][ _player.currentRoom.y ]
		}
		
		private function addEventListeners() {
			stage.addEventListener ( Event.ENTER_FRAME, update );
			stage.addEventListener ( KeyboardEvent.KEY_DOWN, keyDown_fun );
			stage.addEventListener ( KeyboardEvent.KEY_UP, keyUp_fun );
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
		// по возможности удалить RoomEvent
		public function nextRoom (e:RoomEvent) {
			cLevel.removeEventListener(RoomEvent.EXIT_ROOM_EVENT, nextRoom);
			
			var endDoor:Door = null;
			if ( _player.y < 200 ) {
				_player.currentRoom.y --;
				 endDoor = cLevel.getDoor("down");
			}
			if ( _player.y > 500 ) {
				_player.currentRoom.y ++;
				endDoor = cLevel.getDoor("up");
			}
			if ( _player.x < 100 ) {
				_player.currentRoom.x --;
				endDoor = cLevel.getDoor("right");
			}
			if ( _player.x > 500 ) {
				_player.currentRoom.x ++;
				endDoor = cLevel.getDoor("left");
			}
			cLevel = getCurrentLevel();
			
			var correctY = stat.height;
			
			var tweenX:Tween = new Tween (levelMap, "x",Strong.easeInOut, levelMap.x, -cLevel.x, 25);
			var tweenY:Tween = new Tween (levelMap, "y",Strong.easeInOut, levelMap.y, -cLevel.y + correctY , 25);
			
			blockControlls = true;
			var playerXTween:Tween = new Tween (_player, "x", Strong.easeInOut, _player.x, endDoor.x, 25 );
			var playerYTween:Tween = new Tween (_player, "y", Strong.easeInOut, _player.y, endDoor.y + correctY, 25 );
			
			var map = stat.getMapMC();
			map.update(_LEVEL);
			
			tweenX.addEventListener(TweenEvent.MOTION_FINISH, roomTweenFinished);
		}
		
		private function roomTweenFinished  (e:Event) {
			cLevel.lock();
			blockControlls = false;
			
			cLevel.addEventListener ( RoomEvent.EXIT_ROOM_EVENT , nextRoom );
			
			var tween:Tween = Tween(e.target);
			tween.removeEventListener(TweenEvent.MOTION_FINISH, roomTweenFinished);
		}
	}

}