
package fluidity.backends.lime;

import lime.graphics.opengl.*;

import lime.utils.GLUtils;
import lime.utils.Float32Array;

import fluidity.GameObject;
import fluidity.GameScene;
import fluidity.utils.Vec2;

class LimeLayer{

    public var customRenderer:CustomRenderer;
    // public var program:GLProgram;
    // public var postProcessProgram:GLProgram;

    var rttTexture:GLTexture;

    private var initialized = false;

    public var width:Int = 1;
    public var height:Int = 1;

    public var vWidth:Int = 1;
    public var vHeight:Int = 1;

    public var position:Vec2 = new Vec2();
    public var sceneOffset:Vec2 = new Vec2();

    public var layer:GameLayer;

    public function new(l:GameLayer)
    {
        layer = l;
    }

    public function readLayer()
    {
        if(!initialized || vWidth != layer.vWidth || vHeight != layer.vHeight)
        {
            initialized = true;
            vWidth = layer.vWidth;
            vHeight = layer.vHeight;

            GL.activeTexture(GL.TEXTURE0);

            var newTexture = false;
            if(rttTexture == null)
            {
                newTexture = true;
                rttTexture = GL.createTexture();
            }

            GL.bindTexture(GL.TEXTURE_2D, rttTexture);
            
            if(newTexture)
            {
                GL.texParameteri (GL.TEXTURE_2D, GL.TEXTURE_MAG_FILTER, GL.NEAREST);
                GL.texParameteri (GL.TEXTURE_2D, GL.TEXTURE_MIN_FILTER, GL.NEAREST);
                GL.texParameteri (GL.TEXTURE_2D, GL.TEXTURE_WRAP_S, GL.CLAMP_TO_EDGE);
                GL.texParameteri (GL.TEXTURE_2D, GL.TEXTURE_WRAP_T, GL.CLAMP_TO_EDGE);
            }

            GL.texImage2D(GL.TEXTURE_2D, 0, GL.RGBA, vWidth, vHeight, 0, GL.RGBA, GL.UNSIGNED_BYTE, null);
        }

        width = (layer.width);
        height = (layer.height);

        position.set(layer.position);
        sceneOffset.set(layer.sceneOffset);
    }

    public function bind()
    {
        if(!initialized)
        {
            readLayer();
        }
        GL.viewport (0, 0, vWidth, vHeight);
        GL.framebufferTexture2D(GL.FRAMEBUFFER, GL.COLOR_ATTACHMENT0, GL.TEXTURE_2D, rttTexture, 0);
    }

    public function bindTexture()
    {
        GL.bindTexture(GL.TEXTURE_2D, rttTexture);
    }

    public function setCustom(cr:CustomRenderer)
    {
        customRenderer = cr;
        if(!customRenderer.initialized)
        {
            customRenderer.init();
        }
        return this;
    }

}