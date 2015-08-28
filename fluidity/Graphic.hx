
package fluidity;

enum Graphic {

  Image(filename:String);
  // Animation(filename:String,width:Int);
  SpriteSheet(filename:String,width:Int,height:Int,frames:Array<Int>,frameLength:Int,loop:Bool);
}