package src {
    import flash.display.DisplayObject;
    import flash.display.MovieClip;
    import flash.display.SimpleButton;
    import flash.display.Sprite;
    import flash.events.MouseEvent;
    import flash.text.TextField;
    import flash.text.TextFormat;
    
    import flash.utils.getQualifiedClassName;

    public class MainMenu extends Sprite {
        private var currentMenu:Sprite;
        private var titleMenuContainer:Sprite;
        private var levelsMenuContainer:Sprite;
        
        public function MainMenu() {
            super();
            
            createBG();
            
            setTitleMenu();
            setLevelsMenu();
            
            switchToMenu("title");
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
            
            createMoveLeftButton();
            createMoveRigthButton();
            createGotoMenuButton();
            createLevelsButtons();
            
            addEventListener(MouseEvent.CLICK, levelItemClickListener);
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
                case "MoveLeft":
            }
        }
        
        private function switchToMenu(menuName:String):void {
            removeAllEventListeners();
            if (currentMenu != null) {
                resetSpritesInMenu();
                removeChild(currentMenu); 
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
        
        private function resetSpritesInMenu():void {
            var i:int = currentMenu.numChildren;
            while (i--) {
                if (currentMenu.getChildAt(i) is MovieClip) {
                    MovieClip(currentMenu.getChildAt(i)).gotoAndStop(1);
                }
                if (currentMenu.getChildAt(i) is SimpleButton) {
                    var sb:SimpleButton = currentMenu.getChildAt(i) as SimpleButton;
                    var tmp_x:Number = sb.x;
                    sb.x = -100;
                }
            }
        }
        
        private function displayMenu(menu:Sprite, clickListener:Function=null):void {
            currentMenu = menu;
            menu.addEventListener(MouseEvent.CLICK, clickListener);
            addChild(menu);
        }
        
        
        /*public function loadLevelsData () {
            levelLoader = new URLLoader(new URLRequest("level_table.xml"));
            levelLoader.addEventListener(Event.COMPLETE, levelDataLoaded);
        }
        
        private function levelDataLoaded(e:Event) {
            var xmlLevels:XMLList = new XMLList(levelLoader.data);
            
            addLevelButtons(xmlLevels.level);
        }
        
        private function addLevelButtons (levels:XMLList) {
            var btnMap:GenericLevelButton,
                i:int = 0,
                j:int = 0,
                k:int = 0;
            
            levelButtonPanel = new Sprite();
            
            for each ( var level:XML in levels ) {
                btnMap = new GenericLevelButton(level.name, level.@rating);
                btnMap.y = 200 + j * (btnMap.height + 10);
                btnMap.x = 110 + stage.width * k + 140*i++;
                
                if (level.@locked.toString() == "true") {
                    btnMap.block();
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
                
                btnMap.addEventListener(MouseEvent.CLICK, createLevelLoadFunction(level.src));
                
                levelButtonPanel.addChild(btnMap);
            }
            
            addChild(levelButtonPanel);
        }
        
        private function createLevelLoadFunction (url:String):Function {
            return function (e:Event) {
                gotoAndStop(1, "Scene 3");
                init(url);
            };
        }
        
        public function setUpLeftRightButtons() {
            var left_btn:SimpleButton = SimpleButton(this.getChildByName("left_btn")),
                right_btn:SimpleButton = SimpleButton(this.getChildByName("right_btn")),
                back_to_menu_btn:SimpleButton = SimpleButton(this.getChildByName("back_to_menu_btn"));
                
            left_btn.addEventListener(MouseEvent.CLICK, moveLevelButtonPanelLeft);
            right_btn.addEventListener(MouseEvent.CLICK, moveLevelButtonPanelRight);
            back_to_menu_btn.addEventListener(MouseEvent.CLICK, backToMainMenu);
        }
        
        private function moveLevelButtonPanelLeft (e:Event) {
            if (levelButtonPanel.x < -10) {
                var tween:Tween = new Tween (levelButtonPanel, "x", Strong.easeInOut, levelButtonPanel.x, levelButtonPanel.x + 750, 18 );
            }
        }
        
        private function moveLevelButtonPanelRight (e:Event) {
            if (Math.abs(levelButtonPanel.x - 750) <= levelButtonPanel.width) {
                var tween:Tween = new Tween (levelButtonPanel, "x", Strong.easeInOut, levelButtonPanel.x, levelButtonPanel.x - 750, 18 );
            }
        }
        
        private function backToMainMenu (e:Event) {
            removeLevelButtons();
            gotoAndStop("main");
        }
        
        private function removeLevelButtons() {
            while (levelButtonPanel.numChildren > 0) {
                levelButtonPanel.removeChild(levelButtonPanel.getChildAt(levelButtonPanel.numChildren-1));
            }
        }*/
        
        public function destroy():void {
            removeEventListener(MouseEvent.CLICK, menuItemClickListener);
        }
    }

}