package src.levels {
	import flash.display.MovieClip;
	import src.interfaces.*;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	import flash.events.Event;
	import flash.utils.*;
	import src.objects.Lever;
	import src.enemy.FlyingEnemy;
	
	public class LevelLoader {
		private var urlLoader:URLLoader;
		private var _level:Array = null;
		private var first_level:Object;
		
		private var floorCounter:int = 0;

		public function LevelLoader() {
			urlLoader = new URLLoader();
			urlLoader.addEventListener(Event.COMPLETE, xmlLevelLoadedListener);
		}
		
		public function addLoadLevelListener(onLoadComplete:Function) {
			urlLoader.addEventListener("LevelLoaded", onLoadComplete);
		}
		
		public function startLevelLoad (levelUrl:String) {
			var urlRequest:URLRequest = new URLRequest(levelUrl);
			//urlLoader.
			urlLoader.load(urlRequest);
		}
		
		private function xmlLevelLoadedListener(e:Event) {
			var xmlLevel:XML = new XML(urlLoader.data);
			
			//trace(xmlLevel);
			_level = createFloorArray(xmlLevel);
			urlLoader.dispatchEvent(new LevelLoadedEvent(_level, first_level));
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
				cRoom = new CastleLevel();
				cRoom.x = room.@x * cRoom.width;
				cRoom.y = room.@y * cRoom.height;
				
				if ( !rooms[room.@x] ) {
					rooms[room.@x] = new Array();
				}
				
				if ( String(room.task.@type) != "" ) {
					cRoom.addTask(room.task.@type);
				}
				
				if ( room.@first_level == "true" ) {
					first_level = {
						x: room.@x,
						y: room.@y,
						z: floorCounter
					};
				}
				
				addActiveObjectsToRoom(cRoom, room.active.*);
				
				addEnemiesToRoom(cRoom, room.enemy);
				
				cRoom.setParameters(createParameters(room.@*));
				
				rooms[room.@x][room.@y] = cRoom;
			}
			
			rooms = makeDoorsInRooms(rooms);
			
			return rooms;
		}
		
		private function addActiveObjectsToRoom (room:Level, activeObjectsXML:XMLList) {
			
			for each ( var object:XML in activeObjectsXML ) {
				switch ( object.name().toString() ) {
					case "lever" :
						var currentObject:Lever = new Lever();
						currentObject.x = object.@x;
						currentObject.y = object.@y;
						
						room.addActiveObject(currentObject);
					break;
				}
			}
		}
		
		private function addEnemiesToRoom (room:Level, enemiesXML:XMLList) {
			for each ( var object:XML in enemiesXML ) {
				var enemy:FlyingEnemy = new FlyingEnemy();
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
