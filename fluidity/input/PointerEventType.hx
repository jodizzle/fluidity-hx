
package fluidity.input;


enum PointerEventType {
    Object(object:GameObject,event:String);
    Function(func:Pointer->Void);
    ButtonObject(button:Int,object:GameObject,event:String);
    ButtonFunction(button:Int,func:Pointer->Void);
    ObjectFunction(object:GameObject,func:Pointer->GameObject->Void);
}
