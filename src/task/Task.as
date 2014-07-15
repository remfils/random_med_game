package src.task {
	
	public class Task {
		private var completeFun:Function;

		public function Task( onComplete:Function ) {
			completeFun = onComlete;
		}
		
		public function Complete () {
			completeFun();
		}

	}
	
}
