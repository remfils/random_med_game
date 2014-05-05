package  
{
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.events.KeyboardEvent;
	import Player;
	/**
	 * ...
	 * @author vlad
	 */
	class Game{
		public static var Renderer:BitmapData; //То что рисует все
		public var bitmap:Bitmap; // Сама картинка игры
		
		private var Colliders:Array; // Массив обьектов
		private var player:Player;
		var dx, dy:Number; // смещение игрока
		private var isDown, isUp, isLeft, isRight:Boolean; // Определяем зажата ли клавиша
		
		
		function Game(WIDTH:Number, HEIGHT:Number) {
			//Colliders = new Array();
			player = new Player(100,100,10,10);
			Renderer = new BitmapData(WIDTH, HEIGHT,true);
			bitmap = new Bitmap(Renderer);
			
			dx = 0;
			dy = 0;
		}
		
		/**
		 * Тут рисуем игру
		 */
		function Render():void {
			Renderer.lock();
			Renderer.fillRect(Renderer.rect, 0);
			
			player.Render();
			
			Renderer.unlock();
		}
		
		/**
		 * Тут смещаем все обьекты
		 */
		public function Update():void {
			player.checkCollisions();
			player.Update();
			player.setPosition(dx, dy);
			
		}
		
		/**
		 * Определяем зажата ли клавиша
		 * @param	e событие клавиатуры
		 */
		public function KeyDown(e:KeyboardEvent):void {
			if (e.keyCode == 39) dx = 1;
			if (e.keyCode == 37) dx = -1;
			
			if (e.keyCode == 40) dy = 1;
			if (e.keyCode == 38) dy = -1;
		}
		
		/**
		 * Определяем отжата ли клавиша
		 * @param	e
		 */
		public function KeyUp(e:KeyboardEvent):void {
			if (e.keyCode == 39 || e.keyCode == 37) dx = 0;
			if (e.keyCode == 38 || e.keyCode == 40) dy = 0;
		}
		
	}

}