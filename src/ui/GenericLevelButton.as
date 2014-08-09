﻿package src.ui {
	
	import flash.display.MovieClip;
	import flash.text.TextField;
	import flash.text.TextFormat;
	import flash.events.MouseEvent;
	import flash.geom.ColorTransform;
	import flash.ui.Mouse;
	
	public class GenericLevelButton extends MovieClip {
		var levelName:String,
			rating:int;
		
		public function GenericLevelButton(levelLabel:String, rating:int) {
			this.levelName = levelLabel;
			this.rating = rating;
			
			addLabel();
			addStars();
			
			this.addEventListener(MouseEvent.MOUSE_OVER, makeDarker);
			this.addEventListener(MouseEvent.MOUSE_OUT, makeNormal);
		}
		
		private function addLabel() {
			var tf:TextField = new TextField();
			tf.text = levelName;
			tf.x = 0;
			tf.y = -20;
			
			tf.setTextFormat(getLevelNameFormat());
			
			addChild(tf);
		}
		
		private function getLevelNameFormat():TextFormat {
			var tf:TextFormat = new TextFormat();

			tf.color = 0xffffff;
			tf.align = "center";
			tf.size = 15;
			
			return tf;
		}
		
		private function addStars() {
			var star:Star=new Star(),
				ammendX:Number = (width - star.width*3)-4,
				ammendY:Number = height;
			
			for ( var i=0; i<3; i++ ) {
				star = new Star();
				star.gotoAndStop(1);
				star.x = ammendX + star.width * i;
				star.y = ammendY;
				
				if ( i < rating ) {
					star.setScore();
				}
				
				addChild(star);
			}
		}
		
		private function makeDarker(e:MouseEvent) {
			this.transform.colorTransform = new ColorTransform(1.2,1.2,1.2);
			Mouse.cursor = "button";
		}
		
		private function makeNormal(e:MouseEvent) {
			this.transform.colorTransform = new ColorTransform();
			Mouse.cursor = "auto";
		}
	}
	
}