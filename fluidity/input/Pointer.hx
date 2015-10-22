
package fluidity.input;

import nape.geom.Vec2;


class Pointer {

    public var active:Bool = true;

    public var buttons:Array<Bool> = [false,false,false,false,false];

    public var position(get,never):Vec2;
    public var movement(get,never):Vec2;

    public static var mousePosition:Vec2 = new Vec2();
    public static var mouseMovement:Vec2 = new Vec2();

    public var onMoveEvents:Array<PointerEventType> = [];
    public var onReleaseEvents:Array<PointerEventType> = [];

    public function new()//position:Vec2, movement:Vec2)
    {
        // this.id = id;
        // this.position = position;
        // this.movement = movement;
    }

    public function get_position()
    {
        return mousePosition;
    }

    public function get_movement()
    {
        return mouseMovement;
    }
}