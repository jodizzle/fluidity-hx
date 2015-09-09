
package fluidity.backends.lime;

import lime.graphics.opengl.*;

import lime.utils.GLUtils;
import lime.utils.Float32Array;

import fluidity.GameObject;
import fluidity.GameScene;

class LimeScene{

    public var objectList:Array<GameObject> = new Array<GameObject>();
    public var objectMap:Map<GameObject,Float> = new Map<GameObject,Float>();

    var sortNeeded = false;

    public function new()
    {

    }

    public function render()
    {
        #if !depthbuffer
        if(sortNeeded)
        {
            updatePosition();
        }
        #end
    }

    public function add(obj:GameObject)
    {
        #if !depthbuffer
        objectMap.set(obj,obj.z);
        var added = false;
        for(i in 0...objectList.length)
        {
            if(obj.z < objectList[i].z)
            {
                added = true;
                objectList.insert(i,obj);
                break;
            }
        }
        if(!added)
        {
            objectList.push(obj);
        }
        #else
        objectList.push(obj);
        #end


        objectMap.set(obj,obj.z);
    }


    public function updatePosition()
    {
        sortNeeded = false;

        for(i in 1...objectList.length)
        {
            if(objectList[i].z < objectList[i - 1].z)
            {
                var moved = false;
                for(j in 1...i)
                {
                    if(!moved && objectList[i].z > objectList[i - j].z)
                    {
                        objectList.insert(i - j + 1,objectList.splice(i,1)[0]);
                        moved = true;
                        break;
                    }
                }
                if(!moved)
                {
                    objectList.insert(0,objectList.splice(i,1)[0]);
                }
            }
        }
    }

    public function objectUpdate(obj:GameObject)
    {
        #if !depthbuffer
        if(obj.z != objectMap.get(obj))
        {
            objectMap.set(obj,obj.z);
            sortNeeded = true;
        }
        #end
    }

    public function remove(obj:GameObject)
    {
        objectList.remove(obj);
        objectMap.remove(obj);
    }
}