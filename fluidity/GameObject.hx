
package fluidity;

import evsm.FState;

import haxe.ds.StringMap;

class GameObject{

    public var state:FState<GameObject,GameEvent>;

    public var hasParent:Bool = false;

    public var type:ObjectType;

    public var scene:GameScene;

    public function new()
    {
        // Backend.physics.newObject(this);
    }

    public function processEvent(e:GameEvent)
    {
        if(state != null)
        {
            state.processEvent(this,e);
        }
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

    public function setType(t:ObjectType):GameObject
    {
        if(type != null)
        {
            type.removeObject(this);
        }
        if(t != null)
        {
            t.addObject(this);
        }
        type = t;
        // Backend.physics.objectSetType(this,t);
        return this;
    }

    public function isType(t:ObjectType):Bool
    {
        return (type == t);
    }

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
        // Backend.physics.objectUpdate(this);
        // Backend.graphics.objectUpdate(this);

        if(state != null)
        {
            state.update(this);
        }

        currentAnimationTime += 1;
    }

    // public function addEventTrigger(eventName:String,func:GameObject->Bool)
    // {
    //     eventTriggers.push({eventName: eventName, func: func});
    // }   

    private var attributes:StringMap<Dynamic> = new StringMap<Dynamic>();
    // private var eventTriggers:Array<{eventName:String,func:GameObject->Bool}> = [];

}