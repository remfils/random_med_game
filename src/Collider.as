package src{

	import flash.display.MovieClip;
	import flash.geom.Point;


	public class Collider extends MovieClip {
		protected var unlocked:Boolean = true;
		
		protected var top_left:Point;
		protected var bottom_right:Point;

		//создаём коллайдер
		public function Collider () {

			// this.visible = false;
			
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
		
		// проверка простых столкновений
		public function checkSloppyCollision ( P:Player ):Boolean {
			return unlocked && P.x > top_left.x
							&& P.x < bottom_right.x
							&& P.y > top_left.y
							&& P.y < bottom_right.y;
		}

		// проверка столкновений
		public function checkCollision (P:Player):Boolean {
			return unlocked && this.hitTestObject(P.getCollider());
		}
		
		public function getCollider ():Collider {
			return this;
		}

	}

}