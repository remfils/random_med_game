package src.events {
    import flash.events.Event;
    
    public class MenuItemSelectedEvent extends Event {
        public var URL:String;
            
        static public const LEVEL_SELECTED:String = "MenuLevelSelectedEvent"
        
        public function LevelSelectedEvent(type:String, data:Object, bubbles:Boolean=false, cancelable:Boolean=false) { 
            super(type, bubbles, cancelable);
            
            URL = data.url;
        } 
        
        public override function clone():Event { 
            return new LevelSelectedEvent(type, bubbles, cancelable);
        } 
        
        public override function toString():String { 
            return formatToString("LevelSelectedEvent", "type", "bubbles", "cancelable", "eventPhase"); 
        }
        
    }
    
}