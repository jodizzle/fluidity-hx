
package fluidity.ash.systems;

import ash.tools.ListIteratingSystem;

class ObjectSystem<TNode> extends ListIteratingSystem<TNode>
{
    public function new(objClass:Class<TNode>)
    {
        super(objClass, updateNode);
    }

    private function updateNode(node:TNode, time:Float):Void
    {

    }
}
