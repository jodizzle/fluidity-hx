package fluidity2.backends;

import fluidity2.GameObject;
import fluidity2.TypeBin;
import lime.graphics.opengl.*;
import lime.utils.GLUtils;
import lime.ui.Window;
import lime.utils.Float32Array;

class LimeGraphicsBackend implements IGraphicsBackend { 

    public var objectMap:Map<GameObject,Float> = new Map<GameObject,Float>();
    public var objectList:Array<GameObject> = [];
    public var graphicBin:EnumBin<Graphic,LimeGraphicsObject>;

    public var program:GLProgram;

    public var postProcessProgram:GLProgram;

    public var window:Window;

    public var customRenderer:CustomRenderer;

    var rttFramebuffer:GLFramebuffer;
    var rttTexture:GLTexture;
    var quadBuffer:GLBuffer;

    public function new(w)
    {
        window = w;

        initBins();
        initGL();
    };

    public function setCustom(custom:CustomRenderer)
    {
        customRenderer = custom;
        initGL();
    }

    private function initBins()
    {

        graphicBin = new EnumBin<Graphic,LimeGraphicsObject>(
            function(g:Graphic)
            {
                var obj = new LimeGraphicsObject(g);
                if(customRenderer != null && customRenderer.customRenderPreFunc != null)
                {
                    obj.customRenderPreFunc = customRenderer.customRenderPreFunc;
                }
                if(customRenderer != null && customRenderer.customRenderPostFunc != null)
                {
                    obj.customRenderPostFunc = customRenderer.customRenderPostFunc;
                }
                return obj;
            });
    }

