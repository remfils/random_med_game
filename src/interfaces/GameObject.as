package src.interfaces {
    import Box2D.Dynamics.b2Body;
    import Box2D.Dynamics.b2World;
    import src.util.Collider;

    public interface GameObject {
        
        // обновляет координаты элемента
        function update ();
        
        // проверяет активен ли элемент
        function isActive ():Boolean;
        // @TODO: make getBody
        function createBodyFromCollider (world:b2World):b2Body;

    }

}