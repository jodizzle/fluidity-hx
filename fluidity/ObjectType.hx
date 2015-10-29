
package fluidity;

import fluidity.backends.Backend;
 
class ObjectType{

    public var objects:Array<GameObject> = new Array<GameObject>();
    public var startInteractionEvents:Map<ObjectType,String> = new Map<ObjectType,String>();
    public var continueInteractionEvents:Map<ObjectType,String> = new Map<ObjectType,String>();
    public var stopInteractionEvents:Map<ObjectType,String> = new Map<ObjectType,String>();
    public var collisionTypes:Array<ObjectType> = [];

    public function new() {};

    public function addObject(obj:GameObject)
    {
        objects.push(obj);
        obj.type = this;
    }

    public function removeObject(obj:GameObject)
    {
        if(obj.type == this)
        {
            objects.remove(obj);
            obj.type = null;
        }
    }

    // public function collides(other:ObjectType)
    // {
    //     // trace(collisionTypes.length);
    //     return collisionTypes.indexOf(other) >= 0;
    // }

    public function addCollision(other:ObjectType)
    {
        collisionTypes.push(other);
        Backend.physics.typeAddCollision(this,other);
        return this;
    }

    public function addCollisionStartEvent(eventName:String,other:ObjectType)
    {
        startInteractionEvents.set(other,eventName);
        if(collisionTypes.indexOf(other) < 0)
        {
            collisionTypes.push(other);
        }
        Backend.physics.typeAddInteractionStartEvent(this,eventName,other);
        return this;
    }

    // public function addCollisionContinueEvent(eventName:String,other:ObjectType)
    // {
    //     continueInteractionEvents.set(other,eventName);
    //     if(collisionTypes.indexOf(other) < 0)
    //     {
    //         collisionTypes.push(other);
    //     }
    //     Backend.physics.typeAddInteractionContinueEvent(this,eventName,other);
    //     return this;
    // }

    public function addCollisionStopEvent(eventName:String,other:ObjectType)
    {
        startInteractionEvents.set(other,eventName);
        if(collisionTypes.indexOf(other) < 0)
        {
            collisionTypes.push(other);
        }
        Backend.physics.typeAddInteractionStartEvent(this,eventName,other);
        return this;
    }
}