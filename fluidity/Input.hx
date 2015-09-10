
package fluidity;

import fluidity.input.Key;
import haxe.ds.ObjectMap;
import haxe.ds.StringMap;

class Input
{

    public var scenes:Array<GameScene> = [];

    public function new()
    {

    }

    public function addScene(scene:GameScene)
    {
        if(!(scenes.indexOf(scene) >= 0))
        {
            scenes.push(scene);
        }
    }

    public function removeScene(scene:GameScene)
    {
        scenes.remove(scene);
    }

    public function reset()
    {
        scenes = [];
    }

    public function onKeyDown(key:Key)
    {
        for(scene in scenes)
        {
            for(ev in scene.input.keyDownEvents)
            {
                var keyName = scene.input.keyMap.get(key);
                if(keyName != null)
                {
                    switch(ev)
                    {
                        case Object(inputName,object,event):
                            if(inputName == keyName)
                            {
                                object.processEvent(new GameEvent(event));
                            }
                        case Function(inputName, func):
                            if(inputName == keyName)
                            {
                                func();
                            }
                    }
                }
            }
            if(scene.input.positiveKeyAxisMap.exists(key))
            {
                scene.input.positiveKeyAxisMap.get(key).positive = true;
                scene.input.positiveKeyAxisMap.get(key).value = 1;
            }
            if(scene.input.negativeKeyAxisMap.exists(key))
            {
                scene.input.negativeKeyAxisMap.get(key).negative = true;
                scene.input.negativeKeyAxisMap.get(key).value = -1;
            }
        }
    }

    public function onKeyUp(key:Key)
    {
        for(scene in scenes)
        {
            for(ev in scene.input.keyUpEvents)
            {
                var keyName = scene.input.keyMap.get(key);
                if(keyName != null)
                {
                    switch(ev)
                    {
                        case Object(inputName,object,event):
                            if(inputName == keyName)
                            {
                                object.processEvent(new GameEvent(event));
                            }
                        case Function(inputName, func):
                            if(inputName == keyName)
                            {
                                func();
                            }
                    }
                }
            }
             
            if(scene.input.positiveKeyAxisMap.exists(key))
            {
                var axis = scene.input.positiveKeyAxisMap.get(key);
                axis.positive = false;
                if(axis.negative)
                {
                    axis.value = -1;
                }
                else
                {
                    axis.value = 0;
                }
            }
            
            if(scene.input.negativeKeyAxisMap.exists(key))
            {       
                var axis = scene.input.negativeKeyAxisMap.get(key);
                axis.negative = false;
                if(axis.positive)
                {
                    axis.value = 1;
                }
                else
                {
                    axis.value = 0;
                }
            }
        }
    }
}