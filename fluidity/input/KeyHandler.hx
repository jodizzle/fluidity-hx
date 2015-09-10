
package fluidity.input;


enum KeyHandler {
    Object(inputName:String,object:GameObject,event:String);
    Function(inputName:String,func:Void->Void);
}