﻿package src  {
    
    import Box2D.Dynamics.b2Body;
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
        
        private var body:b2Body;
        
//invincibility
        static var immune:Boolean = false;
        var invincibilityDelay:Number = 140;
        var invincibilityTimer:Timer;
        
        static public var instance:Player = null;
        
        // переменные движения
        public var MOVE_RIGHT = false;
        public var MOVE_LEFT = false;
        public var MOVE_UP = false;
        public var MOVE_DOWN = false;
        
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
        
        /** проверяет стоит ли персонаж */
        public function isStopped () :Boolean {
            return false;
        }
        
        /** обновляет положение персонажа */
        public function update():void {
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
