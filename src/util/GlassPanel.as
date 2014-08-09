package src.util {
	import src.stats.PlayerStat;
	import src.Player;
	import flash.display.Sprite;
	import src.levels.Level;
	
	public class GlassPanel extends Sprite {
		var _gameObjects:Array;
		var displayObjects:Array;
		var newObjects:Array;
		var _player:Player;
		var _level:Level;
		var i:int;
		var deltaY:Number;
		var active = true;

		public function GlassPanel() {
			deltaY = PlayerStat.getInstance().height;
			_player = Player.getInstance();
			displayObjects = new Array();
			newObjects = new Array();
		}
		
		public function setCurrentLevel(cLevel:Level) {
			//clear();
			active = true;
			_level = cLevel;
			_gameObjects = cLevel.getGameObjects();
		}
		
		public function setGameObjects(gameObjects:Array) {
			_gameObjects = gameObjects;
		}
		
		public function update() {
			if (!active) return;
			
			i = _gameObjects.length;
			
			while(i--){
				if ( _gameObjects[i].y + deltaY > _player.y) {
					if ( displayObjects.indexOf(_gameObjects[i]) == -1 ) {
						displayObjects[i] = _gameObjects[i];
						newObjects.push(_gameObjects[i]);
					}
				}
				else {
					if ( displayObjects.indexOf(_gameObjects[i]) != -1 ) {
						_level.addChild(displayObjects[i]);
						displayObjects[i] = null;
					}
				}
			}
			
			addNewObjects();
		}
		
		public function addNewObjects() {
			var i = newObjects.length;
			
			while(i--) {
				addChild(newObjects[i]);
				newObjects.pop();
			}
		}
		
		public function clear() {
			while (displayObjects.length) {
				displayObjects.pop();
			}
			
			while (numChildren > 0) {
				_level.addChild(getChildAt(numChildren-1));
			}
			
			active = false;
		}

	}
	
}
