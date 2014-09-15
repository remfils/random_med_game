package src.bullets {
    import flash.display.DisplayObjectContainer;
    import flash.utils.Timer;
    import flash.events.TimerEvent;
    import src.events.RoomEvent;
    import src.Game;
    
    import src.levels.Room;
    import src.Player;
    
    public class BulletController {
        private var _bullets:Array = new Array();
        private var _bulletsToRemove:Array = new Array();
        private var fire:Boolean;
        
        private var bulletClasses:Array = [Spark, BombSpell];
        private var currentBulletClass:int = 0;
        public var BulletClass:Class;
        
        private var bulletDelay:Timer;
        private var block:Boolean = false;
        
        private var currentRoom:Room = null;
        
        private var stage:DisplayObjectContainer;

        public function BulletController(stage:DisplayObjectContainer) {
            this.stage = stage;
            
            BulletClass = bulletClasses[currentBulletClass];
            
            bulletDelay = new Timer(BulletClass.DELAY);
            bulletDelay.addEventListener(TimerEvent.TIMER, unlockSpawn);
        }
        
        public function changeLevel (level:Room):void {
            currentRoom = level;
        }
        
        public function update () {
            if (fire && Player.MANA >= BulletClass.MANA_COST) {
                var b:Bullet = spawnBullet();
                if ( b ) {
                    currentRoom.game.playerStat.registerManaLoss(BulletClass.MANA_COST);
                    Player.MANA -= BulletClass.MANA_COST;
                    trace(Player.MANA);
                }
            }
            
            var i = _bullets.length;
            while ( i-- ) {
                _bullets[i].update();
            }
            
            i = _bulletsToRemove.length;
            while ( i-- ) {
                if ( !_bulletsToRemove[i].isActive() ) {
                    deleteBullet(_bulletsToRemove[i]);
                    _bulletsToRemove.splice(i,1);
                }
            }
        }
        
        public function startBulletSpawn() {
            fire = true;
        }
        
        public function stopBulletSpawn() {
            fire = false;
        }
        
        public function spawnBullet():Bullet {
            if ( block ) return null;
            
            var bullet = getFreeBullet();
            
            if ( bullet == null ) {
                bullet = new BulletClass();
                bullet.createBodyFromCollider(currentRoom.world);
                stage.addChild (bullet);
                _bullets.push(bullet);
            }
            
            var player:Player = Player.getInstance();
            
            bullet.moveTo(player.x + player.dir_x*15, player.y);
            
            bullet.setSpeedDirection (player.dir_x, player.dir_y);
            lockSpawn();
            
            return bullet;
        }
        
        public function getFreeBullet():Bullet {
            var i = _bullets.length;
            while (i--) {
                if (!_bullets[i].isActive()) {
                    _bullets[i].activate();
                    _bullets[i].gotoAndPlay(1);
                    return _bullets[i];
                }
            }
            return null;
        }
        
        public function hideBullet (B:Bullet) {
            var i = _bullets.length;
            while (i--) {
                if ( B == _bullets[i] ) {
                    _bullets[i].disableMovement();
                    _bullets[i].gotoAndPlay("destroy");
                    return;
                }
            }
        }
        
        public function setNextBullet():void {
            currentBulletClass ++;
            if ( currentBulletClass == bulletClasses.length ) {
                currentBulletClass = 0;
            }
            updateBulletClass();
        }
        
        public function setPrevBullet():void {
            currentBulletClass --;
            if ( currentBulletClass == -1 ) {
                currentBulletClass = bulletClasses.length - 1;
            }
            updateBulletClass();
        }
        
        private function updateBulletClass():void {
            BulletClass = bulletClasses[currentBulletClass];
            bulletDelay.delay = BulletClass.DELAY;
            smartClearBullets();
        }
        
        private function deleteBullet(b:Bullet) {
            b.moveTo(-100, -100);
            currentRoom.world.DestroyBody(b.body);
            stage.removeChild(b);
            _bullets.splice(_bullets.indexOf(b),1);
        }
        
        public function clearBullets():void {
            var i = _bullets.length;
            
            while (i--) {
                deleteBullet(_bullets[i]);
            }
        }
        
        public function smartClearBullets():void {
            var i = _bullets.length;
            
            while (i--) {
                if ( _bullets[i].isActive() ) {
                    if ( _bulletsToRemove.indexOf(_bullets[i]) == -1 )
                        _bulletsToRemove.push(_bullets[i]);
                }
                else {
                    deleteBullet(_bullets[i]);
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
