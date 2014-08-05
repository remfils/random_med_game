﻿
package src.util {
	/**
	 * Класс для просцета столкновений персонажа с обьектами
	 * Содает луч, точки которого проверяются в столкновениях
	 */
	public class Ray {
		
		public var x:Number;
		public var y:Number;
		
		private var dx:Number;
		private var dy:Number;
		
		private var ds:Number;
		private var end_distance:Number;

		public function Ray( X:Number, Y:Number, DX:Number, DY:Number, END_DISTANCE:Number=1 ) {
			x = X;
			y = Y;
			
			ds = 0;
			
			end_distance = END_DISTANCE;
			
			var d = Math.sqrt( DX*DX + DY*DY );
			dx = DX/d/3;
			dy = DY/d/3;
		}
		
		/**
		 * меняет положение точки луча на шаг
		 * @return [description]
		 */
		public function inc () {
			x += dx;
			y += dy;
			
			ds += Math.sqrt( dx*dx + dy*dy );
		}
		
		/**
		 * Возвращает true если луч закончил свой ход
		 * @return [description]
		 */
		public function collided ():Boolean {
			return ds < end_distance;
		}

	}
	
}