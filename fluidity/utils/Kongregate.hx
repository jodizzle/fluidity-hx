
package fluidity.utils;

class Kongregate
{
    public static inline function submit(name:String,value:Int)
    {
        #if js
        #if kongregate
        untyped kongSubmit('highScore',highScore);
        #end
        #end
    }
}