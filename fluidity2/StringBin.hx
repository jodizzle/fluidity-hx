
package fluidity2;

class StringBin<V> {

    public var binMap:Map<String,V> = new Map<String,V>();

    public var instantiator:String->V;

    public function new(f:String->V)
    {
        instantiator = f;
    }

    public function get(name:String) {
        if(binMap.exists(name))
        {
            return binMap.get(name);
        }
        else
        {
            var obj = instantiator(name);
            binMap.set(name,obj);
            return obj;
        }
    }

    public function remove(key:String)
    {
        binMap.remove(key);
    }
}