    private function initGL()
    {
        var vertexSource = '';
        if(customRenderer != null && customRenderer.vertexSource != null)
        {
            vertexSource = customRenderer.vertexSource;
        }
        else
        {
            vertexSource = 
            
            "attribute vec4 aPosition;
            attribute vec2 aTexCoord;
            varying vec2 vTexCoord;
            
            uniform mat4 uProjectionMatrix;
            uniform mat4 uModelViewMatrix;
            uniform vec2 uTexSize;
            uniform vec2 uTexOffset;

            uniform vec2 uScale;
            // uniform float uRotation;
            
            void main(void) {
                
                vTexCoord = uTexOffset + aTexCoord * uTexSize;
                // mat4 rot = rotationMatrix(uRotation);
                vec4 scale = aPosition * vec4(uScale,1,1);
                gl_Position = uProjectionMatrix * uModelViewMatrix * scale;
                
            }
            // mat4 rotationMatrix(float angle)
            // {
            //     float s = sin(angle);
            //     float c = cos(angle);
            //     float oc = 1.0 - c;
                
            //     return mat4(c,       - 1.0 * s, 0.0,                0.0,
            //                 1.0 * s, c,         0.0,                0.0,
            //                 0.0,     0.0,       oc * 1.0 * 1.0 + c, 0.0,
            //                 0.0,     0.0,       0.0,                1.0);
            // }
            ";
        }
        
        var fragmentSource = '';
        if(customRenderer != null && customRenderer.fragmentSource != null)
        {
            fragmentSource = customRenderer.fragmentSource;
        }
        else
        {
            fragmentSource = 
            
            #if !desktop
            "precision mediump float;" +
            #end
            "varying vec2 vTexCoord;
            uniform sampler2D uImage0;
            
            void main(void)
            {
                gl_FragColor = texture2D (uImage0, vTexCoord);
            }";
        }
        
        program = GLUtils.createProgram (vertexSource, fragmentSource);

        GL.depthFunc(GL.NEVER);

        LimeGraphicsObject.init(program);


        vertexSource = '';
        if(false && customRenderer != null && customRenderer.vertexSource != null)
        {
            vertexSource = customRenderer.vertexSource;
        }
        else
        {
            vertexSource = 
            
            "
            attribute vec4 aPosition;
            attribute vec2 aTexCoord;
            varying vec2 vTexCoord;

            void main(void) {
              gl_Position = aPosition;
              vTexCoord = aTexCoord;
            }
            ";
        }
        
        fragmentSource = '';
        if(false && customRenderer != null && customRenderer.fragmentSource != null)
        {
            fragmentSource = customRenderer.fragmentSource;
        }
        else
        {
            fragmentSource = 
            
            #if !desktop
            "precision mediump float;" +
            #end
            "varying vec2 vTexCoord;
            uniform sampler2D uImage0;
            
            void main(void)
            {
                gl_FragColor = texture2D (uImage0, vTexCoord);
            }";
        }

        postProcessProgram = GLUtils.createProgram (vertexSource, fragmentSource);

        GL.activeTexture(GL.TEXTURE0);
        rttTexture = GL.createTexture();
        GL.bindTexture(GL.TEXTURE_2D, rttTexture);
        GL.texParameteri (GL.TEXTURE_2D, GL.TEXTURE_MAG_FILTER, GL.NEAREST);
        GL.texParameteri (GL.TEXTURE_2D, GL.TEXTURE_MIN_FILTER, GL.NEAREST);
        GL.texParameteri (GL.TEXTURE_2D, GL.TEXTURE_WRAP_S, GL.CLAMP_TO_EDGE);
        GL.texParameteri (GL.TEXTURE_2D, GL.TEXTURE_WRAP_T, GL.CLAMP_TO_EDGE);
        GL.texImage2D(GL.TEXTURE_2D, 0, GL.RGBA, 400, 300, 0, GL.RGBA, GL.UNSIGNED_BYTE, null);

        /* Depth buffer */
        // glGenRenderbuffers(1, &rbo_depth);
        // glBindRenderbuffer(GL.RENDERBUFFER, rbo_depth);
        // glRenderbufferStorage(GL.RENDERBUFFER, GL.DEPTH_COMPONENT16, 400, 600);
        // glBindRenderbuffer(GL.RENDERBUFFER, 0);

        /* Framebuffer to link everything together */
        rttFramebuffer = GL.createFramebuffer();
        GL.bindFramebuffer(GL.FRAMEBUFFER, rttFramebuffer);
        // rttFramebuffer.width = 400;
        // rttFramebuffer.height = 600;

        GL.framebufferTexture2D(GL.FRAMEBUFFER, GL.COLOR_ATTACHMENT0, GL.TEXTURE_2D, rttTexture, 0);
        // glFramebufferRenderbuffer(GL.FRAMEBUFFER, GL.DEPTH_ATTACHMENT, GL.RENDERBUFFER, rbo_depth);

        GL.bindTexture(GL.TEXTURE_2D, null);
        GL.bindFramebuffer(GL.FRAMEBUFFER, null);

        var data = 
            [          
                1, 1, 0,    1, 1,
                1, -1, 0,    1, 0,
                -1, 1, 0,    0, 1,
                -1, -1, 0,    0, 0   
            ];
        
        quadBuffer = GL.createBuffer ();
        GL.bindBuffer (GL.ARRAY_BUFFER, quadBuffer);
        GL.bufferData (GL.ARRAY_BUFFER, new Float32Array (data), GL.STATIC_DRAW);
        GL.bindBuffer (GL.ARRAY_BUFFER, null);


    }

    private function normalShader()
    {
        GL.useProgram (program);

        var vertexAttribute = GL.getAttribLocation (program, "aPosition");
        GL.enableVertexAttribArray (vertexAttribute);
        
        var textureAttribute = GL.getAttribLocation (program, "aTexCoord");
        GL.enableVertexAttribArray (textureAttribute);
        
        var imageUniform = GL.getUniformLocation (program, "uImage0");
        GL.uniform1i (imageUniform, 0);

        GL.bindFramebuffer(GL.FRAMEBUFFER, rttFramebuffer);

        if(customRenderer != null && customRenderer.customInitFunc != null)
        {
            customRenderer.customInitFunc(program);
        }
    }

    private function postProcessShader()
    {
        GL.useProgram (postProcessProgram);

        var imageUniform = GL.getUniformLocation (program, "uImage0");
        GL.uniform1i (imageUniform, 0);

        // glUniform1i(uniform_rttTexture, 0);
        // glEnableVertexAttribArray(attribute_v_coord_postproc);

        GL.bindFramebuffer(GL.FRAMEBUFFER, null);
    }

