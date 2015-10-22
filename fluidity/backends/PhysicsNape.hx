
package fluidity.backends;

import fluidity.backends.nape.*;
import fluidity.backends.simple.*;

import fluidity.GameObject;
import fluidity.Collider;
// import nape.geom.Vec2;

import nape.space.Space;
import nape.geom.Vec2;
import nape.callbacks.*;


class PhysicsNape implements IPhysicsBackend{ 

    public var scenes:Map<GameScene,Space> = new Map<GameScene,Space>();
    public var objects:Map<GameObject,NapeObject> = new Map<GameObject,NapeObject>();

    public static var sensorCbType:CbType = new CbType();

    public function new()
    {

    }

    public function newScene(scene:GameScene)
    {
        var space = new Space();
        space.listeners.add(new InteractionListener(CbEvent.BEGIN, InteractionType.SENSOR, sensorCbType, sensorCbType, beginHandler));
        space.listeners.add(new InteractionListener(CbEvent.END, InteractionType.SENSOR, sensorCbType, sensorCbType, beginHandler));
        space.listeners.add(new InteractionListener(CbEvent.BEGIN, InteractionType.COLLISION, CbType.ANY_BODY, CbType.ANY_BODY, beginHandler));
        space.listeners.add(new InteractionListener(CbEvent.END, InteractionType.COLLISION, CbType.ANY_BODY, CbType.ANY_BODY, beginHandler));
        space.listeners.add(new PreListener(InteractionType.COLLISION, CbType.ANY_BODY, CbType.ANY_BODY, preHandler));
        scenes.set(scene,space);
    }

    function beginHandler(cb:InteractionCallback):Void
    {
        // var firstObject:Interactor = cb.int1;
        // var secondObject:Interactor = cb.int2;
    }

    function preHandler(cb:PreCallback):PreFlag {
        if (Math.random() < 0.5)
        {
            return PreFlag.IGNORE_ONCE;
        }
        else
        {
            return null;
        }
    }

    public function sceneAdd(scene:GameScene,obj:GameObject)
    {
        if(obj.collider != null && obj.type == null)
        {
            objects.set(obj,new NapeObject(obj));
            scenes.get(scene).bodies.add(objects.get(obj).body);
        }
    }

    public function sceneRemove(scene:GameScene,obj:GameObject)
    {
        if(objects.get(obj) == null)
        {
            objects.set(obj,new NapeObject(obj));
            scenes.get(scene).bodies.remove(objects.get(obj).body);
            objects.remove(obj);
        }
    }

    public function sceneUpdate(scene:GameScene)
    {
        scenes.get(scene).step(1/60);
        for(obj in objects)
        {
            obj.update();
        }
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

    }

    public function objectChanged(obj:GameObject)
    {
        var napeObj = objects.get(obj);
        if(napeObj != null)
        {
            napeObj.read();
        }
        else
        {
            obj.position.addeq(obj.velocity);
        }
    }

    public function objectUpdate(obj:GameObject)
    {

    }
    
    public function preUpdate():Void{}
    public function postUpdate():Void{}
}