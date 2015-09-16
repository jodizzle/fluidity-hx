
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

    public var pointerClickEvents:Array<PointerEventType> = [];
    public var pointerMoveEvents:Array<PointerEventType> = [];
    public var pointerReleaseEvents:Array<PointerEventType> = [];
    public var touchClickEvents:Array<TouchEventType> = [];
    public var touchMoveEvents:Array<TouchEventType> = [];
    public var touchReleaseEvents:Array<TouchEventType> = [];

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

    public function getAxis(axisName:String)
    {
        return axisMap.get(axisName).value;
    }

    public function registerFunctionOnPointerClick(button:Int,func:Pointer->Void)
    {
        pointerClickEvents.push(ButtonFunction(button,func));
        return this;
    }

    public function registerFunctionOnPointerMove(func:Pointer->Void)
    {
        pointerMoveEvents.push(Function(func));
        return this;
    }

    public function registerFunctionOnPointerRelease(button:Int,func:Pointer->Void)
    {
        pointerReleaseEvents.push(ButtonFunction(button,func));
        return this;
    }

    public function registerObjectOnPointerClick(obj:GameObject,button:Int,eventName:String)
    {
        pointerClickEvents.push(ButtonObject(button,obj,eventName));
        return this;
    }

    public function registerFunctionOnTouchClick(func:Touch->Void)
    {
        touchClickEvents.push(Function(func));
        return this;
    }

    public function registerFunctionOnTouchMove(func:Touch->Void)
    {
        touchMoveEvents.push(Function(func));
        return this;
    }

    public function registerFunctionOnTouchRelease(func:Touch->Void)
    {
        touchReleaseEvents.push(Function(func));
        return this;
    }

    public function registerObjectOnTouchClick(obj:GameObject,eventName:String)
    {
        touchClickEvents.push(Object(obj,eventName));
        return this;
    }

    public function update()
    {
        
    }
}