    public function newScene(scene:GameScene){};
    public function sceneAdd(scene:GameScene,obj:GameObject){};
    public function sceneRemove(scene:GameScene,obj:GameObject){};
    public function sceneUpdate(scene:GameScene){};
    public function sceneStart(scene:GameScene){};
    public function sceneStop(scene:GameScene){};

    public function objectDispose(obj:GameObject)
    {
        if(obj.graphic != null)
        {
            objectList.remove(obj);
            objectMap.remove(obj);
        }
    }

    public function sceneRender(scene:GameScene)
    {
        GL.viewport (0, 0, 400, 300);
        GL.clearColor (0,0,0,1);

        normalShader();
        GL.clear (GL.COLOR_BUFFER_BIT);

        var projectionMatrixUniform = GL.getUniformLocation (program, "uProjectionMatrix");

        // var matrix = lime.math.Matrix4.createOrtho (-window.width/2, window.width/2, window.height/2, -window.height/2, -2000, 2000);
        var matrix = lime.math.Matrix4.createOrtho (-400/2/scene.cameraScale + scene.camera.x, 400/2/scene.cameraScale + scene.camera.x, 300/2/scene.cameraScale + scene.camera.y, -300/2/scene.cameraScale + scene.camera.y, -2000, 2000);
        GL.uniformMatrix4fv (projectionMatrixUniform, false, matrix);


        LimeGraphicsObject.bindGeneral();

        var currentGraphic:LimeGraphicsObject = null;
        for(obj in objectList)
        {
            if(graphicBin.get(obj.graphic) != currentGraphic)
            {
                if(currentGraphic != null)
                {
                    currentGraphic.unbind();
                }
                currentGraphic = graphicBin.get(obj.graphic);
                currentGraphic.bind();
            }
            currentGraphic.render(obj);
        }
        if(currentGraphic != null)
        {
            currentGraphic.unbind();
        }
        LimeGraphicsObject.unbindGeneral();


        GL.viewport (0, 0, window.width, window.height);
        postProcessShader();

        var vertexAttribute = GL.getAttribLocation (program, "aPosition");
        var textureAttribute = GL.getAttribLocation (program, "aTexCoord");
        GL.bindBuffer (GL.ARRAY_BUFFER, quadBuffer);
        GL.vertexAttribPointer (vertexAttribute, 3, GL.FLOAT, false, 5 * Float32Array.BYTES_PER_ELEMENT, 0);
        GL.vertexAttribPointer (textureAttribute, 2, GL.FLOAT, false, 5 * Float32Array.BYTES_PER_ELEMENT, 3 * Float32Array.BYTES_PER_ELEMENT);
                
        // GL.bindBuffer (GL.ARRAY_BUFFER, quadBuffer);
        // GL.vertexAttribPointer (vertexAttribute, 2, GL.FLOAT, false, 2 * Float32Array.BYTES_PER_ELEMENT, 0);
        GL.activeTexture (GL.TEXTURE0);
        GL.bindTexture(GL.TEXTURE_2D, rttTexture);

        GL.drawArrays (GL.TRIANGLE_STRIP, 0, 4);

        GL.bindBuffer (GL.ARRAY_BUFFER, null);
        GL.bindTexture(GL.TEXTURE_2D, null);
    }

    public function newObject(obj:GameObject){};
    public function objectSet(obj:GameObject,graphic:Graphic)
    {
        if(obj.graphic != null)
        {
            objectList.remove(obj);
            objectList.push(obj);
        }
        else
        {

            var i = Math.floor(objectList.length/2);

            objectMap.set(obj,obj.z + 1);
            objectList.push(obj);
            updatePosition(obj);
        }
        obj.graphic = graphic;


    }

    public function updatePosition(obj:GameObject)
    {
        if(objectMap.exists(obj))
        {
            var z = obj.z;
            if(z != objectMap.get(obj))
            {
                var originalIndex:Int;
                var index = originalIndex = objectList.indexOf(obj);

                while(index > 0 && objectList[index - 1].z > z)
                {
                    index--;
                }
                while(index < objectList.length - 1 && objectList[index + 1].z <= z)
                {
                    index++;
                }
                objectList.insert(index,objectList.splice(originalIndex,1)[0]);
                objectMap.set(obj,z);
            }
        }
    }

    public function objectUpdate(obj:GameObject)
    {
        updatePosition(obj);
    }
}