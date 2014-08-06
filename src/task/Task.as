package src.task {
	
	import src.util.Random;
	
	public class Task {
		var answer:int;

		public function Task(type:String) {
			answer = Random.getOneFromThree();
		}
		
		public function getAnswer():int {
			return answer;
		}

	}
	
}
