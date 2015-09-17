
package fluidity;

import haxe.ds.StringMap;

import evsm.FState;

import fluidity.input.SceneInput;
import fluidity.backends.Backend;

import fluidity.utils.StringBin;
import fluidity.utils.Vec2;

class GameScene{

    public var layer:GameLayer;

    public var active(default,null):Bool = false;
    public var input:SceneInput;

    public var camera:Vec2 = new Vec2();

    public var cameraScale:Float = 1;

    public var states:StringBin<FState<GameObject,GameEvent>>;

    public function new(?gravity:Vec2)
    {
        input = new SceneInput();

        Backend.physics.newScene(this);
        Backend.graphics.newScene(this);

        states = new StringBin<FState<GameObject,GameEvent>>(function(name:String)
            {
                return new FState<GameObject,GameEvent>(name);
            });
    }

    public function setLayer(l:GameLayer)
    {
        layer = l;
        Backend.graphics.sceneLayerSet(this);
        return this;
    }

    public function add(obj:GameObject)
    {
        if(obj.scene != null)
        {
            obj.scene.remove(obj);
        }
        objects.push(obj);
        obj.scene = this;

        Backend.graphics.sceneAdd(this,obj);
        Backend.physics.sceneAdd(this,obj);
        return this;
    }

    public function remove(obj:GameObject)
    {
        obj.scene = null;
        if(objects.remove(obj))
        {
            Backend.graphics.sceneRemove(this,obj);
            Backend.physics.sceneRemove(this,obj);
        }
        return this;
    }

    public function delete(obj:GameObject)
    {
        if(obj != null)
        {
            input.delete(obj);
            remove(obj);
            Backend.graphics.objectDispose(obj);
            Backend.physics.objectDispose(obj);
        }
        return this;
    }

    public function update()
    {
        input.update();
        onUpdate();
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

        Backend.graphics.sceneStart(this);
        Backend.physics.sceneStart(this);

        return this;
    }

    public function reset()
    {
        while(objects.length > 0)
        {
            delete(objects[objects.length - 1]);
        }
        Backend.graphics.sceneReset(this);
        Backend.physics.sceneReset(this);
        input = new SceneInput();
        onReset();

        active = false;
        camera = new Vec2();

        cameraScale = 1;

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
        // typeMap.set(name,new ObjectType());
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

    // public function setState(s:FState<GameObject,GameEvent>)
    // {
    //     state = s;
    // }

    // public function type(name:String):ObjectType
    // {
    //     if(typeMap.exists(name))
    //     {
    //         return typeMap.get(name);
    //     }
    //     var t = new ObjectType();
    //     typeMap.set(name,t);
    //     return t;
    // }


    private var objects:Array<GameObject> = [];

    private var generatorMap:StringMap<Array<Dynamic>->GameObject> = new StringMap<Array<Dynamic>->GameObject>();

}