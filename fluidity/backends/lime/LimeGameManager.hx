
package fluidity.backends.lime;

import haxe.ds.StringMap;

import evsm.FState;

import fluidity.backends.Backend;

import fluidity.utils.StringBin;
import fluidity.utils.Vec2;

import lime.app.Application;
import lime.ui.KeyCode;
import lime.ui.KeyModifier;
import lime.ui.Window;

class LimeGameManager extends Application{

    public var gameManager:GameManager = new GameManager();
    public var lgb:GraphicsLime;

    public var layers:StringBin<GameLayer>;

    public var limeInput:LimeInput;
    public var started:Bool = false;

    public function new()
    {
        super();

        layers = new StringBin<GameLayer>(function (name:String)
            {
                return gameManager.layers.get(name);
            });
    }

    public function _init()
    {
        lgb = new GraphicsLime(window);
        limeInput = new LimeInput();
        Backend.graphics = lgb;
        Backend.physics = new PhysicsSimple();
        Backend.input = limeInput;
        gameManager.init();
        window.onResize.add(_onResize);
        onInit();
    }

    public function onInit()
    {

    }

    public override function render (renderer):Void
    {
        if(!started)
        {
            started = true;
            _init();
        }
        gameManager.update();
        gameManager.render();
    }
    
    
    public override function onKeyDown (window,key:KeyCode, modifier:KeyModifier):Void {
        limeInput.limeOnKeyDown(key);
    }
    public override function onKeyUp (window,key:KeyCode, modifier:KeyModifier):Void {
        limeInput.limeOnKeyUp(key);
    }

    public override function onTouchStart(touch)
    {
        GameLayer.sendEventToLayers(new GameEvent('titleFinished'));
        // if(gameScene != null)
        // {
        //  gameScene.finished = true;
        // }
    }

    public override function onTouchEnd(touch)
    {

    }

    public override function onTouchMove(touch)
    {

    }

    public override function onMouseMove(window,x:Float, y:Float)
    {
        
    }

    public override function onMouseDown(window:Window,x:Float, y:Float, button:Int)
    {
        for(layer in layers.binMap)
        {
            var kek = layer.worldPointToLocal(new Vec2(-window.width/2 + x,-window.height/2 + y));
            var kek2 = layer.localPointToWorld(kek);
            trace('' + (x - window.width/2) + ', ' + kek2.x);
            layer.getScene().generate('name').setPosition(new Vec2(kek.x,kek.y));
        }
    }

    public function _onResize(width:Int,height:Int)
    {
        lgb.width = width;
        lgb.height = height;
        onResize();
        gameManager.onResize();
    }

    public function onResize()
    {
    }

}