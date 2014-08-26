package src.ui {
    
    import flash.display.MovieClip;
    import flash.text.TextField;
    import flash.text.TextFormat;
    import flash.events.MouseEvent;
    import flash.geom.ColorTransform;
    import flash.ui.Mouse;
    
    public class GenericLevelButton extends MovieClip {
        public var levelSRC:String;
        var mapHeight:Number;
        
        public function GenericLevelButton() {
            mapHeight = height;

            this.addEventListener(MouseEvent.MOUSE_OVER, makeDarker);
            this.addEventListener(MouseEvent.MOUSE_OUT, makeNormal);
        }
        
        public function setLabel(levelLabel:String):void {
            var tf:TextField = new TextField();
            tf.text = levelLabel;
            tf.x = 0;
            
            tf.wordWrap = true;
            
            tf.setTextFormat(getLevelNameFormat());
            tf.y = -20*(Math.floor(tf.length/10)+1);
            
            addChild(tf);
        }
        
        private function getLevelNameFormat():TextFormat {
            var tf:TextFormat = new TextFormat();

            tf.color = 0xffffff;
            tf.align = "center";
            tf.size = 15;
            
            return tf;
        }
        
        public function setRating(rating:int):void {
                var star:Star=new Star(),
                ammendX:Number = (width - star.width*3)-4,
                ammendY:Number = mapHeight;
            
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
        
        public function block () {
            removeEventListener(MouseEvent.MOUSE_OVER, makeDarker);
            removeEventListener(MouseEvent.MOUSE_OUT, makeNormal);
            
            mouseChildren = false;
            mouseEnabled = false;
            
            this.transform.colorTransform = new ColorTransform(0.3,0.3,0.3);
        }
    }
    
}
