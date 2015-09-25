
package fluidity;
 
class ObjectType{

    public var objects:Array<GameObject> = new Array<GameObject>();

    public function new() {};

    public function addObject(obj:GameObject)
    {
        objects.push(obj);
        obj.type = this;
    }

    public function removeObject(obj:GameObject)
    {
        if(obj.type == this)
        {
            objects.remove(obj);
            obj.type = null;
        }
    }
}