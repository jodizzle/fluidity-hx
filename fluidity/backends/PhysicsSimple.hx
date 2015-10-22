
package fluidity.backends;

import fluidity.backends.simple.*;

import fluidity.GameObject;
import fluidity.Collider;
import nape.geom.Vec2;


class PhysicsSimple implements IPhysicsBackend{ 

    public var scenes:Map<GameScene,PhysicsSimpleScene>;

    public function new()
    {
        clear();
    }

    public function clear()
    {
        scenes = new Map<GameScene,PhysicsSimpleScene>();
    }

    public function newScene(scene:GameScene)
    {
        scenes.set(scene,new PhysicsSimpleScene());
    }

    public function sceneAdd(scene:GameScene,obj:GameObject)
    {
        if(obj.type != null)
        {
            scenes.get(scene).add(obj);
        }
    }

    public function sceneRemove(scene:GameScene,obj:GameObject)
    {
        if(obj.type != null)
        {
            scenes.get(scene).remove(obj);
        }
    }

    public function sceneUpdate(scene:GameScene)
    {
        scenes.get(scene).update();
    }

    public function sceneStart(scene:GameScene)
    {

    }

    public function sceneReset(scene:GameScene)
    {

    }

    public function typeAddCollision(type:ObjectType, otherType:ObjectType)
    {

    }

    public function typeAddInteractionStartEvent(type:ObjectType, eventName:String,otherType:ObjectType)
    { 

    }

    public function typeAddInteractionContinueEvent(type:ObjectType, eventName:String,otherType:ObjectType)
    { 

    }

    public function typeAddInteractionStopEvent(type:ObjectType, eventName:String,otherType:ObjectType)
    {

    }

    public function newObject(obj:GameObject)
    {

    }

    public function objectDispose(obj:GameObject)
    {

    }

    public function objectSet(obj:GameObject,collider:Collider)
    {

    }

    public function objectSetType(obj:GameObject,type:ObjectType)
    {
        if(type != null && obj.scene != null)
        {
            scenes.get(obj.scene).add(obj);
        }
    }

    public function objectChanged(obj:GameObject)
    {

    }

    public function objectUpdate(obj:GameObject)
    {
        obj.position.addeq(obj.velocity);
        obj.angle += obj.angularVelocity;
    }
    
    public function preUpdate():Void{}
    public function postUpdate():Void{}
}