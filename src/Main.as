package src {
    import flash.events.*;
    import flash.display.Sprite;
    import flash.net.URLLoader;
    import flash.net.URLRequest;
    import src.Game;
    import src.MainMenu;
    import src.util.LevelCreator;
    import src.events.*;

    public class Main extends Sprite {
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


