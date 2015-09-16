
package fluidity.backends.lime;

import lime.graphics.opengl.*;

import lime.utils.GLUtils;
import lime.utils.Float32Array;

import fluidity.GameObject;
import fluidity.GameScene;
import fluidity.utils.Vec2;
import fluidity.utils.EnumBin;

class LimeLayer{

    public var customRenderer:CustomRenderer;

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

    public function render(window:lime.ui.Window,limeScene:LimeScene)
    {
        bind();

        var scene = layer.getScene();

        customRenderer.initFunc(customRenderer.program);

        GL.clear(GL.COLOR_BUFFER_BIT | GL.DEPTH_BUFFER_BIT);

        var projectionMatrixUniform = GL.getUniformLocation (customRenderer.program, "uProjectionMatrix");

        var matrix = lime.math.Matrix4.createOrtho (-vWidth/2/scene.cameraScale + scene.camera.x + sceneOffset.x, vWidth/2/scene.cameraScale + scene.camera.x + sceneOffset.x, -vHeight/2/scene.cameraScale + scene.camera.y + sceneOffset.y, vHeight/2/scene.cameraScale + scene.camera.y + sceneOffset.y, -2000, 2000);
        GL.uniformMatrix4fv (projectionMatrixUniform, false, matrix);


        GraphicsLimeObject.bindGeneral();
        var lastObj:GraphicsLimeObject;
        for(graphicObj in limeScene.graphicIdMap)
        {
            graphicObj.bind();
            for(obj in graphicObj.objects)
            {
                graphicObj.render(obj,customRenderer.program,customRenderer.renderPreFunc,customRenderer.renderPostFunc);
            }
            lastObj = graphicObj;
        }
        lastObj.unbind();
        GraphicsLimeObject.unbindGeneral();
    }

    public function postProcessRender(window:lime.ui.Window,quadBuffer:GLBuffer)
    {

        var vertexAttribute = GL.getAttribLocation (customRenderer.postProcessProgram, "aPosition");
        var textureAttribute = GL.getAttribLocation (customRenderer.postProcessProgram, "aTexCoord");
        var mvMatrixUniform = GL.getUniformLocation (customRenderer.postProcessProgram, "uViewMatrix");
        var projectionMatrixUniform = GL.getUniformLocation (customRenderer.postProcessProgram, "uProjectionMatrix");

        var projectionMatrix = lime.math.Matrix4.createOrtho (-window.width/2, window.width/2, window.height/2, -window.height/2, -2000, 2000);
       
        GL.uniformMatrix4fv (projectionMatrixUniform, false, projectionMatrix);

        var mvMatrix = new lime.math.Matrix4();
        
        mvMatrix.appendScale(width,height,1);
        mvMatrix.appendTranslation(position.x,position.y,0);
        // if(obj.angle != 0)
        // {
        //     mvMatrix.appendRotation(obj.angle,lime.math.Vector4.Z_AXIS);
        // }
        // mvMatrix.appendTranslation(.1,0,0);

        GL.uniformMatrix4fv (mvMatrixUniform, false, mvMatrix);

        GL.bindBuffer (GL.ARRAY_BUFFER, quadBuffer);
        GL.vertexAttribPointer (vertexAttribute, 3, GL.FLOAT, false, 5 * Float32Array.BYTES_PER_ELEMENT, 0);
        GL.vertexAttribPointer (textureAttribute, 2, GL.FLOAT, false, 5 * Float32Array.BYTES_PER_ELEMENT, 3 * Float32Array.BYTES_PER_ELEMENT);
                
        bindTexture();

        GL.drawArrays (GL.TRIANGLE_STRIP, 0, 4);
    }

}