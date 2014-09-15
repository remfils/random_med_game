package src.ui.playerStat {
    import flash.display.Sprite;
    
    public class Bar extends Sprite {
        private var PointClass:Class;
        private var totalPoints:uint;
        private var points:Array;
        
        public var pointsLeftPadding:Number = 3;
        
        public function Bar(pointClass:Class, totalPoints:uint) {
            PointClass = pointClass;
            this.totalPoints = totalPoints;
            points = new Array();
            
            redraw();
        }
        
        public function redraw():void {
            clear();
            
            var i:int = totalPoints;
            
            while ( i-- ) {
                var point = new PointClass();
                point.x = (point.width + pointsLeftPadding) * i;
                addChild(point);
                points.push(point);
            }
        }
        
        private function clear():void {
            while ( numChildren ) {
                removeChildAt(numChildren - 1);
            }
        }
        
        public function removePoints(pointsToRemove:uint):void {
            if ( pointsToRemove == 2 ) {
                for ( i = 0; i < points.length; i++ ) {
                    if ( points[i].isActive() ) {
                        if ( StatPoint(points[i]).isHalfHit ) {
                            pointsToRemove = 1;
                        }
                        StatPoint(points[i]).makeFullHit();
                        
                        break;
                    }
                }
            }
            
            if ( pointsToRemove == 1 ) {
                for ( var i = 0; i < points.length; i++ ) {
                    if ( points[i].isActive() ) {
                        StatPoint(points[i]).makeHalfHit();
                        break;
                    }
                }
            }
        }

    }
    
}
