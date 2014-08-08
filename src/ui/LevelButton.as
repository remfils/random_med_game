package src.ui {
	import flash.text.TextField;
	import flash.display.SimpleButton;
	import flash.display.Sprite;
	import flash.display.DisplayObject;
	import flash.text.TextFormat;
	
	public class LevelButton extends SimpleButton {
		var container:Sprite;

		public function LevelButton(levelName:String, rating:Number = 0) {
			super();
			
			container = new Sprite();
			
			container = new Sprite();
			container.addChild(overState);
			
			addLevelLabel(levelName);
			
			addRatingStars(rating);
			
			overState = downState = upState = container;
		}
		
		private function getLevelLabel(levelName:String) {
			var text:TextField = new TextField();
			text.text = levelName;
			text.x = 0;
			text.y = -20;
			
			text.width = width;
			
			text.setTextFormat(getLevelNameFormat());
			
			addChild(text);
		}
		
		private function getLevelNameFormat():TextFormat {
			var tf:TextFormat = new TextFormat();

			tf.color = 0xffffff;
			tf.align = "center";
			tf.size = 15;
			
			return tf;
		}
		
		private function addRatingStars(rating:Number) {
			var stars:Array = getStarsArray();
		}
		
		private function getStartArray():Array {
			
		}

	}
	
}
