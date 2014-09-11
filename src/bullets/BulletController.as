package src.bullets {
    import flash.display.DisplayObjectContainer;
    import flash.utils.Timer;
    import flash.events.TimerEvent;
    import src.Game;
    
    import src.levels.Room;
    import src.Player;
    
    public class BulletController {
        var _bullets:Array;
        var fire:Boolean;
        
        var BulletClass:Class;
        
        var bulletDelay:Timer;
        var block:Boolean = false;
        
        var currentLevel:Room = null;
        
        var stage:DisplayObjectContainer;
        var i:int = 0;

        public function BulletController(stage:DisplayObjectContainer) {
            this.stage = stage;
            
            _bullets = new Array();
            
            BulletClass = Spark;
            
            bulletDelay = new Timer(BulletClass.DELAY);
            bulletDelay.addEventListener(TimerEvent.TIMER, unlockSpawn);
        }
        
        public function changeLevel (level:Room):void {
            currentLevel = level;
        }
        
        public function update () {
            if (fire) {
                spawnBullet();
            }
            
            i = _bullets.length;
            while ( i-- ) {
                _bullets[i].update();
                
                /*if ( _bullets[i].isActive() && currentLevel.checkCollision(_bullets[i].x, _bullets[i].y)) {
                    deleteBullet(_bullets[i]);
                }*/
            }
        }
        
        public function startBulletSpawn() {
            fire = true;
        }
        
        public function stopBulletSpawn() {
            fire = false;
        }
        
        public function spawnBullet() {
            if ( block ) return;
            
            var bullet = getFreeBullet();
            
            if ( bullet == null ) {
                bullet = new BulletClass();
                bullet.createBodyFromCollider(currentLevel.world);
                stage.addChild (bullet);
                _bullets.push(bullet);
            }
            
            var player:Player = Player.getInstance();
            
            bullet.moveTo(player.x + player.dir_x*15, player.y);
            
            bullet.setSpeedDirection (player.dir_x, player.dir_y);
            
            lockSpawn();
        }
        
        public function getFreeBullet():Bullet {
            i = _bullets.length;
            while (i--) {
                if (!_bullets[i].isActive()) {
                    _bullets[i].activate();
                    _bullets[i].gotoAndPlay(1);
                    return _bullets[i];
                }
            }
            return null;
        }
        
        public function deleteBullet (B:Bullet) {
            var j = _bullets.length;
            while (j--) {
                if ( B == _bullets[j] ) {
                    _bullets[j].disableMovement();
                    _bullets[j].gotoAndPlay("destroy");
                    return;
                }
            }
        }
        // timer methods
        public function lockSpawn() {
            block = true;
            bulletDelay.start();
        }
        
        public function unlockSpawn(e:TimerEvent) {
            block = false;
            bulletDelay.stop();
        }

    }
    
}
