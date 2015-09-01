
package fluidity.backends.lime;

import lime.graphics.opengl.*;

import lime.utils.GLUtils;
import lime.utils.Float32Array;

import fluidity.GameObject;
import fluidity.GameScene;

class LimeScene{
    
    var rttTexture:GLTexture;
    public static var quadBuffer:GLBuffer;

    var sortNeeded = false;
    var scene:GameScene;

    public var customRenderer:CustomRenderer;
    public var objectMap:Map<GameObject,Float> = new Map<GameObject,Float>();
    public var objectList:Array<GameObject> = [];


    var projectionMatrixUniform:GLUniformLocation;

    var vertexAttribute:Int;
    var textureAttribute:Int;
    var mvMatrixUniform:GLUniformLocation;

    var graphicsLimeInstance:GraphicsLime;

    public function new(gameScene:GameScene,gli:GraphicsLime, program:GLProgram,postProcessProgram:GLProgram)
    {
        scene = gameScene;

        graphicsLimeInstance = gli;
        var data = 
            [          
                1, 1, 0,    1, 1,
                1, 0, 0,    1, 0,
                0, 1, 0,    0, 1,
                0, 0, 0,    0, 0   
            ];
        // var data = 
        //     [          
        //         .5, .5, 0,    1, 1,
        //         .5, -.5, 0,    1, 0,
        //         -.5, .5, 0,    0, 1,
        //         -.5, -.5, 0,    0, 0   
        //     ];
        
        quadBuffer = GL.createBuffer ();
        GL.bindBuffer (GL.ARRAY_BUFFER, quadBuffer);
        GL.bufferData (GL.ARRAY_BUFFER, new Float32Array (data), GL.STATIC_DRAW);
        GL.bindBuffer (GL.ARRAY_BUFFER, null);

        projectionMatrixUniform = GL.getUniformLocation (program, "uProjectionMatrix");
        
        vertexAttribute = GL.getAttribLocation (postProcessProgram, "aPosition");
        textureAttribute = GL.getAttribLocation (postProcessProgram, "aTexCoord");
        mvMatrixUniform = GL.getUniformLocation (postProcessProgram, "uViewMatrix");
    }

    public function layerSet()
    {
        rttTexture = GL.createTexture();
        GL.bindTexture(GL.TEXTURE_2D, rttTexture);
        GL.texParameteri (GL.TEXTURE_2D, GL.TEXTURE_MAG_FILTER, GL.NEAREST);
        GL.texParameteri (GL.TEXTURE_2D, GL.TEXTURE_MIN_FILTER, GL.NEAREST);
        GL.texParameteri (GL.TEXTURE_2D, GL.TEXTURE_WRAP_S, GL.CLAMP_TO_EDGE);
        GL.texParameteri (GL.TEXTURE_2D, GL.TEXTURE_WRAP_T, GL.CLAMP_TO_EDGE);
        GL.texImage2D(GL.TEXTURE_2D, 0, GL.RGBA, scene.layer.vWidth, scene.layer.vHeight, 0, GL.RGBA, GL.UNSIGNED_BYTE, null);
        GL.bindTexture(GL.TEXTURE_2D, null);  
    }

    public function reset()
    {
    }

    public function render()
    {

        // GL.viewport (0, 0, 1, 1);
        GL.viewport (0, 0, scene.layer.vWidth, scene.layer.vHeight);

        GL.clearColor (1,0,0,1);
        // GL.clear (GL.COLOR_BUFFER_BIT);

        // var matrix = lime.math.Matrix4.createOrtho (-window.width/2, window.width/2, window.height/2, -window.height/2, -2000, 2000);
        var matrix = lime.math.Matrix4.createOrtho (-400/2/scene.cameraScale + scene.camera.x, 400/2/scene.cameraScale + scene.camera.x, 300/2/scene.cameraScale + scene.camera.y, -300/2/scene.cameraScale + scene.camera.y, -2000, 2000);
        GL.uniformMatrix4fv (projectionMatrixUniform, false, matrix);


        GraphicsLimeObject.bindGeneral();

        var currentGraphic:GraphicsLimeObject = null;
        for(obj in objectList)
        {
            if(graphicsLimeInstance.graphicBin.get(obj.graphic) != currentGraphic)
            {
                if(currentGraphic != null)
                {
                    currentGraphic.unbind();
                }
                currentGraphic = graphicsLimeInstance.graphicBin.get(obj.graphic);
                currentGraphic.bind();
            }
        // customRenderPreFunc(obj);
            currentGraphic.render(obj);
        // customRenderPostFunc(obj);
        }
        if(currentGraphic != null)
        {
            currentGraphic.unbind();
        }
        GraphicsLimeObject.unbindGeneral();
    }

