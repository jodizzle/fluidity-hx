
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
        if(sortNeeded)
        {
            // updatePosition();
        }
            trace(objectList.length);
    }

    public function add(obj:GameObject)
    {
        objectList.push(obj);

        if(obj.graphic != null)
        {
            // objectList.remove(obj);
            // objectList.push(obj);
        }
        else
        {

            // var i = Math.floor(objectList.length/2);

            objectMap.set(obj,obj.z);
            // objectList.push(obj);
            // var added = false;
            // for(i in 0...objectList.length)
            // {
            //     if(obj.z < objectList[0].z)
            //     {
            //         added = true;
            //         objectList.insert(i,obj);
            //         break;
            //     }
            // }
            // if(!added)
            // {
                objectList.push(obj);
            // }
        }
        objectMap.set(obj,obj.z);
    }


    public function updatePosition()
    // public function updatePosition(obj:GameObject)
    {
        // sortNeeded = false;
        // // if(objectMap.exists(obj))
        // // {
        //     // var z = obj.z;
        //     // if(z != objectMap.get(obj))
        //     // {
        //         for(i in 1...objectList.length)
        //         {
        //             if(objectList[i].z < objectList[i - 1].z)
        //             {
        //                 var moved = false;
        //                 for(j in 1...i)
        //                 {
        //                     if(!moved && objectList[i].z > objectList[i - j].z)
        //                     {
        //                         objectList.insert(i - j + 1,objectList.splice(i,1)[0]);
        //                         moved = true;
        //                         break;
        //                     }
        //                 }
        //                 if(!moved)
        //                 {
        //                     objectList.insert(0,objectList.splice(i,1)[0]);
        //                 }
        //             }
        //         }
                // // probably more efficient ways of doing this...
                // objectList.sort(function(obj1,obj2)
                //     {
                //         objectMap.set(obj1,obj1.z);
                //         objectMap.set(obj2,obj2.z);
                //         if(obj1.z < obj2.z)
                //         {
                //             return -1;
                //         }
                //         else if(obj1.z != obj2.z)
                //         {
                //             return 1;
                //         }

                //         return 0;
                //     });
            // }
        // }
    }

    public function objectUpdate(obj:GameObject)
    {
        // // updatePosition(obj);
        // if(obj.z != objectMap.get(obj))
        // {
        //     objectMap.set(obj,obj.z);
        //     sortNeeded = true;
        //     // updatePosition();
        // }
    }

    public function remove(obj:GameObject)
    {
        objectList.remove(obj);
        objectMap.remove(obj);
    }
}