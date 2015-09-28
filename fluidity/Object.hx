
package fluidity;

import evsm.FState;

import haxe.ds.StringMap;

class Object<TObject:(Object<Dynamic>)>{

    public var state:FState<TObject,Event>;

    // public var type:ObjectType;

    public var scene:Scene<TObject>;

    public function new()
    {
        // Backend.physics.newObject(this);
    }

    public function processEvent(e:Event)
    {
        if(state != null)
        {
            state.processEvent(cast this,e);
        }
        return this;
    }

    public function setAttribute(attrib:String, value:Dynamic):TObject
    {
        attributes.set(attrib,value);
        return cast this;
    }

    public function getAttribute(attrib:String):Dynamic
    {
        return attributes.get(attrib);
    }

    // public function setType(t:ObjectType):Object
    // {
    //     if(type != null)
    //     {
    //         type.removeObject(this);
    //     }
    //     if(t != null)
    //     {
    //         t.addObject(this);
    //     }
    //     type = t;
    //     // Backend.physics.objectSetType(this,t);
    //     return this;
    // }

    // public function isType(t:ObjectType):Bool
    // {
    //     return (type == t);
    // }

    public function setState(s:FState<TObject,Event>):TObject
    {
        if(state == null)
        {
            state = new FState<TObject,Event>();
        }
        state.switchTo(cast this,s,new Event(""));
        return cast this;
    }

    public function update()
    {
        // Backend.physics.objectUpdate(this);
        // Backend.graphics.objectUpdate(this);

        if(state != null)
        {
            state.update(cast this);
        }
    }

    // public function addEventTrigger(eventName:String,func:Object->Bool)
    // {
    //     eventTriggers.push({eventName: eventName, func: func});
    // }   

    private var attributes:StringMap<Dynamic> = new StringMap<Dynamic>();
    // private var eventTriggers:Array<{eventName:String,func:Object->Bool}> = [];

}