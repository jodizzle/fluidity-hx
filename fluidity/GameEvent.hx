
package fluidity;

import haxe.ds.StringMap;

class GameEvent {

    public var id:String;
    private var attributes:StringMap<Dynamic> = new StringMap<Dynamic>();
    // public var userData(default,null):Dynamic<Dynamic> = new Dynamic<Dynamic>();

    public var collision:Collision;

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