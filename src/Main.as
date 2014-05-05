package
{
	import flash.display.DisplayObject;
	import flash.display.MovieClip;
	import flash.display.Bitmap
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.display.GradientType
	import flash.events.KeyboardEvent;
	import flash.events.MouseEvent;
	import flash.filters.BlurFilter;
	import flash.filters.ShaderFilter;
	import flash.geom.Matrix;
	import flash.sampler.NewObjectSample;
	
	/**
	 * ...
	 * @author vlad
	 */
	public class Main extends Sprite
	{
		private var gameObject:Game;
		
		//НАЧАЛО
		public function Main():void
		{
			if (stage)
				init();
			else
				addEventListener(Event.ADDED_TO_STAGE, init);
		}
		
		//ВЫЗЫВАЕМ ПОСЛЕ НАЧАЛА
		private function init(e:Event = null):void
		{
			removeEventListener(Event.ADDED_TO_STAGE, init);
			
			gameObject = new Game(stage.stageWidth, stage.stageHeight);
			
			addChild(gameObject.bitmap);
			
			addEventListener(Event.ENTER_FRAME, RUN);
			stage.addEventListener(KeyboardEvent.KEY_DOWN, gameObject.KeyDown);
			stage.addEventListener(KeyboardEvent.KEY_UP, gameObject.KeyUp);
		}
		
		/**
		 * ОБНОВЛЯЕТ СЦЕНУ
		 * @param	событие изменения кадра
		 */
		private function RUN(e:Event):void
		{
			gameObject.Update();
			gameObject.Render();
		}
	
	}

}