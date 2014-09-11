package src.events {
    import flash.events.Event;
    
    public class MenuItemSelectedEvent extends Event {
        public var URL:String;
            
        static public const LEVEL_SELECTED:String = "MenuLevelSelectedEvent"
        
        public function MenuItemSelectedEvent(type:String, url:String, bubbles:Boolean=true, cancelable:Boolean=false) { 
            super(type, bubbles, cancelable);
            URL = url;
        } 
        
        public override function clone():Event { 
            return new MenuItemSelectedEvent(type, URL, bubbles, cancelable);
        } 
        
        public override function toString():String { 
            return formatToString("LevelSelectedEvent", "type", "bubbles", "cancelable", "eventPhase"); 
        }
        
    }
    
}