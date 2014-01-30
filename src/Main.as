package 
{
	import flash.display.MovieClip;
	import flash.display.Bitmap
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.display.GradientType
	import flash.events.MouseEvent;
	import flash.filters.BlurFilter;
	import flash.filters.ShaderFilter;
	import flash.geom.Matrix;
	/**
	 * ...
	 * @author vlad
	 */
	public class Main extends Sprite 
	{
		private var COLORS:Array = [0x000000 , 0xffffff];
		private var mat:Matrix;
		
		private var tiles:Tiles;
		
		
		//НАЧАЛО
		public function Main():void 
		{
			if (stage) init();
			else addEventListener(Event.ADDED_TO_STAGE, init);
		}
		
		//ВЫЗЫВАЕМ ПОСЛЕ НАЧАЛА
		private function init(e:Event = null):void 
		{
			removeEventListener(Event.ADDED_TO_STAGE, init);
			
			drawScene();
		}
		
		//РИСУЕМ СЦЕНУ
		private function drawScene():void {
			var mat:Matrix = new Matrix();
			
			tiles = new Tiles();
			addChild(tiles);
			
			
			mat.createGradientBox(stage.stageWidth , stage.stageHeight , toRad(-90));
			
			graphics.beginGradientFill(GradientType.LINEAR , COLORS , [1 , 1] , [0 , 255] , mat);
			
			graphics.drawRect(0 , 0 , stage.stageWidth , stage.stageHeight);
			
			graphics.endFill();
			
			addChild(tiles);
			addChild(drawDoor(100, 400));
			addChild(drawDoor(290, 400));
			addChild(drawDoor(480, 400));
			
		}
		
		//РИСУЕМ ДВЕРЬ
		[Embed(source = "../bin/img/door002.png")]
		private static var door001:Class;
		
		private function drawDoor(X:int , Y:int):MovieClip {
			var pic:Bitmap = new door001();
			var clip:MovieClip = new MovieClip();
			pic.x -= pic.width / 2;
			pic.y -= pic.height / 2;
			
			clip.addChild(pic);
			
			clip.x = X;
			clip.y = Y;
			
			clip.addEventListener(MouseEvent.CLICK , function(e:MouseEvent) {
				clip.filters = [new BlurFilter(30 , 30 , 1)];
			});
			
			return clip;
		}
		
		//ПРЕОБРАЗУЕТ УГЛЫ В РАДИАНЫ
		private function toRad(a:Number):Number {
			return a * Math.PI / 180;
		}
		
	}
	
}