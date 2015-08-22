
package fluidity2;

class GameEvent {

    public var id:String;
    public var userData(default,null):Dynamic<Dynamic>;
    // public var userData(default,null):Dynamic<Dynamic> = new Dynamic<Dynamic>();

    public var collision:Collision;

    public function new(id:String,?col:Collision)
    {
        this.id = id;
        collision = col;
    }
}