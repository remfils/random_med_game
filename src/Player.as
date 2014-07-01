package src  {
	
	import flash.display.MovieClip;
	import flash.events.KeyboardEvent;
	import flash.geom.Point;
	
	
	public class Player extends MovieClip {
		static public const FRICTION:Number = 0.2;
		static public const MAX_SPEED = 6;
		
		public var MOVE_EAST = false;
		public var MOVE_WEST = false;
		public var MOVE_NORTH = false;
		public var MOVE_SOUTH = false;
		
		private var _collider:Collider;
		
		private var px:Number;
		private var py:Number;
		
		public function Player():void {
			gotoAndStop("south");
			_collider = getChildByName( "collider" ) as Collider;
			
			px = x;
			py = y;
		}
		
		public function setCollide ( C:Boolean ) {
			COLLIDE = C;
		}
		
		public function setMovement(State:String, max:Boolean = true) {
			switch (State) {
				case "east" :
					MOVE_EAST = max;
					if (!max) {
						top_vx = 0;
						if ( isStopped() ) this.gotoAndStop( "stand_east" );
					}
					else gotoAndStop("east");
					break;
				case "west" :
					MOVE_WEST = max;
					if (!max) {
						top_vx = 0;
						if ( isStopped() ) this.gotoAndStop( "stand_west" );
					}
					else gotoAndStop("west");
					break;
				case "south" :
					MOVE_SOUTH = max;
					if (!max){
						top_vy = 0;
						if ( isStopped() ) this.gotoAndStop( "stand_south" );
					}
					else gotoAndStop("south");
					break;
				case "north" :
					MOVE_NORTH = max;
					if (!max){
						top_vy = 0;
						if ( isStopped() ) this.gotoAndStop( "stand_north" );
					}
					else gotoAndStop("north");
					break;
			}
		}
		
		public function move (X:Number, Y:Number):void {
			x = px = X;
			y = py = Y;
		}
		

		public function push ( C:Collider ) {
			
		}
		
		/**
		 * метод обновляющий координаты персонажа
		 */
		public function update():void {
			var ds = x - px;
			
			x += ds;
			
			ds = y - py
			y += ds;
		}
		

		public function getCollider () :Collider {
			return _collider;
		}

		public function getLeft():Point {
			return new Point(x - 10, y);
		}
		
		public function getRight():Point {
			return new Point(x + 10, y);
		}
		
		public function getTop():Point {
			return new Point(x, y-5);
		}
		
		public function getBottom():Point {
			return new Point(x, y + 5);
		}
	}
}
