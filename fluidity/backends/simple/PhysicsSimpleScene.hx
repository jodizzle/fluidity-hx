
package fluidity.backends.simple;

import fluidity.utils.Vec2;
import fluidity.utils.ObjectBin;

class PhysicsSimpleScene{

    // public var objectMap:Map<PhysicsSimpleObject,Bool> = new Map<PhysicsSimpleObject,Bool>();
    public var objects:Array<PhysicsSimpleObject> = [];
    public var objectsToRemove:Array<PhysicsSimpleObject> = [];

    public var typeObjectBin:ObjectBin<SimpleType,Array<PhysicsSimpleObject>>;

    public var typesInScene:Array<SimpleType> = [];

    public function new()
    {
        typeObjectBin = new ObjectBin<SimpleType,Array<PhysicsSimpleObject>>(function(type:SimpleType)
            {
                return new Array<PhysicsSimpleObject>();
            });
    };

    public function add(obj:PhysicsSimpleObject)
    {
        if(typeObjectBin.get(obj.type).length == 0)
        {
            typesInScene.push(obj.type);
        }
        typeObjectBin.get(obj.type).push(obj);
        objects.push(obj);
    }

    public function remove(obj:PhysicsSimpleObject)
    {
        objectsToRemove.push(obj);
    }

    private function removeObjects()
    {
        for(obj in objectsToRemove)
        {
            if(objects.remove(obj))
            {
                typeObjectBin.get(obj.type).remove(obj);
                if(typeObjectBin.get(obj.type).length == 0)
                {
                    typesInScene.remove(obj.type);
                }
            }
        }
        objectsToRemove = [];
    }

    public function update()
    {
        removeObjects();
        // var len = objects.length;
        // for(i in 0...(len - 1))
        // {
        //     var obj1 = objects[i];
        //     for(j in (i+1)...len)
        //     {
        //         var obj2 = objects[j];
        //         if (checkInteracts(obj1,obj2)) {
        //             var msv = minimumSeparationVector(obj1,obj2);
        //             handleInteracts(obj1,obj2,msv);
        //         }
        //     }
        // }


                // var processedMSVs = new Map<GameObject,Vec2>();
        for(type in typesInScene)
        {
            for(obj1 in typeObjectBin.get(type))
            {
                for(otherType in type.sensorTypes.keys())
                {
                    for(obj2 in typeObjectBin.get(otherType))
                    {
                        if(obj1 != obj2)
                        {
                            var msv = minimumSeparationVector(obj1,obj2);
                            // trace(msv.length);
                            handleInteracts(obj1,obj2,msv);
                        }
                    }
                }
                for(otherType in type.collisionTypes)
                {
                    for(obj2 in typeObjectBin.get(otherType))
                    {
                        if(obj1 != obj2)
                        {
                            var msv = minimumSeparationVector(obj1,obj2);
                            handleInteracts(obj1,obj2,msv);
                        }
                    }
                }
            }
        }
        removeObjects();
    }

    private function handleCollisions(obj1:PhysicsSimpleObject,obj2:PhysicsSimpleObject,msv:Vec2)
    {
        var collides1 = hasCollisions(obj1,obj2);
        var collides2 = hasCollisions(obj2,obj1);
        if(collides1 && collides2)
        {
            var hmsv = msv.copy();
            hmsv.length /= 2;

            obj1.gameObject.translate(hmsv);
            obj2.gameObject.translate(new Vec2(-hmsv.x,-hmsv.y));
        }
    }

    private function handleInteracts(obj1:PhysicsSimpleObject,obj2:PhysicsSimpleObject,msv:Vec2)
    {
        if(msv.length > 0)
        {
            handleInteractionCollision(obj1,obj2);
            // handleInteractionCollision(obj2,obj1);
        }
    }

    private function handleInteractionCollision(obj1:PhysicsSimpleObject,obj2:PhysicsSimpleObject)
    {
        var interaction = obj1.type.sensorTypes.get(obj2.type);
        if(interaction != null)
        {
            obj1.gameObject.processEvent(new GameEvent(interaction,new Collision(obj1.gameObject,obj2.gameObject)));
        }
    }

    private function checkInteracts(obj1:PhysicsSimpleObject,obj2:PhysicsSimpleObject)
    {
        return (obj1.type.sensorTypes.exists(obj2.type) || hasCollisions(obj1,obj2));
    }

    private function hasCollisions(obj1:PhysicsSimpleObject,obj2:PhysicsSimpleObject)
    {
        return obj1.type.collisionTypes.indexOf(obj2.type) >= 0;
    }

    // public function colliding(obl1:PhysicsSimpleObject,obj2:PhysicsSimpleObject)
    // {
    //     return minimumSeparationVector(obj1,obj2).length == 0;
    // }

