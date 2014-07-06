package src  {
	
	import flash.display.MovieClip;
	import flash.events.KeyboardEvent;
	import flash.geom.Point;
	
	
	/**
	 * Главный класс игрока
	 */
	public class Player extends MovieClip {

		static public const FRICTION:Number = 0.2; //--
		static public const MAX_SPEED = 6; //--
		// скорости персонажа
		static public const SPEED = 4;
		static public const D_SPEED = SPEED * Math.SQRT2 / 2;//--
		
		// переменные движения
		public var MOVE_RIGHT = false;
		public var MOVE_LEFT = false;
		public var MOVE_UP = false;
		public var MOVE_DOWN = false;
		
		// направление персонажа
		private var dir_x:Number;
		private var dir_y:Number;
		//коллайдер персонажа
		private var _collider:Collider;
		// предидущие координаты персонажа
		// нужны для движения персонажа и столкновений
		private var px:Number;
		private var py:Number;
		
		public function Player():void {
			// задаём стандартное направление
			gotoAndStop("south");
			dir_x = 0;
			dir_y = -1;

			// получаем коллайдер
			_collider = getChildByName( "collider" ) as Collider;
			
			px = x;
			py = y;
		}
		/** получаем скорость по оси х */
		public function getVX() :Number {
			return x - px;
		}
		/** получаем скорость по уси у */
		public function getVY ():Number {
			return y - py;
		}
		/**
		 * задает движение персонажа и определяет его направление
		 * @param State куда нажата клавиша
		 * @param max = true если клавиша нажата, false - отжата
		 */
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
		/** перемещение персонажа без начала движения */
		public function move (X:Number, Y:Number):void {
			x = px = X;
			y = py = Y;
		}
		/** проверяет стоит ли персонаж */
		public function isStopped () :Boolean {
			return Math.abs ( getVX() ) < 2 && Math.abs ( getVY() ) < 2 ;
		}
		
		/**
		 * Отталкивает персонажа от коллайдера
		 * @param  C коллайдер
		 */
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
		/**
		 * берем точку для каста лучей в зависимости от направления
		 * @return координата каста
		 */
		public function getCastPointX () :Number {
			if ( dir_x > 0 ) return x + width/2;
			else return x - width/2;
		}
		/**
		 * берем точку для каста лучей в зависимости от направления
		 * @return координата каста
		 */
		public function getCastPointY ():Number {
			if ( dir_y > 0 ) return y + height/2;
			else return y - height/2;
		}
		/** обновляет положение персонажа */
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
