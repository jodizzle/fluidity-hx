
package fluidity.backends.simple;

typedef SimpleType =  {

    var objects:Array<PhysicsSimpleObject>;
    var sensorTypes:Map<SimpleType,String>;
    var collisionTypes:Array<SimpleType>;
}