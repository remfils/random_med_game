package 
{
	import flash.display.BitmapData;
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.geom.Matrix;
	
	/**
	 * ...
	 * @author vlad
	 */
	public class Player extends GameSprite{
		static public const FRICTION:Number = 10;
		private var renderer:BitmapData;
		private var image:Sprite;
		
		
		function Player(x:int, y:int, width:int, height:int) :void {
			super(x, y, width, height);
			image = new Sprite();
			
			image.graphics.beginFill(0xFF0000, 1);
			image.graphics.drawRect( -40, -60, 80, 120);
			image.graphics.endFill();
		}
		
		public function setPosition(X:Number, Y:Number):void {
			this.x += X;
			this.y += Y;
		}
		
		public function getVX():Number {
			return x - past_x;
		}
		
		override public function Update():void {
			var a:Number = x;
			x += x - past_x - (x-past_x)/FRICTION;
			past_x = a;
			
			a = y;
			y += y - past_y - (y - past_y)/FRICTION;
			past_y = a;
		}
		
		override public function Render():void {
			var matrix:Matrix = new Matrix();
			matrix.translate(x, y);
			
			Game.Renderer.draw(image, matrix);
		}
		
		public function checkCollisions():void {
			if (x < 40) x = 40;
			if (x > 760) x = 760;
			if (y < 60) y = 60;
			if (y > 540) y = 540;
		}
	}
	
}