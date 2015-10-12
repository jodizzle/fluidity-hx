
package fluidity;

import evsm.FState;

import haxe.ds.StringMap;

@:autoBuild(fluidity.macro.Macro.build())
class Object<TObject:(Object<TObject,TEvent>),TEvent:(Event<TEvent>)>{

    public var state:FState<TObject,TEvent>;

    public function new()
    {

    }

    public function processEvent(e:TEvent)
    {
        if(state != null)
        {
            state.processEvent(cast this,e);
        }
        return this;
    }

    public function setState(s:FState<TObject,TEvent>,event:TEvent):TObject
    {
        if(state == null)
        {
            state = new FState<TObject,TEvent>();
        }
        state.switchTo(cast this,s,event);
        return cast this;
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

    private var attributes:StringMap<Dynamic> = new StringMap<Dynamic>();

}