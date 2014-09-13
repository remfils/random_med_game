package src {
    import Box2D.Common.Math.b2Vec2;
    import Box2D.Dynamics.b2Body;
    import Box2D.Dynamics.b2DebugDraw;
    import Box2D.Dynamics.b2World;
    import flash.display.Sprite;
    import flash.events.*;
    import flash.ui.Keyboard;
    import flash.geom.Point;
    import src.task.TaskManager;
    
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
    import flash.net.URLLoader;
    import flash.net.URLRequest;
    import src.ui.GenericLevelButton;
    import src.util.PlayerPanel;
    import flash.display.*;
    
    public class Game extends Sprite {
        private var blockControlls:Boolean = false;
        private var isTransition:Boolean = false;
        
        public static const WORLD_SCALE:Number = 30;
        public static const TIME_STEP:Number = 1 / 30;
        
        public static const EXIT_ROOM_EVENT = "exit_room";
        public static const OBJECT_ACTIVATE_EVENT = "object_activate";
        public static const TEST_MODE:Boolean = false;
        public static const TestModePanel:Sprite = new Sprite();

        var gamePanel:Sprite;
        var playerPanel:PlayerPanel;
        var glassPanel:GlassPanel;
        
        var _player:Player;

        var _LEVEL:Array = new Array();
        public static var cRoom:Room;
        
        var levelMap:MovieClip;
        
        var playerStat:PlayerStat;
        public var bulletController:BulletController;
        public var taskManager:TaskManager = new TaskManager();
        
        public function Game() {
            super();
            
            _player = Player.getInstance();
            _player.x = 385;
            _player.y = 400;
        }
        
        public function setLevel(level:Array):void {
            _LEVEL = level;
        }
        
        public function init() {
            this.stage.focus = this;
            Room.taskManager = taskManager;
            
            cRoom = getCurrentLevel();
            
            createGamePanel();
            
            addPlayerStat();
            
            addBulletController();
            
            setUpLevelMapPosition();
            
            addEventListeners();
            
            initCurrentLevel();
            
            playerStat.getMapMC().setUpScale(_LEVEL[_player.currentRoom.z]);
            playerStat.getMapMC().update(_LEVEL[_player.currentRoom.z]);
            
            TestModePanel.y += playerStat.height;
            addChild(TestModePanel);
        }
        
        private function addBulletController() {
            bulletController = new BulletController(playerPanel);
            playerStat.setCurrentSpell(bulletController.BulletClass);
        }
        
        private function createGamePanel():void {
            gamePanel = new Sprite();
            
            addLevelTo(gamePanel);
            
            addPlayerTo(gamePanel);
            
            addGlassPanelTo(gamePanel);
            
            gamePanel.y += PlayerStat.getInstance().height;
            
            addChild(gamePanel);
        }
        
        private function addLevelTo(panel:DisplayObjectContainer):void {
            var k:int = _LEVEL.length;
            
            levelMap = new MovieClip();
            
            while (k--) {
                for (var i in _LEVEL[k]) {
                    for (var j in _LEVEL[k][i]) {
                        levelMap.addChild(_LEVEL[k][i][j]);
                    }
                }
            }
            
            panel.addChild(levelMap);
        }
        
        private function addPlayerTo(panel:DisplayObjectContainer):void {
            playerPanel = new PlayerPanel();
            
            _player = Player.getInstance();
            
            playerPanel.addChild(_player);
            
            panel.addChild(playerPanel);
        }
        
        private function addGlassPanelTo(panel:DisplayObjectContainer):void {
            glassPanel = new GlassPanel();
            glassPanel.setGameObjects(cRoom.getGameObjects());
            glassPanel.setCurrentLevel(cRoom);
            panel.addChild(glassPanel);
        }
        
        private function addPlayerStat() {
            playerStat = PlayerStat.getInstance();
            playerStat.x = 0;
            playerStat.y = 0;
            addChild (playerStat);
        }
        
        private function setUpLevelMapPosition() {
            levelMap.x -= _player.currentRoom.x * cRoom.width;
            levelMap.y -= _player.currentRoom.y * cRoom.height;
        }
        
        private function getCurrentLevel ():Room {
            return _LEVEL[ _player.currentRoom.z ][ _player.currentRoom.x ][ _player.currentRoom.y ]
        }
        
        private function addEventListeners() {
            stage.addEventListener ( Event.ENTER_FRAME, update );
            stage.addEventListener ( KeyboardEvent.KEY_DOWN, keyDown_fun );
            stage.addEventListener ( KeyboardEvent.KEY_UP, keyUp_fun );
            stage.addEventListener ( RoomEvent.EXIT_ROOM_EVENT , nextRoom, true );
        }
        
        
        public function initCurrentLevel() {
            bulletController.changeLevel(cRoom);
            cRoom.init();
        }

        public function update (e:Event) {
            if (isTransition) return;
            
            _player.preupdate();
            
            
            if (!blockControlls) {
                cRoom.update();
                glassPanel.update();
            }
            _player.update ();
            
            bulletController.update();
        }

        public function keyDown_fun (e:KeyboardEvent) {
            if ( blockControlls ) return;
            
            _player.handleInput(e.keyCode);
            
            switch (e.keyCode) {
                // E key
                case 69:
                    cRoom.activateObjectNearPlayer();
                break;
                // J key
                case 74 :
                    bulletController.startBulletSpawn();
                    playerStat.flashButton("fire");
                break;
                // H key
                case 72:
                    bulletController.setPrevBullet();
                    playerStat.flashButton("spellLeft");
                    playerStat.setCurrentSpell(bulletController.BulletClass);
                break;
                // K key
                case 75:
                    bulletController.setNextBullet();
                    playerStat.flashButton("spellRight");
                    playerStat.setCurrentSpell(bulletController.BulletClass);
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
                case 74:
                    bulletController.stopBulletSpawn();
                    break;
            }
        }
        
        // по возможности удалить RoomEvent
        public function nextRoom (e:Event) {
            isTransition = true;
            blockControlls = true;
            
            var destination:Point = new Point();
            
            glassPanel.clear();
            cRoom.exit();
            bulletController.clearBullets();
            
            var endDoor:Door = e.target as Door;
            
            switch (endDoor.name) {
                case "door_up":
                    _player.currentRoom.y --;
                    destination.y -= _player.getCollider().height / 2;
                    endDoor = cRoom.getDoorByDirection("down");
                break;
                case "door_down":
                    _player.currentRoom.y ++;
                    destination.y += _player.getCollider().height / 2;
                    endDoor = cRoom.getDoorByDirection("up");
                break;
                case "door_left":
                    _player.currentRoom.x --;
                    destination.x -= _player.getCollider().width / 2;
                    endDoor = cRoom.getDoorByDirection("right");
                break;
                case "door_right":
                    _player.currentRoom.x ++;
                    destination.x += _player.getCollider().width / 2;
                    endDoor = cRoom.getDoorByDirection("left");
                break;
            }
            
            destination.x += endDoor.x;
            destination.y += endDoor.y;
            
            cRoom = getCurrentLevel();
            
            var tweenX:Tween = new Tween (levelMap, "x",Strong.easeInOut, levelMap.x, -cRoom.x, 18);
            var tweenY:Tween = new Tween (levelMap, "y",Strong.easeInOut, levelMap.y, -cRoom.y , 18);
            tweenX.start();
            
            
            var playerXTween:Tween = new Tween (_player, "x", Strong.easeInOut, _player.x, destination.x, 18 );
            var playerYTween:Tween = new Tween (_player, "y", Strong.easeInOut, _player.y, destination.y, 18 );
            
            var map = playerStat.getMapMC();
            map.update(_LEVEL);

            tweenX.addEventListener(TweenEvent.MOTION_FINISH, roomTweenFinished);
        }
        
        private function roomTweenFinished  (e:Event) {
            var tween:Tween = Tween(e.target);
            tween.removeEventListener(TweenEvent.MOTION_FINISH, roomTweenFinished);
            initCurrentLevel();

            blockControlls = false;
            isTransition = false;
            
            glassPanel.setCurrentLevel(cRoom);
        }
    }

}