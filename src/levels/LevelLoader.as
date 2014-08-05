package src.levels {
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	import flash.events.Event;
	
	public class LevelLoader {
		private var urlLoader:URLLoader;
		private var _level:Array = new Array();;

		public function LevelLoader() {
			urlLoader = new URLLoader();
			urlLoader.addEventListener(Event.COMPLETE, xmlLevelLoadedListener);
		}
		
		public function loadLevel (levelName:String) :Array {
			var urlRequest:URLRequest = new URLRequest("levels/" + levelName + ".xml");
			urlLoader.load(urlRequest);
			
			return _level;
		}
		
		private function xmlLevelLoadedListener(e:Event) {
			var xmlLevel:XML = new XML(urlLoader.data);
			
			//trace(xmlLevel);
			_level = createFloorArray(xmlLevel);
		}
		
		private function createFloorArray(xmlLevel:XML):Array {
			var floors:Array = new Array();
			
			for each ( var floor:XML in xmlLevel.floor ) {
				floors.push( createRooms(floor) );
			}
		}
		
		private function createRooms (xmlFloor:XML) {
			var rooms:Array = new Array();
			
			for each ( var room:XML in xmlFloor.room ) {
				rooms.push( new CastleLevel() );
			}
		}

	}
	
}
