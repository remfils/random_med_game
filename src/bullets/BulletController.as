package src.bullets {
	import flash.utils.Timer;
	import flash.events.TimerEvent;
	
	import src.levels.Level;
	import src.Player;
	
	public class BulletController {
		var _bullets:Array;
		
		var BulletClass:Class;
		
		var bulletDelay:Timer;
		var block:Boolean = false;
		
		var currentLevel:Level;
		
		var stage;
		var i:int = 0;

		public function BulletController(currentLevel:Level) {
			this.stage = currentLevel.stage;
			this.currentLevel = currentLevel;
			
			_bullets = new Array();
			
			BulletClass = Spark;
			
			bulletDelay = new Timer(BulletClass.DELAY);
			bulletDelay.addEventListener(TimerEvent.TIMER, unlockSpawn);
		}
		
		public function changeLevel (level:Level) {
			currentLevel = level;
		}
		
		public function update () {
			i = _bullets.length;
			while ( i-- ) {
				_bullets[i].update();
				
				if ( _bullets[i].isActive() && currentLevel.checkCollision(_bullets[i].x, _bullets[i].y)) {
					deleteBullet(_bullets[i]);
				}
			}
		}
		
		public function spawnBullet() {
			if ( block ) return;
			
			var bullet = getFreeBullet();
			
			if ( bullet == null ) {
				bullet = new BulletClass();
				stage.addChild (bullet);
				_bullets.push(bullet);
			}
			
			var player:Player = Player.getPlayer();
			
			bullet.x = player.x + player.dir_x*15;
			bullet.y = player.y ;
			
			bullet.setSpeed (player.dir_x, player.dir_y);
			
			lockSpawn();
		}
		
		public function getFreeBullet():Bullet {
			i = _bullets.length;
			while (i--) {
				if (_bullets[i].visible == false) {
					_bullets[i].visible = true;
					return _bullets[i];
				}
			}
			return null;
		}
		
		public function deleteBullet (B:Bullet) {
			var j = _bullets.length;
			while (j--) {
				if ( B == _bullets[j] ) {
					//_bullets[j].visible = false;
					_bullets[j].gotoAndPlay("destroy");
					_bullets[j].stopUpdate();
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
