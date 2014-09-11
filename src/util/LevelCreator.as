package src.util {
    import flash.display.Sprite;
    import flash.text.StaticText;
    import src.Game;
    import src.levels.CastleLevel;
    import src.levels.Room;
    import flash.display.MovieClip;
	import src.interfaces.*;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	import flash.events.Event;
	import flash.utils.*;
	import src.objects.Lever;
	import src.enemy.FlyingEnemy;
    import src.objects.Obstacle;
    import src.objects.StaticObstacle;
    import src.Player;
    import src.task.TaskManager;
    
    public class LevelCreator {
        private var game:Game;
        private var gameTaskManager:TaskManager;
        private var floorCounter:int = 0;
        
        public function LevelCreator() {
        }
        
        public function createLevelFromXML (game:Game, levelData:XML):void {
            gameTaskManager = game.taskManager;
            this.game = game;
            game.setLevel(createFloorArray(levelData));
        }
        
        private function createFloorArray(xmlLevel:XML):Array {
            var floors:Array = new Array();
            
            for each ( var floor:XML in xmlLevel.floor ) {
                floors.push( createRooms(floor) );
                floorCounter ++;
            }
            
            return floors;
        }
        
        private function createRooms (xmlFloor:XML):Array {
            var rooms:Array = new Array(),
                cRoom:CastleLevel = null;
            
            for each ( var room:XML in xmlFloor.room ) {
                cRoom = new CastleLevel(game);
                cRoom.x = room.@x * cRoom.width;
                cRoom.y = room.@y * cRoom.height;
                
                if ( !rooms[room.@x] ) {
                    rooms[room.@x] = new Array();
                }
                
                if ( String(room.task.@type) != "" ) {
                    gameTaskManager.addLeverTaskToRoom(cRoom, room.task.@id);
                }
                
                if ( room.@first_level == "true" ) {
                    Player.getInstance().currentRoom = {
                        x: room.@x,
                        y: room.@y,
                        z: floorCounter
                    };
                }
                
                addDecorationsToRoom(cRoom, room.wallDecorations.*);
                
                addObstaclesToRoom(cRoom, room.obstacles.*);
                
                addTaskObjectsToRoom(cRoom, room.active.*);
                
                addEnemiesToRoom(cRoom, room.enemies.*);
                
                cRoom.setParameters(createParameters(room.@*));
                
                rooms[room.@x][room.@y] = cRoom;
            }
            
            rooms = makeDoorsInRooms(rooms);
            
            return rooms;
        }
        
        private function addDecorationsToRoom(cRoom:Room, wallDecorationsXML:XMLList):void {
            for each (var decorationNode:XML in wallDecorationsXML) {
                var decorationClass:Class = getDefinitionByName(decorationNode.name()) as Class;
                
                var decorationSprite:Sprite = new decorationClass();
                decorationSprite.x = decorationNode.@x;
                decorationSprite.y = decorationNode.@y;
                
                if ( decorationNode.@flip == "true" ) {
                    decorationSprite.scaleX *= -1;
                }
                
                if ( decorationNode.@rotation ) {
                    decorationSprite.rotation = decorationNode.@rotation;
                }
                
                cRoom.addChild(decorationSprite);
            }
        }
        
        private function addObstaclesToRoom (cRoom:Room, obstaclesXMLList:XMLList):void {
            for each (var obstacle:XML in obstaclesXMLList) {
                var obstClass:Class = getDefinitionByName(obstacle.name()) as Class;
                var obstSprite:Obstacle = new obstClass() as Obstacle;
                
                obstSprite.x = obstacle.@x;
                obstSprite.y = obstacle.@y;
                
                cRoom.addObstacle(obstSprite);
            }
        }
        
        private function addTaskObjectsToRoom (room:Room, activeObjectsXML:XMLList) {
            
            for each ( var object:XML in activeObjectsXML ) {
                switch ( object.name().toString() ) {
                    case "lever" :
                        var currentObject:Lever = new Lever(object.@id);
                        currentObject.x = object.@x;
                        currentObject.y = object.@y;
                        currentObject.assignToTask(object.parent().@taskId);
                        
                        room.addActiveObject(currentObject);
                    break;
                }
            }
        }
        
        private function addEnemiesToRoom (room:Room, enemiesXML:XMLList) {
            for each ( var object:XML in enemiesXML ) {
                var enemyClass:Class = getDefinitionByName(object.name()) as Class;
                
                var enemy = new enemyClass();
                
                enemy.cRoom = room;
                enemy.setPosition(object.@x,object.@y);
                
                room.addEnenemy(enemy);
            }
        }
        
        private function createParameters(roomParams):Object {
            var paramObj:Object = new Object();
            for (var N in roomParams) {
                paramObj[roomParams[N].name().toString()] = roomParams[N].toString();
            }
            return paramObj;
        }
    
        private function makeDoorsInRooms(rooms:Array):Array {
            for ( var i in rooms ) {
                for ( var j in rooms[i] ) {
                    if ( j < rooms[i].length-1 && rooms[i][j+1] ){
                        rooms[i][j].makeDoorWay("down");
                    }
                    if ( j > 0 && rooms[i][j-1] ){
                        rooms[i][j].makeDoorWay("up");
                    }
                    if ( i > 0 && rooms[i-1][j] ){
                        rooms[i][j].makeDoorWay("left");
                    }
                    if ( i < rooms.length-1 && rooms[i+1][j] ){
                        rooms[i][j].makeDoorWay("right");
                    }
                }
            }
            
            return rooms;
        }
    }

}