    public function minimumSeparationVector(obj1:PhysicsSimpleObject,obj2:PhysicsSimpleObject)
    {
        switch (obj1.collider)
        {
            case Circle(x1,y1,r1):

                var p1 = new Vec2(obj1.gameObject.position.x + x1,obj1.gameObject.position.y + y1);
                r1 = r1*obj1.gameObject.scale;

                switch (obj2.collider)
                {
                    case Circle(x2,y2,r2):

                        var p2 = new Vec2(obj2.gameObject.position.x + x2,obj2.gameObject.position.y + y2);
                        r2 = r2*obj2.gameObject.scale;

                        var difference = p1.sub(p2);
                        if(difference.length == 0)
                        {
                            return Vec2.fromPolar(Math.min(r1,r2),Math.random()*Math.PI*2);
                        }
                        if(difference.length < r1 + r2)
                        {
                            difference.length -= (r1 + r2);

                            return difference;
                        }
                        return new Vec2(0,0);

                    case Rectangle(x2,y2,w,h):

                        w = w*obj2.gameObject.scale;
                        h = h*obj2.gameObject.scale;

                        var p2 = new Vec2(obj2.gameObject.position.x + x2,obj2.gameObject.position.y + y2);

                        var result = rectangleCircleCollision(p2,w,h,p1,r1);
                        result.set(new Vec2(-result.x,-result.y));

                        return result;
                    default:
                        //should never happen
                        return new Vec2(0,0);
                }

            case Rectangle(x1,y1,w1,h1):

                w1 = w1*obj1.gameObject.scale;
                h1 = h1*obj1.gameObject.scale;

                switch (obj2.collider)
                {
                    case Circle(x2,y2,r):

                        r = r*obj2.gameObject.scale;

                        var p1 = new Vec2(obj1.gameObject.position.x + x1,obj1.gameObject.position.y + y1);
                        var p2 = new Vec2(obj2.gameObject.position.x + x2,obj2.gameObject.position.y + y2);

                        return rectangleCircleCollision(p1,w1,h1,p2,r);

                    case Rectangle(x2,y2,w2,h2):

                        w2 = w2*obj2.gameObject.scale;
                        h2 = h2*obj2.gameObject.scale;

                        var msv = new Vec2(w1 + w2,0);

                        var l1 = obj1.gameObject.position.x + x1 - w1/2;
                        var l2 = obj2.gameObject.position.x + x2 - w2/2;
                        var r1 = obj1.gameObject.position.x + x1 + w1/2;
                        var r2 = obj2.gameObject.position.x + x2 + w2/2;
                        var b1 = obj1.gameObject.position.y + y1 - h1/2;
                        var b2 = obj2.gameObject.position.y + y2 - h2/2;
                        var t1 = obj1.gameObject.position.y + y1 + h1/2;
                        var t2 = obj2.gameObject.position.y + y2 + h2/2;

                        if(l1 >= r2)
                        {
                            return new Vec2(0,0);
                        }
                        else
                        {
                            msv = compareMSV(msv,new Vec2(r2 - l1,0));
                        }

                        if(r1 <= l2)
                        {
                            return new Vec2(0,0);
                        }
                        else
                        {
                            msv = compareMSV(msv,new Vec2(r1 - l2,0));
                        }

                        if(t1 <= b2)
                        {
                            return new Vec2(0,0);
                        }
                        else
                        {
                            msv = compareMSV(msv,new Vec2(0,t1 - b2));
                        }

                        if(b1 >= t2)
                        {
                            return new Vec2(0,0);
                        }
                        else
                        {
                            msv = compareMSV(msv,new Vec2(0,b1 - t2));
                        }

                        return msv;
                    default:
                        //should never happen
                        return new Vec2(0,0);
                }
            default:
                //should never happen
                return new Vec2(0,0);
        }
    }

    private function compareMSV(v1:Vec2,v2:Vec2)
    {
        if(v1.length < v2.length)
        {
            return v1;
        }
        return v2;
    }

    private function rectangleCircleCollision(p1:Vec2, w:Float, h:Float, p2:Vec2, r:Float):Vec2
    {
        //calculate closest point on the rectangle to the center of the circle
        var rp = p2.copy();

        var l = p1.x - w/2;
        var r = p1.x + w/2;
        var b = p1.y - h/2;
        var t = p1.y + h/2;

        if(p2.x  < l)
        {
            rp.x = l;
        }
        else if(p2.x > r)
        {
            rp.x = r;
        }

        if(p2.y  < b)
        {
            rp.y = b;
        }
        else if(p2.y > t)
        {
            rp.y = t;
        }

        var sv = p2.sub(rp);

        if(sv.length < r)
        {
            return sv;
        }

        return new Vec2(0,0);
    }
}