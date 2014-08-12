package src.util {

	import flash.display.MovieClip;
	import flash.geom.Point;
	import src.Main;


	public class Collider extends MovieClip {
		protected var unlocked:Boolean = true;
		
		protected var top_left:Point;
		protected var bottom_right:Point;

		//создаём коллайдер
		public function Collider () {

			this.visible = Main.TEST_MODE;
			
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

		// проверка столкновений
		public function checkCollision ( X:Number, Y:Number ):Boolean {
			return unlocked && this.hitTestPoint( X, Y );
		}
		
		public function getCollider ():Collider {
			return this;
		}

	}

}