    public function renderBuffer()
    {
        GL.framebufferTexture2D(GL.FRAMEBUFFER, GL.COLOR_ATTACHMENT0, GL.TEXTURE_2D, rttTexture, 0);

        var mvMatrix = new lime.math.Matrix4();
        // trace(mvMatrix);

        mvMatrix.appendScale(2,2,1);
        // if(obj.angle != 0)
        // {
        //     mvMatrix.appendRotation(obj.angle,lime.math.Vector4.Z_AXIS);
        // }
        // mvMatrix.appendTranslation(.1,0,0);

        GL.uniformMatrix4fv (mvMatrixUniform, false, mvMatrix);

        GL.bindBuffer (GL.ARRAY_BUFFER, quadBuffer);
        GL.vertexAttribPointer (vertexAttribute, 3, GL.FLOAT, false, 5 * Float32Array.BYTES_PER_ELEMENT, 0);
        GL.vertexAttribPointer (textureAttribute, 2, GL.FLOAT, false, 5 * Float32Array.BYTES_PER_ELEMENT, 3 * Float32Array.BYTES_PER_ELEMENT);
                
        // GL.bindBuffer (GL.ARRAY_BUFFER, quadBuffer);
        // GL.vertexAttribPointer (vertexAttribute, 2, GL.FLOAT, false, 2 * Float32Array.BYTES_PER_ELEMENT, 0);
        // GL.activeTexture (GL.TEXTURE0);
        GL.bindTexture(GL.TEXTURE_2D, rttTexture);

        GL.drawArrays (GL.TRIANGLE_STRIP, 0, 4);

        GL.bindBuffer (GL.ARRAY_BUFFER, null);
        GL.bindTexture(GL.TEXTURE_2D, null);
    }


    public function updatePosition()
    // public function updatePosition(obj:GameObject)
    {
        sortNeeded = false;
        // if(objectMap.exists(obj))
        // {
            // var z = obj.z;
            // if(z != objectMap.get(obj))
            // {
                for(i in 1...objectList.length)
                {
                    if(objectList[i].z < objectList[i - 1].z)
                    {
                        var moved = false;
                        for(j in 1...i)
                        {
                            if(!moved && objectList[i].z > objectList[i - j].z)
                            {
                                objectList.insert(i - j + 1,objectList.splice(i,1)[0]);
                                moved = true;
                                break;
                            }
                        }
                        if(!moved)
                        {
                            objectList.insert(0,objectList.splice(i,1)[0]);
                        }
                    }
                }
                // // probably more efficient ways of doing this...
                // objectList.sort(function(obj1,obj2)
                //     {
                //         objectMap.set(obj1,obj1.z);
                //         objectMap.set(obj2,obj2.z);
                //         if(obj1.z < obj2.z)
                //         {
                //             return -1;
                //         }
                //         else if(obj1.z != obj2.z)
                //         {
                //             return 1;
                //         }

                //         return 0;
                //     });
            // }
        // }
    }

    public function add(obj:GameObject)
    {
        objectMap.set(obj,obj.z);
        // objectList.push(obj);
        var added = false;
        for(i in 0...objectList.length)
        {
            if(obj.z < objectList[0].z)
            {
                added = true;
                objectList.insert(i,obj);
                break;
            }
        }
        if(!added)
        {
            objectList.push(obj);
        }
    }

    public function remove(obj:GameObject)
    {
        objectMap.remove(obj);
        objectList.remove(obj);
    }
}