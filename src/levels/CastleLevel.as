﻿package src.levels {
    
    import flash.display.MovieClip;
    import src.Game;
    import src.levels.Room;
    import src.Player;
    import flash.display.Sprite;
    import fl.motion.Color;
    
    
    public class CastleLevel extends Room {
        var wall_color:uint;
        var walls:Sprite;
        
        public function CastleLevel(game:Game) {
            super(game);
            
            walls = new Sprite();
            
            drawWalls();
            
            addChildAt(walls,0);
        }
        
        private function drawWalls() {
            walls.graphics.clear();
            walls.graphics.beginFill(wall_color);
            walls.graphics.drawRect(13,15,723,473);
        }
        
        override public function setParameters (params:Object):void {
            super.setParameters(params);
            if ( params.hasOwnProperty("color") ) {
                wall_color = params.color;
            }
            else wall_color = 0x000000;
            
            drawWalls();
        }
        
    }
    
}
