
package fluidity.backends.simple;

import fluidity.utils.Vec2;
import fluidity.utils.ObjectBin;

class PhysicsSimpleScene{

    public var typesInScene:Array<ObjectType> = [];

    public function new()
    {

    };

    public function add(obj:GameObject)
    {
        if(typesInScene.indexOf(obj.type) < 0)
        {
            typesInScene.push(obj.type);
        }
    }

    public function remove(obj:GameObject)
    {

    }

    public function update()
    {
        var toRemove = [];
        for(type in typesInScene)
        {
            if(type.objects.length == 0)
            {
                toRemove.push(type);
            }
            for(obj1 in type.objects)
            {
                var collisions = [];
                for(otherType in type.collisionTypes)
                {
                    for(obj2 in otherType.objects)
                    {
                        if(obj1 != obj2)
                        {
                            var msv = minimumSeparationVector(obj1,obj2).mul(-1);
                            if(msv.length > 0)
                            {
                                collisions.push(new Collision(obj2,msv));
                            }
                        }
                    }
                }

                var newCollisions = Lambda.filter(collisions,function(c:Collision)
                    {
                        return Lambda.count(obj1.collisions, function(c2:Collision)
                            {
                                return c.obj == c2.obj; 
                            }) == 0;
                    });

                for(c in newCollisions)
                {
                    var interaction = obj1.type.startInteractionEvents.get(c.obj.type);
                    if(interaction != null)
                    {
                        obj1.processEvent(new GameEvent(interaction,new Collision(c.obj,c.normal)));
                    }
                }

                var continueCollisions = Lambda.filter(collisions,function(c:Collision)
                    {
                        return Lambda.count(obj1.collisions, function(c2:Collision)
                            {
                                return c.obj == c2.obj; 
                            }) > 0;
                    });

                for(c in continueCollisions)
                {
                    var interaction = obj1.type.continueInteractionEvents.get(c.obj.type);
                    if(interaction != null)
                    {
                        obj1.processEvent(new GameEvent(interaction,new Collision(c.obj,c.normal)));
                    }
                }

                var endCollisions = Lambda.filter(obj1.collisions,function(c:Collision)
                    {
                        return Lambda.count(collisions, function(c2:Collision)
                            {
                                return c.obj == c2.obj; 
                            }) == 0;
                    });

                for(c in endCollisions)
                {
                    if(c.obj.type != null)
                    {
                        var interaction = obj1.type.stopInteractionEvents.get(c.obj.type);
                        if(interaction != null)
                        {
                            obj1.processEvent(new GameEvent(interaction,new Collision(c.obj,c.normal)));
                        }
                    }
                }

                obj1.collisions = collisions;
            }
        }
        for(type in toRemove)
        {
            typesInScene.remove(type);
        }
    }

    public function minimumSeparationVector(obj1:GameObject,obj2:GameObject)
    {
        switch (obj1.collider)
        {
            case Circle(x1,y1,r1):

                var p1 = new Vec2(obj1.worldPosition.x + x1,obj1.worldPosition.y + y1);
                r1 = r1*obj1.worldScale;

                switch (obj2.collider)
                {
                    case Circle(x2,y2,r2):

                        var p2 = new Vec2(obj2.worldPosition.x + x2,obj2.worldPosition.y + y2);
                        r2 = r2*obj2.worldScale;

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

                        w = w*obj2.worldScale;
                        h = h*obj2.worldScale;

                        var p2 = new Vec2(obj2.worldPosition.x + x2,obj2.worldPosition.y + y2);

                        var result = rectangleCircleCollision(p2,w,h,p1,r1);
                        result.set(new Vec2(-result.x,-result.y));

                        return result;
                    default:
                        //should never happen
                        return new Vec2(0,0);
                }

            case Rectangle(x1,y1,w1,h1):

                w1 = w1*obj1.worldScale;
                h1 = h1*obj1.worldScale;

                switch (obj2.collider)
                {
                    case Circle(x2,y2,r):

                        r = r*obj2.worldScale;

                        var p1 = new Vec2(obj1.worldPosition.x + x1,obj1.worldPosition.y + y1);
                        var p2 = new Vec2(obj2.worldPosition.x + x2,obj2.worldPosition.y + y2);

                        return rectangleCircleCollision(p1,w1,h1,p2,r);

                    case Rectangle(x2,y2,w2,h2):

                        w2 = w2*obj2.worldScale;
                        h2 = h2*obj2.worldScale;

                        var msv = new Vec2(w1 + w2,0);

                        var l1 = obj1.worldPosition.x + x1 - w1/2;
                        var l2 = obj2.worldPosition.x + x2 - w2/2;
                        var r1 = obj1.worldPosition.x + x1 + w1/2;
                        var r2 = obj2.worldPosition.x + x2 + w2/2;
                        var b1 = obj1.worldPosition.y + y1 - h1/2;
                        var b2 = obj2.worldPosition.y + y2 - h2/2;
                        var t1 = obj1.worldPosition.y + y1 + h1/2;
                        var t2 = obj2.worldPosition.y + y2 + h2/2;

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
                            msv = compareMSV(msv,new Vec2(r2 - l1,0));
                        }

                        if(t1 <= b2)
                        {
                            return new Vec2(0,0);
                        }
                        else
                        {
                            msv = compareMSV(msv,new Vec2(0,t2 - b1));
                        }

                        if(b1 >= t2)
                        {
                            return new Vec2(0,0);
                        }
                        else
                        {
                            msv = compareMSV(msv,new Vec2(0,b2 - t1));
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

    private function rectangleCircleCollision(p1:Vec2, w:Float, h:Float, p2:Vec2, radius:Float):Vec2
    {

        var l = -w/2;
        var r = w/2;
        var t = -h/2;
        var b = h/2;

        var hAxis = new Vec2(1,0);
        var vAxis = new Vec2(0,1);

        var hProj = hAxis.dot(p2.sub(p1));
        var p2l = hProj - radius;
        var p2r = hProj + radius;
        var vProj = vAxis.dot(p2.sub(p1));
        var p2t = vProj - radius;
        var p2b = vProj + radius;
        var msv = new Vec2(w + h + radius*2, 0);

        if(l >= p2r)
        {
            return new Vec2(0,0);
        }
        else
        {
            msv = compareMSV(msv,new Vec2(p2r - l,0));
        }

        if(r <= p2l)
        {
            return new Vec2(0,0);
        }
        else
        {
            msv = compareMSV(msv,new Vec2(p2l - r,0));
        }

        trace(t,p2b);

        if(t >= p2b)
        {
            return new Vec2(0,0);
        }
        else
        {
            msv = compareMSV(msv,new Vec2(0,p2b - t));
        }

        if(b <= p2t)
        {
            return new Vec2(0,0);
        }
        else
        {
            msv = compareMSV(msv,new Vec2(0,p2t - b));
        }

        msv.muleq(-1);
        return msv;
    }
}