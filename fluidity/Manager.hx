
package fluidity;

import haxe.ds.StringMap;

import evsm.FState;
// import fluidity.ash.AshEngine;


typedef System<TObject,TEvent> = 
    {
        public function update(objects:Array<TObject>):Void;
        public function onAddObject(object:TObject):Void;
        public function onRemoveObject(object:TObject):Void;
        public var priority:Float;
    }

class ManagerSystem<TObject:(Object<TObject,TEvent>),TEvent:(Event<TEvent>)> {
    public function new(p:Float)
    {
        priority = p;
    }
    public function update(objects:Array<TObject>)
    {
        for(obj in objects)
        {
            if(obj.state != null)
            {
                obj.state.update(obj);
            }
        }
    }
    public function onAddObject(object:TObject){}
    public function onRemoveObject(object:TObject){}
    public var priority:Float = 0;
}

class Manager<TObject:(Object<TObject,TEvent>),TEvent:(Event<TEvent>)>{

    public var objects:Array<TObject> = [];
    private var toAdd:Array<TObject> = [];
    private var toRemove:Array<TObject> = [];

    private var systems:Array<System<TObject,TEvent>> = [];

    public function new(evPriority:Float = 0)
    {
        addSystem(new ManagerSystem<TObject,TEvent>(evPriority));
    }

    public function newState(?name:String)
    {
        return new FState<TObject,TEvent>(name);
    }

    public function addSystem(system:System<TObject,TEvent>)
    {
        var inserted = false;
        for(i in 0...(systems.length))
        {
            if(system.priority <= systems[i].priority)
            {
                systems.insert(i,system);
                inserted = true;
                break;
            }
        }
        if(!inserted)
        {
            systems.push(system);
        }
        return this;
    }

    public function addObject(obj:TObject)
    {
        for(system in systems)
        {
            system.onAddObject(obj);
        }
        toAdd.push(obj);
    }

    public function removeObject(obj:TObject)
    {
        for(system in systems)
        {
            system.onRemoveObject(obj);
        }
        toRemove.push(obj);
    }

    public function update()
    {
        applyObjectListChanges();
        for(system in systems)
        {
            system.update(objects);
        }
        applyObjectListChanges();
        return this;
    }

    private function applyObjectListChanges()
    {
        for(obj in toRemove)
        {
            objects.remove(obj);
        }
        toRemove = [];
        objects = objects.concat(toAdd);
        toAdd = [];
    }

}