package fluidity2.backends;

import fluidity2.GameObject;
import fluidity2.Collider;

import nape.geom.Vec2;

class SimplePhysicsBackend implements IPhysicsBackend{ 

    public var scenes:Map<GameScene,SimplePhysicsScene>;
    public var objects:Map<GameObject,SimplePhysicsObject>;

    public var simplePhysicsTypes:Map<ObjectType,SimplePhysicsType>;

    public function new()
    {
        clear();
    }

    public function clear()
    {
        scenes = new Map<GameScene,SimplePhysicsScene>();
        objects = new Map<GameObject,SimplePhysicsObject>();

        simplePhysicsTypes = new Map<ObjectType,SimplePhysicsType>();
    }

    public function newScene(scene:GameScene)
    {
        scenes.set(scene,new SimplePhysicsScene());
    }

    public function sceneAdd(scene:GameScene,obj:GameObject)
    {
        scenes.get(scene).add(objects.get(obj));
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

    public function sceneStop(scene:GameScene)
    {

    }

    public function typeAddInteractionStartEvent(type:ObjectType, eventName:String,otherType:ObjectType)
    { 
        getSimplePhysicsType(type).sensorTypes.set(getSimplePhysicsType(otherType),eventName);
    }

    public function typeAddInteractionStopEvent(type:ObjectType, eventName:String,otherType:ObjectType)
    {
        // getSimplePhysicsType(type).addTypeStartEvent(eventName,otherType);
    }

    // public function sceneAddCollision(scene:GameScene,?eventName:String,type:ObjectType,otherType:ObjectType,?verifier:Collision->Bool);
    
    // public function sceneRemoveCollision(type:ObjectType,otherType:ObjectType);

    public function newObject(obj:GameObject)
    {
        objects.set(obj,{gameObject:obj,collider:None,type:null});
    }

    public function objectSet(obj:GameObject,collider:Collider)
    {
        objects.get(obj).collider = collider;
    }

    public function objectAddType(obj:GameObject,type:ObjectType)
    {
        var spType = getSimplePhysicsType(type);

        objects.get(obj).type = spType;
        spType.objects.push(objects.get(obj));
    }

    // public function objectRemoveType(obj:GameObject,type:ObjectType)
    // {
    //     objects.get(obj).body.simplePhysicsTypes.remove(getSimplePhysicsType(type));
    // }

    public function objectChanged(obj:GameObject)
    {
        // objects.get(obj).readObject();
    }

    public function objectUpdate(obj:GameObject)
    {
        obj.position.addeq(obj.velocity);
    }

    public function getSimplePhysicsType(type:ObjectType):SimplePhysicsType
    {
        if(!simplePhysicsTypes.exists(type))
        {
            simplePhysicsTypes.set(type,{
                                objects:new Array<SimplePhysicsObject>(),
                                sensorTypes:new Map<SimplePhysicsType,String>(),
                                collisionTypes: new Array<SimplePhysicsType>()
                            });
        }
        return simplePhysicsTypes.get(type);
    }
}