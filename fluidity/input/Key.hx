
package fluidity.input;


class Key {

    public function new(code:Int,char:String,output:String,shiftOutput:String)
    {
        this.code = code;
        this.char = char;
        this.output = output;
        this.shiftOutput = shiftOutput;
    }

    public var code:Int;
    public var char:String;
    public var output:String;
    public var shiftOutput:String;

}