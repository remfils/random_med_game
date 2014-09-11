package src.stats {
    
    import flash.display.MovieClip;
    
    
    public class Heart extends MovieClip {
        private var active:Boolean = true;
        public var isHalfHit:Boolean = false;
        
        public function Heart():void {
            stop();
        }
        
        public function makeHalfHit():void {
            if ( isHalfHit ) {
                makeFullHit();
            }
            else {
                isHalfHit = true;
                gotoAndPlay("half_hit");
            }
        }
        
        public function makeFullHit() {
            gotoAndPlay("full_hit");
            active = false;
        }
        
        public function isActive():Boolean {
            return active;
        }
    }
    
}
