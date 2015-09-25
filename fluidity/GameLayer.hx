
package fluidity;

import haxe.ds.StringMap;

import evsm.FState;

import fluidity.backends.Backend;

import fluidity.utils.StringBin;
import fluidity.utils.Vec2;

class GameLayer{

    private var state:FState<GameLayer,GameEvent>;

    public static var activeLayers:Array<GameLayer> = [];

    private var states:Map<String,FState<GameLayer,GameEvent>> = new Map<String,FState<GameLayer,GameEvent>>();

    private var scenes:Map<String,GameScene> = new Map<String,GameScene>();

    public function new()
    {
        // width = vWidth = Backend.graphics.width;
        // height = vHeight = Backend.graphics.height;
    }

    public function addScene(stateName:String,scene:GameScene)
    {
        scenes.set(stateName,scene);
        states.set(stateName,new FState<GameLayer,GameEvent>(stateName));
        return this;
    }

    public function addTransition(eventID:String,stateFrom:String,reset1:Bool = false,stateTo:String,reset2:Bool = false)
    {
        var fromScene = scenes.get(stateFrom);
        var toScene = scenes.get(stateTo);

        states.get(stateFrom)
            .addTransition(states.get(stateTo),eventID)
            .onEvent(eventID,function(l:GameLayer)
                {
                    fromScene.layer = null;
                    // Backend.input.removeScene(fromScene);
                    if(toScene.layer == null)
                    {
                        toScene.setLayer(this);
                        // Backend.input.addScene(toScene);
                        // toScene.layer = this;
                    }
                    else
                    {
                        trace('scene from state ' + stateTo + 'owned by other layer');
                    }
                    if(reset1)
                    {
                        fromScene.reset();
                    }
                    if(reset2)
                    {
                        toScene.reset();
                    }
                    if(!toScene.active)
                    {
                        toScene.start();
                    }
                })
        ;
        return this;
    }

    public function start(stateName:String)
    {
        state = states.get(stateName);
        scenes.get(stateName).setLayer(this).start();
        // Backend.input.addScene(scenes.get(stateName));
        activeLayers.push(this);
        return this;
    }

    public function update()
    {
        scenes.get(state.name).update();
        return this;
    }

    public function processEvent(event:GameEvent)
    {
        state.processEvent(this,event);
        return this;
    }

    public static function sendEventToLayers(event:GameEvent)
    {
        for(layer in activeLayers)
        {
            layer.processEvent(event);
        }
    }

    public function getScene():GameScene
    {
        return scenes.get(state.name);
    }
}