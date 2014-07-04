package src.stat {
	import flash.utils.getTimer;
	/**
	 * Класс который создается, для генерирования рандомного числа, от 0 до 2
	 * так же он засекает время между генерацией и попытками и записывает время в time
	 */
	public class Random {
		var times:Array = [0];
		var timer:Timer;
		
		public function Random() {
			timer = new Timer();
		}
		
		/**
		 * Функция, которая возвращает случайное число от 1 до 3
		 * @return число 1, 2 или 3
		 */
		public function getNumber():Number {
			registerTry ();

			var t_ms:int = timer.getTime(),
				r:Number = t_ms % 3;
			return r;
		}

		/**
		 * регистрируем попытку выбора
		 */
		public function registerTry () {
			times.push ( timer.getTime() );
		}

		/**
		 * завершаем работу рандома
		 * @return массив со временем, кол-во попыток определяется из длинны массива
		 */
		public function end ():Array {
			registerTry ();

			return times;
		}
		
		/**
		 * Функция, кторая возвращает кол-во милисекунд, с последнего её вызова
		 * @return кол-во милисекунд
		 */
		public static function time_Click():Number
		{ 
			t++;
			time.push(getTimer());
			return time[t]-time[t-1];
		}
	}

}