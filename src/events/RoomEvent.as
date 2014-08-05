package src.events {
	import flash.events.Event;
	
	public class RoomEvent extends Event {
		public static const EXIT_ROOM_EVENT = "exit_room";

		public function RoomEvent(type:String) {
			super(type);
		}

	}
	
}
