package src.task {
    
    import src.objects.TaskObject;
    import src.util.Random;
    
    public class Task {
        public var id:uint;
        var answer:uint;

        public function Task(type:String) {
            answer = Random.getOneFromThree();
        }
        
        public function getAnswer():int {
            return answer;
        }
        
        public function makeGuess(taskObject:TaskObject):void {
            if ( taskObject.id == answer ) {
                taskObject.positioveOutcome();
            }
            else {
                taskObject.negativeOutcome();
            }
        }

    }
    
}
