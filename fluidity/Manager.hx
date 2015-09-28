
package fluidity;

import haxe.ds.StringMap;

import evsm.FState;
import fluidity.ash.AshEngine;

class Manager<TObj:Object<Dynamic>>{

    public var layers:Array<Layer<TObj>> = [];

    public var engine:AshEngine<TObj>;

    public function new(generator:Void->Array<Dynamic>)
    {
        // layers = new StringBin<Layer>(function (name:String)
        //     {
        //         return new Layer();
        //     });
        engine = new AshEngine<TObj>(generator);
        
    }

    public function init()
    {

    }

    public function update()
    {
        // Backend.physics.preUpdate();
        // Backend.graphics.preUpdate();
        // onUpdate();
        // for(layer in layers)
        // {
        //     layer.update();
        // }
        // Backend.physics.postUpdate();
        // Backend.graphics.postUpdate();
        engine.update(.1);
        return this;
    }

    // public function render()
    // {
    //     // Backend.graphics.preRender();
    //     // onRender();
    //     for(layer in layers.binMap)
    //     {
    //         layer.render();
    //     }
    //     // Backend.graphics.postRender();
    //     return this;
    // }

    // public function onUpdate()
    // {

    // }

    // public function onRender()
    // {

    // }

    // public function onResize()
    // {
        
    // }

}