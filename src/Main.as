package src {

    import flash.events.*;
    import flash.ui.Keyboard;
    import flash.geom.Point;
    import src.util.LevelCreator;
    
    import src.levels.CastleLevel;
    import fl.transitions.Tween;
    import fl.transitions.TweenEvent;
    import fl.transitions.easing.*;
    import src.stats.PlayerStat;
    import src.stats.Map;
    
    import src.interfaces.*;
    
    import src.objects.*;
    import src.levels.*;
    import src.events.*;
    import src.bullets.BulletController;
    import src.stats.Heart;
    import src.util.GlassPanel;
    import flash.display.Sprite;
    import flash.net.URLLoader;
    import flash.net.URLRequest;
    import src.ui.GenericLevelButton;
    import src.util.PlayerPanel;
    import flash.display.*;
    ////////////////
    import src.MainMenu;
    

    public class Main extends MovieClip {
        var mainMenu:MainMenu;
        var loader:URLLoader;
        var game:Game;
        
        public function Main () {
            super ();
            startDataLoading();
            
            addEventListener(MenuItemSelectedEvent.LEVEL_SELECTED, startLevelLoading);
        }
        
        private function startDataLoading():void {
            loader = new URLLoader(new URLRequest("level_table.xml"));
            loader.addEventListener(Event.COMPLETE, loadCompleteListener);
        }
        
        private function loadCompleteListener(e:Event):void {
            loader.removeEventListener(Event.COMPLETE, loadCompleteListener);
            
            createMainMenu();
            mainMenu.importExternalData(new XMLList(loader.data));
            mainMenu.switchToMenu("title");
        }
        
        private function createMainMenu():void {
            mainMenu = new MainMenu();
            addChild(mainMenu);
        }
        
        private function startLevelLoading(e:MenuItemSelectedEvent):void {
            var levelLoader = new URLLoader();
            levelLoader.addEventListener(Event.COMPLETE, levelDataLoaded);
            
            levelLoader.load(new URLRequest(e.URL));
        }
        
        private function levelDataLoaded(e:Event) {
            var levelLoader:URLLoader = e.target as URLLoader;
            
            levelLoader.removeEventListener(Event.COMPLETE, levelDataLoaded);
            
            var levelCreator:LevelCreator = new LevelCreator();
            levelCreator.createLevelFromXML(XML(levelLoader.data));
            
            game = new Game();
            addChild(game);
            game.init(levelCreator._level);
            
            mainMenu.destroy();
        }
    }

}


