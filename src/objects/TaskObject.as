package src.objects {
    import src.interfaces.ActiveObject;
    import src.util.Collider;
	/**
     * ...
     * @author vlad
     */
    public class TaskObject extends Obstacle implements ActiveObject {
        public var id:uint = 0;
        public var taskId:uint = 0;
        
        private var active = true;
        
        public function TaskObject(id:uint) {
            this.id = id;
        }
        
        public function assignToTask(taskId:uint):void {
            this.taskId = taskId;
        }
        
        public function positiveOutcome():void {
            
        }
        
        public function negativeOutcome():void {
            
        }
        
        public function getActiveArea():Collider {
            return new Collider();
        }
        
        public function update() {}
        
        public function isActive():Boolean {
            return active;
        }
        
    }

}