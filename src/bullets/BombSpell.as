package src.bullets {
    public class BombSpell extends Bullet {
        static public const DELAY:Number = 1000;
        static public var MANA_COST:Number = 2;
        
        public function BombSpell() {
            super();
            damage = 100;
        }
        
    }

}