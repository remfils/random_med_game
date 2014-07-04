package src  {
	
	import flash.display.MovieClip;
	import flash.events.KeyboardEvent;
	import flash.geom.Point;
	
	
	public class Player extends MovieClip {
		static public const FRICTION:Number = 0.2;
		static public const MAX_SPEED = 6;
		static public const SPEED = 4;
		static public const D_SPEED = SPEED * Math.SQRT2 / 2;
		
		public var MOVE_RIGHT = false;
		public var MOVE_LEFT = false;
		public var MOVE_UP = false;
		public var MOVE_DOWN = false;
		
		private var dir_x:Number;
		private var dir_y:Number;
		
		private var _collider:Collider;
		
		private var px:Number;
		private var py:Number;
		
		public function Player():void {
			gotoAndStop("south");
			_collider = getChildByName( "collider" ) as Collider;
			dir_x = 0;
			dir_y = -1;
			
			px = x;
			py = y;
		}
		
		public function getVX() :Number {
			return x - px;
		}
		
		public function getVY ():Number {
			return y - py;
		}
		
		public function setMovement(State:String, max:Boolean = true) {
			switch (State) {
				case "east" :
					MOVE_RIGHT = max;
					if (!max) {
						if ( isStopped() ) this.gotoAndStop( "stand_east" );
					}
					else gotoAndStop("east");
					break;
				case "west" :
					MOVE_LEFT = max;
					if (!max) {
						if ( isStopped() ) this.gotoAndStop( "stand_west" );
					}
					else gotoAndStop("west");
					break;
				case "south" :
					MOVE_DOWN = max;
					if (!max) {
						if ( isStopped() ) this.gotoAndStop( "stand_south" );
					}
					else gotoAndStop("south");
					break;
				case "north" :
					MOVE_UP = max;
					if (!max) {
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
			return Math.abs ( getVX() ) < 2 && Math.abs ( getVY() ) < 2 ;
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
		
		public function getCastPointX () :Number {
			if ( dir_x > 0 ) return x + width/2;
			else return x - width/2;
		}
		
		public function getCastPointY ():Number {
			if ( dir_y > 0 ) return y + height/2;
			else return y - height/2;
		}
		
		public function update():void {
			var ds = x - px;
			px = x;
			
			ds -= ds/2.3 + ds*ds*ds/2000;
			if ( Math.abs(ds) < 0.07 ) ds = 0;
			x += ds;
			
			ds = y - py;
			py = y;
			
			ds -= ds/2.3 + ds*ds*ds/2000;
			if ( Math.abs(ds) < 0.07 ) ds = 0;
			y += ds;
			
			if ( MOVE_RIGHT )  {
				dir_x = 1;
				
				if ( MOVE_DOWN ) {
					x += D_SPEED;
					y += D_SPEED;
					dir_y = 1;
				}
				else if ( MOVE_UP ) {
					x += D_SPEED;
					y -= D_SPEED;
					dir_y = -1;
				}
				else {
					x += SPEED;
					dir_y = 0;
				}
				
			}
			
			if ( MOVE_LEFT )  {
				dir_x = -1;
				if ( MOVE_DOWN ) {
					x -= D_SPEED;
					y += D_SPEED;
					dir_y = 1;
				}
				else if ( MOVE_UP ) {
					x -= D_SPEED;
					y -= D_SPEED;
					dir_y = -1;
				}
				else {
					x -= SPEED
					dir_y = 0;
				};
				
			}
			
			if ( MOVE_DOWN && !( MOVE_RIGHT || MOVE_LEFT ) ) {
				dir_y = 1;
				dir_x = 0;
				y += SPEED;
			}
			
			if ( MOVE_UP && !( MOVE_RIGHT || MOVE_LEFT ) ) {
				dir_y = -1;
				dir_x = 0;
				y -= SPEED;
			}
			
			// setting the face directioon
			if ( isStopped() ) {
				if ( dir_x == 0 ) {
					if ( dir_y > 0 ) gotoAndStop ("stand_south");
					else gotoAndStop ("stand_north");
				} else if ( dir_x > 0 ) gotoAndStop ("stand_east");
				else gotoAndStop ("stand_west");
			}
		}
		

		public function getCollider () :Collider {
			return _collider;
		}
	}
}
