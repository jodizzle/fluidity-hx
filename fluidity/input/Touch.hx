
package fluidity.input;

import fluidity.utils.Vec2;

class Touch {

    public var active:Bool = true;

    public var id:Int;

    public var position:Vec2;
    public var movement:Vec2;

    public function new(id:Int, position:Vec2, movement:Vec2)
    {
        this.id = id;
        this.position = position;
        this.movement = movement;
    }

    private function getEvent(eventName)
    {
        var event = new GameEvent(eventName);
        event.touch = this;
    }
}