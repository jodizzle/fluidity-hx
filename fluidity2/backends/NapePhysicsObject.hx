
// package fluidity2.backends;

// import nape.phys.Body;
// import nape.phys.BodyType;
// // import nape.dynamics.InteractionGroup;
// import nape.shape.Shape;

// // typedef Child = {

// //     obj:NapePhysicsObject;
// //     relX:Float;
// //     relY:Float;
// // }
 
// class NapePhysicsObject {

//     public var body:Body;
//     // public var group:InteractionGroup = new InteractionGroup(true);

//     public var children:Array<NapePhysicsObject> = [];

//     public var parent:NapePhysicsObject = null;
//     public var scene:NapePhysicsScene = null;

//     public var hasParent = false;
//     public var scale:Float = 1;

//     public var gameObject:GameObject;

//     public function new(?bodyType:nape.phys.BodyType, obj) 
//     { 
//         if(bodyType == null)
//         {
//             bodyType = BodyType.KINEMATIC;
//         }
//         body = new Body(bodyType);
//         body.userData.gameObject = obj;

//         // body.group = group;

//         gameObject = obj;
//     } 

//     public function setScene(s:NapePhysicsScene)
//     {
//         scene = s;
//         body.space = s.space;

//         // if(!hasParent)
//         // {
//         //     s.sprite.addChild(sprite);
//         // // }

//         // for(child in children)
//         // {
//         //     child.setScene(s);
//         // }
//     }

//     public function unsetScene(s:NapePhysicsScene)
//     {
//         scene = null;
//         body.space = null;
//     }

//     // public function setGroup(g:InteractionGroup)
//     // {
//     //     group = g;
//     //     body.group = g;
//     // }

//     public function set_scale(a:Float)
//     {
//         body.scaleShapes(a/scale,a/scale);
//         scale = a;
//         return a;
//     }

//     public function update()
//     {
//         // trace(body.position.x);
//     //     updatePosition();
//         gameObject.position = body.position;
//         gameObject.velocity = body.velocity;

//         gameObject.angle = body.rotation;
//         gameObject.angularVelocity = body.angularVel;
//         gameObject.scale = scale;
//     }

//     public function readObject()
//     {
//         body.position = gameObject.position;
//         body.velocity = gameObject.velocity;

//         body.rotation = gameObject.angle;
//         body.angularVel = gameObject.angularVelocity;
//         scale = gameObject.scale;
//     }
// }