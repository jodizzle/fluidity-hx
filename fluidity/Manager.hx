
package fluidity;

import haxe.ds.StringMap;

import evsm.FState;
import fluidity.ash.AshEngine;

class Manager<TObject:(Object<TObject,TEvent>),TEvent:(Event<TEvent>)>{

    public var objects:Array<TObject> = [];
    private var toRemove:Array<TObject> = [];

    private var systems:Array<{f:Array<TObject>->Void,p:Int}> = [];

    public function new(evPriority:Int = 0)
    {
        addSystem(function(objs:Array<TObject>)
            {
                for(obj in objs)
                {
                    if(obj.state != null)
                    {
                        obj.state.update();
                    }
                }
            }, evPriority);
    }

    public function addSystem(func:Array<TObject> -> Void, priority:Float)
    {
        var inserted = false;
        for(i in 0...(systems.length))
        {
            if(priority <= systems[i].p)
            {
                systems.insert(i,{f:func,p:priority});
                inserted = true;
                break;
            }
        }
        if(!inserted)
        {
            system.push({f:func,p:priority});
        }
    }

    public function addObject(obj:TObject)
    {
        objects.push(obj);
    }

    public function removeObject(obj:TObject)
    {
        toRemove.push(obj);
    }

    public function update()
    {
        for(system in systems)
        {
            system(objects);
        }
        return this;
    }

}