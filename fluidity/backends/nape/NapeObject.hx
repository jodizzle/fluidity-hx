
package fluidity.backends.nape;

import fluidity.backends.simple.*;

import fluidity.GameObject;
import fluidity.Collider;
// import fluidity.utils.Vec2;

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

    public function new(obj:GameObject)
    {
        body = new Body();
        gameObj = obj;
        set(obj);
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
                solidShape = new Polygon(Polygon.rect(x,y,w,h),solidMaterial);
                sensorShape = new Polygon(Polygon.rect(x,y,w,h));
                sensorShape.sensorEnabled = true;
            default:
                trace('fuck');
        }
        solidShape.body = body;
        sensorShape.body = body;
    }
}