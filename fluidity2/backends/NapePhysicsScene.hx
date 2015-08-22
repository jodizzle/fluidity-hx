
package fluidity2.backends;

import nape.space.Space;
import nape.geom.Vec2;
import nape.callbacks.*;
// import flash.Lib;
 
class NapePhysicsScene {

    public var space:Space;

    // var _t:Int;
    var objects:Array<NapePhysicsObject> = [];

    public function new(?gravity:Vec2) 
    { 
        if(gravity == null)
        {
            gravity = new Vec2(0, 600); // units are pixels/second/second
        }
        space = new Space(gravity);

        // _t = Lib.getTimer();
    } 

    public function add(physObj:NapePhysicsObject)
    {
        objects.push(physObj);

        physObj.setScene(this);
        for(child in physObj.children)
        {
            space.bodies.add(child.body);
        }
    }

    public function remove(physObj:NapePhysicsObject)
    {
        physObj.unsetScene(this);
        for(child in physObj.children)
        {
            remove(child);
        }
        objects.remove(physObj);
    }

    public function update()
    {
        // var t:Int = Lib.getTimer();
        // var dt:Float = (t - _t) * 0.001;
        // _t = t;
        
        space.step(1/60);

        for(object in objects)
        {
            object.update();
        }
    }

    public function addStartListener(name:String,type1:CbType,type2:CbType)
    {
        addListener(CbEvent.BEGIN,name,type1,type2);
    }

    public function addStopListener(name:String,type1:CbType,type2:CbType)
    {
        addListener(CbEvent.END,name,type1,type2);
    }

    public function addListener(type:CbEvent,eventName:String,type1:CbType,type2:CbType)
    {
        //processing collision normals is probably fucked up lol

        if(type1 == type2)
        {

            var listener = new InteractionListener(type, InteractionType.SENSOR, type1, type2, function(iCb:InteractionCallback)
                {
                    iCb.int1.userData.gameObject.processEvent(new GameEvent(eventName,new Collision(iCb.int1.userData.gameObject, iCb.int2.userData.gameObject)));
                });

            space.listeners.add(listener);

            var listener2 = new InteractionListener(type, InteractionType.COLLISION, type1, type2, function(iCb:InteractionCallback)
                {
                    iCb.int1.userData.gameObject.processEvent(new GameEvent(eventName,new Collision(iCb.int1.userData.gameObject, iCb.int2.userData.gameObject, iCb.arbiters.at(0).collisionArbiter.normal) ));
                });

            space.listeners.add(listener2);
        }
        else
        {

            var listener = new InteractionListener(type, InteractionType.SENSOR, type1, type2, function(iCb:InteractionCallback)
                {
                    iCb.int1.userData.gameObject.processEvent(new GameEvent(eventName,new Collision(iCb.int1.userData.gameObject, iCb.int2.userData.gameObject)));
                    iCb.int1.userData.gameObject.processEvent(new GameEvent(eventName,new Collision(iCb.int2.userData.gameObject, iCb.int1.userData.gameObject)));
                });

            space.listeners.add(listener);

            var listener2 = new InteractionListener(type, InteractionType.COLLISION, type1, type2, function(iCb:InteractionCallback)
                {
                    iCb.int1.userData.gameObject.processEvent(new GameEvent(eventName,new Collision(iCb.int1.userData.gameObject, iCb.int2.userData.gameObject, iCb.arbiters.at(0).collisionArbiter.normal)));
                    iCb.int1.userData.gameObject.processEvent(new GameEvent(eventName,new Collision(iCb.int2.userData.gameObject, iCb.int1.userData.gameObject, iCb.arbiters.at(0).collisionArbiter.normal.mul(-1))));
                });

            space.listeners.add(listener2);
        }
    }
}