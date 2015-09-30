
package fluidity.ash.systems;

import ash.tools.ListIteratingSystem;

// typedef StateNode = {
//   public var object:Object;
// }

class StateSystem<TNode:(Object<Dynamic>)> extends ObjectSystem<TNode>
{
    public function new(objClass:Class<TNode>)
    {
        super(TNode, updateNode);
    }

    // private function updateNode(node:TNode, time:Float):Void
    // {
    //     node.update();
    // }
}
