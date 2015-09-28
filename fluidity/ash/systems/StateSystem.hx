
package fluidity.ash.systems;

import ash.tools.ListIteratingSystem;

typedef StateNode = {
  public var object:Object;
}

class StateSystem<TNode:(StateNode)> extends ObjectSystem<TNode>
{
    public function new()
    {
        super(TNode, updateNode);
    }

    private function updateNode(node:TNode, time:Float):Void
    {
        node.object.update();
    }
}
