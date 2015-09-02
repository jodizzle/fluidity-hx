
package fluidity;

import haxe.ds.StringMap;

import evsm.FState;

import fluidity.backends.Input;
import fluidity.backends.Backend;

import fluidity.utils.StringBin;
import fluidity.utils.Vec2;

class GameLayer{

    public var state:FState<GameLayer,GameEvent>;

    // public var width(get,set):Float;
    // public var height(get,set):Float;

    // private var _width:Float; 
    // private var _height:Float; 

    public var position:Vec2 = new Vec2();
    public var sceneOffset:Vec2 = new Vec2();

    public var width:Float = 1;
    public var height:Float = 1;

    public var vWidth:Float = 1;
    public var vHeight:Float = 1;

    // public var lockAspectRatio:Bool = false;

    public static var activeLayers:Array<GameLayer> = [];

    private var states:Map<String,FState<GameLayer,GameEvent>> = new Map<String,FState<GameLayer,GameEvent>>();

    private var scenes:Map<String,GameScene> = new Map<String,GameScene>();

    public function new()
    {

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
                    if(toScene.layer == null)
                    {
                        toScene.setLayer(this);
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
        activeLayers.push(this);
        return this;
    }

    public function update()
    {
        scenes.get(state.name).update();
        return this;
    }

    public function render()
    {
        scenes.get(state.name).render();
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
}