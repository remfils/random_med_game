package src  {
	
	import flash.display.MovieClip;
	import flash.events.KeyboardEvent;
	import flash.geom.Point;
	
	
	public class Player extends MovieClip {
		static public const FRICTION:Number = 0.2;
		static public const MAX_SPEED = 6;
		static public const SPEED = 4;
		
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
		
		public function setMovement(State:String, max:Boolean = true) {
			switch (State) {
				case "east" :
					MOVE_EAST = max;
					if (!max) {
						//top_vx = 0;
						if ( isStopped() ) this.gotoAndStop( "stand_east" );
					}
					else gotoAndStop("east");
					break;
				case "west" :
					MOVE_WEST = max;
					if (!max) {
						//top_vx = 0;
						if ( isStopped() ) this.gotoAndStop( "stand_west" );
					}
					else gotoAndStop("west");
					break;
				case "south" :
					MOVE_SOUTH = max;
					if (!max){
						//top_vy = 0;
						if ( isStopped() ) this.gotoAndStop( "stand_south" );
					}
					else gotoAndStop("south");
					break;
				case "north" :
					MOVE_NORTH = max;
					if (!max){
						//top_vy = 0;
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
		
		public function isStopped () :Boolean {
			return x - px == 0 && y - py == 0;
		}
		

		public function push ( C:Collider ) {
			var X:Number = x + _collider.x;
			var Y:Number = y + _collider.y;
			
			if ( C.hitTestPoint ( X - _collider.width/2 , Y ) || C.hitTestPoint ( X + _collider.width/2 , Y ) ) {
				x -= x - px;
			}

			if ( C.hitTestPoint ( X , Y + _collider.height/2 ) || C.hitTestPoint ( X , Y - _collider.height/2 ) ) {
				y -= y - py;
			}
		}
		
		public function update():void {
			var ds = x - px;
			px = x;
			
			ds -= ds/2.3 + ds*ds*ds/2000;
			if ( Math.abs(ds) < 0.02 ) ds = 0;
			x += ds;
			
			ds = y - py;
			py = y;
			
			ds -= ds/2.3 + ds*ds*ds/2000;
			if ( Math.abs(ds) < 0.02 ) ds = 0;
			y += ds;
			
			if ( MOVE_EAST ) x += SPEED;
			if ( MOVE_WEST ) x -= SPEED;
			if ( MOVE_SOUTH ) y += SPEED;
			if ( MOVE_NORTH ) y -= SPEED;
		}
		

		public function getCollider () :Collider {
			return _collider;
		}
	}
}
