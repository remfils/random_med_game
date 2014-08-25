package src.util {

	import flash.display.MovieClip;
	import flash.geom.Point;
	import src.Main;
	import flash.display.DisplayObject;


	public class Collider extends MovieClip {
		public var unlocked:Boolean = true;
		
		protected var top_left:Point;
		protected var bottom_right:Point;

		//создаём коллайдер
		public function Collider () {

			//this.visible = Main.TEST_MODE;
			
			var w2:Number = width/2,
				h2:Number = height/2;
			
			// здесь мы берем область больше, чем оригинал, для простых столкновений
			top_left = new Point (parent.x + x -w2 - 20, parent.y + y - h2 - 20);
			bottom_right = new Point (parent.x + x + w2 + 20, parent.y + y + h2 + 20);
		}

		// разблокирываем коллайдер
		public function unlock () {
			unlocked = false;
		}

		// блокируем коллайдер
		public function lock () {
			unlocked = true;
		}
		
		public function checkObjectCollision (O:DisplayObject):Boolean {
			return unlocked && this.hitTestObject(O);
		}

		// проверка столкновений
		public function checkCollision ( X:Number, Y:Number ):Boolean {
			return unlocked && this.hitTestPoint( X, Y );
		}
		
		public function getCollider ():Collider {
			return this;
		}
		
		public function getGlobalX():Number {
			return localToGlobal(new Point(0,0)).x;
		}
		
		public function getGlobalY():Number {
			return localToGlobal(new Point(0,0)).y;
		}

	}

}