package src.task {
    import flash.events.Event;
    import src.levels.Room;
    import src.objects.TaskObject;
	/**
     * ...
     * @author vlad
     */
    public class TaskManager {
        private var tasks:Array;
        
        public function TaskManager() {
            tasks = new Array();
        }
        
        public function addLeverTaskToRoom(room:Room, id:uint):void {
            var task:Task = new Task(id);
            task.assignToRoom(room);
            tasks.push(task);
        }
        
        public function guessEventListener(e:Event):void {
            var answer:TaskObject = e.target as TaskObject;
            var i:int = tasks.length;
            
            while(i--) {
                if ( tasks[i].id == answer.taskId ) {
                    if ( tasks[i].makeGuess(answer) ) {
                        var task:Task = tasks[i];
                        tasks.splice(i, 1);
                        task.room.assignTask( getNextTaskForRoom(task.room) );
                    }
                    break;
                }
            }
        }
        
        private function getNextTaskForRoom(room:Room):Task {
            for each (var task:Task in tasks ) {
                if ( task.room == room ) return task;
            }
            return null;
        }
        
    }

}