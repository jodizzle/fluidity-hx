
package fluidity.input;


class SceneInput {

    public function new()
    {
    }

    public var keyMap:Map<Key,String> = new Map<Key,String>();
    public var inputStates:Map<String,Bool> = new Map<String,Bool>();

    public var axisMap:Map<String,Axis> = new Map<String,Axis>();
    public var negativeKeyAxisMap:Map<Key,Axis> = new Map<Key,Axis>();
    public var positiveKeyAxisMap:Map<Key,Axis> = new Map<Key,Axis>();
    
    public var keyDownEvents:Array<KeyHandler> = [];
    public var keyUpEvents:Array<KeyHandler> = [];
    public var keyHeldEvents:Array<KeyHandler> = [];

    public function registerAxis(negativeKey:Key,positiveKey:Key,axisName:String)
    {
        var axis:Axis =axisMap.get(axisName);
        if(axis == null)
        {
            axis = new Axis();
            axisMap.set(axisName, axis);
        }
        negativeKeyAxisMap.set(negativeKey,axis);
        positiveKeyAxisMap.set(positiveKey,axis);

        return this;
    }

    public function delete(obj:GameObject)
    {
        removeObjectFromList(keyDownEvents,obj);
        removeObjectFromList(keyUpEvents,obj);
        removeObjectFromList(keyHeldEvents,obj);
    }

    private function removeObjectFromList(events:Array<KeyHandler>,obj:GameObject)
    {
        var toRemove = [];
        for(i in 0...events.length)
        {
            switch (events[i])
            {
                case Object(_,object,_):
                    if(object == obj)
                    {
                        toRemove.push(i);
                    }
                default:
            }
        }
        for(i in toRemove)
        {
            events.splice(i,1);
        }
    }

    public function registerInput(key:Key,inputName:String)
    {
        keyMap.set(key,inputName);
        if(!inputStates.exists(inputName))
        {
            inputStates.set(inputName,false);
        }
        return this;
    }

    public function getInput(inputName:String)
    {
        return inputStates.get(inputName);
    }

    public function registerObjectOnKeyDown(inputName:String,obj:GameObject,eventName:String)
    {
        keyDownEvents.push(Object(inputName,obj,eventName));
        return this;
    }

    public function registerObjectOnKeyUp(inputName:String,obj:GameObject,eventName:String)
    {
        keyUpEvents.push(Object(inputName,obj,eventName));
        return this;
    }

    public function registerObjectOnKeyHeld(inputName:String,obj:GameObject,eventName:String)
    {
        keyHeldEvents.push(Object(inputName,obj,eventName));
        return this;
    }

    public function registerFunctionOnKeyDown(inputName:String,func:Void->Void)
    {
        keyDownEvents.push(Function(inputName,func));
        return this;
    }

    public function registerFunctionOnKeyUp(inputName:String,func:Void->Void)
    {
        keyUpEvents.push(Function(inputName,func));
        return this;
    }

    public function registerFunctionOnKeyHeld(inputName:String,func:Void->Void)
    {
        keyHeldEvents.push(Function(inputName,func));
        return this;
    }

    public function getAxis(axisName:String)
    {
        return axisMap.get(axisName).value;
    }

    public function update()
    {
        
    }
}