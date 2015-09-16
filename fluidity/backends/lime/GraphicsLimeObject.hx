package fluidity.backends.lime;

import fluidity.GameObject;
import lime.graphics.opengl.GLBuffer;
import lime.utils.Float32Array;
import lime.graphics.opengl.*;
import lime.Assets;

class GraphicsLimeObject { 

    public static var initialized = false;
    public static var quadBuffer:GLBuffer;
    public static var mvMatrixUniformLocation:GLUniformLocation;
    public static var texSizeUniformLocation:GLUniformLocation;
    public static var texOffsetUniformLocation:GLUniformLocation;
    public static var scaleUniformLocation:GLUniformLocation;
    // public static var rotationUniformLocation:GLUniformLocation;
    // public static var textures:Map<String,GLTexture>;
    public static var vertexAttribute:Int;
    public static var textureAttribute:Int;
    // public static var projectionMatrixUniform:GLUniformLocation;

    // public var mvMatrix:Matrix4;
    public var texture:GLTexture;
    public var width:Int = 0;
    public var height:Int = 0;


    // public var graphic:Graphic;
    public var graphicName:String;

    public var objects:Array<GameObject> = [];

    // public var frame:Int = 0;
    private var imageWidth:Float;
    private var imageFrames:Int;

    public static function init(program)
    {
        vertexAttribute = GL.getAttribLocation (program, "aPosition");
        textureAttribute = GL.getAttribLocation (program, "aTexCoord");

        mvMatrixUniformLocation = GL.getUniformLocation(program,"uModelViewMatrix");
        texSizeUniformLocation = GL.getUniformLocation(program,"uTexSize");
        texOffsetUniformLocation = GL.getUniformLocation(program,"uTexOffset");
        scaleUniformLocation = GL.getUniformLocation(program,"uScale");
        // rotationUniformLocation = GL.getUniformLocation(program,"uRotation");

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

        initialized = true;
    }

    public function new(filename:String)
    {
        // graphic = g;

        // var filename:String = switch (graphic) {
        //         case Image(f): f;
        //         case SpriteSheet(f,_,_,_,_,_): f;
        //     };

        var image = Assets.getImage (filename);

        // switch(graphic)
        // {
        //     case Image(_):
                width = image.width;
                height = image.height;
        //     case SpriteSheet(_,w,h,_,_,_):
        //         width = w;
        //         height = h;
        //         imageWidth = image.width;
        //         imageFrames = Math.floor(image.width/w);
        // };

        texture = GL.createTexture ();
        GL.bindTexture (GL.TEXTURE_2D, texture);
        GL.texParameteri (GL.TEXTURE_2D, GL.TEXTURE_WRAP_S, GL.CLAMP_TO_EDGE);
        GL.texParameteri (GL.TEXTURE_2D, GL.TEXTURE_WRAP_T, GL.CLAMP_TO_EDGE);
        #if js
        // GL.texImage2D (GL.TEXTURE_2D, 0, GL.RGBA, GL.RGBA, GL.UNSIGNED_BYTE, image.src);
        GL.texImage2D (GL.TEXTURE_2D, 0, GL.RGBA, image.buffer.width, image.buffer.height, 0, GL.RGBA, GL.UNSIGNED_BYTE, image.data);
        #else
        GL.texImage2D (GL.TEXTURE_2D, 0, GL.RGBA, image.buffer.width, image.buffer.height, 0, GL.RGBA, GL.UNSIGNED_BYTE, image.data);
        #end
        GL.texParameteri (GL.TEXTURE_2D, GL.TEXTURE_MAG_FILTER, GL.NEAREST);
        GL.texParameteri (GL.TEXTURE_2D, GL.TEXTURE_MIN_FILTER, GL.NEAREST);
        GL.bindTexture (GL.TEXTURE_2D, null);
    }

