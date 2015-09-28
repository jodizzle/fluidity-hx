
package fluidity;

import haxe.ds.StringMap;

import evsm.FState;


class Scene<TObj:Object<Dynamic>>{

    public var layer:Layer<TObj>;

    public var active(default,null):Bool = false;

    public var updating:Bool = false;

    public var toAdd:Array<TObj> = [];
    public var toRemove:Array<TObj> = [];
    public var toDelete:Array<TObj> = [];

    public function new()
    {

    }

    public function setLayer(l:Layer<TObj>)
    {
        layer = l;
        // Backend.graphics.sceneLayerSet(this);
        return this;
    }

    // private function __add(obj:TObj)
    // {
    //     if(obj.scene != null)
    //     {
    //         obj.scene.remove(obj);
    //     }
    //     objects.push(obj);
    //     obj.scene = this;

    //     // Backend.graphics.sceneAdd(this,obj);
    //     // Backend.physics.sceneAdd(this,obj);
    //     return this;
    // }

    public function add(obj:TObj)
    {
        toAdd.push(obj);
    }

    // private function __remove(obj:TObj)
    // {
    //     obj.scene = null;
    //     if(objects.remove(obj))
    //     {
    //         // Backend.graphics.sceneRemove(this,obj);
    //         // Backend.physics.sceneRemove(this,obj);
    //     }
    //     return this;
    // }

    // public function remove(obj:TObj)
    // {
    //     toRemove.push(obj);
    // }

    // private function __delete(obj:TObj)
    // {
    //     if(obj != null)
    //     {
    //         if(obj.type != null)
    //         {
    //             obj.type.removeObject(obj);
    //         }
    //         input.delete(obj);
    //         __remove(obj);

    //         // Backend.graphics.objectDispose(obj);
    //         // Backend.physics.objectDispose(obj);
    //     }
    // }

    // public function delete(obj:TObj)
    // {
    //     toDelete.push(obj);
    //     return this;
    // }

    public function update()
    {
        // input.update();
        onUpdate();
        for(obj in objects)
        {
            obj.update();
        }

        // Backend.physics.sceneUpdate(this);
        // Backend.graphics.sceneUpdate(this);

        // for(obj in toAdd)
        // {
        //     __add(obj);
        // }
        // toAdd = [];

        // for(obj in toRemove)
        // {
        //     __remove(obj);
        // }
        // toRemove = [];

        // for(obj in toDelete)
        // {
        //     __delete(obj);
        // }
        // toDelete = [];
        return this;
    }

    public function start()
    {
        active = true;
        
        onStart();

        // Backend.graphics.sceneStart(this);
        // Backend.physics.sceneStart(this);

        return this;
    }

    public function reset()
    {
        while(objects.length > 0)
        {
            // delete(objects[objects.length - 1]);
        }

        // Backend.graphics.sceneReset(this);
        // Backend.physics.sceneReset(this);
        
        // input = new SceneInput();
        onReset();

        return this;
    }

    public function onStart()
    {

    }

    public function onUpdate()
    {

    }

    public function onReset()
    {

    }

    public function processEvent(event:Event)
    {
        for(obj in objects)
        {
            obj.processEvent(event);
        }
        return this;
    }

    public function addGenerator(name:String, ?generatorWithoutArgs:Void->TObj, ?generatorWithArgs:Array<Dynamic>->TObj)
    {
        if(generatorWithoutArgs == null && generatorWithArgs == null)
        {
            trace("No argument given to set generator " + name);
            return this;
        }
        if(generatorWithoutArgs != null && generatorWithArgs != null)
        {
            trace("Too many arguments given to set generator " + name);
            return this;
        }
        if(generatorWithoutArgs != null)
        {
            generatorMap.set(name,function(a:Array<Dynamic>){return generatorWithoutArgs();});
        }
        if(generatorWithArgs != null)
        {
            generatorMap.set(name,generatorWithArgs);
        }
        return this;
    }

    public function generate(name:String, ?args:Array<Dynamic>)
    {
        if(args == null)
        {
            args = [];
        }
        if(generatorMap.exists(name))
        {
            if(active)
            {
                var obj = generatorMap.get(name)(args);
                add(obj);
                return obj;
            }
            else
            {
                trace('Cannot generate objects before this scene has started. Override onStart() and generate objects there. Obj name: ' + name);
            }
        }
        else
        {
            trace('Generator with name ' + name + ' does not exist');
        }
        return null;
    }


    private var objects:Array<TObj> = [];

    private var generatorMap:StringMap<Array<Dynamic>->TObj> = new StringMap<Array<Dynamic>->TObj>();

}