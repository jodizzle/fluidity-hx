
package fluidity;
 
import fluidity.utils.Vec2;
 
class Collision{

    public var obj:GameObject;

    public var normal:Vec2;

    public function new(o,n)
    {
        obj = o;
        normal = n;
    };
}