
package fluidity.backends;

import fluidity.backends.simple.*;

import fluidity.GameObject;
import fluidity.Collider;
import fluidity.utils.Vec2;


class PhysicsSimple implements IPhysicsBackend{ 

    public var scenes:Map<GameScene,PhysicsSimpleScene>;
    public var objects:Map<GameObject,PhysicsSimpleObject>;

    public var simpleTypes:Map<ObjectType,SimpleType>;

    public function new()
    {
        clear();
    }

    public function clear()
    {
        scenes = new Map<GameScene,PhysicsSimpleScene>();
        objects = new Map<GameObject,PhysicsSimpleObject>();

        simpleTypes = new Map<ObjectType,SimpleType>();
    }

    public function newScene(scene:GameScene)
    {
        scenes.set(scene,new PhysicsSimpleScene());
    }

    public function sceneAdd(scene:GameScene,obj:GameObject)
    {
        if(obj.type != null)
        {
            scenes.get(scene).add(objects.get(obj));
        }
    }

    public function sceneRemove(scene:GameScene,obj:GameObject)
    {
        scenes.get(scene).remove(objects.get(obj));
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

    public function typeAddInteractionStartEvent(type:ObjectType, eventName:String,otherType:ObjectType)
    { 
        getSimpleType(type).sensorTypes.set(getSimpleType(otherType),eventName);
    }

    public function typeAddInteractionStopEvent(type:ObjectType, eventName:String,otherType:ObjectType)
    {
        // getSimpleType(type).addTypeStartEvent(eventName,otherType);
    }

    // public function sceneAddCollision(scene:GameScene,?eventName:String,type:ObjectType,otherType:ObjectType,?verifier:Collision->Bool);
    
    // public function sceneRemoveCollision(type:ObjectType,otherType:ObjectType);

    public function newObject(obj:GameObject)
    {
        objects.set(obj,{gameObject:obj,collider:None,type:null});
    }

    public function objectDispose(obj:GameObject)
    {
        objects.remove(obj);
    }

    public function objectSet(obj:GameObject,collider:Collider)
    {
        objects.get(obj).collider = collider;
    }

    public function objectAddType(obj:GameObject,type:ObjectType)
    {
        var spType = getSimpleType(type);

        objects.get(obj).type = spType;
        spType.objects.push(objects.get(obj));
        if(obj.scene != null)
        {
            scenes.get(obj.scene).add(objects.get(obj));
        }
    }

    // public function objectRemoveType(obj:GameObject,type:ObjectType)
    // {
    //     objects.get(obj).body.simpleTypes.remove(getSimpleType(type));
    // }

    public function objectChanged(obj:GameObject)
    {
        // objects.get(obj).readObject();
    }

    public function objectUpdate(obj:GameObject)
    {
        obj.position.addeq(obj.velocity);
        obj.angle += obj.angularVelocity;
    }

    public function getSimpleType(type:ObjectType):SimpleType
    {
        if(!simpleTypes.exists(type))
        {
            simpleTypes.set(type,{
                                objects:new Array<PhysicsSimpleObject>(),
                                sensorTypes:new Map<SimpleType,String>(),
                                collisionTypes: new Array<SimpleType>()
                            });
        }
        return simpleTypes.get(type);
    }
    
    public function preUpdate():Void{}
    public function postUpdate():Void{}
}