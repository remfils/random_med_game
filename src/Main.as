﻿package src {

	import flash.events.*;
	import flash.ui.Keyboard;
	import flash.geom.Point;
	
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
		public function Main () {
			super ();
			
			createMainMenu();
		}
		
		private function createMainMenu():void {
			mainMenu = new MainMenu();
			addChild(mainMenu);
		}
	}

}