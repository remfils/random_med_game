package src.interfaces {
	import src.util.Collider;

	public interface GameObject {
		
		// обновляет координаты элемента
		function update ();
		
		// проверяет активен ли элемент
		function isActive ():Boolean;
		
		function getCollider ():Collider;

	}

}