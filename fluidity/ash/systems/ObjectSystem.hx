
package fluidity.ash.systems;

import ash.tools.ListIteratingSystem;

class ObjectSystem<TNode> extends ListIteratingSystem<TNode>
{
    public function new()
    {
        super(TNode, updateNode);
    }

    private function updateNode(node:TNode, time:Float):Void
    {

    }
}
