package fluidity2.backends;

typedef SimplePhysicsType =  {

    var objects:Array<SimplePhysicsObject>;
    var sensorTypes:Map<SimplePhysicsType,String>;
    var collisionTypes:Array<SimplePhysicsType>;
}