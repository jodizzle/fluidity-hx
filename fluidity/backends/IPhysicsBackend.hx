package fluidity.backends;

import fluidity.GameObject;

interface IPhysicsBackend { 

    public function newScene(scene:GameScene):Void;
    public function sceneAdd(scene:GameScene,obj:GameObject):Void;
    public function sceneRemove(scene:GameScene,obj:GameObject):Void;
    public function sceneUpdate(scene:GameScene):Void;
    public function sceneStart(scene:GameScene):Void;
    public function sceneReset(scene:GameScene):Void;

    public function typeAddCollision(type:ObjectType,otherType:ObjectType):Void;

    public function typeAddInteractionStartEvent(type:ObjectType,eventName:String,otherType:ObjectType):Void;
    // public function typeAddInteractionContinueEvent(type:ObjectType,eventName:String,otherType:ObjectType):Void;
    public function typeAddInteractionStopEvent(type:ObjectType,eventName:String,otherType:ObjectType):Void;

    public function newObject(obj:GameObject):Void;
    public function objectSet(obj:GameObject,collider:Collider):Void;
    public function objectSetType(obj:GameObject,type:ObjectType):Void;
    public function objectDispose(obj:GameObject):Void;
    // public function objectRemoveType(obj:GameObject,type:ObjectType):Void;
    // public function objectAddChild(obj:GameObject,child:GameObject):Void;
    // public function objectRemoveChild(obj:GameObject,child:GameObject):Void;
    public function objectChanged(obj:GameObject):Void;
    public function objectUpdate(obj:GameObject):Void;

    public function preUpdate():Void;
    public function postUpdate():Void;
}