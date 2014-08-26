package src {
    import fl.transitions.easing.Strong;
    import fl.transitions.Tween;
    import flash.display.DisplayObject;
    import flash.display.MovieClip;
    import flash.display.SimpleButton;
    import flash.display.Sprite;
    import flash.events.Event;
    import flash.events.MouseEvent;
    import flash.text.TextField;
    import flash.text.TextFormat;
    import src.ui.GenericLevelButton;
    
    import flash.utils.getQualifiedClassName;

    public class MainMenu extends Sprite {
        private var currentMenu:Sprite;
        private var titleMenuContainer:Sprite;
        private var levelsMenuContainer:Sprite;
		
		private var allLevelsContainer:Sprite;
        
        public function MainMenu() {
            super();
            
            createBG();
            
            setTitleMenu();
            setLevelsMenu();
        }
        
        private function createBG():void {
            var BG:Sprite = new MenuBackground();
            
            BG.x = -2.7;
            BG.y = -13.1;
            BG.width = 784.95;
            BG.height = 770.15;
            
            addChild(BG);
        }

// TITLE MENU
        private function setTitleMenu():void {
            titleMenuContainer = new Sprite();
            
            addUserData();
            addTitleMenuButtons();
            titleMenuContainer.addEventListener(MouseEvent.CLICK, menuItemClickListener);
            
            titleMenuContainer.visible = false;
            addChild(titleMenuContainer);
        }
        
        private function addUserData():void {
            
        }
        
        private function addTitleMenuButtons():void {
            createGotoLevelsButton();
            createGotoShopButton();
            createGotoAchievementsButton();
        }
        
        private function getSimpleButtonAt(ButtonClass:Class, x:Number, y:Number):SimpleButton {
            var btn:SimpleButton = new ButtonClass();
            
            btn.x = x;
            btn.y = y;
            
            return btn
        }
        
        private function createGotoLevelsButton():void {
            var btn:SimpleButton = getSimpleButtonAt(GotoLevelsButton, 236.25, 504.3);
            titleMenuContainer.addChild(btn);
        }
        
        private function createGotoShopButton():void {
            var btn:SimpleButton = getSimpleButtonAt(GotoShopButton, 401.25, 506);
            titleMenuContainer.addChild(btn);
        }
        
        private function createGotoAchievementsButton():void {
            var btn:SimpleButton = getSimpleButtonAt(GotoAchievementsButton, 544.15, 504.5);
            titleMenuContainer.addChild(btn);
        }
        
        private function menuItemClickListener(e:MouseEvent):void {
            if ( e.target is GotoLevelsButton ) {
                switchToMenu("levels");
            }
            if ( e.target is GotoShopButton ) {
                switchToMenu("shop");
            }
            if ( e.target is GotoAchievementsButton ) {
                switchToMenu("achievements");
            }
        }
        
        
// LEVELS MENU
        private function setLevelsMenu():void {
            levelsMenuContainer = new Sprite();
            
            allLevelsContainer = new Sprite();
            levelsMenuContainer.addChild(allLevelsContainer);
            
            createMoveLeftButton();
            createMoveRigthButton();
            createGotoMenuButton();
            createLevelsButtons();
            
            addEventListener(MouseEvent.CLICK, levelItemClickListener);
            
            levelsMenuContainer.visible = false;
            addChild(levelsMenuContainer);
        }
        
        private function getCustomButtonAt(ButtonClass:Class, x:Number, y:Number):Sprite {
            var btnContainer:Sprite = new Sprite();
            btnContainer.x = x;
            btnContainer.y = y;
            
            var btn:SimpleButton = new ButtonClass();
            btnContainer.addChild(btn);
            return btnContainer;
        }
        
        private function createMoveLeftButton():void {
            var btnContainer:Sprite = getCustomButtonAt(TabletButton, 55.4, 485.45);
            btnContainer.name = "MoveLeft";
            btnContainer.rotation = 4;
            
            var arrow:Sprite = new PaintedArrow();
            arrow.rotation = 180;
            arrow.mouseEnabled = false;
            btnContainer.addChild(arrow);
            
            levelsMenuContainer.addChild(btnContainer);
        }
        
        private function createMoveRigthButton():void {
            var btnContainer:Sprite = getCustomButtonAt(TabletButton, 697.95, 485.45);
            btnContainer.name = "MoveRight";
            btnContainer.rotation = -4;
            
            var arrow:Sprite = new PaintedArrow();
            arrow.mouseEnabled = false;
            btnContainer.addChild(arrow);
            
            levelsMenuContainer.addChild(btnContainer);
        }
        
        private function createGotoMenuButton():void {
            var btnContainer:Sprite = getCustomButtonAt(TabletButton, 375.3, 583);
            btnContainer.name = "GotoTitle";
            btnContainer.width = 182;
            
            var text:TextField = new TextField();
            text.textColor = 0xF0D685;
            text.width = btnContainer.width;
            text.mouseEnabled = false;
            
            var tf:TextFormat = new TextFormat(null, 30);
            tf.align = "center";
            text.defaultTextFormat = tf;
            text.text = "Меню";
            
            text.x -= text.width / 2;
            text.y -= text.height / 4;
            
            btnContainer.addChild(text);
            levelsMenuContainer.addChild(btnContainer);
        }
        
        private function createLevelsButtons():void {
            
        }
        
        private function levelItemClickListener(e:MouseEvent):void {
            var target:Sprite = e.target.parent;
            
            switch( target.name ) {
                case "GotoTitle":
                    switchToMenu("title");
                    break;
                case "MoveRight":
                    moveAllLevelsContainerRight();
                    break;
                case "MoveLeft":
                    moveAllLevelsContainerLeft();
                    break;
            }
        }
        
        public function switchToMenu(menuName:String):void {
            removeAllEventListeners();
            if (currentMenu != null) {
                currentMenu.visible = false; 
            }
            
            switch(menuName) {
                case "title":
                    displayMenu(titleMenuContainer, menuItemClickListener);
                    break;
                case "levels":
                    displayMenu(levelsMenuContainer, levelItemClickListener);
                    break;
            }
        }
        
        private function removeAllEventListeners():void {
            levelsMenuContainer.removeEventListener(MouseEvent.CLICK, levelItemClickListener);
            titleMenuContainer.removeEventListener(MouseEvent.CLICK, menuItemClickListener);
        }
        
        private function displayMenu(menu:Sprite, clickListener:Function=null):void {
            currentMenu = menu;
            menu.addEventListener(MouseEvent.CLICK, clickListener);
            menu.visible = true;
        }
        
        private function moveAllLevelsContainerLeft () {
            if (allLevelsContainer.x < -10) {
                var tween:Tween = new Tween (allLevelsContainer, "x", Strong.easeInOut, allLevelsContainer.x, allLevelsContainer.x + 750, 18 );
            }
        }
        
        private function moveAllLevelsContainerRight () {
            if (Math.abs(allLevelsContainer.x - 750) <= allLevelsContainer.width) {
                var tween:Tween = new Tween (allLevelsContainer, "x", Strong.easeInOut, allLevelsContainer.x, allLevelsContainer.x - 750, 18 );
            }
        }
        
// ANALAZING EXTERNAL DATA
        public function importExternalData (levels:XMLList) {
            // TODO: make level_table to more complex form
            createLevelSelectButtons(levels);
        }
        
        private function createLevelSelectButtons(levels:XMLList):void {
            var btnLevel:GenericLevelButton,
                i:int = 0,
                j:int = 0,
                k:int = 0;
            
            for each ( var level:XML in levels.* ) {
                btnLevel = new GenericLevelButton();
                btnLevel.y = 200 + j * (btnLevel.height + 10);
                btnLevel.x = 110 + stage.width * k + 140 * i++;
                btnLevel.setLabel(level.name);
                btnLevel.setRating(level.rating);
                
                if (level.@locked.toString() == "true") {
                    btnLevel.block();
                }
                
                if ( i == 4 ) {
                    i = 0;
                    j++;
                }
                
                if ( j == 2 ) {
                    i = 0;
                    j = 0;
                    k++;
                }
                
                btnLevel.levelSRC = level.src;
                
                allLevelsContainer.addChild(btnLevel);
            }
        }
        
        public function destroy():void {
            removeEventListener(MouseEvent.CLICK, menuItemClickListener);
        }
    }

}