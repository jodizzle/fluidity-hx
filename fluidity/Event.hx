
package fluidity;

import haxe.ds.StringMap;

class Event {

    public var id:String;
    private var attributes:StringMap<Dynamic> = new StringMap<Dynamic>();

    public function new(id:String)
    {
        this.id = id;
    }

    public function setAttribute(attrib:String, value:Dynamic):Event
    {
        attributes.set(attrib,value);
        return this;
    }

    public function getAttribute(attrib:String):Dynamic
    {
        return attributes.get(attrib);
    }
}