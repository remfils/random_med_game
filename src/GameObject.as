package src{

	public interface GameObject {
		
		// обновляет координаты элемента
		function update ();
		
		// проверяет активен ли элемент
		function active ():Boolean;
		
		function getCollider ():Collider;

	}

}