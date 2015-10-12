
package fluidity;

import evsm.FState;

import haxe.ds.StringMap;

interface System{

    public var priority:Float;
    public function update(objects:Array<Object>);
    public function newObject(object:Object):Void;

}