package src.ui.playerStat {
    
    import flash.display.MovieClip;
    import src.Player;
    import src.ui.playerStat.StatPoint;
    import src.bullets.*;
    
    public class PlayerStat extends MovieClip {
        static public var instance:PlayerStat = null;
        public var current_theme = 1;
        var level_map;
        
        private var healthBar:Bar;
        private var manaBar:Bar;
        
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
            
            healthBar = new Bar(StatHeart as Class, Player.MAX_HEALTH / 2);
            healthBar.x = 90;
            healthBar.y = 29;
            addChild(healthBar);
            
            manaBar = new Bar(StatMana as Class, Player.MAX_MANA / 2);
            manaBar.x = 90;
            manaBar.y = 67;
            manaBar.pointsLeftPadding = 7;
            manaBar.redraw();
            addChild(manaBar);
        }
        
        public function setCurrentSpell(spell:Class):void {
            if ( spell == Spark )
                spellPic_mc.gotoAndStop("spark");
            
            if ( spell == BombSpell )
                spellPic_mc.gotoAndStop("bombSpell");
        }
        
        public static function getInstance():PlayerStat {
            if ( instance === null ) instance = new PlayerStat();
            return instance;
        }
        
        public function flashButton(btnName:String):void {
            switch (btnName) {
                case "fire":
                    spellFire_mc.play();
                break;
                case "spellLeft":
                    spellLeft_mc.play();
                break;
                case "spellRight":
                    spellRight_mc.play();
                break;
            }
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
            healthBar.removePoints(dmg);
        }
    }
    
}
