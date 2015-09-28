
package fluidity.ash;

import ash.core.Engine;
import ash.core.Entity;

import fluidity.ash.systems.*;
import fluidity.*;

typedef Constructible = {
  public function new():Void;
}

@:generic
class AshEngine<TObj:Constructible>
{
    private var engine:Engine;

    public var generator:Void->Array<Dynamic>;

    public static var systemList:Array<Class<Dynamic>> = [];

    public function new(g:Void->Array<Dynamic>)
    {
        engine = new Engine();

        generator = g;
    }

    public function addSystem()
    {

    }

    public function createObject():TObj
    {
        var entity = new Entity();
        for(component in generator())
        {
            entity.add(component.component,component.componentClass);
        }

        var instance = new TObj();

        entity.add(instance);
        engine.addEntity(entity);
        return instance;
    }

    public function update(dt:Float):Void
    {
        engine.update(dt);
    }
}
