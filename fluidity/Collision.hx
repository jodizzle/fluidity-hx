
package fluidity;
 
import fluidity.utils.Vec2;
 
class Collision{

    public var obj1:GameObject;
    public var obj2:GameObject;

    public var normal:Vec2;

    public function new(o1,o2,?n)
    {
        obj1 = o1;
        obj2 = o2;
        normal = n;
    };
}