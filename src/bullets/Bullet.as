package src.bullets {
    import flash.display.MovieClip;
    
    public class Bullet extends MovieClip {
        public const SPEED:Number = 10;
        static public const DELAY:Number = 500;
        
        private var active = true;

        public function Bullet() {
            
        }
        
        public function update() {
            if (currentFrame == totalFrames) active = false;
            if (!active) return;
        }
        
        public function activate() {
            active = true;
        }
        
        public function deactivate() {
            active = false;
        }
        
        public function isActive() {
            return active;
        }

    }
    
}
