
import haxe.macro.Context;
import haxe.macro.Expr;

class TestMacro {

    static var componentTypes:Map<String,String>;

    static function getClass(path:TypePath)
    {
        var name = '';
        for(pack in path.pack)
        {
            name += pack + '.';
        }
        name += path.name;
        return name;
    }

    macro static public function build():Array<Field>
    {
        var fields = Context.getBuildFields();
        var pos = Context.currentPos();
        var populateExprs = [];

        if(componentTypes == null)
        {
            componentTypes = new Map<String,String>();
        }

        for (i in Context.getLocalClass().get().interfaces)
        {
            for(field in i.t.get().fields.get())
            {
                var alreadyExists:Bool = false;
                for(f in fields) {
                    if(field.name == f.name)
                    {
                        alreadyExists = true;
                        break;
                    }
                }

                if(!alreadyExists)
                {
                    fields.push({
                                    name: field.name,
                                    kind: FVar(Context.toComplexType(field.type)),
                                    access: [APublic],
                                    pos: Context.currentPos()
                                });
                }
            }
        }
        return fields;
    }
}