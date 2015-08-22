package fluidity2;

import fluidity2.GameObject;

interface IGraphicsBackend { 

    public function newScene(scene:GameScene):Void;
    public function sceneAdd(scene:GameScene,obj:GameObject):Void;
    public function sceneRemove(scene:GameScene,obj:GameObject):Void;
    public function sceneUpdate(scene:GameScene):Void;
    public function sceneRender(scene:GameScene):Void;
    public function sceneStart(scene:GameScene):Void;
    public function sceneStop(scene:GameScene):Void;

    public function newObject(obj:GameObject):Void;
    public function objectSet(obj:GameObject,graphic:Graphic):Void;
    // public function objectAddChild(obj:GameObject,child:GameObject):Void;
    // public function objectRemoveChild(obj:GameObject,child:GameObject):Void;
    public function objectUpdate(obj:GameObject):Void;
}