    public static function bindGeneral()
    {
        #if desktop
        GL.enable (GL.TEXTURE_2D);
        #end  

        GL.bindBuffer (GL.ARRAY_BUFFER, quadBuffer);
        GL.vertexAttribPointer (vertexAttribute, 3, GL.FLOAT, false, 5 * Float32Array.BYTES_PER_ELEMENT, 0);
        GL.vertexAttribPointer (textureAttribute, 2, GL.FLOAT, false, 5 * Float32Array.BYTES_PER_ELEMENT, 3 * Float32Array.BYTES_PER_ELEMENT);
    }

    public function bind()
    {
        GL.activeTexture (GL.TEXTURE0);
        GL.bindTexture (GL.TEXTURE_2D, texture);
    }

    public function unbind()
    {
        GL.bindTexture(GL.TEXTURE_2D, null);
    }

    public static function unbindGeneral()
    {
        GL.bindBuffer (GL.ARRAY_BUFFER, null);
    }

    public static function compareGraphic(obj1:GameObject,obj2:GameObject)
    {
        var filename:String = switch (obj1.graphic) {
                case Image(f): f;
                case SpriteSheet(f,_,_,_,_,_): f;
            };


        var filename2:String = switch (obj2.graphic) {
                case Image(f): f;
                case SpriteSheet(f,_,_,_,_,_): f;
            };

        return filename == filename2;
    }

    public function render(obj:GameObject,program:GLProgram,customRenderPreFunc:GameObject->Void,customRenderPostFunc:GameObject->Void)
    {
        vertexAttribute = GL.getAttribLocation (program, "aPosition");
        textureAttribute = GL.getAttribLocation (program, "aTexCoord");

        mvMatrixUniformLocation = GL.getUniformLocation(program,"uModelViewMatrix");
        texSizeUniformLocation = GL.getUniformLocation(program,"uTexSize");
        texOffsetUniformLocation = GL.getUniformLocation(program,"uTexOffset");
        scaleUniformLocation = GL.getUniformLocation(program,"uScale");

        var offsetX:Float = 0;

        var texWidth:Float = 1;
        var drawWidth = width;
        var drawHeight = height;

        switch (obj.graphic) {
            case SpriteSheet(_,w,h,frames,frameLength,loop):
                if(Math.floor(obj.currentAnimationTime/frameLength) == frames.length)
                {
                    //send animend event
                }
                if(loop && Math.floor(obj.currentAnimationTime/frameLength) >= frames.length)
                {
                    obj.currentAnimationTime = 0;
                }
                var frame:Int = Math.floor(Math.min(frames.length,Math.floor(obj.currentAnimationTime/frameLength)));

                offsetX = frames[frame]/(width/w);
                texWidth = w/width;

                drawWidth = w;
                drawHeight = h;
                // offsetY = Math.floor(frames[frame] / imageWidth);
            default:
                GL.uniform2f(texOffsetUniformLocation,0,0);
                GL.uniform2f(texSizeUniformLocation,1,1);
        }

        GL.uniform2f(texOffsetUniformLocation,offsetX,0);
        GL.uniform2f(texSizeUniformLocation,texWidth,1);

        var flip = 1;
        if(obj.flip)
        {
            flip = -1;
        }
        GL.uniform2f(scaleUniformLocation,flip*obj.scale * drawWidth,obj.scale * drawHeight);
        // GL.uniform1f(rotationUniformLocation,obj.angle);

        customRenderPreFunc(obj);
        var mvMatrix = new lime.math.Matrix4();

        // mvMatrix.appendScale(width*obj.scale,height*obj.scale,1);
        if(obj.angle != 0)
        {
            mvMatrix.appendRotation(obj.angle,lime.math.Vector4.Z_AXIS);
        }
        mvMatrix.appendTranslation(obj.position.x,obj.position.y,obj.z);

        GL.uniformMatrix4fv (mvMatrixUniformLocation, false, mvMatrix);
        
        GL.drawArrays (GL.TRIANGLE_STRIP, 0, 4);
        customRenderPostFunc(obj);
    }

    public function add(obj:GameObject)
    {
        objects.push(obj);
    }

    public function remove(obj:GameObject)
    {
        objects.remove(obj);
    }
}