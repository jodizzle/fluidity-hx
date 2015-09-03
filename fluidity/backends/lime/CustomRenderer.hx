
package fluidity.backends.lime;

import lime.utils.GLUtils;
import lime.graphics.opengl.GLProgram;

class CustomRenderer
{
    public var vertexSource:String = null;
    public var fragmentSource:String = null;

    public var postProcessVertexSource:String = null;
    public var postProcessFragmentSource:String = null;

    public var initFunc:GLProgram->Void = function(f){};

    public var renderPreFunc:GameObject->Void = function(o){};
    public var renderPostFunc:GameObject->Void = function(o){};

    public var postProcessInitFunc:GLProgram->Void = function(f){};

    public var postProcessRenderPreFunc:GameObject->Void = function(o){};
    public var postProcessRenderPostFunc:GameObject->Void = function(o){};


    public var initialized:Bool = false;
    public var program:GLProgram = null;
    public var postProcessProgram:GLProgram = null;

    public function new(){};

    public function init()
    {
        initialized = true;

        if(vertexSource == null)
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
        
        if(fragmentSource == null)
        {
            fragmentSource = 
            
            #if !desktop
            "precision mediump float;" +
            #end
            "varying vec2 vTexCoord;
            uniform sampler2D uImage0;
            
            void main(void)
            {
                vec4 texel = texture2D(uImage0, vTexCoord);
                // if (texel.a < 0.1)
                //     discard; 
                gl_FragColor = texel;
            }";
        }
        
        program = GLUtils.createProgram (vertexSource, fragmentSource);


        if(postProcessVertexSource == null)
        {
            postProcessVertexSource = 
            
            "
            attribute vec4 aPosition;
            attribute vec2 aTexCoord;
            varying vec2 vTexCoord;
            uniform mat4 uViewMatrix;
            uniform mat4 uProjectionMatrix;

            void main(void) {
              gl_Position = uProjectionMatrix*uViewMatrix*aPosition;
              vTexCoord = aTexCoord;
            }
            ";
        }
        
        if(postProcessFragmentSource == null)
        {
            postProcessFragmentSource = 
            
            #if !desktop
            "precision mediump float;" +
            #end
            "varying vec2 vTexCoord;
            uniform sampler2D uImage0;
            
            void main(void)
            {
                vec4 texel = texture2D(uImage0, vTexCoord);
                // if (texel.a < 0.1)
                //     discard; 
                gl_FragColor = texel;
            }";
        }

        postProcessProgram = GLUtils.createProgram (postProcessVertexSource, postProcessFragmentSource);

    }
}