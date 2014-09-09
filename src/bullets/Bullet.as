package src.bullets {
    import flash.display.MovieClip;
    
    public class Bullet extends MovieClip {
        public const SPEED:Number = 10;
        static public const DELAY:Number = 500;
        
        private var active = true;
        
        private var vx = 1;
        private var vy = 0;

        public function Bullet() {
            
        }
        
        public function update() {
            if (currentFrame == totalFrames) active = false;
            if (!active) return;
            
            x += vx;
            y += vy;
        }
        
        public function activate() {
            active = true;
        }
        
        public function stopUpdate() {
            active = false;
        }
        
        public function isActive() {
            return active;
        }
        
        public function setSpeed (dx:Number, dy:Number) {
            vx = SPEED * dx;
            vy = SPEED * dy;
        }

    }
    
}
