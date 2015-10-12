
package fluidity.systems.lime;

import fluidity.Object;
import fluidity.utils.ObjectBin;
import fluidity.utils.Vec2;
import fluidity.utils.EnumBin;
import fluidity.utils.Graphic;
import fluidity.backends.lime.*;

import lime.graphics.opengl.*;

import lime.utils.GLUtils;
import lime.ui.Window;
import lime.utils.Float32Array;

class LimeGraphics { 

    // public var sceneMap:Map<GameScene,LimeScene> = new Map<GameScene,LimeScene>();
    // public var objectSceneMap:Map<LimeObject,LimeScene> = new Map<LimeObject,LimeScene>();

    // public var objects:
    public var priority:Float = 5;
    public var graphicIdMap:Map<String,LimeGraphicsObject> = new Map<String,LimeGraphicsObject>();

    // public var layerBin:ObjectBin<GameLayer,LimeLayer>;
    public var layer:LimeLayer;
    // public var scene:LimeScene;
    public var camera:Vec2 = new Vec2();

    public var cameraScale:Float = 1;

    public var defaultRenderer:CustomRenderer;

    public var window:Window;

    public var width:Int = 800;
    public var height:Int = 600;
    public var vWidth:Int = 800;
    public var vHeight:Int = 600;
    public var position:Vec2 = new Vec2();
    public var sceneOffset:Vec2 = new Vec2();

    public var USE_DEPTH_BUFFER = false;

    var rttFramebuffer:GLFramebuffer;
    
    var quadBuffer:GLBuffer;
    // var renderbuffer:GLRenderbuffer;

    public var renderedLayers:Array<LimeLayer> = [];

    public function new(w)
    {
        window = w;

        width = window.width;
        height = window.height;

        // initBins();
        initGL();
        layer = new LimeLayer(this).setCustom(defaultRenderer);
    }


    public static inline function getId(graphic:Graphic)
    {
        return switch (graphic) {
                case Image(f): f;
                case SpriteSheet(f,_,_,_,_,_): f;
         };
    }

    // public inline function setCustom(layer:GameLayer,custom:CustomRenderer)
    // {
    //     layerBin.get(layer).setCustom(custom);
    // }

    // private inline function initBins()
    // {

    //     layerBin = new ObjectBin<GameLayer,LimeLayer>(
    //         function(l:GameLayer)
    //         {
    //             return new LimeLayer(l).setCustom(defaultRenderer);
    //         });
    // }

    private function initGL()
    {
        defaultRenderer = new CustomRenderer();
        // defaultRenderer.ini
        defaultRenderer.init();

        GL.enable(GL.DEPTH_TEST);
        GL.depthFunc( GL.LEQUAL );
        GL.depthMask( true );

        // GL.blendFunc (GL.SRC_ALPHA, GL.ONE_MINUS_SRC_ALPHA);
        // GL.enable(GL.BLEND);

        LimeGraphicsObject.init(defaultRenderer.program);

        /* Depth buffer */
        // renderbuffer = GL.createRenderbuffer();
        // GL.bindRenderbuffer(GL.RENDERBUFFER, renderbuffer);
        // GL.renderbufferStorage(GL.RENDERBUFFER, GL.DEPTH_COMPONENT16, 400, 300);


        /* Framebuffer to link everything together */
        rttFramebuffer = GL.createFramebuffer();
        
        // GL.bindFramebuffer(GL.FRAMEBUFFER, rttFramebuffer);
        // GL.framebufferRenderbuffer(GL.FRAMEBUFFER, GL.DEPTH_ATTACHMENT, GL.RENDERBUFFER, renderbuffer);
        // GL.bindFramebuffer(GL.FRAMEBUFFER, null);
        
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

    public function update(objects:Array<LimeObject>)
    {
        preRender();
        for(graphicObj in graphicIdMap)
        {
            graphicObj.objects = [];
        }
        for(obj in objects)
        {
            add(obj);
        }

        width = window.width;
        height = window.height;

        // var limeLayer = layerBin.get(scene.layer);

        GL.clearColor (0,0,1,1);

        normalShader(layer.customRenderer.program);

        layer.render(window,this);

        renderedLayers.push(layer);
        postRender();
    }

    public function onAddObject(obj:LimeObject)
    {

    }

    public function onRemoveObject(obj:LimeObject)
    {
        remove(obj);
    }

    // public inline function objectSet(obj:LimeObject,graphic:Graphic)
    // {
    //     if(obj.scene != null)
    //     {
    //         if(!objectSceneMap.exists(obj))
    //         {
    //             obj.graphic = graphic;
    //             sceneMap.get(obj.scene).add(obj);
    //             objectSceneMap.set(obj,sceneMap.get(obj.scene));
    //         }
    //         else
    //         {
    //             sceneMap.get(obj.scene).remove(obj);
    //             obj.graphic = graphic;
    //             sceneMap.get(obj.scene).add(obj);
    //         }
    //     }
    //     else
    //     {
    //         obj.graphic = graphic;
    //     }
    // }

    public function preRender():Void
    {
        renderedLayers = [];
    }

    public function postRender():Void
    {
        GL.bindFramebuffer(GL.FRAMEBUFFER,null);
        GL.clear(GL.COLOR_BUFFER_BIT | GL.DEPTH_BUFFER_BIT);
        trace('le');
        for(limeLayer in renderedLayers)
        {
            trace('le');
            GL.viewport (0, 0, window.width, window.height);
            postProcessShader(limeLayer.customRenderer.postProcessProgram);

            limeLayer.postProcessRender(window,quadBuffer);
        }

        GL.bindBuffer (GL.ARRAY_BUFFER, null);
        GL.bindTexture(GL.TEXTURE_2D, null);
    }

    public function add(obj:LimeObject)
    {
        var id = getId(obj.graphic);
        if(!graphicIdMap.exists(id))
        {
            trace('hello');
            graphicIdMap.set(id,new LimeGraphicsObject(id));
        }
        graphicIdMap.get(id).add(obj);
    }


    public function remove(obj:LimeObject)
    {
        var kek = getId(obj.graphic);
        var kek2 = graphicIdMap.get(kek);
        kek2.remove(obj);
    }
}