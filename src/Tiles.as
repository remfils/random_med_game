package  
{
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.Loader;
	import flash.display.LoaderInfo
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.geom.Matrix;
	import flash.net.URLRequest;
	/**
	 * ...
	 * @author vlad
	 */
	public class Tiles extends MovieClip
	{
		[Embed(source = "../bin/img/tile001.png")]
		private var tile1:Class;
		
		private var tile001:Bitmap;

		public function Tiles() 
		{
			for (var j:int; j < 15; j++ )
				for (var i:int = 0; i < 15; i++ ) {
					tile001 = new tile1();
					tile001.x = (j % 2 === 1) ? (tile001.width - 5) * i : (tile001.width - 5) * i - tile001.width / 2;
					tile001.y = tile001.height * j;
					addChild(tile001);
				}
		}
		
	}

}