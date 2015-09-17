
package fluidity.utils;

class Vec2 {
    public var x:Float = 0;
    public var y:Float = 0;

    public var length(get,set):Float;
    public var angle(get,set):Float;

    public function new(?x:Float,?y:Float)
    {
        if(x != null)
        {
            this.x = x;
            this.y = y;
        }
    }

    public static function distance(a:Vec2,b:Vec2)
    {
        return a.sub(b).length;
    }
    // public static function dsq(a:Vec2,b:Vec2);

    public static function fromPolar(length:Float,angle:Float):Vec2
    {
        return new Vec2(Math.cos(angle)*length, Math.sin(angle)*length);
    }

    public inline function add(vec:Vec2):Vec2
    {
        return new Vec2(x + vec.x, y + vec.y);
    }

    public inline function addMul(vec:Vec2,scalar:Float):Vec2
    {
        return new Vec2(x + vec.x * scalar, y + vec.y * scalar);
    }

    public inline function addeq(vec:Vec2):Vec2
    {
        x += vec.x;
        y += vec.y;
        return this;
    }

    public inline function copy():Vec2
    {
        return new Vec2(x,y);
    }

    public inline function cross(vec:Vec2):Float
    {
        trace('unimplemented');
        return 1;
    }

    public inline function dot(vec:Vec2):Float
    {
        trace('unimplemented');
        return 1;
    }

    public inline function lsq():Float
    {
        trace('unimplemented');
        return 1;
    }

    public inline function mul(scalar:Float):Vec2
    {
        return new Vec2(x*scalar,y*scalar);
    }

    public inline function muleq(scalar:Float):Vec2
    {
        x *= scalar;
        y *= scalar;
        return this;
    }

    public inline function normalise():Vec2
    {
        length = 1;
        return this;
    }

    public inline function rotate(radians:Float):Vec2
    {

        var s = Math.sin(radians);
        var c = Math.cos(radians);
        var newX = x * c - y *s;
        var newY = x * s + y *c;
        setxy(newX,newY);
        return this;
    }

    public inline function set(vec:Vec2):Vec2
    {
        x = vec.x;
        y = vec.y;
        return this;
    }

    public inline function setxy(x:Float,y:Float):Vec2
    {
        this.x = x;
        this.y = y;
        return this;
    }

    public inline function sub(vec:Vec2):Vec2
    {
        return new Vec2(x - vec.x, y - vec.y);
    }

    public inline function subeq(vec:Vec2):Vec2
    {
        x -= vec.x;
        y -= vec.y;
        return this;
    }

    public inline function unit():Vec2
    {
        return copy().normalise();
    }

    public inline function get_length():Float
    {
        return Math.sqrt(x*x + y*y);
    }

    public inline function set_length(a:Float):Float
    {
        var oldLength = length;
        x *= a/oldLength;
        y *= a/oldLength;
        return a;
    }

    public inline function get_angle():Float
    {
        return Math.atan2(y,x);
    }

    public inline function set_angle(a:Float):Float
    {
        trace('unimplemented set angle');
        return a;
    }
}