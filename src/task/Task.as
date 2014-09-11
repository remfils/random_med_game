package src.task {
    
    import src.levels.Room;
    import src.objects.TaskObject;
    import src.util.Random;
    
    public class Task {
        public var room:Room;
        public var id:uint;
        var answer:uint;

        public function Task(id:uint) {
            answer = Random.getOneFromThree();
            this.id = id;
        }
        
        public function assignToRoom(room:Room):void {
            this.room = room;
            if ( !room.hasTask() ) room.assignTask(this);
        }
        
        public function getAnswer():int {
            return answer;
        }
        
        public function makeGuess(taskObject:TaskObject):Boolean {
            if ( taskObject.id == answer ) {
                taskObject.positiveOutcome();
                return true;
            }
            else {
                taskObject.negativeOutcome();
                return false;
            }
        }

    }
    
}
