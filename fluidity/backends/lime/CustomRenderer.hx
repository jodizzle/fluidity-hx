
package fluidity.backends.lime;

import lime.graphics.opengl.GLProgram;

class CustomRenderer
{
    public var vertexSource:String;
    public var fragmentSource:String;

    public var customInitFunc:GLProgram->Void;

    public var customRenderPreFunc:GameObject->Void;
    public var customRenderPostFunc:GameObject->Void;

    public function new(){};
}