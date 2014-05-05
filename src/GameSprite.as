package  {
	/**
	 * ...
	 * @author vlad
	 */
	public class GameSprite {
		
		public var x, y, width, height, past_x, past_y:Number;
		
		public function GameSprite(X:int, Y:int, width:int, height:int){
			this.past_x = this.x = X;
			this.past_y = this.y = Y;
			this.width = width;
			this.height = height;
		}
		
		public function Render():void{}
		public function Update():void{}
		
	}

}