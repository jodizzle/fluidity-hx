
package fluidity.backends.nape;

import fluidity.backends.simple.*;

import fluidity.GameObject;
import fluidity.Collider;
// import nape.geom.Vec2;

import nape.space.Space;
import nape.geom.Vec2;
import nape.phys.Body;
import nape.shape.Shape;
import nape.shape.Circle;
import nape.shape.Polygon;
import nape.callbacks.CbType;
import nape.phys.Material;


class NapeObject{ 

    public var body:Body;

    public var solidShape:Shape;
    public var sensorShape:Shape;

    public static var solidMaterial:Material = new Material(0,0,0,1,0);

    public var gameObj:GameObject;

    public var previousScale:Float = 1;

    public function new(obj:GameObject)
    {
        body = new Body();
        body.userData.gameObj = obj;
        gameObj = obj;
        set(obj);
    }

    public function read()
    {
        body.position.set(gameObj.position);
        body.velocity.set(gameObj.velocity);
        body.rotation = gameObj.angle;
        body.angularVel = gameObj.angularVelocity;

        body.scaleShapes(gameObj.scale/previousScale,gameObj.scale/previousScale);
        previousScale = gameObj.scale;
    }

    public function update()
    {
        gameObj.position.set(body.position);
        gameObj.velocity.set(body.velocity);
        gameObj.angle = body.rotation;
    }

    public function set(obj:GameObject)
    {
        // body = new Body();
        if(solidShape != null)
        {
            solidShape.body = null;
        }
        if(sensorShape != null)
        {
            sensorShape.body = null;
        }
        switch(obj.collider)
        {
            case Circle(x,y,r):
                solidShape = new Circle(r,new Vec2(x,y),solidMaterial);
                sensorShape = new Circle(r,new Vec2(x,y));
                sensorShape.sensorEnabled = true;
            case Rectangle(x,y,w,h):
                solidShape = new Polygon(Polygon.rect(x - w/2,y - h/2,w,h),solidMaterial);
                sensorShape = new Polygon(Polygon.rect(x - w/2,y - h/2,w,h));
                sensorShape.sensorEnabled = true;
                trace('worked');
            default:
                trace('fuck');
        }
        solidShape.body = body;
        sensorShape.body = body;

        read();
    }
}