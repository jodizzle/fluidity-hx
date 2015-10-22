
package fluidity;

import haxe.ds.StringMap;

import evsm.FState;

import fluidity.backends.Backend;

import fluidity.utils.StringBin;
import nape.geom.Vec2;

class GameManager{

    public var layers:StringBin<GameLayer>;

    public function new()
    {
        layers = new StringBin<GameLayer>(function (name:String)
            {
                return new GameLayer();
            });
    }

    public function init()
    {

    }

    public function update()
    {
        Backend.physics.preUpdate();
        Backend.graphics.preUpdate();
        onUpdate();
        for(layer in layers.binMap)
        {
            layer.update();
        }
        Backend.physics.postUpdate();
        Backend.graphics.postUpdate();
        return this;
    }

    public function render()
    {
        Backend.graphics.preRender();
        onRender();
        for(layer in layers.binMap)
        {
            layer.render();
        }
        Backend.graphics.postRender();
        return this;
    }

    public function onUpdate()
    {

    }

    public function onRender()
    {

    }

    public function onResize()
    {
        
    }

}