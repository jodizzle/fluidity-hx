package fluidity.backends;

import fluidity.GameObject;
import fluidity.utils.ObjectBin;
import fluidity.utils.EnumBin;
import fluidity.backends.lime.*;

import lime.graphics.opengl.*;

import lime.utils.GLUtils;
import lime.ui.Window;
import lime.utils.Float32Array;

class GraphicsLime implements IGraphicsBackend { 

    public var sceneMap:Map<GameScene,LimeScene> = new Map<GameScene,LimeScene>();
    public var objectSceneMap:Map<GameObject,LimeScene> = new Map<GameObject,LimeScene>();

    public var layerBin:ObjectBin<GameLayer,LimeLayer>;

    public var defaultRenderer:CustomRenderer;

    public var window:Window;

    public var width:Int = 0;
    public var height:Int = 0;

    public var USE_DEPTH_BUFFER = false;

    var rttFramebuffer:GLFramebuffer;
    
    var quadBuffer:GLBuffer;
    var renderbuffer:GLRenderbuffer;

    public var renderedLayers:Array<LimeLayer> = [];

    public function new(w)
    {
        window = w;

        width = window.width;
        height = window.height;

        initBins();
        initGL();
    };

    public inline function setCustom(layer:GameLayer,custom:CustomRenderer)
    {
        layerBin.get(layer).setCustom(custom);
    }

    private inline function initBins()
    {

        layerBin = new ObjectBin<GameLayer,LimeLayer>(
            function(l:GameLayer)
            {
                return new LimeLayer(l).setCustom(defaultRenderer);
            });
    }

    private function initGL()
    {
        defaultRenderer = new CustomRenderer();
        defaultRenderer.init();

        GL.enable(GL.DEPTH_TEST);
        GL.depthFunc( GL.LEQUAL );
        GL.depthMask( true );

        // GL.blendFunc (GL.SRC_ALPHA, GL.ONE_MINUS_SRC_ALPHA);
        // GL.enable(GL.BLEND);

        GraphicsLimeObject.init(defaultRenderer.program);

        /* Depth buffer */
        renderbuffer = GL.createRenderbuffer();
        GL.bindRenderbuffer(GL.RENDERBUFFER, renderbuffer);
        GL.renderbufferStorage(GL.RENDERBUFFER, GL.DEPTH_COMPONENT16, 400, 300);


        /* Framebuffer to link everything together */
        rttFramebuffer = GL.createFramebuffer();
        
        GL.bindFramebuffer(GL.FRAMEBUFFER, rttFramebuffer);
        GL.framebufferRenderbuffer(GL.FRAMEBUFFER, GL.DEPTH_ATTACHMENT, GL.RENDERBUFFER, renderbuffer);
        GL.bindFramebuffer(GL.FRAMEBUFFER, null);
        
        GL.bindTexture(GL.TEXTURE_2D, null);

        var data = 
            [          
                .5, .5, 0,    1, 1,
                .5, -.5, 0,    1, 0,
                -.5, .5, 0,    0, 1,
                -.5, -.5, 0,    0, 0   
            ];
        
        quadBuffer = GL.createBuffer ();
        GL.bindBuffer (GL.ARRAY_BUFFER, quadBuffer);
        GL.bufferData (GL.ARRAY_BUFFER, new Float32Array (data), GL.STATIC_DRAW);
        GL.bindBuffer (GL.ARRAY_BUFFER, null);
    }

    private inline function normalShader(program:GLProgram)
    {
        GL.useProgram (program);

        var vertexAttribute = GL.getAttribLocation (program, "aPosition");
        GL.enableVertexAttribArray (vertexAttribute);
        
        var textureAttribute = GL.getAttribLocation (program, "aTexCoord");
        GL.enableVertexAttribArray (textureAttribute);
        
        var imageUniform = GL.getUniformLocation (program, "uImage0");
        GL.uniform1i (imageUniform, 0);

        GL.bindFramebuffer(GL.FRAMEBUFFER, rttFramebuffer);

    }

