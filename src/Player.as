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

		public var COLLIDE = false;
		
		private var _collider:Collider;

		private var vx:Number = 0;
		private var vy:Number = 0;
		private var top_vx:Number = 0;
		private var top_vy: Number = 0;
		
		private var P:Point;
		
		public function Player():void {
			gotoAndStop("south");

			
			_collider = getChildByName( "collider" ) as Collider;
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
		
		private function getSpeed (speed:Number, max_speed:Number, acc:Number):Number {
			var dir = max_speed - speed < 0 ? -1 : 1;
			if ( max_speed == speed ) return max_speed;
			else return speed += dir*acc;
		}
		
		public function isStopped ():Boolean {
			return (top_vx == 0 && top_vy == 0);
		}
		
		public function move (X:Number, Y:Number):void {
			x = X;
			y = Y;
		}
		
		/*public function push (dx:Number, dy:Number) {
			x -= dx*vx;
			y -= dy*vy;
		}*/
		

		public function push ( C:Collider ) {
			if ( x < C.x ) x = C.parent.x + C.x - width - 1;
			else x = C.parent.x + C.x + C.width + 1;
			
			if ( y < C.y ) y = C.parent.y + C.y - height - 1;
			else y = C.parent.y + C.y + C.height + 1;
		}
		
		/**
		 * метод обновляющий координаты персонажа
		 */
		public function update():void {
			if (MOVE_EAST) top_vx = MAX_SPEED;
			if (MOVE_WEST) top_vx = -MAX_SPEED;
			if (MOVE_SOUTH) top_vy = MAX_SPEED;
			if (MOVE_NORTH) top_vy = -MAX_SPEED;
			
			vx = getSpeed (vx,top_vx,1);
			vy = getSpeed (vy,top_vy,1);

			
			//if ( COLLIDE ) push();
		
			x += vx;
			y += vy;
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
