package src  {
    
    import Box2D.Common.Math.b2Vec2;
    import Box2D.Dynamics.b2Body;
    import Box2D.Dynamics.b2FixtureDef;
    import flash.display.MovieClip;
    import flash.events.KeyboardEvent;
    import flash.geom.Point;
    import src.util.Collider;
    
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
        
        private var body:b2Body;
        
        
        public static var fixtureDef:b2FixtureDef;
//invincibility
        static var immune:Boolean = false;
        var invincibilityDelay:Number = 140;
        var invincibilityTimer:Timer;
        
        static public var instance:Player = null;
        
        // переменные движения
        private var inputForce:b2Vec2 = new b2Vec2();
        private var DIRECTION_CHANGED:Boolean = false;
        private const SPEED:uint = 40;
        public var MOVE_RIGHT:Boolean = false;
        public var MOVE_LEFT:Boolean = false;
        public var MOVE_UP:Boolean = false;
        public var MOVE_DOWN:Boolean = false;
        
        // направление персонажа
        public var dir_x:Number;
        public var dir_y:Number;
        private var _collider:Collider;
        
        public var currentRoom:Object = {x:0, y:0, z:0};
        
        //TODO: change to currentBuletClass
        private var currentBullet:Class;
        
        public function Player():void {
            // задаём стандартное направление
            gotoAndStop("stand_down");
            dir_x = 0;
            dir_y = -1;

            // получаем коллайдер
            _collider = getChildByName( "collider" ) as Collider;
            
            invincibilityTimer = new Timer(invincibilityDelay,6);
            
            currentBullet = Spark;
            
            definePlayerFixture();
        }
        
        private function definePlayerFixture():void {
            fixtureDef = new b2FixtureDef();
            fixtureDef.density = 1;
            fixtureDef.friction = 0.3;
        }
        
        static public function getInstance():Player {
            if ( instance == null ) instance = new Player();
            return instance;
        }
        
        public function getX ():Number {
            return x;
        }
        
        public function getYInRoom() :Number {
            return y - PlayerStat.getInstance().height;
        }
        
        public function setActorBody(body:b2Body):void {
            this.body = body;
        }
        
        public function handleInput(keyCode:uint):void {
            switch (keyCode) {
                case 37 :
                case 65 :
                    setMovement ("west");
                    break;
                case 38 :
                case 87 :
                    setMovement ("north");
                    break;
                case 39 :
                case 68 :
                    setMovement ("east");
                    break;
                case 40 :
                case 83 :
                    setMovement ("south");
                    break;
                case 32 :
                    makeHit(2);
                    break;
            }
        }
        /**
         * задает движение персонажа и определяет его направление
         * @param State куда нажата клавиша
         * @param max = true если клавиша нажата, false - отжата
         */
        public function setMovement(State:String, keyDown:Boolean = true) {
            DIRECTION_CHANGED = true;
            switch (State) {
                case "east" :
                    MOVE_RIGHT = keyDown;
                    if (keyDown) dir_x = 1;
                    else if ( MOVE_UP || MOVE_DOWN ) dir_x = 0;
                    break;
                case "west" :
                    MOVE_LEFT = keyDown;
                    if (keyDown) dir_x = -1;
                    else if ( MOVE_UP || MOVE_DOWN ) dir_x = 0;
                    break;
                case "south" :
                    MOVE_DOWN = keyDown;
                    if (keyDown) dir_y = 1;
                    else if ( MOVE_RIGHT || MOVE_LEFT ) dir_y = 0;
                    break;
                case "north" :
                    MOVE_UP = keyDown;
                    if (keyDown) dir_y = -1;
                    else if ( MOVE_RIGHT || MOVE_LEFT ) dir_y = 0;
                    break;
            }
        }
        
        /** проверяет стоит ли персонаж */
        public function isStopped () :Boolean {
            return body.GetLinearVelocity().LengthSquared() < 0.3;
            //return false;
        }
        
        /** обновляет положение персонажа */
        public function preupdate():void {
            movePlayer();
        }
        
        private function movePlayer():void {
            inputForce.SetZero();
            
            if (MOVE_DOWN) {
                inputForce.y += SPEED;
            }
            if (MOVE_LEFT) {
                inputForce.x -= SPEED;
            }
            if (MOVE_RIGHT) {
                inputForce.x += SPEED;
            }
            if (MOVE_UP) {
                inputForce.y -= SPEED;
            }
            
            body.ApplyForce(inputForce, body.GetLocalCenter());
        }
        
        public function update():void {
            x = body.GetPosition().x * Game.WORLD_SCALE;
            y = body.GetPosition().y * Game.WORLD_SCALE;
            
            if ( DIRECTION_CHANGED ) {
                applyDirectionChanges();
            }
            
            if ( isStopped() ) {
                if ( dir_x != 0 ) {
                    if ( dir_y > 0 ) gotoAndStop("stand_down");
                    else if ( dir_y < 0 ) gotoAndStop("stand_up");
                    else {
                        if ( dir_x > 0 ) gotoAndStop("stand_right");
                        else gotoAndStop("stand_left");
                    }
                }
                else {
                    if ( dir_y > 0 ) gotoAndStop("stand_down");
                    else if ( dir_y < 0 ) gotoAndStop("stand_up");
                }
            }
        }
        
        private function applyDirectionChanges():void {
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
        

        public function getCollider ():Collider {
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
