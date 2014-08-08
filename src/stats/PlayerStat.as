package src.stats {
	
	import flash.display.MovieClip;
	import src.Player;
	import src.stats.Heart;
	
	public class PlayerStat extends MovieClip {
		static public var instance:PlayerStat = null;
		public var current_theme = 1;
		var level_map;
		
		private const HEARTS_START_X:Number = 90;
		private const HEARTS_START_Y:Number = 29;
		
		var hearts:Array = new Array();
		
		public function PlayerStat() {
			super();
			//gotoAndStop(current_theme);
			level_map = new Map();
			level_map.x = 519;
			level_map.y = 13;
			addChild (level_map);
			
			var playerHP = Math.round(Player.MAX_HEALTH / 2);
			var playerHeart:Heart;
			var playerHasFullHeart = playerHP == Player.MAX_HEALTH;
			
			while (playerHP --) {
				playerHeart = new Heart();
				playerHeart.x = HEARTS_START_X + (playerHeart.width + 3) * playerHP;
				playerHeart.y = HEARTS_START_Y;
				
				addChild(playerHeart);
				
				hearts.push(playerHeart);
			}
			
			if (!playerHasFullHeart) {
				
			}
		}
		
		public static function getInstance():PlayerStat {
			if ( instance === null ) instance = new PlayerStat();
			return instance;
		}
		
		public function drawPlayerHearts() {
			var heartNum:Number = Player.HEALTH,
				playerHeart:Heart = new Heart();
			
			
		}
		
		public function redrawPlayerHearts() {
			drawPlayerHearts();
		}
		
		public function swapMenuTheme(keyFrame:int) {
			gotoAndStop(keyFrame);
		}
		
		public function nextMenuTheme () {
			current_theme ++;
			if (current_theme == totalFrames + 1) current_theme = 1;
			gotoAndStop( current_theme );
		}
		
		public function getMapMC ():Map {
			return level_map;
		}
		
		public function registerDamage (dmg:Number) {
			var heartsLeft = hearts.length - Math.floor((Player.HEALTH)/2);
			for (var i=0; i < heartsLeft; i++) {
				if (hearts[i].isActive()) hearts[i].makeFullHit();
			}
		}
	}
	
}
