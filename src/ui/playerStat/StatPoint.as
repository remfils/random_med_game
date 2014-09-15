package src.ui.playerStat {
    
    import flash.display.MovieClip;
    
    
    public class StatPoint extends MovieClip {
        private var active:Boolean = true;
        public var isHalfHit:Boolean = false;
        
        public function StatPoint():void {
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
