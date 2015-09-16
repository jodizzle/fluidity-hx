
package fluidity.input;


enum TouchEventType {
    Object(object:GameObject,event:String);
    Function(func:Touch->Void);
    ObjectFunction(object:GameObject,func:Touch->GameObject->Void);
}
