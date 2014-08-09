package src.ui {
	import flash.text.TextField;
	import flash.display.SimpleButton;
	import flash.display.Sprite;
	import flash.display.DisplayObject;
	import flash.text.TextFormat;
	import flash.display.MovieClip;
	
	public class LevelButton extends SimpleButton {
		var _label:String;
		var _rating:Number;
		var _stars:Array = new Array();
		var map:Sprite;

		public function LevelButton(levelName:String, rating:Number = 0) {
			super();
			_label = levelName;
			_rating = rating;
			
			setUpStars();
			
			upState = getUpState();
			overState = getOverState();
		}
		
		private function setUpStars() {
			var star:Star=new Star(),
				ammendX:Number = (width - star.width*3)-4;
			
			for ( var i=0; i<3; i++ ) {
				star = new Star();
				star.x = ammendX + star.width * i;
				star.y = height;
				_stars.push(star);
			}
		}
		
		private function getUpState():Sprite {
			var container:Sprite = new Sprite();
			container.addChild(map);
			addLevelLabel(container);
			
			addRatingStars(container);
			return container;
		}
		
		private function getOverState():Sprite {
			var container:Sprite = new Sprite();
			container.addChild(hitTestState);
			addLevelLabel(container);
			
			addRatingStars(container);
			return container;
		}
		
		private function addLevelLabel(container:Sprite) {
			var text:TextField = new TextField();
			text.text = _label;
			text.x = 0;
			text.y = -20;
			
			text.width = width;
			
			text.setTextFormat(getLevelNameFormat());
			
			container.addChild(text);
			
			var mc:MovieClip = new MovieClip();
		}
		
		private function getLevelNameFormat():TextFormat {
			var tf:TextFormat = new TextFormat();

			tf.color = 0xffffff;
			tf.align = "center";
			tf.size = 15;
			
			return tf;
		}
		
		private function addRatingStars(container:Sprite) {
			for (i=0; i<_rating; i++) {
				_stars[i].setScore();
			}
			
			var i = _stars.length;
			while (i--) {
				container.addChild(_stars[i]);
			}
		}

	}
	
}