    private inline function postProcessShader(postProcessProgram:GLProgram)
    {
        GL.useProgram (postProcessProgram);

        var imageUniform = GL.getUniformLocation (postProcessProgram, "uImage0");
        GL.uniform1i (imageUniform, 0);

        GL.bindFramebuffer(GL.FRAMEBUFFER, null);
    }

    public function newLayer(layer:GameLayer):Void {}
    public inline function layerDimensionsChanged(layer:GameLayer):Void
    {
        layerBin.get(layer).readLayer();
    }
    public inline function layerPositionsChanged(layer:GameLayer):Void
    {
        layerBin.get(layer).readLayer();
    }

    public inline function newScene(scene:GameScene)
    {
        sceneMap.set(scene,new LimeScene());
    }

    public inline function sceneAdd(scene:GameScene,obj:GameObject)
    {
        if(obj.graphic != null)
        {
            sceneMap.get(scene).add(obj);
            objectSceneMap.set(obj,sceneMap.get(scene));
        }
    };
    public inline function sceneRemove(scene:GameScene,obj:GameObject)
    {
        if(objectSceneMap.exists(obj))
        {
            objectSceneMap.get(obj).remove(obj);
            objectSceneMap.remove(obj);
        }
    };
    public function sceneUpdate(scene:GameScene){};
    public function sceneStart(scene:GameScene){};
    public function sceneReset(scene:GameScene){};

    public inline function sceneLayerSet(scene:GameScene)
    {
        layerBin.get(scene.layer);
    }

    public inline function objectDispose(obj:GameObject)
    {
        if(objectSceneMap.exists(obj))
        {
            objectSceneMap.get(obj).remove(obj);
            objectSceneMap.remove(obj);
        }
    }

    public function layerRender(layer:GameLayer)
    {

    }

    public function sceneRender(scene:GameScene)
    {
        width = window.width;
        height = window.height;

        var limeScene = sceneMap.get(scene);
        var limeLayer = layerBin.get(scene.layer);

        limeScene.render();

        GL.clearColor (0,0,0,0);

        normalShader(limeLayer.customRenderer.program);

        limeLayer.render(window,limeScene);

        renderedLayers.push(limeLayer);
    }

    public inline function newObject(obj:GameObject){};
    public inline function objectSet(obj:GameObject,graphic:Graphic)
    {
        if(obj.scene != null)
        {
            if(!objectSceneMap.exists(obj))
            {
                obj.graphic = graphic;
                sceneMap.get(obj.scene).add(obj);
                objectSceneMap.set(obj,sceneMap.get(obj.scene));
            }
            else
            {
                sceneMap.get(obj.scene).remove(obj);
                obj.graphic = graphic;
                sceneMap.get(obj.scene).add(obj);
            }
        }
        else
        {
            obj.graphic = graphic;
        }
    }

    public inline function objectUpdate(obj:GameObject)
    {
        if(objectSceneMap.exists(obj))
        {
            objectSceneMap.get(obj).objectUpdate(obj);
        }
    }

    public function preUpdate():Void{}
    public function postUpdate():Void{}

    public function preRender():Void
    {
        renderedLayers = [];
    }

    public function postRender():Void
    {
        GL.bindFramebuffer(GL.FRAMEBUFFER,null);
        GL.clear(GL.COLOR_BUFFER_BIT | GL.DEPTH_BUFFER_BIT);

        for(limeLayer in renderedLayers)
        {
            GL.viewport (0, 0, window.width, window.height);
            postProcessShader(limeLayer.customRenderer.postProcessProgram);

            limeLayer.postProcessRender(window,quadBuffer);
        }

        GL.bindBuffer (GL.ARRAY_BUFFER, null);
        GL.bindTexture(GL.TEXTURE_2D, null);
    }
}