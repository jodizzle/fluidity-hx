
package fluidity.utils;

import haxe.ds.ObjectMap;

class TypeBin<K:{ },V> {

    public var binMap:ObjectMap<K,V> = new ObjectMap<K,V>();

    public var instantiator:K->V;

    public function new(f:K->V)
    {
        instantiator = f;
    }

    public function get(name:K) {
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

    public function remove(key:K)
    {
        binMap.remove(key);
    }
}