﻿package src.enemy {
    import Box2D.Common.Math.b2Vec2;
    import Box2D.Dynamics.b2Body;
    import Box2D.Dynamics.Joints.b2MouseJoint;
    import Box2D.Dynamics.Joints.b2MouseJointDef;
    
    public class FlyingEnemy extends Enemy {
        private var leashJoint:b2MouseJoint;
        private var target:b2Body;
        
        private var jointDef:b2MouseJointDef;
        
        public function FlyingEnemy() {
            super();
            agroDistance = 230;
        }
        
        protected function defineJoint():void {
            jointDef = new b2MouseJointDef();
            jointDef.bodyA = this.body.GetWorld().GetGroundBody();
            jointDef.bodyB = this.body;
            jointDef.target = this.body.GetPosition();
            jointDef.maxForce = 20 * this.body.GetMass();
            jointDef.dampingRatio = 1;
            jointDef.collideConnected = true;
        }
        
        override public function update():void {
            super.update();
            
            if ( isActive() ) {
                if ( leashJoint ) {
                    leashJoint.SetTarget(target.GetPosition());
                }
                else {
                    createLeashJoint();
                }
            }
            else {
                if ( leashJoint ) {
                    destroyLeashJoint();
                }
            }
        }
        
        public function setTarget(body:b2Body):void {
            target = body;
        }
        
        private function createLeashJoint():void {
            if (!jointDef) defineJoint();
            
            leashJoint = this.body.GetWorld().CreateJoint(jointDef) as b2MouseJoint;
            leashJoint.SetTarget(target.GetPosition());
        }
        
        private function destroyLeashJoint():void {
            body.GetWorld().DestroyJoint(leashJoint);
            leashJoint = null;
        }
    }
    
}
