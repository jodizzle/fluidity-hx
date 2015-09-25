
package fluidity;

import haxe.ds.StringMap;
import fluidity.input.Touch;
import fluidity.input.Pointer;

class GameEvent {

    public var id:String;
    private var attributes:StringMap<Dynamic> = new StringMap<Dynamic>();

    public function new(id:String,?col:Collision)
    {
        this.id = id;
        collision = col;
    }

    public function setAttribute(attrib:String, value:Dynamic):GameEvent
    {
        attributes.set(attrib,value);
        return this;
    }

    public function getAttribute(attrib:String):Dynamic
    {
        return attributes.get(attrib);
    }
}