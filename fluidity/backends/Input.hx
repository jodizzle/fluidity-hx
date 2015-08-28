
package fluidity.backends;

import fluidity.utils.Key;
import haxe.ds.ObjectMap;
import haxe.ds.StringMap;

class Input
{

    public static var ONKEYDOWN = 0;
    public static var ONKEYUP = 1;

    private var keyStates:Map<Key,Bool> = new Map<Key,Bool>();

    private var nameKeys:Map<Key,String> = new Map<Key,String>();
    private var keyNames:Map<String,Key> = new Map<String,Key>();

    private var keyAxisMap:Map<Key,String> = new Map<Key,String>();

    private var axisStateNegative:Map<String,Bool> = new Map<String,Bool>();
    private var axisStatePositive:Map<String,Bool> = new Map<String,Bool>();

    private var axisKeyStateNegative:Map<Key, Bool> = new Map<Key, Bool>();
    private var axisKeyStatePositive:Map<Key, Bool> = new Map<Key, Bool>();

    private var axisState:Map<String,Int> = new Map<String,Int>();

    private var registeredFunctions:Map<String,Void->Void> = new Map<String,Void->Void>();

    private var axes:Array<String> = [];
    private var positiveAxisKeys:Array<Key> = [];
    private var negativeAxisKeys:Array<Key> = [];

    public function new()
    {

    }

    public function reset()
    {
        for(key in keyNames)
        {
            keyStates.set(key,false);
        }
        for(axis in axes)
        {
            axisState.set(axis,0);
            axisStateNegative.set(axis,false);
            axisStatePositive.set(axis,false);
        }
        for(key in negativeAxisKeys)
        {
            axisKeyStateNegative.set(key,false);
        }
        for(key in positiveAxisKeys)
        {
            axisKeyStatePositive.set(key,false);
        }
    }

    public function registerFunction(event:Int,inputName:String,func:Void->Void):Input
    {
        registeredFunctions.set(inputName + event,func);
        return this;
    }

    public function registerInput(key:Key,inputName:String):Input
    {
        keyStates.set(key,false);
        keyNames.set(inputName,key);
        nameKeys.set(key,inputName);
        return this;
    } 

    public function registerAxis(negative:Key,positive:Key,axisName:String):Input
    {
        registerInput(negative,axisName + '-');
        registerInput(positive,axisName + '+');
        keyAxisMap.set(negative,axisName);
        keyAxisMap.set(positive,axisName);
        axisKeyStateNegative.set(negative,false);
        axisKeyStatePositive.set(positive,false);
        axisStateNegative.set(axisName,false);
        axisStatePositive.set(axisName,false);

        axes.push(axisName);
        positiveAxisKeys.push(positive);
        negativeAxisKeys.push(negative);

        axisState.set(axisName,0);

        return this;
    }

    public function get(inputName:String):Bool
    {
        var key = keyNames.get(inputName);
        if(key != null)
        {
            var keyState = keyStates.get(key);
            if(keyState != null)
            {
                return keyState;
            }
            trace('key ' + key.output + ' for input ' + inputName + ' is not registered');
            return false;
        }
        trace('input name ' + inputName + ' has no associated key');
        return false;
    }


    public function getAxis(axisName:String):Int
    {
        var axisState = axisState.get(axisName);
        if(axisState != null)
        {
            return axisState;
        }
        trace('axis name ' + axisName + ' is not registered');
        return 0;
    }

    private function runFunction(key:Key,type:Int)
    {
        var input = nameKeys.get(key);
        if(input != null)
        {
            var func = registeredFunctions.get(input + type);
            if(func != null)
            {
                func();
            }
        }
    }

    public function onKeyDown(key:Key)
    {

        var negativeState = axisKeyStateNegative.get(key);
        if(negativeState != null)
        {
            var axis = keyAxisMap.get(key);
            if(!negativeState)
            {
                axisKeyStateNegative.set(key,true);
                axisStateNegative.set(axis,true);
                axisState.set(axis,-1);
            }
        }

        var positiveState = axisKeyStatePositive.get(key);
        if(positiveState != null)
        {
            var axis = keyAxisMap.get(key);
            if(!positiveState)
            {
                axisKeyStatePositive.set(key,true);
                axisStatePositive.set(axis,true);
                axisState.set(axis,1);
            }
        }

        var keyState = keyStates.get(key);
        if(keyState != null)
        {
            if(!keyState)
            {
                keyStates.set(key,true);
                runFunction(key,ONKEYDOWN);
            }
        }
    }

    public function onKeyUp(key:Key)
    {
        var negativeState = axisKeyStateNegative.get(key);
        if(negativeState != null)
        {
            var axis = keyAxisMap.get(key);
            if(negativeState)
            {
                axisKeyStateNegative.set(key,false);
                axisStateNegative.set(axis,false);
                if(axisStatePositive.get(axis))
                {
                    axisState.set(axis,1);
                }
                else
                {
                    axisState.set(axis,0);
                }
            }
        }

        var positiveState = axisKeyStatePositive.get(key);
        if(positiveState != null)
        {
            var axis = keyAxisMap.get(key);
            if(positiveState)
            {
                axisKeyStatePositive.set(key,false);
                axisStatePositive.set(axis,false);
                if(axisStateNegative.get(axis))
                {
                    axisState.set(axis,-1);
                }
                else
                {
                    axisState.set(axis,0);
                }
            }
        }
        
        var keyState = keyStates.get(key);
        if(keyState != null)
        {
            if(keyState)
            {
                keyStates.set(key,false);
                runFunction(key,ONKEYUP);
            }
        }
    }
}