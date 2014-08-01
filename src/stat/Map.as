package src.stat {
	import flash.display.MovieClip;
	import flash.display.Sprite;
	
	public class Map extends MovieClip {
		private var _rooms:Array;
		private var miniMap:Sprite;
		
		private var WIDTH:int = 10;
		private var HEIGHT:int = 6;

		public function Map() {
			_rooms = new Array();
			
			miniMap = new Sprite();
			addChild(miniMap);
		}
		
		public function setUpRooms( instructions:Array ) {
			adjustRoomSize(instructions);
			
			for (var i:int=instructions.length-1; i>=0; i--) {
				addLevel(instructions[i][0],instructions[i][1]);
			}
			
			miniMap.x = width/2;
			miniMap.y = height/2;
		}
		
		public function adjustRoomSize(instructions:Array):void {
			var i = instructions.length,
				max_x = 0,
				max_y = 0,
				min_x = 0,
				min_y = 0;
			
			while (i--) {
				if ( max_x < instructions[i][0] ) max_x = instructions[i][0];
				if ( max_y < instructions[i][1] ) max_y = instructions[i][1];
				if ( min_x > instructions[i][0] ) min_x = instructions[i][0];
				if ( min_y > instructions[i][1] ) min_y = instructions[i][1];
			}
			
			HEIGHT = height/ (max_y - min_y + 1);
			WIDTH = width/ (max_x - min_x + 1);
		}
		
		private function addLevel (i:int, j:int) {
			miniMap.graphics.beginFill(0xff0000,1);
			miniMap.graphics.drawRect(i*WIDTH,j*HEIGHT,WIDTH-1,HEIGHT-1);
		}

	}
	
}
