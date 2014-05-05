package  {
	import flash.utils.getTimer;
	/**
	 * ...
	 * @author vlad
	 */
	public class Random {
		
		public function Random() {
			
		}
		
		public static function getNumber():Number {
		var t_ms:int = getTimer(),
			r:Number = t_ms % 3;
		return r;
		}
		
	}

}