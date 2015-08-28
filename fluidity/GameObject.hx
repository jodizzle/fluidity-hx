
package fluidity;

import evsm.FState;

import haxe.ds.StringMap;
 
import fluidity.utils.Vec2;
import fluidity.backends.Backend;

class GameObject{

    public var state:FState<GameObject,GameEvent>;

    public var position:Vec2 = new Vec2(0,0);
    public var velocity:Vec2 = new Vec2(0,0);

    public var angle:Float = 0;
    public var angularVelocity:Float = 0;

    public var parent:GameObject;
    public var hasParent:Bool = false;

    public var z:Float = 1;
    public var scale:Float = 1;

    public var physicsManaged = false;

    public var currentAnimationTime = 0;

    public var type:ObjectType;

    public var graphic:Graphic;

    public var flip:Bool = false;

    // public var scene:Scene;

    public function new()
    {
        Backend.physics.newObject(this);
    }

    public function processEvent(e:GameEvent)
    {
        state.processEvent(this,e);
        return this;
    }

    public function setX(x:Float):GameObject
    {
        position.x = x;
        Backend.physics.objectChanged(this);
        return this;
    }

    public function setY(y:Float):GameObject
    {
        position.y = y;
        Backend.physics.objectChanged(this);
        return this;
    }

    public function setAngle(r:Float):GameObject
    {
        angle = r;
        Backend.physics.objectChanged(this);
        return this;
    }

    public function translateX(x:Float):GameObject
    {
        position.x += x;
        Backend.physics.objectChanged(this);
        return this;
    }

    public function translateY(y:Float):GameObject
    {
        position.y += y;
        Backend.physics.objectChanged(this);
        return this;
    }

    public function translate(v:Vec2):GameObject
    {
        position.add(v);
        Backend.physics.objectChanged(this);
        return this;
    }
    public function rotate(r:Float):GameObject
    {
        angle += r;
        Backend.physics.objectChanged(this);
        return this;
    }

    public function setVelocityX(x:Float):GameObject
    {
        velocity.x = x;
        Backend.physics.objectChanged(this);
        return this;
    }

    public function setVelocityY(y:Float):GameObject
    {
        velocity.y = y;
        Backend.physics.objectChanged(this);
        return this;
    }

    public function setAngularVel(r:Float):GameObject
    {
        angularVelocity = r;
        return this;
    }

    public function setPosition(v:Vec2):GameObject
    {
        position.set(v.copy());
        Backend.physics.objectChanged(this);
        return this;
    }

    public function setVelocity(v:Vec2):GameObject
    {
        velocity.set(v);
        Backend.physics.objectChanged(this);
        return this;
    }

    public function setZ(z:Float):GameObject
    {
        this.z = z;
        Backend.physics.objectChanged(this);
        return this;
    }
    public function setScale(s:Float):GameObject
    {
        scale = s;
        Backend.physics.objectChanged(this);
        return this;
    }

    public function setAttribute(attrib:String, value:Dynamic):GameObject
    {
        attributes.set(attrib,value);
        return this;
    }

    public function getAttribute(attrib:String):Dynamic
    {
        return attributes.get(attrib);
    }

    public function setGraphic(g:Graphic):GameObject
    {
        Backend.graphics.objectSet(this,g);
        return this;
    }

    public function setCollider(collider:Collider):GameObject
    {
        Backend.physics.objectSet(this,collider);
        return this;
    }

    public function addType(type:ObjectType):GameObject
    {
        type.addObject(this);
        Backend.physics.objectAddType(this,type);
        return this;
    }

    // public function removeType(type:ObjectType):GameObject
    // {
    //     type.removeObject(this);
    //     Backend.physics.objectRemoveType(this,type);
    //     return this;
    // }

    public function isType(t:ObjectType):Bool
    {
        return (type == t);
    }

    // public function addChild(obj:GameObject)
    // {
    //     obj.parent = this;

    //     children.push(obj);

    //     Backend.graphics.objectAddChild(this,obj);
    //     Backend.physics.objectAddChild(this,obj);
    // }

    // public function removeChild(obj:GameObject)
    // {
    //     if(children.contains(obj))
    //     {
    //         obj.parent = null;
            
    //         children.remove(obj);

    //         Backend.graphics.objectRemoveChild(this,obj);
    //         Backend.physics.objectRemoveChild(this,obj);
    //     }
    // }

    public function setState(s:FState<GameObject,GameEvent>)
    {
        if(state == null)
        {
            state = new FState<GameObject,GameEvent>();
        }
        state.switchTo(this,s,new GameEvent(""));
        return this;
    }

    public function update()
    {
        state.update(this);

        Backend.physics.objectUpdate(this);
        Backend.graphics.objectUpdate(this);

        currentAnimationTime += 1;
    }

    // public function dispose()
    // {
    //     Backend.physics.objectDispose(this);
    //     Backend.graphics.objectDispose(this);
    // }

    public function addEventTrigger(eventName:String,func:GameObject->Bool)
    {
        eventTriggers.push({eventName: eventName, func: func});
    }   

    private var attributes:StringMap<Dynamic> = new StringMap<Dynamic>();
    private var eventTriggers:Array<{eventName:String,func:GameObject->Bool}> = [];
    // private var children:Array<GameObject> = [];

}