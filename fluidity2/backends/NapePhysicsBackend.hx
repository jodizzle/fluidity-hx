// package fluidity2.backends;

// import fluidity2.GameObject;
// import fluidity2.Collider;

// import nape.space.Space;
// import nape.callbacks.CbType;
// import nape.geom.Vec2;

// class NapePhysicsBackend implements IPhysicsBackend{ 

//     public var scenes:Map<GameScene,NapePhysicsScene>;
//     public var objects:Map<GameObject,NapePhysicsObject>;

//     public var cbTypes:Map<ObjectType,CbType>;

//     public function new()
//     {
//         clear();
//     }

//     public function clear()
//     {
//         scenes = new Map<GameScene,NapePhysicsScene>();
//         objects = new Map<GameObject,NapePhysicsObject>();

//         cbTypes = new Map<ObjectType,CbType>();
//     }

//     public function newScene(scene:GameScene)
//     {
//         scenes.set(scene,new NapePhysicsScene());
//     }

//     public function sceneAdd(scene:GameScene,obj:GameObject)
//     {
//         scenes.get(scene).add(objects.get(obj));
//     }

//     public function sceneRemove(scene:GameScene,obj:GameObject)
//     {
//         scenes.get(scene).remove(objects.get(obj));
//     }

//     public function sceneUpdate(scene:GameScene)
//     {
//         scenes.get(scene).update();
//     }

//     public function sceneStart(scene:GameScene)
//     {

//     }

//     public function sceneStop(scene:GameScene)
//     {

//     }

//     public function sceneAddInteractionStartEvent(scene:GameScene, eventName:String,type:ObjectType,otherType:ObjectType)
//     { 
//         scenes.get(scene).addStartListener(eventName,getCbType(type),getCbType(otherType));
//     }

//     public function sceneAddInteractionStopEvent(scene:GameScene, eventName:String,type:ObjectType,otherType:ObjectType)
//     {
//         scenes.get(scene).addStopListener(eventName,getCbType(type),getCbType(otherType));
//     }

//     // public function sceneAddCollision(scene:GameScene,?eventName:String,type:ObjectType,otherType:ObjectType,?verifier:Collision->Bool);
    
//     // public function sceneRemoveCollision(type:ObjectType,otherType:ObjectType);

//     public function newObject(obj:GameObject)
//     {
//         objects.set(obj,new NapePhysicsObject(obj));
//     }

//     public function objectSet(obj:GameObject,collider:Collider)
//     {
//         var shape:nape.shape.Shape = switch (collider) {
//             case Circle(x, y, r): new nape.shape.Circle(r,new Vec2(x,y));
//             case Rectangle(x, y, w, h): new nape.shape.Polygon(nape.shape.Polygon.rect(x - w/2,y - h/2,w,h));
//         }

//         shape.sensorEnabled = true;

//         objects.get(obj).body.shapes.add(shape);
//     }

//     public function objectAddType(obj:GameObject,type:ObjectType)
//     {
//         objects.get(obj).body.cbTypes.add(getCbType(type));
//     }

//     // public function objectRemoveType(obj:GameObject,type:ObjectType)
//     // {
//     //     objects.get(obj).body.cbTypes.remove(getCbType(type));
//     // }

//     public function objectChanged(obj:GameObject)
//     {
//         objects.get(obj).readObject();
//     }

//     public function objectUpdate(obj:GameObject)
//     {
//         // objects.get(obj).update();
//     }

//     public function getCbType(type:ObjectType):CbType
//     {
//         if(!cbTypes.exists(type))
//         {
//             cbTypes.set(type,new CbType());
//         }
//         return cbTypes.get(type);
//     }
// }