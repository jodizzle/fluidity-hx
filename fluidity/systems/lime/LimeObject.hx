
package fluidity.systems.lime;

import fluidity.utils.Vec2;
import fluidity.utils.Graphic;
import lime.graphics.opengl.GLBuffer;
import lime.utils.Float32Array;
import lime.graphics.opengl.*;
import lime.Assets;

interface LimeObject { 

    // public var state:FState<GameObject,GameEvent>;

    public var position:Vec2 = new Vec2(0,0);
    public var velocity:Vec2 = new Vec2(0,0);

    // public var worldAngle(get,never):Float;
    // public var worldScale(get,never):Float;
    // public var worldPosition(get,never):Vec2;

    public var angle:Float = 0;
    public var angularVelocity:Float = 0;

    public var parent:LimeObject;
    public var hasParent:Bool = false;

    public var z:Float = 1;
    public var scale:Float = 1;

    public var currentAnimationTime = 0;

    public var graphic:Graphic;

    public var flip:Bool = false;
}