package src  {
    
    import flash.display.MovieClip;
    import flash.events.KeyboardEvent;
    import flash.geom.Point;
    
    import src.bullets.*;
    import src.stats.PlayerStat;
    import flash.utils.Timer;
    import flash.events.TimerEvent;
    
    
    /**
     * Главный класс игрока
     */
    public class Player extends MovieClip {
//stats
        public static var MAX_HEALTH = 6;
        public static var HEALTH:Number = MAX_HEALTH;
        public var MANA:Number = 4;
//invincibility
        static var immune:Boolean = false;
        var invincibilityDelay:Number = 140;
        var invincibilityTimer:Timer;
        
        static public var instance:Player = null;

        static public const FRICTION:Number = 0.2; //--
        static public const MAX_SPEED = 6; //--
        // скорости персонажа
        static public const SPEED = 4;
        static public const D_SPEED = SPEED * Math.SQRT2 / 2;//--
        
        // переменные движения
        public var MOVE_RIGHT = false;
        public var MOVE_LEFT = false;
        public var MOVE_UP = false;
        public var MOVE_DOWN = false;
        
        // направление персонажа
        public var dir_x:Number;
        public var dir_y:Number;
        //коллайдер персонажа
        private var _collider:Collider;
        // предидущие координаты персонажа
        // нужны для движения персонажа и столкновений
        private var px:Number;
        private var py:Number;
        
        public var currentRoom:Object = {x:0, y:0, z:0};
        
        private var currentBullet;
        
        public function Player():void {
            // задаём стандартное направление
            gotoAndStop("stand_down");
            dir_x = 0;
            dir_y = -1;

            // получаем коллайдер
            _collider = getChildByName( "collider" ) as Collider;
            
            px = x;
            py = y;
            
            invincibilityTimer = new Timer(invincibilityDelay,6);
            
            currentBullet = Spark;
        }
        
        static public function getInstance():Player {
            if ( instance == null ) instance = new Player();
            return instance;
        }
        /** получаем скорость по оси х */
        public function getVX() :Number {
            return x - px;
        }
        /** получаем скорость по уси у */
        public function getVY ():Number {
            return y - py;
        }
        
        public function getX ():Number {
            return x;
        }
        
        public function getYInRoom() :Number {
            return y - PlayerStat.getInstance().height;
        }
        /**
         * задает движение персонажа и определяет его направление
         * @param State куда нажата клавиша
         * @param max = true если клавиша нажата, false - отжата
         */
        public function setMovement(State:String, max:Boolean = true) {
            switch (State) {
                case "east" :
                    MOVE_RIGHT = max;
                    if ( max ) gotoAndStop("right");
                    break;
                case "west" :
                    MOVE_LEFT = max;
                    if ( max ) gotoAndStop("left");
                    break;
                case "south" :
                    MOVE_DOWN = max;
                    if ( max ) gotoAndStop("down");
                    break;
                case "north" :
                    MOVE_UP = max;
                    if ( max ) gotoAndStop("up");
                    break;
            }
        }
        /** перемещение персонажа без начала движения */
        public function move (X:Number, Y:Number):void {
            x = px = X;
            y = py = Y;
        }
        /** проверяет стоит ли персонаж */
        public function isStopped () :Boolean {
            return Math.abs ( getVX() ) < 2 && Math.abs ( getVY() ) < 2 ;
        }
        
        /**
         * Отталкивает персонажа от коллайдера
         * @param  C коллайдер
         */
        public function push ( C:Collider ) {
            
            var X:Number = x + _collider.x;
            var Y:Number = y + _collider.y;
            
            var dx = 0, dy = 0;
            
            trace(C.getGlobalX());
            
            if ( C.checkCollision(X - _collider.width/2, Y) ) {
                dx = C.width * Math.sin(C.rotation * Math.PI / 180) / 2 + C.height * Math.cos(C.rotation * Math.PI / 180) / 2 + C.getGlobalX() + _collider.width/2 - X;
                dy = 0
            }
            else if ( C.checkCollision(X + _collider.width/2, Y) ) {
                dx = C.getGlobalX() - C.width * Math.sin(C.rotation * Math.PI / 180) / 2 - C.height * Math.cos(C.rotation * Math.PI / 180) / 2 - _collider.width/2 - X;
                dy = 0;
            }
            else if ( C.checkCollision(X - _collider.width/2, Y) ) {
                dx = C.width/2 + C.x + _collider.width/2 - X;
                dy = 0;
            }
            else if ( C.checkCollision(X - _collider.width/2, Y) ) {
                dx = C.width/2 + C.x + _collider.width/2 - X;
                dy = 0;
            }
            else if ( C.checkCollision(X - _collider.width/2, Y) ) {
                dx = C.width/2 + C.x + _collider.width/2 - X;
                dy = 0;
            }
            else if ( C.checkCollision(X - _collider.width/2, Y) ) {
                dx = C.width/2 + C.x + _collider.width/2 - X;
                dy = 0;
            }
            else if ( C.checkCollision(X - _collider.width/2, Y) ) {
                dx = C.width/2 + C.x + _collider.width/2 - X;
                dy = 0;
            }
            else if ( C.checkCollision(X - _collider.width/2, Y) ) {
                dx = C.width/2 + C.x + _collider.width/2 - X;
                dy = 0;
            }
            
            x += dx;
            
        }
        /**
         * берем точку для каста лучей в зависимости от направления
         * @return координата каста
         */
        public function getCastPointX () :Number {
            if ( dir_x > 0 ) return x + width/2;
            else return x - width/2;
        }
        /**
         * берем точку для каста лучей в зависимости от направления
         * @return координата каста
         */
        public function getCastPointY ():Number {
            if ( dir_y > 0 ) return y + height/2;
            else return y - height/2;
        }
        /** обновляет положение персонажа */
        public function update():void {
            var ds = x - px;
            px = x;
            
            ds -= ds/2.3 + ds*ds*ds/2000;
            if ( Math.abs(ds) < 0.07 ) ds = 0;
            x += ds;
            
            ds = y - py;
            py = y;
            
            ds -= ds/2.3 + ds*ds*ds/2000;
            if ( Math.abs(ds) < 0.07 ) ds = 0;
            y += ds;
            
            if ( MOVE_RIGHT )  {
                dir_x = 1;
                
                if ( MOVE_DOWN ) {
                    x += D_SPEED;
                    y += D_SPEED;
                    dir_y = 1;
                }
                else if ( MOVE_UP ) {
                    x += D_SPEED;
                    y -= D_SPEED;
                    dir_y = -1;
                }
                else {
                    x += SPEED;
                    dir_y = 0;
                }
                
            }
            
            if ( MOVE_LEFT )  {
                dir_x = -1;
                if ( MOVE_DOWN ) {
                    x -= D_SPEED;
                    y += D_SPEED;
                    dir_y = 1;
                }
                else if ( MOVE_UP ) {
                    x -= D_SPEED;
                    y -= D_SPEED;
                    dir_y = -1;
                }
                else {
                    x -= SPEED
                    dir_y = 0;
                };
                
            }
            
            if ( MOVE_DOWN && !( MOVE_RIGHT || MOVE_LEFT ) ) {
                dir_y = 1;
                dir_x = 0;
                y += SPEED;
            }
            
            if ( MOVE_UP && !( MOVE_RIGHT || MOVE_LEFT ) ) {
                dir_y = -1;
                dir_x = 0;
                y -= SPEED;
            }
            
            // setting the face directioon
            if ( isStopped() ) {
                if ( dir_x == 0 ) {
                    if ( dir_y > 0 ) gotoAndStop ("stand_down");
                    else gotoAndStop ("stand_up");
                } else if ( dir_x > 0 ) gotoAndStop ("stand_right");
                else gotoAndStop ("stand_left");
            }
            else {
                if ( dir_x != 0 ) {
                    if ( dir_y > 0 ) gotoAndStop("down");
                    else if ( dir_y < 0 ) gotoAndStop("up");
                    else {
                        if ( dir_x > 0 ) gotoAndStop("right");
                        else gotoAndStop("left");
                    }
                }
                else {
                    if ( dir_y > 0 ) gotoAndStop("down");
                    else if ( dir_y < 0 ) gotoAndStop("up");
                }
            }
        }
        

        public function getCollider () :Collider {
            return _collider;
        }
        
        public function makeHit (dmg:Number) {
            if (isImmune()) return;
            
            startInvincibilityTimer();

            HEALTH -= dmg;
            if ( HEALTH <= 0 ) {
                die();
                HEALTH = 0;
            }
            PlayerStat.getInstance().registerDamage(dmg);
        }
        
        private function startInvincibilityTimer() {
            invincibilityTimer.addEventListener(TimerEvent.TIMER, blink);
            invincibilityTimer.addEventListener(TimerEvent.TIMER_COMPLETE, stopInvincibilityTimer);
            invincibilityTimer.reset();
            invincibilityTimer.start();
            immune = true;
        }
        
        private function blink(e:TimerEvent) {
            visible = !visible;
        }
        
        private function stopInvincibilityTimer (e:TimerEvent) {
            immune = false;
            visible = true;
            invincibilityTimer.stop();
        }
        
        public static function isImmune():Boolean {
            return immune;
        }
        
        public function die() {
            trace("Player is dead");
        }
    }
}
