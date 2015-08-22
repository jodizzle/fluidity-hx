
package fluidity2;

import nape.geom.Vec2;

import haxe.ds.StringMap;

import gtoolbox.Input;

class GameScene{

    public var active(default,null):Bool = false;
    public var input:Input;
    // public var state:FState<GameObject,GameEvent>;

    public function new(?gravity:Vec2)
    {
        input = Backend.input;
        input.reset();
        Backend.physics.newScene(this);
        Backend.graphics.newScene(this);
    }

    public function add(obj:GameObject)
    {
        objects.push(obj);

        Backend.graphics.sceneAdd(this,obj);
        Backend.physics.sceneAdd(this,obj);
        return this;
    }

    public function remove(obj:GameObject)
    {
        if(objects.remove(obj))
        {

            Backend.graphics.sceneRemove(this,obj);
            Backend.physics.sceneRemove(this,obj);
        }
        return this;
    }

    public function update()
    {
        for(obj in objects)
        {
            obj.update();
        }
        Backend.physics.sceneUpdate(this);
        Backend.graphics.sceneUpdate(this);
        return this;
    }

    public function render()
    {
        Backend.graphics.sceneRender(this);
    }

    public function start()
    {
        active = true;
        
        onStart();
        // input.start();
        Backend.graphics.sceneStart(this);
        Backend.physics.sceneStart(this);

        return this;
    }

    public function stop()
    {
        // input.stop();
        Backend.graphics.sceneStop(this);
        Backend.physics.sceneStop(this);
        onStop();

        active = false;

        return this;
    }

    public function onStart()
    {

    }

    public function onStop()
    {

    }

    public function processEvent(event:GameEvent)
    {
        for(obj in objects)
        {
            obj.processEvent(event);
        }
        return this;
    }

    public function addGenerator(name:String, ?generatorWithoutArgs:Void->GameObject, ?generatorWithArgs:Array<Dynamic>->GameObject)
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
        typeMap.set(name,new ObjectType());
        return this;
    }

    public function addInteractionStartListener(name:String, type1:ObjectType, type2:ObjectType)
    {
        Backend.physics.typeAddInteractionStartEvent(type1,name,type2);
    }

    public function addInteractionStopListener(name:String, type1:ObjectType, type2:ObjectType)
    {
        Backend.physics.typeAddInteractionStopEvent(type1,name,type2);
    }

    public function generate(name:String, ?args:Array<Dynamic>)
    {
        if(args == null)
        {
            args = [];
        }

        if(active)
        {
            var obj = generatorMap.get(name)(args);
            add(obj);
            typeMap.get(name).addObject(obj);
            return obj;
        }
        else
        {
            trace('Cannot generate objects before this scene has started. Override onStart() and generate objects there. Obj name: ' + name);
            return null;
        }
    }

    // public function setState(s:FState<GameObject,GameEvent>)
    // {
    //     state = s;
    // }

    public function type(name:String):ObjectType
    {
        if(typeMap.exists(name))
        {
            return typeMap.get(name);
        }
        var t = new ObjectType();
        typeMap.set(name,t);
        return t;
    }

    private var typeMap:StringMap<ObjectType> = new StringMap<ObjectType>();

    private var objects:Array<GameObject> = [];

    // private var graphics:IGraphics;
    // private var physics:IPhysics;

    private var generatorMap:StringMap<Array<Dynamic>->GameObject> = new StringMap<Array<Dynamic>->GameObject>();

}