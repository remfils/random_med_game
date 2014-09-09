package src.stats {
    
    import flash.display.MovieClip;
    
    
    public class Heart extends MovieClip {
        private var active = true;
        
        public function Heart() {
            stop();
        }
        
        public function makeFullHit() {
            gotoAndPlay("full_hit");
            active = false;
        }
        
        public function makeHalfHit() {
            gotoAndPlay("half_hit");
        }
        
        public function isActive():Boolean {
            return active;
        }
    }
    
}
