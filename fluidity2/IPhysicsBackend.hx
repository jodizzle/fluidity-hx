package fluidity2;

import fluidity2.GameObject;

interface IPhysicsBackend { 

    public function newScene(scene:GameScene):Void;
    public function sceneAdd(scene:GameScene,obj:GameObject):Void;
    public function sceneRemove(scene:GameScene,obj:GameObject):Void;
    public function sceneUpdate(scene:GameScene):Void;
    public function sceneStart(scene:GameScene):Void;
    public function sceneStop(scene:GameScene):Void;

    public function typeAddInteractionStartEvent(type:ObjectType,eventName:String,otherType:ObjectType):Void;
    public function typeAddInteractionStopEvent(type:ObjectType,eventName:String,otherType:ObjectType):Void;
    // public function sceneAddCollision(scene:GameScene,type:ObjectType,otherType:ObjectType,?verifier:Collision->Bool):Void;
    // public function sceneRemoveCollision(scene:GameScene,type:ObjectType,otherType:ObjectType):Void;

    public function newObject(obj:GameObject):Void;
    public function objectSet(obj:GameObject,collider:Collider):Void;
    public function objectAddType(obj:GameObject,type:ObjectType):Void;
    public function objectDispose(obj:GameObject):Void;
    // public function objectRemoveType(obj:GameObject,type:ObjectType):Void;
    // public function objectAddChild(obj:GameObject,child:GameObject):Void;
    // public function objectRemoveChild(obj:GameObject,child:GameObject):Void;
    public function objectChanged(obj:GameObject):Void;
    public function objectUpdate(obj:GameObject):Void;
}