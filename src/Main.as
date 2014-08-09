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
	
	import src.interfaces.*;
	
	import src.objects.*;
	import src.levels.*;
	import src.events.*;
	import src.bullets.BulletController;
	import src.stats.Heart;
	import src.util.GlassPanel;
	import flash.display.Sprite;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	import src.ui.GenericLevelButton;

	public class Main extends MovieClip {
		// true если уровень закончен
		private var blockControlls:Boolean = false;
		
		public static const EXIT_ROOM_EVENT = "exit_room";
		public static const OBJECT_ACTIVATE_EVENT = "object_activate";

		var stat:PlayerStat;
		var glassPanel:GlassPanel;

		var _player:Player;

		var _LEVEL:Array = new Array();
		public static var cLevel:Level;
		
		var currentRoom:Object = {x:0, y:0, z:0};
		
		var levelMap:MovieClip;
		
		var bulletController:BulletController;
		
		var levelLoader:URLLoader;

		public function Main () {
			super ();

			_player = Player.getInstance();
			_player.move (385,400);
			
			bulletController = new BulletController(stage);
		}
		
		private function testFun() {
			var ar:Array = new Array(1,2,3,4,5,6);
			var i = ar.length;
			
			while (i--) {
				trace(ar[i]);
				if (ar[i]==5) {
					ar.splice(i,1);
				}
			}
			
			trace(ar);
		}
		
		public function loadLevelsData () {
			levelLoader = new URLLoader(new URLRequest("level_table.xml"));
			levelLoader.addEventListener(Event.COMPLETE, levelDataLoaded);
		}
		
		private function levelDataLoaded(e:Event) {
			var xmlLevels:XMLList = new XMLList(levelLoader.data);
			
			addLevelButtons(xmlLevels.level);
		}
		
		private function addLevelButtons (levels:XMLList) {
			var btnMap:GenericLevelButton,
				i:int = 0;
			
			for each ( var level:XML in levels ) {
				btnMap = new GenericLevelButton(level.name, level.@rating);
				btnMap.y = 200;
				btnMap.x = 100 + 140*i++;
				
				btnMap.addEventListener(MouseEvent.CLICK, createLevelLoadFunction(level.src));
				
				addChild(btnMap);
			}
		}
		
		private function createLevelLoadFunction (url:String):Function {
			return function (e:Event) {
				gotoAndStop(1, "Scene 3");
				init(url);
			};
			
		}

		// FUNCTIONS FOR LEVEL START
		public function init (levelUrl:String) {
			var levelLoader:LevelLoader = new LevelLoader();
			levelLoader.addLoadLevelListener(onLoadLevelComplete);
			
			levelLoader.startLevelLoad(levelUrl);
		}
		
		private function onLoadLevelComplete(e:LevelLoadedEvent) {
			_LEVEL = e.getLevel();
			_player.currentRoom = e.first_level;
			
			this.stage.focus = this;
			
			addObjectsToStage();
			
			setUpLevelMapPosition();
			
			addEventListeners();
			
			prepareCurrentLevel();
			
			stat.getMapMC().setUpScale(_LEVEL[_player.currentRoom.z]);
			stat.getMapMC().update(_LEVEL[_player.currentRoom.z]);
		}
		
		private function addObjectsToStage() {
			addLevel();
			
			cLevel = getCurrentLevel();
			
			addPlayerStat();
			
			addPlayer();
			
			addGlassPanel();
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
			stat = PlayerStat.getInstance();
			stat.x = 0;
			stat.y = 0;
			addChild (stat);
		}
		
		private function addPlayer() {
			_player = Player.getInstance();
			addChild(_player);
		}
		
		private function addGlassPanel() {
			glassPanel = new GlassPanel();
			glassPanel.y += stat.height;
			glassPanel.setGameObjects(cLevel.getGameObjects());
			glassPanel.setCurrentLevel(cLevel);
			addChild(glassPanel);
		}
		
		private function setUpLevelMapPosition() {
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
		
		public function prepareCurrentLevel() {
			bulletController.changeLevel(cLevel);
			cLevel.addEventListener ( RoomEvent.EXIT_ROOM_EVENT , nextRoom );
			cLevel.addEventListener(OBJECT_ACTIVATE_EVENT, cLevel.completeCurrentTask);
			
			cLevel.subscribeGameObjects();
		}

		public function update (e:Event) {
			_player.update ();
			
			if (!blockControlls) {
				cLevel.update();
				glassPanel.update();
			}
			
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
					activateObject();
					break;
				case 32 :
					//stat.nextMenuTheme();
					_player.makeHit(2);
					break;
				case 74 :
					bulletController.startBulletSpawn();
					break;
			}
		}
		
		private function activateObject() {
			var A:ActiveObject = cLevel.getCurrentActiveObject();
			if ( A != null ) A.action();
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
				case 74:
					bulletController.stopBulletSpawn();
					break;
			}
		}
		// по возможности удалить RoomEvent
		public function nextRoom (e:Event) {
			blockControlls = true;
			var tweenX:Tween = null;
			glassPanel.clear();
			cLevel.removeEventListener(EXIT_ROOM_EVENT, nextRoom);
			
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
			
			tweenX = new Tween (levelMap, "x",Strong.easeInOut, levelMap.x, -cLevel.x, 18);
			var tweenY:Tween = new Tween (levelMap, "y",Strong.easeInOut, levelMap.y, -cLevel.y + correctY , 18);
			tweenX.start();
			
			
			var playerXTween:Tween = new Tween (_player, "x", Strong.easeInOut, _player.x, endDoor.x, 18 );
			var playerYTween:Tween = new Tween (_player, "y", Strong.easeInOut, _player.y, endDoor.y + correctY, 18 );
			
			var map = stat.getMapMC();
			map.update(_LEVEL);

			tweenX.addEventListener(TweenEvent.MOTION_FINISH, roomTweenFinished);
		}
		
		private function roomTweenFinished  (e:Event) {
			cLevel.lock();
			blockControlls = false;
			
			prepareCurrentLevel();
			glassPanel.setCurrentLevel(cLevel);
			
			var tween:Tween = Tween(e.target);
			tween.removeEventListener(TweenEvent.MOTION_FINISH, roomTweenFinished);
		}
	}

}