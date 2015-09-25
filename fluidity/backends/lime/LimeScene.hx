
package fluidity.backends.lime;

import lime.graphics.opengl.*;

import lime.utils.GLUtils;
import lime.utils.Float32Array;

import fluidity.GameObject;
import fluidity.GameScene;

class LimeScene{

    // public var graphicList

    public var graphicIdMap:Map<String,GraphicsLimeObject> = new Map<String,GraphicsLimeObject>();

    var sortNeeded = false;

    public function new()
    {

    }

    public static inline function getId(graphic:Graphic)
    {
        return switch (graphic) {
                case Image(f): f;
                case SpriteSheet(f,_,_,_,_,_): f;
         };
    }

    public function render()
    {

    }

    public function add(obj:GameObject)
    {
        var id = getId(obj.graphic);
        if(!graphicIdMap.exists(id))
        {
            graphicIdMap.set(id,new GraphicsLimeObject(id));
        }
        graphicIdMap.get(id).add(obj);
    }

    public function objectUpdate(obj:GameObject)
    {
    }

    public function remove(obj:GameObject)
    {
        var kek = getId(obj.graphic);
        var kek2 = graphicIdMap.get(kek);
        kek2.remove(obj);
    }
}